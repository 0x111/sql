
SELECT db_name(dbid), filename 
FROM sys.sysaltfiles;


USE Airport_Norm;


/*¬ыбрать имена всех таблиц, созданных назначенным пользователем базы данных*/
SELECT USER_NAME(ss.principal_id) AS 'User', st.name AS 'Name'
	FROM sys.tables st JOIN sys.schemas ss ON (ss.schema_id = st.schema_id)	
	WHERE (st.object_id NOT IN (SELECT major_id FROM sys.extended_properties));
GO
SELECT TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE';

/*¬ыбрать им€ таблицы, им€ столбца таблицы, признак того, допускает ли данный столбец
NULL-значени€, название типа данных столбца таблицы, размер этого типа данных - дл€ всех
таблиц, созданных назначенным пользователем базы данных и всех их столбцов.*/

SELECT USER_NAME(ss.principal_id) AS 'user', so.name AS table_name, sc.name AS column_name, sc.is_nullable AS 'null',
	   st.name AS 'type_name', sc.max_length AS 'size' 
	FROM sys.objects so
		JOIN sys.columns sc ON (sc.object_id = so.object_id)
		JOIN sys.types st ON (sc.user_type_id = st.user_type_id)
		JOIN sys.schemas ss ON (ss.schema_id = so.schema_id)
	WHERE (so.type = 'U') AND (USER_NAME(ss.principal_id) ='dbo') AND (so.object_id NOT IN (SELECT major_id FROM sys.extended_properties));

/*¬ыбрать название ограничени€ целостности (первичные и внешние ключи), им€ таблицы, в
которой оно находитс€, признак того, что это за ограничение ('PK' дл€ первичного ключа и 'F'
дл€ внешнего) - дл€ всех ограничений целостности, созданных назначенным пользователем
базы данных.*/
SELECT USER_NAME(ss.principal_id) AS 'user', so1.name AS key_name, so2.name AS table_name, so1.type
	FROM sys.objects so1, sys.objects so2
		JOIN sys.schemas ss ON (ss.schema_id = so2.schema_id)
	WHERE (so1.parent_object_id = so2.object_id) AND ((so1.type = 'F') OR (so1.type = 'PK') OR (so1.type = 'C')) AND (USER_NAME(ss.principal_id) ='dbo')
	AND (so1.object_id NOT IN (SELECT major_id FROM sys.extended_properties)) AND (so2.object_id NOT IN (SELECT major_id FROM sys.extended_properties))
/*¬ыбрать название внешнего ключа, им€ таблицы, содержащей внешний ключ, им€ таблицы,
содержащей его родительский ключ - дл€ всех внешних ключей, созданных назначенным
пользователем базы данных.*/
SELECT sfk.name AS kname, so1.name AS fname, so2.name AS kname, sc1.name AS fcolumn
	FROM sys.foreign_keys sfk
		JOIN sys.objects so1 ON (sfk.parent_object_id = so1.object_id)
		JOIN sys.objects so2 ON (sfk.referenced_object_id = so2.object_id)
		JOIN sys.schemas ss ON (ss.schema_id = so1.schema_id)
		JOIN sys.foreign_key_columns sfkc ON (sfkc.constraint_object_id = sfk.object_id)
		JOIN sys.columns sc1 ON (sfkc.parent_object_id = sc1.object_id AND sfkc.parent_column_id = sc1.column_id)
		
	WHERE (USER_NAME(ss.principal_id) ='dbo') AND (so1.object_id NOT IN (SELECT major_id FROM sys.extended_properties));
/*¬ыбрать название представлени€, SQL-запрос, создающий это представление - дл€ всех
представлений, созданных назначенным пользователем базы данных.*/ 
SELECT v.name, text
	FROM sys.views v
		JOIN sys.syscomments c ON v.object_id = c.id
		JOIN sys.schemas ss ON (ss.schema_id = v.schema_id)
	WHERE (USER_NAME(ss.principal_id) ='dbo') AND (v.object_id NOT IN (SELECT major_id FROM sys.extended_properties));
/*¬ыбрать название триггера, им€ таблицы, дл€ которой определен триггер - дл€ всех
триггеров, созданных назначенным пользователем базы данных.*/SELECT strr.name, st.name	FROM sys.triggers strr	JOIN sys.tables st ON st.object_id = strr.parent_id	JOIN sys.schemas ss ON (ss.schema_id = st.schema_id)
	WHERE (USER_NAME(ss.principal_id) ='dbo') AND (strr.object_id NOT IN (SELECT major_id FROM sys.extended_properties));	

