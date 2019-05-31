

--##SUMMARY create folder for Folders for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.03.2010

--##RETURNS Don't use

/*

--Example of a call of procedure:

declare @idflQuery bigint
select top 1 @idflQuery = idflQuery from tasQuery

EXEC	[dbo].[spAsLanguageSelectLookup]		 @strLanguage			= 'en'				

*/ 

create PROCEDURE [dbo].[spAsLanguageSelectLookup]
	 @strLanguage				nvarchar(50)
AS
BEGIN
	SELECT 
		l.* 
	FROM fnReference(@strLanguage, 19000049) l
	JOIN trtLanguageToCP ltc ON
		l.idfsReference = ltc.idfsLanguage
	WHERE ltc.idfCustomizationPackage = dbo.fnCustomizationPackage()
END


