

--=====================================================================================================
-- Name: usp_Rayon_GetLookup
--
-- Description: Select lookup list of Rayons from 
--              tables: gisRayon; gisCountry; tstCustomizationPackage
--              Functions: fnGisExtendedReferenceRepair;fnGisReferenceRepair
--
-- renamed sp to usp_ by MCW

--exec usp_Rayon_GetLookup 'en', null, null
--exec usp_Rayon_GetLookup 'en' , 37020000000
--
-- Ann Xiong    2/22/2019 modified to return entire list of Rayons even when @ID IS not NULL.


CREATE       PROCEDURE [dbo].[usp_Rayon_GetLookup]
	@LangID		As nvarchar(50),
	@RegionID	as bigint = NULL ,
	@ID			as bigint = NULL

AS

SELECT	
		rayon.idfsReference as idfsRayon,
		rayon.name as strRayonName,
		rayon.ExtendedName as strRayonExtendedName,
		gisRayon.idfsRegion,
		gisRayon.idfsCountry,
		rayon.intRowStatus,
		region.ExtendedName as strRegionExtendedName,
		country.name as strCountryName

FROM	dbo.fnGisExtendedReferenceRepair(@LangID,19000002) rayon--'rftRayon' 
		join 	gisRayon 
		on		rayon.idfsReference = gisRayon.idfsRayon 
		join 	gisCountry 
		on		gisRayon.idfsCountry = gisCountry.idfsCountry
		join    dbo.fnGisExtendedReferenceRepair(@LangID,19000003) region	
		on		region.idfsReference = gisRayon.idfsRegion
		join    dbo.fnGisReferenceRepair(@LangID,19000001) country	
		on		country.idfsReference = gisRayon.idfsCountry

WHERE	
	gisRayon.idfsRegion = isnull(@RegionID, gisRayon.idfsRegion)
	AND ( (NOT @RegionID IS NULL) OR  (@ID IS NULL) OR (gisRayon.idfsRegion = @ID) )
	--AND (@ID IS NULL OR @ID = idfsRayon)
	and gisRayon.idfsCountry in (select distinct idfsCountry from tstCustomizationPackage)

ORDER BY strRayonName






