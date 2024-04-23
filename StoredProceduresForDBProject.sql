---------------------------------------------------------------------------------------------------
-- Stored Procedure for getting the highest number of cases for specific year for specific location
---------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE Highest_Lung_Cancer_Cases
    @Given_Year INT,
    @Given_City VARCHAR(50),
    @Highest_Cancer_Count INT OUTPUT,
    @Highest_PM_Value FLOAT OUTPUT
AS
BEGIN
    SELECT TOP 1 @Highest_Cancer_Count = lc.CountOfCases, @Highest_PM_Value = ap.PM25
    FROM AirPollutionLungCancerDB.dbo.LungCancerRates lc
    JOIN AirPollutionLungCancerDB.dbo.CityToParish cp ON cp.Parish = lc.Parish
    JOIN AirPollutionLungCancerDB.dbo.AirpollutionData ap ON ap.City = cp.City
    WHERE ap.PM25 IS NOT NULL
    AND YEAR(ap.Date) = @Given_Year
    AND lc.Year = @Given_Year
    AND ap.City = @Given_City
    ORDER BY ap.PM25 DESC;
END
GO

---------------------------------------------------------------------------------------------------
-- Stored Procedure for getting the Lowest number of cases for specific year for specific location
---------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE Lowest_Lung_Cancer_Cases
    @Given_Year INT,
    @Given_City VARCHAR(50),
    @Lowest_Cancer_Count INT OUTPUT,
    @Lowest_PM_Value FLOAT OUTPUT
AS
BEGIN
    SELECT TOP 1 @Lowest_Cancer_Count = lc.CountOfCases, @Lowest_PM_Value = ap.PM25
    FROM AirPollutionLungCancerDB.dbo.LungCancerRates lc
    JOIN AirPollutionLungCancerDB.dbo.CityToParish cp ON cp.Parish = lc.Parish
    JOIN AirPollutionLungCancerDB.dbo.AirpollutionData ap ON ap.City = cp.City
    WHERE ap.PM25 IS NOT NULL
    AND YEAR(ap.Date) = @Given_Year
    AND lc.Year = @Given_Year
    AND ap.City = @Given_City
    ORDER BY ap.PM25;
END
GO

---------------------------------------------------------------------------------------------------
-- Stored Procedure for getting the Average of cases for specific year for specific location
---------------------------------------------------------------------------------------------------
CREATE or ALTER PROCEDURE Average_Lung_Cancer_Cases 
@Given_Year INT,
@Given_City VARCHAR(50),
@Average_Cancer_Count FLOAT OUTPUT,
@Average_PM25 FLOAT OUTPUT
AS
BEGIN
SELECT @Average_Cancer_Count = AVG(lc.CountOfCases), @Average_PM25 = AVG(ap.PM25)
FROM AirPollutionLungCancerDB.dbo.LungCancerRates lc
JOIN AirPollutionLungCancerDB.dbo.CityToParish cp ON lc.Parish = cp.Parish
JOIN AirPollutionLungCancerDB.dbo.AirpollutionData ap ON ap.City = cp.City
WHERE ap.PM25 IS NOT NULL
AND ap.City = @Given_City
AND lc.Year = @Given_Year
AND YEAR(ap.Date) = @Given_Year
END
GO

---------------------------------------------------------------------------------------------------
-- Inserting the Data in Air Pollution DB
---------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE Insert_In_Air_Pollution_DB 
    @Given_Date DATE,
    @Given_City VARCHAR(50),
    @Given_PM25 FLOAT
AS
BEGIN
    DECLARE @SQL_Query NVARCHAR(MAX);

    SET @SQL_Query = 'INSERT INTO AirPollutionLungCancerDB.dbo.AirPollutionData (City, Date, PM25) VALUES (''' + @Given_City + ''', ''' + CONVERT(NVARCHAR(10), @Given_Date, 120) + ''', ' + CONVERT(NVARCHAR(50), @Given_PM25) + ')';
    PRINT @SQL_Query;

    EXEC sp_executesql @SQL_Query;
END
GO

-- Inserting the Data in Lung Cancer DB
CREATE OR ALTER PROCEDURE Insert_In_Lung_Cancer_DB 
    @Given_Year smallint,
    @Given_Parish VARCHAR(50),
    @Given_Rate FLOAT,
    @Given_Count int,
    @Given_Population int
AS
BEGIN
    DECLARE @SQL_Query NVARCHAR(MAX);

    SET @SQL_Query = 'INSERT INTO AirPollutionLungCancerDB.dbo.LungCancerRates (Year, Parish, Rate, CountOfCases, Population) VALUES 
	(' + CONVERT(NVARCHAR(10), @Given_Year) + ',''' + @Given_Parish + ''', ' + CONVERT(NVARCHAR(50), @Given_Rate) + ', ' + CONVERT(NVARCHAR(50), @Given_Count) + 
	', ' + CONVERT(NVARCHAR(50), @Given_Population) + ')';
    PRINT @SQL_Query;

    EXEC sp_executesql @SQL_Query;
END
GO

---------------------------------------------------------------------------------------------------
-- Inserting the Data in Location DB
---------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE Insert_In_Location_DB
    @Given_City VARCHAR(50),
    @Given_Parish VARCHAR(50)
AS
BEGIN
    DECLARE @SQL_Query NVARCHAR(MAX);

    SET @SQL_Query = 'INSERT INTO AirPollutionLungCancerDB.dbo.CityToParish (City, Parish) VALUES 
	(''' + @Given_City + ''', ''' + @Given_Parish + ''')';
    PRINT @SQL_Query;

    EXEC sp_executesql @SQL_Query;
END
GO

---------------------------------------------------------------------------------------------------
-- Creating a Trigger that logs the execution of the Insert_In_Air_Pollution_DB stored procedure by inserting a record into a logging table
---------------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_log_insert_air_pollution
ON AirPollutionLungCancerDB.dbo.AirPollutionData
AFTER INSERT
AS
BEGIN
    DECLARE @ProcedureName NVARCHAR(255);
    SET @ProcedureName = OBJECT_NAME(@@PROCID);
    
    INSERT INTO LogTable (ProcedureName, Time_stamp)
    VALUES (@ProcedureName, SYSDATETIME());
END;
GO

---------------------------------------------------------------------------------------------------
-- Creating a Trigger that logs the execution of the Insert_In_Lung_Cancer_DB stored procedure by inserting a record into a logging table
---------------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_log_insert_lung_cancer
ON AirPollutionLungCancerDB.dbo.LungCancerRates
AFTER INSERT
AS
BEGIN
    DECLARE @ProcedureName NVARCHAR(255);
    SET @ProcedureName = OBJECT_NAME(@@PROCID);
    
    INSERT INTO LogTable (ProcedureName, Time_stamp)
    VALUES (@ProcedureName, SYSDATETIME());
END;
GO

---------------------------------------------------------------------------------------------------
-- Creating a Trigger that logs the execution of the Insert_In_Lung_Cancer_DB stored procedure by inserting a record into a logging table
---------------------------------------------------------------------------------------------------

CREATE OR ALTER TRIGGER trg_log_insert_lung_cancer
ON AirPollutionLungCancerDB.dbo.LungCancerRates
AFTER INSERT
AS
BEGIN
    DECLARE @ProcedureName NVARCHAR(255);
    SET @ProcedureName = OBJECT_NAME(@@PROCID);
    
    INSERT INTO LogTable (ProcedureName, Time_stamp)
    VALUES (@ProcedureName, SYSDATETIME());
END;
GO

---------------------------------------------------------------------------------------------------