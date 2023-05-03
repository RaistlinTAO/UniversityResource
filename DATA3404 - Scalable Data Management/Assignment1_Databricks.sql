-- Databricks notebook source
-- MAGIC %md
-- MAGIC ## DATA3404 Assignment 1
-- MAGIC 
-- MAGIC This is the SQL notebook for the assignment on Databricks, 2023s1.
-- MAGIC 
-- MAGIC This notebook assumes that you have executed the **Bootstrap** notebook first.
-- MAGIC 
-- MAGIC As the first step, we are mapping the imported CSV files as SQL tables so that they are available for subsequent SQL queries wiht a number of tables: **Aircrafts**, **Airlines**, **Airports** and three variants of the **Flights_**_scale_ table. You can switch between differenty dataset sizes by referring to _either_ the **Flights_small**, _or_ **Flights_medium** _or_ **Flights_large** tables.

-- COMMAND ----------

-- Databricks SQL notebook source
-- PS,1445,1987-10-18,BUR,OAK,,1145,1247,1144,1248,325.00
DROP TABLE IF EXISTS Aircrafts;
CREATE TABLE Aircrafts
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_aircrafts.csv", header "true");

DROP TABLE IF EXISTS Airlines;
CREATE TABLE Airlines
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_airlines.csv", header "true");

DROP TABLE IF EXISTS Airports;
CREATE TABLE Airports
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_airports.csv", header "true");

DROP TABLE IF EXISTS Flights_small;
CREATE TABLE Flights_small (
  carrier_code char(2), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number varchar(10), 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float)
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_flights_small.csv", header "true");

DROP TABLE IF EXISTS Flights_medium;
CREATE TABLE Flights_medium (
  carrier_code char(2), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number varchar(10), 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float)
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_flights_medium.csv", header "true");

DROP TABLE IF EXISTS Flights_large;
CREATE TABLE Flights_large (
  carrier_code char(2), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number varchar(10), 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float)
USING csv
OPTIONS (path "/FileStore/tables/ontimeperformance_flights_large.csv", header "true");


-- COMMAND ----------

-- MAGIC %md
-- MAGIC After you executed the CREATE TABLE statements from the cell above, you can now use SQL to query the imported data.
-- MAGIC 
-- MAGIC For example:

-- COMMAND ----------

SELECT count(*) FROM Flights_small

-- COMMAND ----------

-- MAGIC %md
-- MAGIC ### Own SQL code
-- MAGIC 
-- MAGIC Continue below here with developing your own answers to the different assignment questions.
