from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("ONPE_Prep_Datalake").master("local[*]").getOrCreate()
spark.sparkContext.setLogLevel("ERROR")

df = (spark.read
      .option("header", True)
      .option("inferSchema", True)
      .csv("datalake/onpe/participacion_historica/participacion.csv"))

df.write.mode("overwrite").parquet("datalake/onpe/participacion_historica_parquet/")
print("Parquet escrito OK. Filas:", df.count())
spark.stop()
