
--*************************************************************
-- Name 				: VW_GBL_RAYONS_GET
-- Description			: Selects the list of rayons for aggregate cases. Include virtual rayons. 
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE VIEW [dbo].[VW_GBL_RAYONS_GET]
AS 
	SELECT	
		b.idfsGISBaseReference AS idfsRayon
		,IsNull(c.strTextString
		,b.strDefault) AS strRayonName
		,gisRayon.idfsRegion 
		,gisRayon.idfsCountry
		,b.intRowStatus
		,c.idfsLanguage
	FROM	
		dbo.gisBaseReference as b 
		LEFT JOIN dbo.gisStringNameTranslation AS c ON
			b.idfsGISBaseReference = c.idfsGISBaseReference
		JOIN gisRayon ON
			b.idfsGISBaseReference = gisRayon.idfsRayon 
		JOIN gisCountry ON
			gisRayon.idfsCountry = gisCountry.idfsCountry
	WHERE	
		gisRayon.idfsCountry = dbo.FN_GBL_CURRENTCOUNTRY_GET()
		AND	
		b.idfsGISReferenceType = 19000002--'rftRayon'

	UNION ALL
	
	SELECT
		rayon.idfsGISBaseReference AS idfsRayon 
		,ISNULL(c.strTextString
		,rayon.strDefault) AS strRayonName 
		,region.idfsGISBaseReference AS idfsRegion
		,dbo.FN_GBL_CURRENTCOUNTRY_GET() AS idfsCountry 
		,rayon.intRowStatus
		,c.idfsLanguage
	FROM	
		dbo.gisBaseReference AS rayon
		LEFT JOIN dbo.gisStringNameTranslation AS c ON
			rayon.idfsGISBaseReference = c.idfsGISBaseReference
		CROSS JOIN dbo.gisBaseReference AS region
	WHERE 
		dbo.FN_GBL_CURRENTCOUNTRY_GET() = 170000000	
		AND 
		rayon.idfsGISReferenceType = 19000021--'rftAggrRayon'
		AND 
		region.idfsGISReferenceType = 19000020  --'rftAggrRegion'