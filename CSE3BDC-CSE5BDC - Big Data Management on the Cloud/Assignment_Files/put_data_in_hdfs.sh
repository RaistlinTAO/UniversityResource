#!/bin/bash -e

data_files=(
  'Task_1/Data/bank.csv'
  'Task_1/Data/bank-small.csv'
  'Task_2/Data/twitter.tsv'
  'Task_2/Data/twitter-small.tsv'
  'Task_3/Data/docword.txt'
  'Task_3/Data/vocab.txt'
  'Task_3/Data/docword-small.txt'
  'Task_3/Data/vocab-small.txt'
)

hdfs dfs -mkdir -p Assignment_Data
for data_file in ${data_files[@]}
do
  echo "# $data_file"
  hdfs dfs -put -f "$data_file" Assignment_Data
done
