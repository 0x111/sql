DROP TABLE Proc_log;
CREATE TABLE Proc_log (
	auth VARCHAR(40), 
	creation_time datetime,
	proc_name VARCHAR(40),
);

GO
DROP TRIGGER logging ON ALL SERVER;
GO
CREATE TRIGGER logging
ON ALL SERVER 
AFTER CREATE_PROCEDURE AS
	DECLARE @data XML  
	SET @data = EVENTDATA()
	
	INSERT INTO dbo.Proc_log VALUES(ORIGINAL_LOGIN(), GETDATE(), 
	@data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(100)'));
	
GO
CREATE PROCEDURE lil7
AS  
    SET NOCOUNT ON;  
    SELECT *
    FROM Country;  
GO  
SELECT * FROM Proc_log;