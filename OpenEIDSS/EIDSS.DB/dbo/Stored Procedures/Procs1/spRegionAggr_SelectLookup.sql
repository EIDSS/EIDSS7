



--exec spRegionAggr_SelectLookup 'en'
--exec spRegionAggr_SelectLookup 'en' , 170000000

CREATE          PROCEDURE dbo.spRegionAggr_SelectLookup
	@LangID As nvarchar(50),
	@CountryID as bigint = NULL,
	@ID as bigint = NULL,
	@idfsAggrCaseType as bigint = null
as
if @idfsAggrCaseType = 10102001 -- HumanAggregateCase
	SELECT	
		idfsRegion, 
		strRegionName, 
		strRegionCode, 
		idfsCountry, 
		intRowStatus
	FROM	vwRegionAggr
	WHERE	
		idfsCountry = isnull(@CountryID, idfsCountry)
		AND (@ID IS NULL OR @ID = idfsRegion)
		and idfsCountry in (select distinct idfsCountry from tstSite)
		and idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	ORDER BY strRegionName
else
	exec spRegion_SelectLookup @LangID, @CountryID, @ID


/*
declare @CurrentCountryID bigint

SELECT		@CurrentCountryID = s.idfsCountry
FROM		tstSite s
INNER JOIN	tstLocalSiteOptions lso
ON			lso.strName = N'SiteID'
			and lso.strValue = cast(s.idfsSite as nvarchar(20))

SELECT	
	idfsReference as idfsRegion, 
	[name] as strRegionName, 
	gisRegion.strCode as strRegionCode, 
	gisRegion.idfsCountry, 
	fnGisReferenceRepair.intRowStatus
FROM	dbo.fnGisReferenceRepair(@LangID,19000003) --'rftRegion'
	inner join	gisRegion
	on	idfsReference = gisRegion.idfsRegion 
WHERE	
	gisRegion.idfsCountry = isnull(@CountryID, gisRegion.idfsCountry)
	AND (@ID IS NULL OR @ID = gisRegion.idfsRegion)
	and gisRegion.idfsCountry in (select distinct idfsCountry from tstSite)


union all

select
	idfsReference as idfsRegion, 
	[name] as strRegionName, 
	null as strRegionCode, 
	@CurrentCountryID as idfsCountry, 
	fnGisReferenceRepair.intRowStatus
FROM	dbo.fnGisReferenceRepair(@LangID,19000020) --'rftRegion'
where @CurrentCountryID = 170000000	
and (@ID IS NULL OR @ID = idfsReference)


ORDER BY strRegionName

*/

