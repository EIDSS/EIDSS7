


--exec spRayon_SelectLookup 'en', null, null
--exec spRayon_SelectLookup 'en' , 37020000000


CREATE       PROCEDURE dbo.spRayon_SelectLookup
	@LangID As nvarchar(50),
	@RegionID as bigint = NULL ,
	@ID as bigint = NULL

AS
SELECT	
	rayon.idfsReference as idfsRayon
	,rayon.[name] as strRayonName
	,rayon.[ExtendedName] as strRayonExtendedName
	,gisRayon.idfsRegion
	,gisRayon.idfsCountry
	,rayon.intRowStatus
	,region.ExtendedName as strRegionExtendedName
	,country.name as strCountryName
FROM	dbo.fnGisExtendedReferenceRepair(@LangID,19000002) rayon--'rftRayon' 
join 	gisRayon 
	on	rayon.idfsReference = gisRayon.idfsRayon 
join 	gisCountry
	on	gisRayon.idfsCountry = gisCountry.idfsCountry
join dbo.fnGisExtendedReferenceRepair(@LangID,19000003) region
	on region.idfsReference = gisRayon.idfsRegion
join dbo.fnGisReferenceRepair(@LangID,19000001) country
	on country.idfsReference = gisRayon.idfsCountry
WHERE	
	gisRayon.idfsRegion = isnull(@RegionID, gisRayon.idfsRegion)
	AND (@ID IS NULL OR @ID = idfsRayon)
	and gisRayon.idfsCountry in (select distinct idfsCountry from tstCustomizationPackage)
ORDER BY strRayonName




