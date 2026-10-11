# Manifiesto de evidencias

Tabla 32 del informe, con la ubicación de cada evidencia dentro de este repositorio.

| Código | Evidencia | Ubicación | Estado |
|---|---|---|---|
| E-01 | Dataset original y ficha de procedencia | BD_ONPE (SQL Server): `sql/01_...` y datos de ejemplo `sql/04_...`; informe, sección 4.2 | Incluido |
| E-02 | Dataset procesado y perfil de calidad | `bigdata/datalake/onpe/participacion_historica_parquet/` | Incluido |
| E-03 | Datos de prueba/sintéticos y método | `bigdata/datalake/onpe/participacion_historica/participacion.csv`, `bigdata/generar_datos.py`; para la prueba de escalabilidad, `bigdata/escalabilidad.py` (los CSV de 10 000 a 5 000 000 filas se regeneran con la semilla 42 y no se versionan) | Incluido |
| E-04 | Diseño experimental y configuraciones | Informe, capítulo IV (4.1 a 4.7) | En el informe |
| E-05 | Diagrama de arquitectura y esquema de datos | Informe, secciones 3.3 y 3.4.2; `sql/02_...` y `sql/03_...` | Incluido |
| E-06 | SQL/NoSQL/Spark, scripts y notebook | `sql/` (01 a 08, incluye `07_...ETL_carga_estrella.sql` y `08_...job_automatizacion.sql`), `bigdata/*.py` (incluye `escalabilidad.py`), notebook `bigdata/bigdata_onpe.ipynb` y código de Power Query `powerbi/consultas_powerquery.m` | Incluido |
| E-07 | Resultados de la solución BI | Informe, secciones 3.4.4 y 6.3; dashboard de Power BI (`powerbi/Inteligencia de Negocios ERM 2026.pbix`) | Incluido |
| E-08 | Resultados de la solución Big Data | `bigdata/salida_resultado/`, `bigdata/escalabilidad/resultados_escalabilidad.csv` y `resumen_escalabilidad.csv`; informe, secciones 3.5.5 y 6.3 | Incluido |
| E-09 | Comparación de escenarios y métricas | Informe, sección 6.3 | En el informe |
| E-10 | Logs, capturas y visualizaciones | Informe, secciones 3.4.4, 3.5.5 y 6.4; `docs/figuras/` (incluye `fig_ejecucion_sqlserver.png`, Figura 5: ejecución en SQL Server y bitácora de carga); `bigdata/escalabilidad/log_escalabilidad.txt` | Incluido |
| E-11 | Conclusiones, recomendaciones y decisiones | Informe, capítulo VII | En el informe |
| E-12 | Retroalimentación y mejoras implementadas | Informe, sección 5.5 | En el informe |
| E-13 | Solución BI funcional / demostración | `powerbi/Inteligencia de Negocios ERM 2026.pbix`; dashboard publicado: https://app.powerbi.com/links/JEjCrLz9UF?ctid=48ba00e0-002e-4cb0-b501-07385d34ec34&pbi_source=linkShare | Incluido |
| E-14 | Solución Big Data funcional / demostración | `bigdata/`, `bigdata/evidencia_bigdata_onpe.zip`, `bigdata/bigdata_onpe.ipynb` (copia del notebook); notebook de Colab: https://colab.research.google.com/drive/1sxzbUL4gdrtDeD9W5IRiCgCzpEqYErSc?usp=sharing | Incluido |
| E-15 | Aportes individuales y defensa | Informe, sección 5.6 (Tabla 23); `aportes-individuales/contribuciones-individuales-5.6.png`: https://github.com/j-Antonio732/onpe-bd-bigdata/blob/main/aportes-individuales/contribuciones-individuales-5.6.png | Incluido |
| E-16 | Declaración de uso responsable de IA | Informe, sección 5.7 y último anexo | En el informe |
