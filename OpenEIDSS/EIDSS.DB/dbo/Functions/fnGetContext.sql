﻿
--##SUMMARY During opening connection EIDSS stores ClientID string in the connection context.
--##SUMMARY This function converts connection context to string, truncates trailing zeros
--##SUMMARY and returns this processed string.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.12.2009

--##RETURNS string stored in the current connection context


/*
--Example of function:

EXEC spSetContext 'Test'
DECLARE @s varchar(50)
SELECT @s = dbo.fnGetContext()
print @s
Print LEN(@S)
*/



CREATE  function fnGetContext()
returns VARCHAR(50)
as
begin

declare @ContextString VARCHAR(50)

SET @ContextString = CAST(CONTEXT_INFO() AS VARCHAR(50))
DECLARE @position int
SET @position = 1
WHILE @position <= LEN(@ContextString)
	BEGIN
		IF ASCII(SUBSTRING(@ContextString, @position, 1)) = 0 BREAK
		SET @position = @position + 1
	END
SET @ContextString = SUBSTRING(@ContextString, 1, @position - 1)
return @ContextString


end







