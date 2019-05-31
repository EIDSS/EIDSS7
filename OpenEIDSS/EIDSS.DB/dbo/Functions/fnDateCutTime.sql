


--##SUMMARY Returns the date without time part.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 06.04.2010

--##RETURNS Returns the date without time part



/*
Example of function call:

SELECT dbo.fnDateCutTime(GetDate())

*/


CREATE       FUNCTION [dbo].[fnDateCutTime](
	@Date DateTime --##PARAM @Date - date to convert
)
RETURNS DateTime 
AS
BEGIN
	RETURN CONVERT(datetime,CONVERT(varchar,@Date,1),1)
END	














