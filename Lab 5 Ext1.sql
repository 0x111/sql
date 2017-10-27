USE Airport_norm;
SELECT Model_ID, SUM([Avg dist]) as [Avg_Dist]/*Определить среднее время полета для каждой марки самолета*/
FROM Aircraft_Stat
GROUP BY Model_ID;

SELECT * /*Отменили все следующие на сегодня рейсы, показать возможные пути решение*/
FROM (SELECT Dep, Dest
FROM Flight 
JOIN [Route] ON Flight.Rout_ID = [Route].Route_ID
WHERE CONVERT(VARCHAR(10), Dep_Time, 111) = CONVERT(VARCHAR(7), GETDATE(), 111) AND Dep_Time > GETDATE()) AS Search
JOIN Chance_To_Fly AS Cha ON Cha.Dep = Search.Dep AND Cha.Dest = Search.Dest;



SELECT * /*Показать самый ненагруженный рейс на этот месяц*/
FROM Book3
ORDER BY Free / Max_Tickets;
