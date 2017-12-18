USE Airport_Norm;

IF OBJECT_ID('Age_Of_People', 'U') IS NOT NULL
	DROP TABLE [Age_Of_People];

IF OBJECT_ID('Aims_Large_Index', 'U') IS NOT NULL
	DROP TABLE [Aims_Large_Index];
	
IF OBJECT_ID('Aims_Large', 'U') IS NOT NULL
	DROP TABLE [Aims_Large];


CREATE TABLE [Age_Of_People] 
(
	ID INT IDENTITY(1, 1),
	Birth_Year INT,
	CHAR VARCHAR(50)
);

GO
INSERT [Age_Of_People](Birth_Year) VALUES((1957 + CONVERT(INT, RAND() * 60)));
GO 10000

CREATE TABLE [Aims_Large] 
(
	Birth_Year INT,
	INFO CHAR(50)
);
CREATE TABLE [Aims_Large_Index] 
(
	Birth_Year INT,
	INFO CHAR(50)
);




GO

INSERT INTO Aims_Large(Birth_Year)
	SELECT Birth_Year FROM [Age_Of_People];
INSERT INTO Aims_Large_Index(Birth_Year)
	SELECT Birth_Year FROM [Age_Of_People];
GO 1000

