import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.SparkContext

object Main {
  def solution(sc: SparkContext, x: String, y: String) {
    // Load each line of the input data
    val twitterLines = sc.textFile("Assignment_Data/twitter.tsv")
    // Split each line of the input data into an array of strings
    val twitterdata = twitterLines.map(_.split("\t"))

    // TODO: *** Put your solution here ***

  }

  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger,Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Check command line arguments
    if(args.length != 2) {
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
