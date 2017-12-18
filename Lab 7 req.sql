USE Airport_Norm;

SELECT *
FROM Flight;



SELECT *
FROM Aircraft_Stat;

SELECT [Route].Route_ID, COUNT(Flight_ID) AS Rate /*������� �������/��������, �� ������� ���� ����� ������ �����, ����������� �����, ��� �� 70%. */
	FROM [Route] JOIN Flight ON Flight.Rout_ID = [Route].Route_ID
	WHERE Selled_Tickets < Max_Tickets * 7 / 10
	GROUP BY [Route].Route_ID
	ORDER BY COUNT(Flight_ID) DESC; /*���� �������, ��� ��� ����� ������ �������*/
	

SELECT *
FROM Country; /*����� ������������� ����������*/

INSERT [Country] ([Name], [Population]) VALUES ('Hacking', 0000); /*�� �� ����� �������� � ���, �� ���� ����� �� �������*/

/*��������� ������ ��������� ������ ��������� �������, �� ������� �� ���� ������*/
SELECT Last_Name 
FROM Passenger;

SELECT *
FROM Passenger;