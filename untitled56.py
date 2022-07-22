import pyspark
import pandas as pd
from pyspark.context import SparkContext
from pyspark.sql.session import SparkSession
dados = {'EMPRESA':['LATAM','KLM','GOL','KLM','AZUL'],
        'PAÍS DE ORIGEM':['BRASIL','BRASIL','BRASIL','BRASIL','BRASIL'],
        'QTADE VOO':[3000,500,700,2500,100]}
df=pd.DataFrame(dados)
df.to_csv('spark2.csv')

arquivo = "d:\spark2.csv"
sc = SparkContext.getOrCreate()
spark = SparkSession(sc)
df_csv= spark.read.option("inferSchema", "true").option("header", "true").csv(arquivo)
df_csv= df_csv.drop("_c0")
print (df_csv.show())

