from pyspark.sql import SparkSession

def initiate_spark():
    # Inisialisasi SparkSession
    spark = SparkSession.builder.appName("StartUpInvestment").getOrCreate()
    return spark
