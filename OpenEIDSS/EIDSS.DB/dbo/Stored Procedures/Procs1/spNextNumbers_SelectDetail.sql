
 

--##SUMMARY Selects specific numbering object data for NextNumbersDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spNextNumbers_SelectDetail 10057019, 'en'
*/

CREATE       PROCEDURE dbo.spNextNumbers_SelectDetail 
	@idfsNumberName AS BIGINT,--##PARAM @idfsNumberName - numbering object Type
	@LangID AS NVARCHAR(50)--##PARAM @LangID - language ID
AS
DECLARE @ObjectName NVARCHAR(200)
SELECT 
	@ObjectName = fnReference.[name]
FROM 	fnReference(@LangID, 19000057/*rftNumberingType*/)
WHERE 
	idfsReference = @idfsNumberName

DECLARE @EnglishName NVARCHAR(200)
SELECT 
	@EnglishName = fnReference.[name]
FROM 	fnReference('en', 19000057/*rftNumberingType*/)
WHERE 
	idfsReference = @idfsNumberName

SELECT 
	[idfsNumberName], 
	[strPrefix], 
	[strSuffix], 
	[intNumberValue], 
	[intMinNumberLength], 
	@ObjectName as strObjectName,
	@EnglishName as strEnglishName,
	[blnUsePrefix],
	[blnUseSiteID],
	[blnUseYear],
	[blnUseHACSCodeSite],
	[blnUseAlphaNumericValue], 
	[intYear]
FROM 
	dbo.tstNextNumbers
WHERE 
	idfsNumberName = @idfsNumberName








