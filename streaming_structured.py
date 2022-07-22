from __future__ import print_function

from pyspark.sql import SparkSession
from pyspark.sql.functions import explode
from pyspark.sql.functions import split

def main():

    spark = SparkSession\
        .builder\
        .appName("StructuredNetworkWordCount")\
        .getOrCreate()
    spark.sparkContext.setLogLevel('WARN')
    spark.conf.set("spark.sql.shuffle.partitions",2)

    # Create DataFrame representing the stream of input lines from connection to host:port
    lines = spark.readStream.format('socket').option('host', "localhost").option('port', 9009).load()

    # Split the lines into words
    words = lines.select(explode(split(lines.value, ' ')).alias('word'))

    # Generate running word count
    words.createOrReplaceTempView("words_table")

    wordCounts = spark.sql("""select word
                          , count(*) as cnt
                          from words_table
                          where word like '%#%'
                          group by word
                          order by cnt desc""")


    # Start running the query that prints the running counts to the console
    query = wordCounts\
        .writeStream\
        .outputMode('complete')\
        .format('console') \
        .trigger(processingTime='2 seconds')\
        .option("numRows",30)\
        .start()

    #You can set number to rows to display by setting 'numRows' property on writestream.

    query.awaitTermination()

if __name__ == "__main__":
    main()
