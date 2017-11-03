USE Airport_norm;

/*Рассадить пассажиров с завтрашнего самого загруженного рейса*/
/*
SELECT *
INTO Failed_Temp
FROM (SELECT TOP 1 Dep as Fail_Dep, Dest as Fail_Dest, Dep_Time as Fail_Dep_Time, Flight_ID AS Fail_Flight_ID, Selled_Tickets AS Fail_Selled_Tickets
		FROM Flight JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID
		WHERE CONVERT(VARCHAR(10), Dep_Time, 111) = CONVERT(VARCHAR(10), Dateadd(day, 1, GetDate()), 111)
		ORDER BY Selled_Tickets DESC) as A
*/



DECLARE 
	@Selled AS INT,
	@Max AS INT,
	@NoTick AS INT,
	@ID AS INT,
	@Fail_Flight_ID INT,
	@Fail_Dep_Time Datetime


SELECT TOP 1  @Fail_Dep_Time = Dep_Time, @Fail_Flight_ID = Flight_ID, @NoTick = Selled_Tickets
		FROM Flight JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID
		WHERE CONVERT(VARCHAR(10), Dep_Time, 111) = CONVERT(VARCHAR(10), Dateadd(day, 1, GetDate()), 111)
		ORDER BY Selled_Tickets DESC;

DECLARE Test_Cursor CURSOR FOR
	SELECT Selled_Tickets, Max_Tickets, Flight_ID
	FROM  
		(SELECT TOP 1 Dep as Fail_Dep, Dest as Fail_Dest, Dep_Time as Fail_Dep_Time, Flight_ID AS Fail_Flight_ID, Selled_Tickets AS Fail_Selled_Tickets
		FROM Flight JOIN [Route] ON [Route].Route_ID = Flight.Rout_ID
		WHERE CONVERT(VARCHAR(10), Dep_Time, 111) = CONVERT(VARCHAR(10), Dateadd(day, 1, GetDate()), 111)
		ORDER BY Selled_Tickets DESC) as A 
		JOIN [Route] ON [Route].Dep = Fail_Dep AND [Route].Dest = Fail_Dest 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		WHERE @Fail_Dep_Time <= Dep_Time
		ORDER BY Dep_Time;
OPEN Test_Cursor
FETCH NEXT FROM Test_Cursor;
WHILE @@FETCH_STATUS = 0
	BEGIN
		FETCH NEXT FROM Test_Cursor INTO @Selled, @Max, @ID
		UPDATE Flight 
		SET Selled_Tickets = (SELECT CASE WHEN @Selled + @NoTick <= @Max THEN @Selled + @NoTick ELSE @Max END)
		WHERE @ID = Flight_ID;
		SET @NoTick = @NoTick - (@Max - @Selled)
	END
CLOSE Test_Cursor
DEALLOCATE Test_Cursor




IF @NoTick <= 0
BEGIN
	PRINT 'SUCCESS'
	DELETE Booking
	FROM Booking
	JOIN Flight ON Flight.Flight_ID = Booking.Flight_ID WHERE Flight.Flight_ID = @Fail_Flight_ID
	DELETE Book_For_Pass
	FROM Book_For_Pass JOIN Booking ON Book_For_Pass.Book_Pass_ID = Booking.Book_Pass
	JOIN Flight ON Flight.Flight_ID = Booking.Flight_ID WHERE Flight.Flight_ID = @Fail_Flight_ID
	DELETE FROM Flight WHERE Flight_ID = @Fail_Flight_ID;
END
ELSE 
PRINT N'No Chance For U';