# Manifiesto de evidencias

Tabla 30 del informe, con la ubicación de cada evidencia dentro de este repositorio.

| Código | Evidencia | Ubicación | Estado |
|---|---|---|---|
| E-01 | Dataset original y ficha de procedencia | BD_ONPE (SQL Server): `sql/01_...`; informe, sección 4.2 | En el informe |
| E-02 | Dataset procesado y perfil de calidad | `bigdata/datalake/onpe/participacion_historica_parquet/` | Incluido |
| E-03 | Datos de prueba/sintéticos y método | `bigdata/datalake/onpe/participacion_historica/participacion.csv`, `bigdata/generar_datos.py` | Incluido |
| E-04 | Diseño experimental y configuraciones | Informe, capítulo IV (4.1 a 4.7) | En el informe |
| E-05 | Diagrama de arquitectura y esquema de datos | Informe, secciones 3.3 y 3.4.2; `sql/02_...` y `sql/03_...` | Incluido |
| E-06 | SQL/NoSQL/Spark, scripts y notebook | `sql/`, `bigdata/*.py` | Incluido (falta enlace al notebook de Colab) |
| E-07 | Resultados de la solución BI | Informe, secciones 3.4.4 y 6.3; dashboard de Power BI | `.pbix` pendiente |
| E-08 | Resultados de la solución Big Data | `bigdata/salida_resultado/`; informe, sección 3.5.5 | Incluido |
| E-09 | Comparación de escenarios y métricas | Informe, sección 6.3 | En el informe |
| E-10 | Logs, capturas y visualizaciones | Informe, secciones 3.4.4, 3.5.5 y 6.4; `docs/figuras/` | Incluido |
| E-11 | Conclusiones, recomendaciones y decisiones | Informe, capítulo VII | En el informe |
| E-12 | Retroalimentación y mejoras implementadas | Informe, sección 5.5 | En el informe |
| E-13 | Solución BI funcional / demostración | Archivo `.pbix` de Power BI | Pendiente |
| E-14 | Solución Big Data funcional / demostración | `bigdata/`, `bigdata/evidencia_bigdata_onpe.zip` | Incluido (falta enlace a Colab) |
| E-15 | Aportes individuales y defensa | Informe, sección 5.6 | Pendiente |
| E-16 | Declaración de uso responsable de IA | Informe, sección 5.7 y último anexo | En el informe |
