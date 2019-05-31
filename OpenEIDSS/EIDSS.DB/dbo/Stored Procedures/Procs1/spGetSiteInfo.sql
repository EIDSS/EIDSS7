

--##SUMMARY This procedure returns site, country and organization information related with current site.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 05.11.2009

--##REMARKS Updated: Zolotareva N.
--##REMARKS Update date: 25.11.2011 
--##REMARKS Changed tlbGeoLocation to tlbGeoLocationShared


--##RETURNS Don't use


/*
--Example of a call of procedure:

exec dbo.[spGetSiteInfo] 'en'
*/


CREATE PROCEDURE [dbo].[spGetSiteInfo](
	@LangID NVARCHAR(10) --##PARAM LanguageID - language ID for localized strings
	)
AS
BEGIN
declare @idfsRealSiteID bigint
declare @idfsRealSiteType bigint
select		@idfsRealSiteID = cast(tstLocalSiteOptions.strValue as bigint)
from		tstLocalSiteOptions
where		tstLocalSiteOptions.strName='SiteID'

select		@idfsRealSiteType = cast(tstLocalSiteOptions.strValue as bigint)
from		tstLocalSiteOptions
where		tstLocalSiteOptions.strName='SiteType'

if(@idfsRealSiteType is null)
	SELECT @idfsRealSiteType = idfsSiteType
	FROM tstSite
	WHERE idfsSite = @idfsRealSiteID and intRowStatus = 0

SELECT dbo.fnGisReference.idfsReference as idfsCountry,   
  dbo.fnGisReference.[name] as strCountryName,  
  gisCountry.strHASC as strHASCCountry,  
  CAST(ISNULL(tlbGeoLocationShared.idfsRegion, -1) as bigint) as idfsRegion,  
  CAST(ISNULL(tlbGeoLocationShared.idfsRayon, -1) as bigint) as idfsRayon,  
  tstSite.idfsSite,  
  @idfsRealSiteID as idfsRealSiteID,
  @idfsRealSiteType as idfsRealSiteType,
  tstSite.strHASCsiteID,  
  tstSite.strSiteName,  
  tstSite.strSiteID,  
  tstSite.idfsSiteType,  
  dbo.fnReference.name as strSiteTypeName,  
  tstSite.idfOffice,  
  fnInstitution.[name] As strOrganizationName,
  tstSite.idfCustomizationPackage,
  dbo.fnPermissionSite() as idfsPermissionSite
FROM dbo.fnGisReference(@LangID,19000001) --'rftCountry'  
inner join gisCountry  
on  dbo.fnGisReference.idfsReference = gisCountry.idfsCountry 
JOIN tstCustomizationPackage tcpac ON
	tcpac.idfsCountry = gisCountry.idfsCountry
inner join tstSite   
on  tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage
inner join dbo.fnReference(@LangID, 19000085) --rftSiteType  
on  tstSite.idfsSiteType = fnReference.idfsReference  
inner join dbo.fnInstitution(@LangID)   
on  tstSite.idfOffice = fnInstitution.idfOffice  
Left OUTER JOIN tlbGeoLocationShared   
on  fnInstitution.idfLocation = tlbGeoLocationShared.idfGeoLocationShared  
where tstSite.idfsSite = dbo.fnSiteID()  
  

END

