--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/07/2017
-- Last modified by:		Joan Li
-- Description:				06/07/2017:Created based on V6 spSettlement_SelectLookup: V7 USP48
--                          Select lookup list of settlements from 
--                          tables: gisSettlement;tstCustomizationPackage ;tstSite
--                          Functions: fnGisReference;fnGisExtendedReferenceRepair;fnGisReferenceRepair
--     
-- Change Log:
-- Name                  Date       Description
-- --------------------- ---------- --------------------------------------------------------------
-- Stephen Long          04/04/2019 Added settlement type ID for SYSUC07 - settlement type drop 
--                                  down on the location user control.
--
-- Testing code:
/*
----testing code:
JL: no data return for gisSettlement only contains GG 780000000 data but fnSiteID restricting for 1
EXEC usp_Settlement_GetLookup 'ru'
EXEC usp_Settlement_GetLookup 'en', 3260000000	
*/
--=====================================================================================================
CREATE PROCEDURE [dbo].[usp_Settlement_GetLookup] @LangID AS NVARCHAR(50), --##PARAM @LangID - language ID
	@RayonID AS BIGINT = NULL, --##PARAM @idfsRayon - settlement rayon. If NULL is passed, entire list of settlements is returned
	@ID AS BIGINT = NULL --##PARAM @ID - ID of specific settlement. If not null, returns only this specific settlement, in other case entire list is returned
AS
SELECT settlement.idfsReference AS idfsSettlement,
	settlement.name AS strSettlementName,
	settlement.ExtendedName AS strSettlementExtendedName,
	gisSettlement.idfsRayon,
	gisSettlement.idfsRegion,
	gisSettlement.idfsCountry,
	settlementType.idfsReference AS SettlementTypeID,
	settlementType.name AS strSettlementType,
	settlement.intRowStatus,
	country.name AS strCountryName,
	region.ExtendedName AS strRegionExtendedName,
	rayon.ExtendedName AS strRayonExtendedName,
	gisSettlement.intElevation
FROM dbo.fnGisExtendedReferenceRepair(@LangID, 19000004) settlement
INNER JOIN dbo.gisSettlement
	ON settlement.idfsReference = gisSettlement.idfsSettlement
JOIN dbo.tstCustomizationPackage tcpac
	ON tcpac.idfsCountry = dbo.gisSettlement.idfsCountry
INNER JOIN dbo.tstSite
	ON dbo.tstSite.idfCustomizationPackage = tcpac.idfCustomizationPackage
		AND tstSite.idfsSite = dbo.fnSiteID()
LEFT JOIN dbo.fnGisReference(@LangID, 19000005) settlementType
	ON settlementType.idfsReference = gisSettlement.idfsSettlementType
LEFT JOIN dbo.fnGisExtendedReferenceRepair(@LangID, 19000003) region
	ON region.idfsReference = gisSettlement.idfsRegion
LEFT JOIN dbo.fnGisExtendedReferenceRepair(@LangID, 19000002) rayon
	ON rayon.idfsReference = gisSettlement.idfsRayon
LEFT JOIN dbo.fnGisReferenceRepair(@LangID, 19000001) country
	ON country.idfsReference = gisSettlement.idfsCountry
WHERE (
		@RayonID IS NULL
		OR gisSettlement.idfsRayon = @RayonID
		)
	AND (
		(NOT @RayonID IS NULL)
		OR (@ID IS NULL)
		OR (gisSettlement.idfsSettlement = @ID)
		)
ORDER BY strSettlementName;
GO