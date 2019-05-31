

--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/01/2017
-- Last modified by:		Joan Li
-- Description:				06/01/2017:Created based on V6 spSettlementAggr_SelectLookup: rename for V7 USP43
--                                     Select data for SettlementDetail from 
--                                     gisSettlement,tstCustomizationPackage,tstSite,gisStringNameTranslation 
--                                     fnGisReferenceRepair,gisBaseReference
--                                     spSettlement_GetLookup
--							10/16/2016: fixed the glich of calling of SP name 					
-- Testing code:
/*
----testing code:
EXEC spSettlementAggr_GetLookup 'en'					---no records? need to look at data in db
EXEC spSettlementAggr_GetLookup 'en', 1344620000000	---no records?
EXEC spSettlementAggr_GetLookup 'en', 868			---no records?
	
*/
--=====================================================================================================

CREATE         PROCEDURE [dbo].[usp_SettlementAggr_GetLookup]

	@LangID AS NVARCHAR(50),  --##PARAM @LangID - language ID

	@RayonID AS BIGINT = NULL,   --##PARAM @idfsRayon - settlement rayon. If NULL is passed, entire list of settlements is returned

	@ID AS BIGINT = NULL,   --##PARAM @ID - ID of specific settlement. If not null, returns only this specific settlement, in other case entire list is returned

	@idfsAggrCaseType AS BIGINT = NULL

AS

IF @idfsAggrCaseType = 10102001 -- HumanAggregateCase

BEGIN

	declare @CurrentCountryID bigint

	SET @CurrentCountryID = dbo.fnCurrentCountry()

	SELECT	

		gisBaseReference.idfsGISBaseReference AS idfsSettlement, 

		ISNULL(gisStringNameTranslation.strTextString, gisBaseReference.strDefault) AS strSettlementName,

		gisSettlement.idfsRayon,

		gisSettlement.idfsRegion,

		gisSettlement.idfsCountry,

		gisBaseReference.intRowStatus

	FROM dbo.gisBaseReference 

	INNER JOIN 	gisSettlement	
		ON	gisBaseReference.idfsGISBaseReference = gisSettlement.idfsSettlement 
		AND ( @RayonID IS NULL OR gisSettlement.idfsRayon = @RayonID )
		AND ( (NOT @RayonID IS NULL)OR  (@ID IS NULL) OR (gisSettlement.idfsSettlement = @ID) )
	JOIN tstCustomizationPackage tcpac 
		ON tcpac.idfsCountry = gisSettlement.idfsCountry
	INNER JOIN tstSite
		ON tstSite.idfCustomizationPackage=tcpac.idfCustomizationPackage AND tstSite.idfsSite=dbo.fnSiteID()
	LEFT JOIN gisStringNameTranslation 
		ON gisBaseReference.idfsGISBaseReference = gisStringNameTranslation.idfsGISBaseReference
 		AND gisStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		AND gisStringNameTranslation.intRowStatus = 0
	WHERE	
		 gisBaseReference.idfsGISReferenceType = 19000004 --'rftSettlement'
		 AND gisSettlement.idfsCountry = @CurrentCountryID
	UNION ALL	 

	SELECT	

		settl.idfsReference AS idfsSettlement, 

		settl.[name] AS strSettlementName,

		rayon.idfsReference AS idfsRayon,

		region.idfsReference AS idfsRegion,

		@CurrentCountryID,

		settl.intRowStatus

	FROM dbo.fnGisReferenceRepair(@LangID,19000022) AS settl 
		INNER JOIN gisBaseReference gbr
			ON gbr.idfsGISBaseReference = settl.idfsReference
			AND gbr.intRowStatus = 0
		INNER JOIN dbo.fnGisReferenceRepair(@LangID,19000021) AS rayon 
			ON CAST(gbr.strBaseReferenceCode AS BIGINT) = rayon.idfsReference
		CROSS JOIN dbo.fnGisReferenceRepair(@LangID,19000020) AS region  --'rftAggrRegion'
	WHERE @CurrentCountryID = 170000000	
		AND (@ID IS NULL OR @ID = rayon.idfsReference)
		AND rayon.idfsReference = @RayonID
	ORDER BY strSettlementName
END	 

ELSE  -- Other cases (not HumanAggregateCase)
	BEGIN
		EXEC usp_Settlement_GetLookup @LangID, @RayonID, @ID
	END







