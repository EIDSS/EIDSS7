






--exec spRegion_SelectLookup 'en'
--exec spRegion_SelectLookup 'en' , 780000000

CREATE          PROCEDURE [dbo].[usp_Region_GetLookup]
	@LangID As nvarchar(50),
	@CountryID as bigint = NULL,
	@ID as bigint = NULL
AS
SELECT	
	region.idfsReference as idfsRegion, 
	region.[name] as strRegionName, 
	region.[ExtendedName] as strRegionExtendedName, 
	gisRegion.strCode as strRegionCode, 
	gisRegion.idfsCountry, 
	region.intRowStatus,
	country.name AS strCountryName
FROM	
	dbo.fnGisExtendedReferenceRepair(@LangID,19000003) region--'rftRegion'
inner join 	
	gisRegion
on
	idfsReference = gisRegion.idfsRegion 
inner join dbo.fnGisReferenceRepair(@LangID,19000001) country
	on  country.idfsReference = gisRegion.idfsCountry
--inner join 
--	tstSite
--on 
--	tstSite.idfsCountry=gisRegion.idfsCountry-- and tstSite.idfsSite=dbo.fnSiteID()

WHERE	
	gisRegion.idfsCountry = isnull(@CountryID, gisRegion.idfsCountry)
	AND (@ID IS NULL OR @ID = gisRegion.idfsRegion)
	and gisRegion.idfsCountry in (select distinct idfsCountry from tstSite)
ORDER BY strRegionName







