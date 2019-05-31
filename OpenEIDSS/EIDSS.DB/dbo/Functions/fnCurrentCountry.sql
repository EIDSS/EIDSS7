





--##SUMMARY Posts data from DiagnosisReferenceDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 5.12.2009

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @Action int
DECLARE @idfsBaseReference bigint
DECLARE @strDefault varchar(200)
DECLARE @Name nvarchar(200)
DECLARE @strOIECode nvarchar(200)
DECLARE @strIDC10 nvarchar(200)
DECLARE @intHACode int
DECLARE @idfsUsingType bigint
DECLARE @LangID nvarchar(50)


EXECUTE @spDiagnosisReference_Post
   @Action
  ,@idfsBaseReference
  ,@strDefault
  ,@Name
  ,@strOIECode
  ,@strIDC10
  ,@intHACode
  ,@idfsUsingType
  ,@LangID

*/




CREATE function [dbo].[fnCurrentCountry]()

-- 20170622 rkirksey migrate over to EIDDSS7
RETURNS BIGINT
AS
BEGIN
	DECLARE @idfsCountry BIGINT
	SELECT		@idfsCountry = tcp1.idfsCountry
	FROM		tstSite ts
	JOIN tstCustomizationPackage tcp1 ON
		tcp1.idfCustomizationPackage = ts.idfCustomizationPackage
	WHERE		ts.idfsSite = dbo.fnSiteID()
	RETURN @idfsCountry
END









