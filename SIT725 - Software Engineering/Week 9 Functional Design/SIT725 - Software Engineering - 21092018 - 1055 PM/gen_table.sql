SET FOREIGN_KEY_CHECKS=0
;

DROP TABLE IF EXISTS `Events` CASCADE
;

DROP TABLE IF EXISTS `Floor Plan` CASCADE
;

DROP TABLE IF EXISTS `Order` CASCADE
;

DROP TABLE IF EXISTS `Sensor` CASCADE
;

DROP TABLE IF EXISTS `User Data` CASCADE
;

CREATE TABLE `Events`
(
	`Ecent ID` VARCHAR(50) NOT NULL,
	`name` VARCHAR(50) 	 NULL,
	`Event_action` VARCHAR(50) 	 NULL,
	`SensorID` VARCHAR(50) 	 NULL,
	CONSTRAINT `PK_Events` PRIMARY KEY (`Ecent ID` ASC)
)
;

CREATE TABLE `Floor Plan`
(
	`Plan ID` VARCHAR(50) 	 NULL,
	`Description` VARCHAR(50) 	 NULL,
	`Level Image` VARCHAR(50) 	 NULL
)
;

CREATE TABLE `Order`
(
	`Order ID` VARCHAR(50) 	 NULL,
	`Order Description` VARCHAR(50) 	 NULL,
	`Date of Order` DATE 	 NULL
)
;

CREATE TABLE `Sensor`
(
	`Sensor ID` VARCHAR(50) NOT NULL,
	`Sensor Location` VARCHAR(50) 	 NULL,
	`Sebsor description` VARCHAR(50) 	 NULL,
	CONSTRAINT `PK_Sensor` PRIMARY KEY (`Sensor ID` ASC)
)
;

CREATE TABLE `User Data`
(
	`name` VARCHAR(50) NOT NULL,
	`ID` VARCHAR(50) 	 NULL,
	`Address` VARCHAR(50) 	 NULL,
	CONSTRAINT `PK_User Data` PRIMARY KEY (`name` ASC)
)
;

SET FOREIGN_KEY_CHECKS=1
;

