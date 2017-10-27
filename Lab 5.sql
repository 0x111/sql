USE Airport_Norm;

IF EXISTS(
	SELECT * FROM sys.views
	WHERE [name] = 'Aircraft_Stat' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW Aircraft_Stat
GO

CREATE VIEW Aircraft_Stat AS /*Марка самолета, месяц, количество рейсов в этом месяце, среднее время полета, среднее расстояние*/
	SELECT Models.Model_ID, CONVERT(VARCHAR(7), Dep_Time, 111) as [Year/Month], COUNT(Flight_ID) as [Rate],
	(Avg(DATEDIFF(minute, Dep_Time, Arr_Time)))/60 as [Hours], Avg(DATEDIFF(minute, Dep_Time, Arr_Time))%60 as [Minutes], AVG(Dist) as [Avg Dist] 
	FROM Models JOIN Aircraft ON Models.Model_ID = Aircraft.Model_ID
	JOIN Flight ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
	JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID
	GROUP BY Models.Model_ID, CONVERT(VARCHAR(7), Dep_Time, 111);

GO

IF EXISTS(
	SELECT * FROM sys.views
	WHERE [name] = 'Chance_To_Fly' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW Chance_To_Fly

GO

CREATE VIEW Chance_to_fly AS /*Пункт вылета, назначения, все возможные способы добраться с не более чем одной пересадкой, время пути*/
	(SELECT R1.Dep, R2.Dest, DATEDIFF(minute, F1.Dep_Time, F2.Arr_Time) AS [Duration], R1.Dest AS Change, F1.Flight_ID AS [First Flight], F2.Flight_ID AS [Second Flight]
	FROM [Route] AS R1 JOIN [Route] AS R2 ON R1.Dest = R2.Dep
	JOIN Flight AS F1 ON F1.Rout_ID = R1.Route_ID 
	JOIN Flight AS F2 ON F2.Rout_ID = R2.Route_ID
	WHERE F1.Arr_Time < F2.Dep_Time)
	UNION ALL
	(SELECT Dep, Dest, DATEDIFF(minute, Dep_Time, Arr_Time), NULL AS Change, Flight_ID AS ID, NULL
	FROM [Route] JOIN Flight ON Flight.Rout_ID = [Route].Route_ID);

GO

IF EXISTS(
	SELECT * FROM sys.views
	WHERE [name] = 'Book3' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW Book3

GO

CREATE VIEW Book3 AS /*Номер самолета, марка самолета, расписание рейсов на ближайщий месяц, количество свободных мест*/
	SELECT Aircraft.Aircraft_ID, Models.Model_Name, Flight.Dep_Time, Flight.Arr_Time, (Max_Tickets - Selled_Tickets) as Free, Max_Tickets
	FROM Flight JOIN Aircraft ON Flight.Aircraft_ID = Aircraft.Aircraft_ID
	JOIN Models ON Models.Model_ID = Aircraft.Model_ID
	WHERE CONVERT(VARCHAR(7), Dep_Time, 111) = CONVERT(VARCHAR(7), GetDate(), 111);
	

GO

IF EXISTS(
	SELECT * FROM sys.views
	WHERE [name] = 'Book2' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW Book2

GO

CREATE VIEW Book2 AS /*Номер рейса, пункт вылета, назначения, марка самолета, дата время - на текущий месяц*/
	SELECT Flight.Flight_ID, Dep, Dest, Models.Model_Name, Dep_Time
	FROM Flight 
	JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID
	JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
	JOIN Models ON Models.Model_ID = Aircraft.Model_ID 
	WHERE CONVERT(VARCHAR(7), Dep_Time, 111) = CONVERT(VARCHAR(7), GetDate(), 111);



