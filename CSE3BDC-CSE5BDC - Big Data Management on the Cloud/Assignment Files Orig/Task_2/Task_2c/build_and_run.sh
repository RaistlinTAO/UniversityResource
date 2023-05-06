#!/bin/bash -e

args="${@:-200910 200912}"

# Compile and package the source code
mvn -q package
# Run with Spark
spark-submit target/task2c-1.0-SNAPSHOT-uber.jar $args
# Remove build outputs
mvn -q clean
