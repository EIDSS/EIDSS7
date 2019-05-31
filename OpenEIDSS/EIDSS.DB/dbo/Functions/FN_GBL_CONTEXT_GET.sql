
/*
--*************************************************************
-- Name 				: FN_GBL_SITEID_GET
-- Description			: Funtion to return userid 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
-- 
EXEC spSetContext 'Test'
DECLARE @s varchar(50)
SELECT @s = dbo.fnGetContext()
print @s
Print LEN(@S)
*/
--*************************************************************
CREATE FUNCTION [dbo].[FN_GBL_CONTEXT_GET]()
RETURNS VARCHAR(50)
AS
BEGIN

	DECLARE @ContextString VARCHAR(50)

	SET @ContextString = CAST(CONTEXT_INFO() AS VARCHAR(50))

	DECLARE @position int

	SET @position = 1
	WHILE @position <= LEN(@ContextString)
		BEGIN
			IF ASCII(SUBSTRING(@ContextString, @position, 1)) = 0 BREAK
				SET @position = @position + 1
		END
	SET @ContextString = SUBSTRING(@ContextString, 1, @position - 1)

	RETURN @ContextString
END








