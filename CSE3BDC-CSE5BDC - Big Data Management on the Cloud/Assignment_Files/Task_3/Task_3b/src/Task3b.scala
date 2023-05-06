import org.apache.spark.sql._
import org.apache.spark.sql.types._
import org.apache.spark.sql.functions._
import org.apache.spark.sql.expressions._

// Define case classes for input data
case class Docword(docId: Int, vocabId: Int, count: Int)

case class VocabWord(vocabId: Int, word: String)

object Main {
  def solution(spark: SparkSession) {
    import spark.implicits._
    // Read the input data
    val docwords = spark.read.
      schema(Encoders.product[Docword].schema).
      option("delimiter", " ").
      csv("Assignment_Data/docword-small.txt").
      as[Docword]
    val vocab = spark.read.
      schema(Encoders.product[VocabWord].schema).
      option("delimiter", " ").
      csv("Assignment_Data/vocab-small.txt").
      as[VocabWord]

    // TODO: *** Put your solution here ***
    //Assume docId - vocabId is not Unique
    val resultDF = docwords.groupBy("docId", "vocabId").agg(sum("count").as("count"))
      //.select("docId", "vocabId", "count")
      .groupBy("docId").agg(max("count").as("count"))
      .join(docwords, Seq("docId", "count"))
      .orderBy(desc("count"))
    resultDF.join(vocab, resultDF("vocabId") === vocab("vocabId")).select("docId", "word", "count")
      .write.mode(SaveMode.Overwrite)
      .csv("file:///root/labfiles/Task_3/Task_3b-out")
  }

  // Do not edit the main function
  def main(args: Array[String]) {
    // Set log level
    import org.apache.log4j.{Logger, Level}
    Logger.getLogger("org").setLevel(Level.WARN)
    Logger.getLogger("akka").setLevel(Level.WARN)
    // Initialise Spark
    val spark = SparkSession.builder
      .appName("Task3b")
      .master("local[4]")
      .config("spark.sql.shuffle.partitions", 4)
      .getOrCreate()
    // Run solution code
    solution(spark)
    // Stop Spark
    spark.stop()
  }
}
