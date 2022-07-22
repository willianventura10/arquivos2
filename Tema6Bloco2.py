# https://spark.apache.org/docs/latest/sql-getting-started.html#starting-point-sparksession

from pyspark.sql import SparkSession

spark = SparkSession \
    .builder \
    .appName("Python Spark SQL basic example") \
    .config("spark.some.config.option", "some-value") \
    .getOrCreate()
    
    
df = spark.read.json("D:python\people.json") #Absoluto

df.show()

df.printSchema()

df.select("name").show()

df.select(df['name'], df['age'] + 1).show()

df.groupBy("age").count().show()


df.createOrReplaceTempView("people")

sqlDF = spark.sql("SELECT * FROM people")
sqlDF.show()

df.createGlobalTempView("people")

spark.sql("SELECT * FROM global_temp.people").show()

spark.newSession().sql("SELECT * FROM global_temp.people").show()