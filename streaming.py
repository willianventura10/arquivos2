from pyspark import SparkContext
from pyspark.streaming import StreamingContext

def updateCount(newCounts, state):
    if state == None:
        return sum(newCounts)
    else:

        return state + sum(newCounts)

# DataFrame operations inside your streaming program

def main():
    sc = SparkContext(appName="Pyspark_Streaming_Demo")
    sc.setLogLevel("WARN")
    ssc = StreamingContext(sc, 2)   #Streaming will execute in every 2 seconds

    lines = ssc.socketTextStream("localhost", 9009)

    # create a new RDD with one word per line
    counts = lines.flatMap(lambda line: line.split(" ")) \
        .map(lambda x: (x, 1)) \
        .reduceByKey(lambda a, b: a + b)

    ssc.checkpoint("result/checkpoints")

    totalWords = counts.updateStateByKey(lambda newCounts, state: updateCount(newCounts, state))

    totalWords = totalWords.transform( lambda rdd: rdd.sortBy(lambda x: x[1], ascending=False))
    #totalWords = totalWords.transform( lambda rdd: rdd(lambda x: decode(x)))

    totalWords.pprint(30)

    # create 1 file
    totalWords.repartition(1).saveAsTextFiles("result/count_words/")

    ssc.start()
    ssc.awaitTermination()

if __name__ == "__main__":
    main()

