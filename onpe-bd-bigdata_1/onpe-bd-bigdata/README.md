# Diseño de Base de Datos para el Sistema Electoral de la ONPE

Proyecto final del curso **Base de Datos Avanzadas y Big Data** (2026-2), Universidad Privada del Norte.
Solución de datos para la **capacitación de miembros de mesa** de la Oficina Nacional de Procesos Electorales (ONPE).

El repositorio reúne la implementación descrita en el informe: base de datos relacional en SQL Server, modelo dimensional en estrella para análisis, y una prueba de concepto Big Data con PySpark y Parquet.

## Estructura

```
.
├── sql/                                   # Base de datos (SQL Server)
│   ├── 01_BD_ONPE_modelo_relacional_3FN.sql          # 12 tablas normalizadas (3FN)
│   ├── 02_BD_ONPE_modelo_dimensional_estrella.sql    # H_ASISTENCIA + 5 dimensiones
│   ├── 03_BD_ONPE_claves_foraneas_estrella.sql       # FK de la tabla de hechos
│   ├── 04_BD_ONPE_datos_iniciales.sql                # datos de ejemplo (INSERT)
│   ├── 05_BD_ONPE_vistas.sql                         # 5 vistas de consulta
│   ├── 06_BD_ONPE_pruebas_DML_y_consultas.sql        # UPDATE/DELETE/INSERT y consultas
│   ├── 07_BD_ONPE_ETL_carga_estrella.sql             # SP_CARGAR_MODELO_ESTRELLA + bitácora LOG_CARGA_ETL
│   └── 08_BD_ONPE_job_automatizacion.sql             # job de SQL Server Agent (diario, 02:00)
├── bigdata/                               # Prueba de concepto Big Data (PySpark)
│   ├── generar_datos.py                   # CSV sintético (semilla 42)
│   ├── convertir_a_parquet.py             # CSV -> Parquet
│   ├── onpe_participacion_historica.py    # agregación con PySpark
│   ├── escalabilidad.py                   # prueba de escalabilidad (72 a 5 000 000 filas)
│   ├── escalabilidad/                     # resultados y log de la prueba de escalabilidad
│   ├── datalake/onpe/                     # datos de entrada (CSV y Parquet)
│   ├── salida_resultado/                  # resultado completo (36 filas)
│   ├── resultado_ejecucion_real.csv       # copia del resultado de la ejecución
│   └── evidencia_bigdata_onpe.zip         # paquete de evidencias (E-14)
├── docs/
│   ├── informe/                           # informe final en Word
│   └── figuras/                           # gráficos de resultados del informe
└── evidencias/MANIFIESTO.md               # evidencias E-01 a E-16 y su ubicación
```

## Modelo de datos

- **Relacional (3FN):** `UBIGEO`, `CIUDADANO`, `MIEMBRO_MESA`, `CAPACITADOR`, `PROCESO_ELECTORAL`, `JORNADA`, `LOCAL_CAPACITACION`, `AULA`, `CAPACITACION`, `ASISTENCIA`, `MATERIAL_CAPACITACION`, `DISTRIBUCION_MATERIAL`.
- **Dimensional (estrella):** tabla de hechos `H_ASISTENCIA` y dimensiones `D_MIEMBRO`, `D_CAPACITACION`, `D_LOCAL`, `D_TIEMPO` y `D_PROCESO`.
  Granularidad: la asistencia de un miembro de mesa en una capacitación específica, relacionada con un proceso electoral, un local y una fecha.

## Cómo crear la base de datos (SQL Server)

Ejecutar en SQL Server Management Studio, en este orden:

1. `sql/01_BD_ONPE_modelo_relacional_3FN.sql`: crea la base de datos BD_ONPE y las 12 tablas.
2. `sql/02_BD_ONPE_modelo_dimensional_estrella.sql`: crea la tabla de hechos y las dimensiones.
3. `sql/03_BD_ONPE_claves_foraneas_estrella.sql`: relaciona la tabla de hechos con las dimensiones.
4. `sql/04_BD_ONPE_datos_iniciales.sql`: carga los datos de ejemplo del modelo relacional.
5. `sql/05_BD_ONPE_vistas.sql`: crea las vistas `VW_CIUDADANOS`, `VW_MIEMBROS_MESA`, `VW_CAPACITACIONES`, `VW_ASISTENCIA` y `VW_DISTRIBUCION_MATERIAL`.
6. `sql/06_BD_ONPE_pruebas_DML_y_consultas.sql` (opcional): pruebas de actualización, eliminación y consultas. Algunas sentencias son pruebas de integridad referencial y SQL Server las rechaza a propósito (ver el comentario al inicio del archivo).

Las tablas del esquema en estrella (paso 2) quedan vacías hasta cargarlas. El informe describe su preparación con Power Query (sección 3.4.3); además, los pasos 7 y 8 automatizan la carga en SQL Server:

7. `sql/07_BD_ONPE_ETL_carga_estrella.sql`: crea la bitácora `LOG_CARGA_ETL` y el procedimiento `SP_CARGAR_MODELO_ESTRELLA`, que carga las cinco dimensiones y `H_ASISTENCIA` en una transacción y reconcilia los registros de `ASISTENCIA` y `H_ASISTENCIA` (si no coinciden, revierte). El script termina ejecutando el procedimiento y mostrando conteos y bitácora (tomar captura como evidencia).
8. `sql/08_BD_ONPE_job_automatizacion.sql`: crea el job `ONPE_Carga_Modelo_Estrella` de SQL Server Agent (todos los días a las 02:00). SQL Server Agent no está en la edición Express; en ese caso, programar el mismo procedimiento con el Programador de tareas de Windows y `sqlcmd` (ver el comentario del archivo).

Estado: la lógica de la carga se verificó trasladándola a SQLite con los datos de `04` y la sintaxis T-SQL con `sqlglot`; **falta ejecutarla en SQL Server** y conservar la captura (figura 5 del informe).

## Cómo ejecutar la prueba de concepto Big Data

Requisitos: Python 3.9 o superior y Java 17 o 21. También funciona en Google Colab (que ya trae Java).

```bash
cd bigdata
pip install pyspark
python generar_datos.py                # opcional: regenera el CSV sintético (72 registros)
python convertir_a_parquet.py          # CSV -> Parquet
python onpe_participacion_historica.py # agrega y guarda el resultado en salida_resultado/
```

Con la semilla 42 el conjunto de datos es siempre el mismo: 12 distritos × 6 procesos electorales = 72 registros, que se agrupan en 36 combinaciones de distrito y tipo de proceso. Los datos son **sintéticos**: sirven para demostrar la solución y no representan estadísticas oficiales de la ONPE.

## Prueba de escalabilidad

Repite el flujo CSV → Parquet → agregación con 72; 10 000; 100 000; 1 000 000 y 5 000 000 filas sintéticas (mismo esquema y semilla 42), tres repeticiones por tamaño, y comprueba en cada ejecución que el resultado tenga 36 grupos y que la suma de `procesos_analizados` sea igual al número de filas.

```bash
cd bigdata
pip install pyspark numpy
python escalabilidad.py                    # tamaños por defecto
python escalabilidad.py 72 10000 100000    # o los tamaños que se indiquen
```

Salidas en `bigdata/escalabilidad/`: `resultados_escalabilidad.csv` (una fila por ejecución), `resumen_escalabilidad.csv` (media y desviación estándar por tamaño) y `log_escalabilidad.txt`. Los archivos generados (`datos_*/`) no se versionan. Los resultados incluidos se midieron en un entorno Linux en la nube (2 CPU lógicos, 7 GB de RAM, Python 3.11, Spark 4.2.0, modo local); en otro equipo los tiempos serán distintos. No se midieron CPU ni memoria.

## Datos pendientes de completar por el equipo

Estos elementos no están en el repositorio y se agregan al informe cuando existan:

- Archivo del dashboard de Power BI (`.pbix`), evidencia E-13, y el código de las consultas de Power Query que cargan el modelo en estrella.
- Enlace al notebook de Google Colab, evidencia E-14.
- Captura de la ejecución en SQL Server de `SP_CARGAR_MODELO_ESTRELLA`, de `LOG_CARGA_ETL` y del job (figura 5 del informe, sección 3.4.3).
- Versiones de SQL Server, Power BI Desktop y PySpark (Tabla 19 del informe).

## Autores

Completar con los integrantes del equipo.
