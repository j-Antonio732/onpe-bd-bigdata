"""
Prueba de escalabilidad de la solución Big Data (EXP-02).

Repite el flujo de la prueba de concepto (CSV -> Parquet -> agregación con
PySpark) con tamaños crecientes del conjunto de datos sintético y mide el
tiempo de cada etapa. Cada tamaño se ejecuta 3 veces y se reporta el promedio
y la desviación estándar.

Uso:
    python escalabilidad.py                  # tamaños por defecto
    python escalabilidad.py 72 10000 100000  # tamaños a elegir

Salida:
    escalabilidad/resultados_escalabilidad.csv   una fila por ejecución
    escalabilidad/resumen_escalabilidad.csv      promedio y desviación por tamaño

El tamaño 72 usa el conjunto original (datalake/.../participacion.csv). Los
demás tamaños se generan con el mismo esquema y la misma lógica de
generar_datos.py (12 distritos, 6 procesos, semilla 42), repitiendo la
estructura hasta llegar a N filas.
"""
import csv
import os
import platform
import shutil
import statistics
import sys
import time

import numpy as np
from pyspark.sql import SparkSession
from pyspark.sql.functions import avg, count, col, sum as spark_sum

TAMANOS = [int(x) for x in sys.argv[1:]] or [72, 10_000, 100_000, 1_000_000, 5_000_000]
REPETICIONES = 3
SEMILLA = 42
DISTRITOS = ['LIMA', 'AREQUIPA', 'CUSCO', 'LORETO', 'PIURA', 'LA LIBERTAD',
             'PUNO', 'JUNIN', 'CAJAMARCA', 'ANCASH', 'SAN MARTIN', 'ICA']
PROCESOS = [('EG-2016', 'Elecciones Generales'), ('EG-2020', 'Elecciones Generales'),
            ('EG-2021', 'Elecciones Generales'), ('ERM-2018', 'Elecciones Regionales y Municipales'),
            ('ERM-2022', 'Elecciones Regionales y Municipales'), ('REF-2018', 'Referéndum')]

BASE = 'escalabilidad'
ORIGINAL_72 = 'datalake/onpe/participacion_historica/participacion.csv'


def generar_csv(n, ruta):
    """Genera n filas con el mismo esquema que generar_datos.py."""
    os.makedirs(os.path.dirname(ruta), exist_ok=True)
    rng = np.random.default_rng(SEMILLA)
    base = rng.uniform(60, 85, len(DISTRITOS))
    idx = np.arange(n)
    d = idx % len(DISTRITOS)
    p = (idx // len(DISTRITOS)) % len(PROCESOS)
    part = np.clip(base[d] + rng.uniform(-6, 6, n), 35, 95).round(2)
    with open(ruta, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['id_proceso', 'ubigeo', 'proceso_electoral', 'codigo_proceso', 'porcentaje_participacion'])
        for i in range(n):
            w.writerow([i + 1, DISTRITOS[d[i]], PROCESOS[p[i]][1], PROCESOS[p[i]][0], part[i]])


def tamano_mb(ruta):
    if os.path.isfile(ruta):
        return os.path.getsize(ruta) / 1e6
    return sum(os.path.getsize(os.path.join(r, f)) for r, _, fs in os.walk(ruta) for f in fs) / 1e6


def main():
    spark = (SparkSession.builder.appName('ONPE_Escalabilidad').master('local[*]').getOrCreate())
    spark.sparkContext.setLogLevel('ERROR')
    os.makedirs(BASE, exist_ok=True)
    filas = []

    # Calentamiento (no se registra): primera ejecución del conjunto original
    # para cargar clases de la JVM y el contexto de Spark.
    df0 = spark.read.option('header', True).option('inferSchema', True).csv(ORIGINAL_72)
    df0.groupBy('ubigeo', 'proceso_electoral').agg(avg('porcentaje_participacion')).collect()

    for n in TAMANOS:
        if n == 72:
            ruta_csv = ORIGINAL_72
        else:
            ruta_csv = f'{BASE}/datos_{n}/participacion.csv'
            if not os.path.exists(ruta_csv):
                generar_csv(n, ruta_csv)
        for rep in range(1, REPETICIONES + 1):
            ruta_parquet = f'{BASE}/datos_{n}/parquet'
            ruta_salida = f'{BASE}/datos_{n}/salida'
            shutil.rmtree(ruta_parquet, ignore_errors=True)
            shutil.rmtree(ruta_salida, ignore_errors=True)

            # Etapa 1: CSV -> Parquet (convertir_a_parquet.py)
            t0 = time.perf_counter()
            df = spark.read.option('header', True).option('inferSchema', True).csv(ruta_csv)
            df.write.mode('overwrite').parquet(ruta_parquet)
            t_conv = time.perf_counter() - t0

            # Etapa 2: agregación (onpe_participacion_historica.py, misma lógica)
            t0 = time.perf_counter()
            dfp = spark.read.parquet(ruta_parquet)
            res = (dfp.groupBy('ubigeo', 'proceso_electoral')
                   .agg(avg('porcentaje_participacion').alias('participacion_promedio'),
                        count('id_proceso').alias('procesos_analizados'))
                   .orderBy('participacion_promedio', ascending=False))
            res.show(5)
            res.coalesce(1).write.mode('overwrite').option('header', True).csv(ruta_salida)
            t_agg = time.perf_counter() - t0

            # Comprobación (fuera de los tiempos medidos): 36 grupos y suma de
            # procesos_analizados igual al número de filas de entrada.
            salida = spark.read.option('header', True).csv(ruta_salida)
            grupos = salida.count()
            suma = salida.agg(spark_sum(col('procesos_analizados').cast('long'))).collect()[0][0]
            filas.append({
                'filas': n, 'repeticion': rep,
                'tam_csv_mb': round(tamano_mb(ruta_csv), 2),
                'tam_parquet_mb': round(tamano_mb(ruta_parquet), 2),
                't_csv_a_parquet_s': round(t_conv, 3),
                't_agregacion_s': round(t_agg, 3),
                't_total_s': round(t_conv + t_agg, 3),
                'filas_por_s': round(n / (t_conv + t_agg), 1),
                'grupos_resultado': grupos,
                'suma_procesos_analizados': suma,
                'suma_coincide_con_filas': suma == n,
            })
            print(f'n={n:>9,}  rep={rep}  conv={t_conv:6.2f}s  agg={t_agg:6.2f}s  grupos={grupos}  '
                  f'suma_procesos={suma}  coincide={suma == n}', flush=True)

    with open(f'{BASE}/resultados_escalabilidad.csv', 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(filas[0].keys()))
        w.writeheader()
        w.writerows(filas)

    resumen = []
    for n in TAMANOS:
        fn = [r for r in filas if r['filas'] == n]
        tot = [r['t_total_s'] for r in fn]
        agg = [r['t_agregacion_s'] for r in fn]
        conv = [r['t_csv_a_parquet_s'] for r in fn]
        resumen.append({
            'filas': n, 'repeticiones': len(fn),
            'tam_csv_mb': fn[0]['tam_csv_mb'], 'tam_parquet_mb': fn[0]['tam_parquet_mb'],
            't_conv_prom_s': round(statistics.mean(conv), 2),
            't_agg_prom_s': round(statistics.mean(agg), 2), 't_agg_desv_s': round(statistics.stdev(agg), 2),
            't_total_prom_s': round(statistics.mean(tot), 2), 't_total_desv_s': round(statistics.stdev(tot), 2),
            'filas_por_s_prom': round(statistics.mean([r['filas_por_s'] for r in fn]), 0),
            'grupos_resultado': fn[0]['grupos_resultado'],
            'suma_coincide_en_todas': all(r['suma_coincide_con_filas'] for r in fn),
        })
    with open(f'{BASE}/resumen_escalabilidad.csv', 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(resumen[0].keys()))
        w.writeheader()
        w.writerows(resumen)

    print('\nEntorno:', platform.platform(), '| CPU lógicos:', os.cpu_count(),
          '| Python', platform.python_version(), '| Spark', spark.version)
    spark.stop()


if __name__ == '__main__':
    main()
