USE Airport_Norm;

SELECT *
FROM Flight;



SELECT *
FROM Aircraft_Stat;

SELECT [Route].Route_ID, COUNT(Flight_ID) AS Rate /*Выбрать маршрут/маршруты, по которым чаще всего летают рейсы, заполненные менее, чем на 70%. */
	FROM [Route] JOIN Flight ON Flight.Rout_ID = [Route].Route_ID
	WHERE Selled_Tickets < Max_Tickets * 7 / 10
	GROUP BY [Route].Route_ID
	ORDER BY COUNT(Flight_ID) DESC; /*Нету доступа, так что будет ошибка доступа*/
	

SELECT *
FROM Country; /*Можем просматривать информацию*/

INSERT [Country] ([Name], [Population]) VALUES ('Hacking', 0000); /*Но не можем вставить в нее, тк нету права на вставку*/

/*Попробуем теперь прочитать только избранные столбцы, на которые мы дали доступ*/
SELECT Last_Name 
FROM Passenger;

SELECT *
FROM Passenger;