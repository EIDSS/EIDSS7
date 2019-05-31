


--exec spRayonAggr_SelectLookup 'en', null, null
--exec spRayonAggr_SelectLookup 'en' , 10300053
--exec spRayonAggr_SelectLookup 'en' , 10300053, 868
--exec spRayonAggr_SelectLookup 'en' , 1344350000000

--exec spRayon_SelectLookup 'en' , 170000000
create       PROCEDURE dbo.spRayonAggr_SelectLookup
	@LangID As nvarchar(50),
	@RegionID as bigint = NULL ,
	@ID as bigint = NULL,
	@idfsAggrCaseType as bigint = null
as
if @idfsAggrCaseType = 10102001 -- HumanAggregateCase
	SELECT 
		idfsRayon, 
		strRayonName, 
		idfsRegion, 
		idfsCountry, 
		intRowStatus
	FROM vwRayonAggr
	WHERE	
		idfsRegion = isnull(@RegionID, idfsRegion)
		AND (@ID IS NULL OR @ID = idfsRayon)
		and idfsCountry in (select distinct idfsCountry from tstSite)
		and idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	ORDER BY strRayonName
else
	exec spRayon_SelectLookup @LangID, @RegionID, @ID


/*	
declare @CurrentCountryID bigint

SELECT		@CurrentCountryID = s.idfsCountry
FROM		tstSite s
INNER JOIN	tstLocalSiteOptions lso
ON			lso.strName = N'SiteID'
			and lso.strValue = cast(s.idfsSite as nvarchar(20))
			
			
SELECT	idfsReference as idfsRayon, 
		[name] as strRayonName, 
		gisRayon.idfsRegion, 
		gisRayon.idfsCountry, 
		fnGisReferenceRepair.intRowStatus
FROM	dbo.fnGisReferenceRepair(@LangID,19000002)--'rftRayon' 
join 	gisRayon 
on	idfsReference = gisRayon.idfsRayon 
join 	gisCountry
on	gisRayon.idfsCountry = gisCountry.idfsCountry

WHERE	
	gisRayon.idfsRegion = isnull(@RegionID, gisRayon.idfsRegion)
	AND (@ID IS NULL OR @ID = idfsRayon)
	and gisRayon.idfsCountry in (select distinct idfsCountry from tstSite)
	
	
union all

select
	rayon.idfsReference as idfsRayon, 
	rayon.[name] as strRayonName, 
	region.idfsReference as idfsRegion,
	@CurrentCountryID as idfsCountry, 
	rayon.intRowStatus
FROM	dbo.fnGisReferenceRepair(@LangID,19000021) as rayon --'rftAggrRayon'
cross join dbo.fnGisReferenceRepair(@LangID,19000020) as region  --'rftAggrRegion'
where @CurrentCountryID = 170000000	
and (@ID IS NULL OR @ID = rayon.idfsReference)
and region.idfsReference = isnull(@RegionID, region.idfsReference)

	
ORDER BY strRayonName

*/


