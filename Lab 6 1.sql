/*It's the first commnd list(first transactions). It is written like steps, so u need to execute the first from here and the first from second, the secon from here, the second from second. Good luck!
USE Airport_Norm

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

BEGIN TRANSACTION /*Потерянное изменение НЕ ДОПУСКАЕТСЯ*/
UPDATE Type_Of_Routes SET International = 11 WHERE [Type_ID] = 1;


COMMIT

UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

BEGIN TRANSACTION /*Гразное чтение ДА, ДОПУСКАЕТСЯ*/


SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1

SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1
COMMIT

UPDATE Type_Of_Routes SET International = 4 WHERE [Type_ID] = 1;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION /*Гразное чтение НЕТ НЕ ДОПУСКАЕТСЯ*/


SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1 /*Boot loop her*/


COMMIT

BEGIN TRANSACTION /*Неповторяющееся чтение ДА ДОПУСКАЕТСЯ*/
SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1

SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1
COMMIT

UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1

SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

BEGIN TRANSACTION /*Неповторяющееся чтение НЕТ НЕ ДОПУСКАЕТСЯ*/
SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1
COMMIT /*THIS COMMIT IS NEEDED WHEN NOT AVALIABLE*/
SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1
COMMIT

UPDATE Type_Of_Routes SET International = 1 WHERE [Type_ID] = 1

BEGIN TRANSACTION /*Фантом ДА ДОПУСКАЕТСЯ*/
SELECT * FROM Type_Of_Routes


SELECT * FROM Type_Of_Routes
COMMIT

/*Delete*/

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

BEGIN TRANSACTION /*Фантом НЕТ НЕ ДОПУСКАЕТСЯ*/
SELECT * FROM Type_Of_Routes
COMMIT /*BLOCK*/

SELECT * FROM Type_Of_Routes
COMMIT

/*Delete*/

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

BEGIN TRANSACTION
UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 0

SELECT * FROM Type_Of_Routes WHERE [Type_ID] = 1 /*Boot loop her*/

ROLLBACK


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRANSACTION
UPDATE Type_Of_Routes SET International = 10 WHERE [Type_ID] = 1

UPDATE Type_Of_Routes SET International = 11 WHERE [Type_ID] = 0 /*Boot loop here*/
COMMIT
