DROP TABLE myinput;
DROP TABLE mywords;

CREATE TABLE myinput (line STRING);

-- Load the text from the local filesystem
LOAD DATA LOCAL INPATH './Input_data/1/'
  INTO TABLE myinput;

-- Table containing all the words in the myinput table
-- The difference between this table and myinput is that myinput stores each line as a separate row
-- whereas mywords stores each word as a separate row.
CREATE TABLE mywords AS
SELECT EXPLODE(SPLIT(LCASE(REGEXP_REPLACE(line,'[\\p{Punct},\\p{Cntrl}]','')),' ')) AS word
FROM myinput;

-- Dump the output to file
INSERT OVERWRITE LOCAL DIRECTORY './task3-out/'
ROW FORMAT DELIMITED
  FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
  SELECT * FROM mywords;
