

--##SUMMARY Selects lookup list of settlements.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

EXEC spSettlementAggr_SelectLookup 'en'
EXEC spSettlementAggr_SelectLookup 'en', 1344620000000

EXEC spSettlementAggr_SelectLookup 'en', 868

*/
create         PROCEDURE dbo.spSettlementAggr_SelectLookup
	@LangID As nvarchar(50),  --##PARAM @LangID - language ID
	@RayonID as bigint = NULL,   --##PARAM @idfsRayon - settlement rayon. If NULL is passed, entire list of settlements is returned
	@ID as bigint = NULL,   --##PARAM @ID - ID of specific settlement. If not null, returns only this specific settlement, in other case entire list is returned
	@idfsAggrCaseType as bigint = null
as
if @idfsAggrCaseType = 10102001 -- HumanAggregateCase
BEGIN
	declare @CurrentCountryID bigint
	SET @CurrentCountryID = dbo.fnCurrentCountry()
	SELECT	
		gisBaseReference.idfsGISBaseReference AS idfsSettlement, 
		isnull(gisStringNameTranslation.strTextString, gisBaseReference.strDefault) AS strSettlementName,
		gisSettlement.idfsRayon,
		gisSettlement.idfsRegion,
		gisSettlement.idfsCountry,
		gisBaseReference.intRowStatus
	FROM dbo.gisBaseReference 
	INNER JOIN 	gisSettlement	ON	
		gisBaseReference.idfsGISBaseReference = gisSettlement.idfsSettlement 
		AND ( @RayonID IS NULL OR gisSettlement.idfsRayon = @RayonID )
		AND ( (NOT @RayonID IS NULL)OR  (@ID IS NULL) OR (gisSettlement.idfsSettlement = @ID) )
	join tstCustomizationPackage tcpac on
		tcpac.idfsCountry = gisSettlement.idfsCountry
	inner join tstSite
	on tstSite.idfCustomizationPackage=tcpac.idfCustomizationPackage and tstSite.idfsSite=dbo.fnSiteID()
	LEFT JOIN gisStringNameTranslation  ON 
		gisBaseReference.idfsGISBaseReference = gisStringNameTranslation.idfsGISBaseReference
 		AND gisStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		AND gisStringNameTranslation.intRowStatus = 0
	WHERE	
		 gisBaseReference.idfsGISReferenceType = 19000004 --'rftSettlement'
		 and gisSettlement.idfsCountry = @CurrentCountryID
		 union all
		 
	SELECT	
		settl.idfsReference AS idfsSettlement, 
		settl.[name] AS strSettlementName,
		rayon.idfsReference as idfsRayon,
		region.idfsReference as idfsRegion,
		@CurrentCountryID,
		settl.intRowStatus
	FROM dbo.fnGisReferenceRepair(@LangID,19000022) as settl 
		inner join gisBaseReference gbr
		on gbr.idfsGISBaseReference = settl.idfsReference
		and gbr.intRowStatus = 0
		inner join dbo.fnGisReferenceRepair(@LangID,19000021) as rayon  
		on cast(gbr.strBaseReferenceCode as bigint) = rayon.idfsReference
		cross join dbo.fnGisReferenceRepair(@LangID,19000020) as region  --'rftAggrRegion'
	where @CurrentCountryID = 170000000	
		and (@ID IS NULL OR @ID = rayon.idfsReference)
		and rayon.idfsReference = @RayonID


	ORDER BY strSettlementName
END	 
else
	exec spSettlement_SelectLookup @LangID, @RayonID, @ID



