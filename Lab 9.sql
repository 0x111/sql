USE Airport_Norm;
/*������������� �������� �� ������ ��������� ������������ ��������� ������ ��� ������� ��������*/

IF EXISTS( /*� ������, ���� ����������, �������*/
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
INSERT [Flight] ([Aircraft_ID], [Rout_ID]) VALUES (1, 1);/*������������ � �����������, ��� ��� ��������� �������� <= ������� ������ ��������*/
SELECT Flight_ID, [Route].Dist, [Models].[Range] FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Rout_ID] = 1;
INSERT [Flight] ([Aircraft_ID], [Rout_ID]) VALUES (4, 1);/*�� ������������ � �� ����������� ��-�� ������������ �������� ������ ������ �������� 4 ������, ��� ����� �������� 1*/ 

GO 
/*�������� ������ ������, ����� ��������, ��� ��������� insert �� ��������*/
SELECT Flight_ID, [Route].Dist, [Models].[Range] FROM [Route] 
		JOIN Flight ON [Route].Route_ID = Flight.Rout_ID
		JOIN Aircraft ON Aircraft.Aircraft_ID = Flight.Aircraft_ID
		JOIN Models ON Models.Model_ID = Aircraft.Model_ID
		WHERE [Rout_ID] = 1;

UPDATE Flight /*����� ������, �� ������� ���������� ��� �� �������, ��� � �� ���������*/
SET Aircraft_ID = 4 
WHERE Rout_ID = 1;