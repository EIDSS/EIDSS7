

--##SUMMARY Returns hash of password/additional key combination.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 14.04.2010

--##RETURNS Returns hash of password/additional key combination.



/*
Example of function call:

SELECT  dbo.fnGetPasswordHash ('p@ssw0rd', 'SessionID')
*/


CREATE   FUNCTION dbo.fnGetPasswordHash(
	@Password as nvarchar(200), --##PARAM @LangID - language ID
	@additionalKey as nvarchar(200) --##PARAM @LangID - language ID
)
returns nvarchar(4000)
as
BEGIN
	-- sys.fn_varbintohexstr is undocumented function
	-- the incompatibilty in the next SQL Server version is possible
	RETURN  sys.fn_varbintohexstr(HashBytes('MD5', @Password + ISNULL(@additionalKey,N'')))
END

