USE Airport_Norm;

GRANT SELECT, INSERT, UPDATE ON Models TO test; /*Все права*/
GRANT SELECT(Name, Last_Name), UPDATE(Name, Last_Name) ON Passenger TO test; /*Только на конкретные*/
GRANT SELECT ON Country TO test; /*Присваиваем только право SELECT*/
GRANT SELECT ON Aircraft_Stat TO test; /*Доступ к представлению Aircraft_Stat*/


IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'azaza' and type = 'R')
DROP ROLE [azaza]

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'azaza2' and type = 'R')
DROP ROLE [azaza2]

CREATE ROLE azaza AUTHORIZATION test;
CREATE ROLE azaza2 AUTHORIZATION test;
exec sp_addrolemember 'azaza', 'test';
exec sp_addrolemember 'azaza2', 'test';

GRANT SELECT ON Flight TO azaza;
DENY SELECT ON Flight TO azaza2;



GRANT UPDATE(Model_ID, [Year/Month], [Avg Dist]) ON Aircraft_Stat TO azaza; /*Выдаем права на получение средней дистанции для каждой модели и каждого месяца, но не частоты полетов и часа минут*/

