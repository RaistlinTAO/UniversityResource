import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.SparkContext


case class twitterData(tokenType: String, month: Int, count: Int, hashtagName: String)

object Main {
  def solution(sc: SparkContext) {
    // Load each line of the input data
    val twitterLines = sc.textFile("Assignment_Data/twitter-small.tsv")
    // Split each line of the input data into an array of strings
    val twitterdata = twitterLines.map(_.split("\t"))

    // TODO: *** Put your solution here ***
    val sqlContext = new org.apache.spark.sql.SQLContext(sc)
    import sqlContext.implicits._
    twitterdata.collect.foreach(a => println(a.mkString("Array(", ", ", ")")))
    val twitterDF = twitterdata.map { case Array(s0, s1, s2, s3) => twitterData(s0, s1.toInt, s2.toInt, s3) }.toDF
    twitterDF.groupBy("hashtagName").agg()

  }

  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger, Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Initialise Spark
    val spark = SparkSession.builder
      .appName("TaskBonus1")
      .master("local[4]")
      .config("spark.hadoop.validateOutputSpecs", "false")
      .config("spark.default.parallelism", 4)
      .getOrCreate()
    // Run solution code
    import spark.implicits._
    solution(spark.sparkContext)
    // Stop Spark
    spark.stop()
  }
}
