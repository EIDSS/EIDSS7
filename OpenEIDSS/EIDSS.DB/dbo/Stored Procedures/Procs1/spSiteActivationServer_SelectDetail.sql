





--##SUMMARY Selects data for SiteActivationServerDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.02.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @SiteID bigint
SET @SiteID = 2
EXECUTE spSiteActivationServer_SelectDetail
   @SiteID
  ,'en'


*/


CREATE          PROCEDURE dbo.spSiteActivationServer_SelectDetail (
	@SiteID AS BIGINT,--##PARAM @SiteID  - site ID
	@LangID AS NVARCHAR(50)--##PARAM @LangID  - language ID
)

AS
--0 tstSite
SELECT 
	idfsSite, 
	strSiteID,
	strSiteName, 
	strServerName,
	idfsSiteType, 
	cp.idfsCountry, 
	idfOffice
FROM tstSite s
inner join tstCustomizationPackage cp
on		cp.idfCustomizationPackage = s.idfCustomizationPackage
WHERE 
	idfsSite = @SiteID
	AND intRowStatus=0




