---------------------------------------------------------------------------------------------------
-- Creating Database
---------------------------------------------------------------------------------------------------

CREATE DATABASE AirPollutionLungCancerDB;
GO

USE AirPollutionLungCancerDB;

GO

---------------------------------------------------------------------------------------------------
-- Creating table to import Air pollution data
---------------------------------------------------------------------------------------------------

-- Alexandria
CREATE TABLE AirPollutionData  (
	City Varchar(50),
	Date DATE,
	PM25 FLOAT,
	PRIMARY KEY (City,Date));
GO

-- Import the file using BULK INSERT

USE AirPollutionLungCancerDB;
GO

BULK INSERT AirPollutionData
FROM 'C:\Users\rajse\Desktop\Modified_Database_Datasets\AirPollutionData.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


------------------------------------------------------------------------------------------------------
-- Creating table to import lung cancer data
------------------------------------------------------------------------------------------------------

CREATE TABLE LungCancerRates (
	Year smallint,
	Parish Varchar(50),
	Rate FLOAT,
	CountOfCases FLOAT,
	Population INT,
	PRIMARY KEY (Year, Parish));

GO

-- import the file in query way

USE AirPollutionLungCancerDB;
GO 

BULK INSERT LungCancerRates
FROM 'C:\Users\rajse\Desktop\Modified_Database_Datasets\Lung_Cancer_Incidence_Rates.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)
GO

------------------------------------------------------------------------------------------------------
-- Creating table to import City to Parish relation table
------------------------------------------------------------------------------------------------------

CREATE TABLE CityToParish (
	City Varchar(50),
	Parish Varchar(50),
	PRIMARY KEY (City, Parish));
GO

-- import the file in query way
 
USE AirPollutionLungCancerDB;
GO 

BULK INSERT CityToParish
FROM 'C:\Users\rajse\Desktop\Modified_Database_Datasets\CityToParish.csv'
WITH
(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
)
GO

------------------------------------------------------------------------------------------------------
-- Creating table to Log any kind of insertion acitivity
------------------------------------------------------------------------------------------------------

USE AirPollutionLungCancerDB
Go

CREATE TABLE LogTable  (
    Log_ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ProcedureName VARCHAR(50),
    Time_stamp DATETIME
);
GO

------------------------------------------------------------------------------------------------------