
--##SUMMARY select sql script for proc create with given name

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.09.2012

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec [spAsGetFunctionText] 'fn_HumanCase_SelectList'
exec [spAsGetFunctionText] 'vw_AVR_HumanCaseReport'

*/ 
 
create PROCEDURE [dbo].[spAsGetFunctionText]
	@name nvarchar(200)
AS
BEGIN
	
	set @name = '[dbo].[' + LTRIM(RTRIM(@name)) + ']'

	
	
	SELECT OBJECT_DEFINITION(OBJECT_ID(@name))
	
END

