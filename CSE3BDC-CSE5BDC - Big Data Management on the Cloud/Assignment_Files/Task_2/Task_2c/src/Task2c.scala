import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.SparkContext

object Main {
  def solution(sc: SparkContext, x: String, y: String) {
    // Load each line of the input data
    val twitterLines = sc.textFile("Assignment_Data/twitter-small.tsv")
    // Split each line of the input data into an array of strings
    val twitterdata = twitterLines.map(_.split("\t"))

    // TODO: *** Put your solution here ***
    val resultRDD = twitterdata
      //Filter only two month data filter(a => a(1) == x || a(1) == y)  //195755
      .filter(a => a(1) == x || a(1) == y).sortBy(a => a(2)).groupBy(a => a(3))
      //Filter missing month filter(a => a._2.toList.length == 2)
      //Ignore any hashtag names that had no tweets in either month x or y.
      //Iterator
      .filter(a => a._2.toArray.length == 2)
      .map(row =>
        (row._1, row._2.toArray.apply(0)(2), row._2.toArray.apply(1)(2), row._2.toArray.apply(1)(2).toInt - row._2.toArray.apply(0)(2).toInt)
      )
      .sortBy(_._4, ascending = false)
      .first()

    //val finalResult = resultRDD
    println("hashtagName: " + resultRDD._1 + ", countX: " + resultRDD._2 + ", countY: " + resultRDD._3)

  }

  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger, Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Check command line arguments
    if (args.length != 2) {
      println("Expected two command line arguments: <month x> and <month y>")
    }
    // Initialise Spark
    val spark = SparkSession.builder
      .appName("Task2c")
      .master("local[4]")
      .config("spark.hadoop.validateOutputSpecs", "false")
      .config("spark.default.parallelism", 1)
      .getOrCreate()
    // Run solution code
    solution(spark.sparkContext, args(0), args(1))
    // Stop Spark
    spark.stop()
  }
}
