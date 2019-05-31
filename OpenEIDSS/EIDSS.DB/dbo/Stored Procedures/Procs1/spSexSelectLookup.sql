

--##SUMMARY select queries for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spSexSelectLookup 'en'
*/ 
 
CREATE PROCEDURE [dbo].[spSexSelectLookup]
	@LangID	as nvarchar(50)
AS
BEGIN
	select * from fnReference(@LangID, 19000043)
END

