USE Airport_norm;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1 /*Boot loop here*/
COMMIT


UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

BEGIN TRANSACTION 

UPDATE Type_Of_Routes SET International = 0 WHERE [Type_ID] = 1

ROLLBACK



UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRANSACTION 

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1

ROLLBACK



BEGIN TRANSACTION 

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1

COMMIT

UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

BEGIN TRANSACTION 

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1

COMMIT

UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

BEGIN TRANSACTION 

INSERT INTO Type_Of_Routes VALUES (2, 2)
COMMIT



DELETE FROM Type_Of_Routes WHERE [Type_ID] = 2

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRANSACTION 

INSERT INTO Type_Of_Routes VALUES (2, 2) /*Boot loop here*/
COMMIT



DELETE FROM Type_Of_Routes WHERE [Type_ID] = 2

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 0

UPDATE Type_Of_Routes SET International = 11 WHERE [Type_ID] = 1 /*Boot loop here*/

COMMIT