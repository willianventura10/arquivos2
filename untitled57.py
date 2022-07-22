import pyspark
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
from pyspark.sql import SQLContext
arquivo = "d:\Python\people.json"
sc = SparkContext.getOrCreate()
spark = SparkSession(sc)
sqlContext = SQLContext(sc)
df = spark.read.json(arquivo)
# Criando um view temporária usando o DataFrame
df.createOrReplaceTempView('temp')
# Visualizando os dados da tabela
sqlContext.sql("select * from temp").show()


