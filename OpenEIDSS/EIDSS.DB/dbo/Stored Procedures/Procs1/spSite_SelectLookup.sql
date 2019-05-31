

--##SUMMARY Selects lookup list of registerd sites for current country.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 13.12.2009

--##RETURNS Doesn't use


/*
--Example of procedure call:
exec spSite_SelectLookup 'en'
*/

CREATE        PROCEDURE dbo.spSite_SelectLookup
	@LangID nvarchar(50) --##PARAM @LangID - language ID
AS
DECLARE @idfCustomizationPackage BIGINT
SELECT @idfCustomizationPackage = idfCustomizationPackage FROM tstSite
WHERE idfsSite = dbo.fnSiteID()


SELECT 
	s.idfsSite
	,s.idfsSiteType
	,ISNULL(i.[name], s.strSiteName) as strSiteName
	,s.strServerName
	,s.strSiteID
	,ISNULL(r.[name],r.strDefault) AS strSiteType
	,s.idfOffice
	,i.FullName AS OfficeName
	,i.[name] AS OfficeAbbreviation
	,s.intRowStatus
	,i.idfsOfficeAbbreviation
	,i.idfsOfficeName
	,i.strOrganizationID
	,s.idfCustomizationPackage 
	,i.intHACode
	,CAST(CASE WHEN (i.intHACode & 2)>0 THEN 1 ELSE 0 END AS BIT) AS blnHuman
	,CAST(CASE WHEN (i.intHACode & 96)>0 THEN 1 ELSE 0 END AS BIT) AS blnVet
	,CAST(CASE WHEN (i.intHACode & 32)>0 THEN 1 ELSE 0 END AS BIT) AS blnLivestock
	,CAST(CASE WHEN (i.intHACode & 64)>0 THEN 1 ELSE 0 END AS BIT) AS blnAvian
	,CAST(CASE WHEN (i.intHACode & 128)>0 THEN 1 ELSE 0 END AS BIT) AS blnVector
	,CAST(CASE WHEN (i.intHACode & 256)>0 THEN 1 ELSE 0 END AS BIT) AS blnSyndromic

  FROM tstSite s
INNER JOIN dbo.fnInstitution(@LangID) i ON
	s.idfOffice = i.idfOffice
INNER JOIN dbo.fnReference(@LangID, 19000085/*Site Type*/) r ON
	s.idfsSiteType = r.idfsReference
WHERE
	s.idfCustomizationPackage = @idfCustomizationPackage 
	and s.intRowStatus = 0
order by ISNULL(i.[name], s.strSiteName), ISNULL(r.[name],r.strDefault), s.strSiteID, s.idfsSite

