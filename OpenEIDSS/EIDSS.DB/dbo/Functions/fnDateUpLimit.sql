






--##SUMMARY Returns the date without time part that corresponds to the start of the next day
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.04.2010

--##RETURNS Returns the date without time part that corresponds to the start of the next day




/*
Example of function call:

SELECT dbo.fnDateUpLimit(GetDate())

*/

CREATE       FUNCTION [dbo].[fnDateUpLimit](@Date DateTime)
RETURNS DateTime 
AS
BEGIN
	RETURN DATEADD(day,1,dbo.fnDateCutTime(@Date))
END	


