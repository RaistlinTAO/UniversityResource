import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.SparkContext

import java.io._
import scala.collection.mutable.ListBuffer

object Main {
  def solution(sc: SparkContext) {
    // Load each line of the input data
    val bankdataLines = sc.textFile("Assignment_Data/bank-small.csv")
    // Split each line of the input data into an array of strings
    val bankdata = bankdataLines.map(_.split(";"))

    // TODO: *** Put your solution here ***
    val resultArray = bankdata.filter(a => a(5).toInt > 500).sortBy(a => a(5).toInt, ascending = false).collect()
    val file = new File("/root/labfiles/Task_1/Task_1d-out")
    val bwFile = new BufferedWriter(new FileWriter(file))
    for (line <- resultArray) {
      bwFile.write(line(3) + ", " + line(5) + ", " + line(1) + ", " + line(2) + ", " + line(7) + "\n")
    }
    bwFile.close()
  }


  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger, Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Initialise Spark
    val spark = SparkSession.builder
      .appName("Task1d")
      .master("local[4]")
      .config("spark.hadoop.validateOutputSpecs", "false")
      .getOrCreate()
    // Run solution code
    solution(spark.sparkContext)
    // Stop Spark
    spark.stop()
  }
}
