SELECT CASE  /*Определить наличие свободных мест на рейс №354 23 августа 2004г.*/
	WHEN (Max_Tickets > Selled_Tickets)
	THEN 'Available'
	ELSE 'Not Available'
	END AS Avaliability
	FROM Flight
	WHERE Flight_ID = 354 AND '2004-23-08 00:00:00' = DATEADD(dd, 0, DATEDIFF(dd, 0, Dep_Time));

SELECT [Route].Route_ID, COUNT(Flight_ID) AS Rate /*Выбрать маршрут/маршруты, по которым чаще всего летают рейсы, заполненные менее, чем на 70%. */
	FROM [Route] JOIN Flight ON Flight.Rout_ID = [Route].Route_ID
	WHERE Selled_Tickets < Max_Tickets * 7 / 10
	GROUP BY [Route].Route_ID
	ORDER BY COUNT(Flight_ID) DESC;
	
SELECT Model_Name, Num 
/*Выбрать марку самолета, которая чаще всего используется на внутренних рейсах */
	FROM Models, (SELECT TOP 1 WITH TIES Models.Model_ID as Mod_ID, COUNT(Flight.Flight_ID) AS Num 
		FROM Models 
			JOIN Aircraft ON Models.Model_ID = Aircraft.Model_ID 
			JOIN Flight ON Aircraft.Aircraft_ID = Flight.Aircraft_ID 
			JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID 
			JOIN [Type_Of_Routes] ON [Route].[Type_ID] = [Type_Of_Routes].[Type_ID]
		WHERE International = 0
		GROUP BY Models.Model_ID
		ORDER BY COUNT(Flight.Flight_ID) DESC) v1
	WHERE Mod_ID = Model_ID;

SELECT (Avg(DATEDIFF(minute, Dep_Time, Arr_Time)))/60 as [Hours], Avg(DATEDIFF(minute, Dep_Time, Arr_Time))%60 as [Minutes] 
/*Определить среднее рассчетное время полета для самолета 'СУ-24' для международных рейсов */
	FROM Models 
	JOIN Aircraft ON Models.Model_ID = Aircraft.Model_ID 
	JOIN Flight ON Aircraft.Aircraft_ID = Flight.Aircraft_ID 
	JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID 
	JOIN [Type_Of_Routes] ON [Route].[Type_ID] = [Type_Of_Routes].[Type_ID]
	WHERE CONVERT(NVARCHAR(MAX), Models.Model_Name) = N'SU-24' AND International = 1;


SELECT TOP 1 WITH TIES COUNT(Airp) as Popularity, Airp, DATEADD(dd, 0, DATEDIFF(dd, 0, Datet)) as [Date] /*Определить дату и аэропорт, где будет больше всего пассажиров*/
FROM (
	(SELECT Dep AS Airp, Dep_Time AS Datet
	FROM Flight JOIN [Route] ON Flight.Rout_ID = [Route].Route_ID)
UNION ALL  
(SELECT Dest AS Airp, Arr_Time AS Datet
	FROM Flight JOIN [Route] ON Flight.Rout_ID = [Route].Route_ID) 
	) as A
GROUP BY Airp, DATEADD(dd, 0, DATEDIFF(dd, 0, Datet))
ORDER BY COUNT(Airp) DESC;


SELECT Flight.Flight_ID, Aircraft.Aircraft_ID, Dist, [Range], CASE /*Показать, может ли самолет пролететь по маршруту*/
	WHEN (Dist > [Range]) 
	THEN 'NO'
	ELSE CASE
		WHEN
		(Dist * 6 / 5 > [Range])
		THEN 'CRITICAL'
		ELSE 'YES'
		END 
	END
FROM Models JOIN Aircraft ON Models.Model_ID = Aircraft.Model_ID
	JOIN Flight ON Flight.Aircraft_ID = Aircraft.Aircraft_ID
	JOIN [Route] ON [Route].Route_ID = Flight.[Rout_ID];

SELECT City.Name /*Выбрать самый дождливый город*/
FROM (SELECT TOP 1 City.City_ID as id 
	FROM City JOIN Airport ON City.City_ID = Airport.City_ID JOIN Wheather ON Airport.Airport_ID = Wheather.Airport_ID
	WHERE Rain > 50
	GROUP BY City.City_ID
	ORDER BY COUNT(Rain)) as vs, City
WHERE vs.id = City.City_ID;


SELECT  d as [Without Group], f as [With Group]  /*Сколько покупает в группе и не в группе*/
FROM 
	(SELECT COUNT(Book_Pass_ID) as d
	FROM Book_For_Pass
	WHERE Group_Book_ID IS NULL) as q, 
	(SELECT COUNT(Book_Pass_ID) as f
	FROM Book_For_Pass
	WHERE Group_Book_ID IS NOT NULL) as w;


/*
DELETE [City] /*ОШибка */
FROM [City]
WHERE City.City_ID = 1;
*/

UPDATE Models  /*Переводим в мили скорость*/
SET Max_Speed = Max_Speed * 1.609
FROM Models 
WHERE Max_Speed IS NOT NULL;

UPDATE Passenger /*Оставить только первую букву фамилии*/
SET Name = SUBSTRING(Name , 1 , 1)
FROM Passenger
WHERE Name IS NOT NULL;

DELETE [Flight] /*Удалить все полеты, летающие из Kitah*/
OUTPUT DELETED.Flight_ID AS [Deleted]
FROM [Route] JOIN City ON [Route].Dep = City.City_ID
JOIN Flight ON Flight.Rout_ID = [Route].Route_ID
WHERE [Route].Dep IN (SELECT City_ID FROM City 
	WHERE CONVERT(NVARCHAR(MAX), City.Name) = 'Kitah');

/*154 В ВЦ*/





