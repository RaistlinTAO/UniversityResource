DROP TABLE bankdata;

-- Create a table for the input data
CREATE TABLE bankdata
(
    age         BIGINT,
    job         STRING,
    marital     STRING,
    education   STRING,
    default     STRING,
    balance     BIGINT,
    housing     STRING,
    loan        STRING,
    contact     STRING,
    day         BIGINT,
    month       STRING,
    duration    BIGINT,
    campaign    BIGINT,
    pdays       BIGINT,
    previous    BIGINT,
    poutcome    STRING,
    termdeposit STRING
)
    ROW FORMAT DELIMITED FIELDS TERMINATED BY '\;';

-- Load the input data
LOAD DATA LOCAL INPATH 'Data/bank.csv' INTO TABLE bankdata;

-- TODO: *** Put your solution here ***
INSERT OVERWRITE LOCAL DIRECTORY './Task_1a-out/'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
SELECT marital, count(*)
FROM bankdata
WHERE balance > 500
  AND LOWER(loan) = 'yes'
GROUP BY marital;