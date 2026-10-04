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
│   └── 03_BD_ONPE_claves_foraneas_estrella.sql       # FK de la tabla de hechos
├── bigdata/                               # Prueba de concepto Big Data (PySpark)
│   ├── generar_datos.py                   # CSV sintético (semilla 42)
│   ├── convertir_a_parquet.py             # CSV -> Parquet
│   ├── onpe_participacion_historica.py    # agregación con PySpark
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

1. `sql/01_BD_ONPE_modelo_relacional_3FN.sql`
2. `sql/02_BD_ONPE_modelo_dimensional_estrella.sql`
3. `sql/03_BD_ONPE_claves_foraneas_estrella.sql`

Los scripts crean la estructura (DDL). Los datos de BD_ONPE y las consultas de Power Query se documentan en el informe, secciones 3.4.2 y 3.4.3.

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

## Datos pendientes de completar por el equipo

Estos elementos no están en el repositorio y se agregan al informe cuando existan:

- Archivo del dashboard de Power BI (`.pbix`), evidencia E-13.
- Enlace al notebook de Google Colab, evidencia E-14.
- Versiones de SQL Server, Power BI Desktop y PySpark (Tabla 18 del informe).

## Autores

Completar con los integrantes del equipo.
