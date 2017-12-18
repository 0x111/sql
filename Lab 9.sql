USE Airport_Norm;
/*Протяженность маршрута не должна превышать максимальную дальность полета для данного самолета*/

IF EXISTS( /*В случае, если существует, удаляем*/
	SELECT * FROM sys.triggers
	WHERE object_id = OBJECT_ID(N'[FlightRange]'))
DROP TRIGGER FlightRange

GO

CREATE TRIGGER FlightRange
	ON [Flight] 
	AFTER INSERT, UPDATE AS
	IF EXISTS(
		SELECT *
		FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Route].Dist >= Models.[Range]AND 
		Flight_ID IN 
			(SELECT Flight_ID FROM INSERTED))
	BEGIN
	RAISERROR('Aircraft bad(', 16, 0);
	END

GO

SELECT Flight_ID, [Route].Dist, [Models].[Range] FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Rout_ID] = 1;
INSERT [Flight] ([Aircraft_ID], [Rout_ID]) VALUES (1, 1);/*Показывается и вставляется, так как дистанция маршрута <= радиусу полета самолета*/
SELECT Flight_ID, [Route].Dist, [Models].[Range] FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Rout_ID] = 1;
INSERT [Flight] ([Aircraft_ID], [Rout_ID]) VALUES (4, 1);/*Не показывается и не вставляется из-за срабатывания триггера Радиус полета самолета 4 меньше, чем длина маршрута 1*/ 

GO 
/*Начинаем другую секцию, чтобы показать, что последний insert не сработал*/
SELECT Flight_ID, [Route].Dist, [Models].[Range] FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Rout_ID] = 1;

UPDATE Flight /*Также ошибка, тк триггер установлен как на вставку, так и на изменение*/
SET Aircraft_ID = 4 
WHERE Rout_ID = 1;