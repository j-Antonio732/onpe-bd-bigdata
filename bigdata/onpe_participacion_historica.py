from pyspark.sql import SparkSession
from pyspark.sql.functions import avg, count

spark = SparkSession.builder \
    .appName("ONPE_BigData_ParticipacionHistorica") \
    .master("local[*]") \
    .getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

# Lectura del histórico de procesos electorales almacenado en el Data Lake
# (particionado por año/proceso, cargado desde BD_ONPE vía Sqoop)
df = spark.read.parquet("datalake/onpe/participacion_historica_parquet/")

resultado = (df
    .groupBy("ubigeo", "proceso_electoral")
    .agg(
        avg("porcentaje_participacion").alias("participacion_promedio"),
        count("id_proceso").alias("procesos_analizados")
    )
    .orderBy("participacion_promedio", ascending=False)
)

resultado.show(5)

# Guardamos el resultado completo también, para dejar evidencia completa (no solo las 5 primeras filas)
resultado.coalesce(1).write.mode("overwrite").option("header", True).csv("salida_resultado")

spark.stop()
