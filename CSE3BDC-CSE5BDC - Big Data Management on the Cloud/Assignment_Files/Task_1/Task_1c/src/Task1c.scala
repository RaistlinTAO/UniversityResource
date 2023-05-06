import org.apache.spark
import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.SparkContext

object Main {
  def solution(sc: SparkContext) {
    // Load each line of the input data
    val bankdataLines = sc.textFile("Assignment_Data/bank-small.csv")
    // Split each line of the input data into an array of strings
    val bankdata = bankdataLines.map(_.split(";"))

    // TODO: *** Put your solution here ***
    val lowAccount = bankdata.filter(a => a(5).toInt <= 500)
    val mediumAccount = bankdata.filter(a => a(5).toInt > 500 && a(5).toInt <= 1500)
    val highAccount = bankdata.filter(a => a(5).toInt > 1500)
    val resultRdd = sc.parallelize(Seq(("High", highAccount.count()),
      ("Medium", mediumAccount.count()), ("Low", lowAccount.count())))
    resultRdd.map(f => f._1 + "," + f._2).saveAsTextFile("file:///root/labfiles/Task_1/Task_1c-out")

  }

  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger, Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Initialise Spark
    val spark = SparkSession.builder
      .appName("Task1c")
      .master("local[4]")
      .config("spark.hadoop.validateOutputSpecs", "false")
      .config("spark.default.parallelism", 1)
      .getOrCreate()
    // Run solution code
    solution(spark.sparkContext)
    // Stop Spark
    spark.stop()
  }
}
