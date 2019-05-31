
--*************************************************************
-- Name 				: VW_GBL_REGIONS_GET
-- Description			: Selects the list of regions for aggregate cases. Include virtual regions.
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE VIEW [dbo].[VW_GBL_REGIONS_GET]

AS 
	SELECT	
		b.idfsGISBaseReference AS idfsRegion 
		,ISNULL(c.strTextString
		,b.strDefault) AS strRegionName 
		,gisRegion.strCode AS strRegionCode
		,gisRegion.idfsCountry
		,b.intRowStatus
		,c.idfsLanguage
	FROM	
		dbo.gisBaseReference as b 
		LEFT JOIN dbo.gisStringNameTranslation AS c ON
			b.idfsGISBaseReference = c.idfsGISBaseReference
		JOIN gisRegion ON
			b.idfsGISBaseReference = gisRegion.idfsRegion 
	WHERE	
		gisRegion.idfsCountry = dbo.FN_GBL_CURRENTCOUNTRY_GET()
		AND	
		b.idfsGISReferenceType = 19000003--'rftRegion'

	UNION ALL

	SELECT
		region.idfsGISBaseReference AS idfsRegion
		,IsNull(c.strTextString, region.strDefault) AS strRegionName
		,null as strRegionCode
		,dbo.FN_GBL_CURRENTCOUNTRY_GET() AS idfsCountry
		,region.intRowStatus
		,c.idfsLanguage
	FROM	
		dbo.gisBaseReference as region
		LEFT JOIN dbo.gisStringNameTranslation AS c ON
			region.idfsGISBaseReference = c.idfsGISBaseReference
	WHERE 
		dbo.FN_GBL_CURRENTCOUNTRY_GET() = 170000000	
		AND 
		region.idfsGISReferenceType = 19000020  --'rftAggrRegion'