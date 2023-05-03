-- create a new schema
DROP SCHEMA IF EXISTS ontimeflightdata CASCADE;
CREATE SCHEMA ontimeflightdata;

-- tell postgresql to look at the new schema 
SET search_path to ontimeflightdata;

-- drop existing tables
DROP TABLE IF EXISTS airlines;
DROP TABLE IF EXISTS aircrafts;
DROP TABLE IF EXISTS airports;
DROP TABLE IF EXISTS flights_small;
DROP TABLE IF EXISTS flights_medium;
DROP TABLE IF EXISTS flights_large;
DROP TABLE IF EXISTS flights_xlarge;

-- Airlines table
-- expected: 
--	SE,Das Air Cargo,Uganda
-- Outliers:
-- 	UX (1),Air Illinois Inc.,United States
-- 	SFQ (1),Southern Frontier Air Trans,Canada
CREATE TABLE airlines(
	carrier_code char(7), -- can be char(3) or char(7) depending on the situation
	name text,
	country text
);

-- Aircraft table
-- Expected:
-- 	N194DN,Corporation,BOEING,10/02/1997,767-332,Valid,Fixed Wing Multi-Engine,Turbo-Fan,1997
-- Outliers:
-- 	N194DN (1),,,,,,,,
CREATE TABLE aircrafts(
	tailnum text,
	type text,
	manufacturer text,
	issue_date text,
	model text,
	status text,
	aircraft_type text,
	engine_type text,
	year text
);

-- Airports table
-- Expected:
-- 	00M,Thigpen ,Bay Springs,MS,USA,31.95376472,-89.23450472
CREATE TABLE airports(
	iata text,
	airport text,
	city text,
	state text,
	country text,
	lat float,
	long float
);

-- Flights tables
-- Expected:
--	OO,6258,2005-10-04,SFO,SBA,N221SW,1855,2014,1848,1959,262.00
CREATE TABLE flights_small(
  carrier_code char(7), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number text, 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float
);

CREATE TABLE flights_medium(
  carrier_code char(7), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number text, 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float
);

------------- EXTRA TABLES FOR ASSIGNMENT PART 2 -------------

CREATE TABLE flights_large(
  carrier_code char(7), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number text, 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float
);
-- 
CREATE TABLE flights_xlarge(
  carrier_code char(7), 
  flight_number int, 
  flight_date date, 
  origin char(3), 
  destination char(3), 
  tail_number text, 
  scheduled_depature_time char(4), 
  scheduled_arrival_time char(4), 
  actual_departure_time char(4), 
  actual_arrival_time char(4), 
  distance float
);
