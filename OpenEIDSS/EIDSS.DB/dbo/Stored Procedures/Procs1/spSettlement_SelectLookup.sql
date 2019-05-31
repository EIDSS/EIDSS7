

--##SUMMARY Selects lookup list of settlements.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

EXEC spSettlement_SelectLookup 'en'
EXEC spSettlement_SelectLookup 'en', 3260000000

*/
CREATE         PROCEDURE dbo.spSettlement_SelectLookup
	@LangID As nvarchar(50),  --##PARAM @LangID - language ID
	@RayonID as bigint = NULL,   --##PARAM @idfsRayon - settlement rayon. If NULL is passed, entire list of settlements is returned
	@ID as bigint = NULL   --##PARAM @ID - ID of specific settlement. If not null, returns only this specific settlement, in other case entire list is returned
AS
SELECT	
	settlement.idfsReference AS idfsSettlement, 
	settlement.name AS strSettlementName,
	settlement.ExtendedName AS strSettlementExtendedName,
	gisSettlement.idfsRayon,
	gisSettlement.idfsRegion,
	gisSettlement.idfsCountry,
	settlementType.name as strSettlementType,
	settlement.intRowStatus,
	country.name as strCountryName,
	region.ExtendedName as strRegionExtendedName,
	rayon.ExtendedName as strRayonExtendedName,
	gisSettlement.intElevation
FROM dbo.fnGisExtendedReferenceRepair(@LangID,19000004) settlement
INNER JOIN 	gisSettlement	
	ON	settlement.idfsReference = gisSettlement.idfsSettlement 
join tstCustomizationPackage tcpac on
	tcpac.idfsCountry = gisSettlement.idfsCountry
inner join tstSite
	on	tstSite.idfCustomizationPackage=tcpac.idfCustomizationPackage 
	and tstSite.idfsSite=dbo.fnSiteID()
left join fnGisReference(@LangID, 19000005) settlementType 
	on settlementType.idfsReference = gisSettlement.idfsSettlementType
left join dbo.fnGisExtendedReferenceRepair(@LangID,19000003) region
	on region.idfsReference = gisSettlement.idfsRegion
left join dbo.fnGisExtendedReferenceRepair(@LangID,19000002) rayon
	on rayon.idfsReference = gisSettlement.idfsRayon
left join dbo.fnGisReferenceRepair(@LangID,19000001) country
	on country.idfsReference = gisSettlement.idfsCountry

WHERE	
( @RayonID IS NULL OR gisSettlement.idfsRayon = @RayonID )
	AND ( (NOT @RayonID IS NULL)OR  (@ID IS NULL) OR (gisSettlement.idfsSettlement = @ID) )
ORDER BY strSettlementName



