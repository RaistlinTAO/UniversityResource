DROP TABLE twitterdata;

-- Create a table for the input data
CREATE TABLE twitterdata (tokenType STRING, month STRING, count BIGINT,
  hashtagName STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t';

-- Load the input data
LOAD DATA LOCAL INPATH 'Data/twitter-small.tsv' INTO TABLE twitterdata;

-- TODO: *** Put your solution here ***



