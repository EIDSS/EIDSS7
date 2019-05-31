
--##SUMMARY Returns list of aggregate cases depending on case type.
--##SUMMARY This function is used internally by functions that load data for specific aggregate cases.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 03.10.2011


--##RETURNS Returns list of human aggregate case.



/*
select * from fnAggregateCaseList ('en', 10102001)
*/

/* Statistic period types
    None = 0
    Month = 10091001
    Day = 10091002
    Quarter = 10091003
    Week = 10091004
    Year = 10091005

*/
/*
StatisticAreaType
    None = 0
    Country = 10089001
    Rayon = 10089002
    Region = 10089003
    Settlement = 10089004
*/

/* Aggregate Case Type
    HumanAggregateCase = 10102001
    VetAggregateCase = 10102002
    VetAggregateAction = 10102003
*/
Create     Function [dbo].[fnAggregateCaseList](
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
	,@caseType as bigint  --##PARAM @caseType - aggregate case type 
)
returns table 
as
return
SELECT [idfAggrCase]
      ,[idfsAggrCaseType]
      ,[idfsAdministrativeUnit]
      ,[idfReceivedByOffice]
      ,[idfReceivedByPerson]
      ,[idfSentByOffice]
      ,[idfSentByPerson]
      ,[idfEnteredByOffice]
      ,[idfEnteredByPerson]
      ,[datReceivedByDate]
      ,[datSentByDate]
      ,[datEnteredByDate]
      ,[datStartDate]
      ,[datFinishDate]
      ,[strCaseID]
      ,adminUnit.idfsBaseReference as idfsAreaType
      ,country.idfsGISBaseReference as idfsCountry
      ,country.strTextString as strCountry
      ,region.idfsGISBaseReference as idfsRegion
      ,region.strTextString as strRegion
      ,rayon.idfsGISBaseReference as idfsRayon
      ,rayon.strTextString as strRayon
      ,settlement.idfsGISBaseReference as idfsSettlement
      ,settlement.strTextString as strSettlement
      ,period.idfsBaseReference as idfsPeriodType
      ,period.strTextString as strPeriodName
	  ,idfCaseObservation
	  ,idfDiagnosticObservation
	  ,idfProphylacticObservation
	  ,idfSanitaryObservation
	  ,diagnosticObs.idfsFormTemplate as idfsDiagnosticFormTemplate
	  ,prophylacticObs.idfsFormTemplate as idfsProphylacticFormTemplate
	  ,sanitaryObs.idfsFormTemplate as idfsSanitaryFormTemplate
	  ,caseObs.idfsFormTemplate as idfsCaseFormTemplate
                                                                       

FROM tlbAggrCase
	left outer join gisCountry
	on		gisCountry.idfsCountry = idfsAdministrativeUnit 
	--AND gisCountry.intRowStatus = 0
	left outer join vwRegionAggr as gisRegion
	on		gisRegion.idfsRegion = idfsAdministrativeUnit 
			and gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	--AND gisRegion.intRowStatus = 0
	left outer join vwRayonAggr as gisRayon
	on		gisRayon.idfsRayon = idfsAdministrativeUnit
			and gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	--AND gisRayon.intRowStatus = 0
	left outer join gisSettlement
	on		gisSettlement.idfsSettlement = idfsAdministrativeUnit  
	--AND gisSettlement.intRowStatus = 0
	LEFT OUTER JOIN gisStringNameTranslation country on 
		country.idfsGISBaseReference = CASE	WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsCountry
				WHEN NOT gisRayon.idfsRayon IS NULL THEN gisRayon.idfsCountry
				WHEN NOT gisRegion.idfsRegion IS NULL THEN gisRegion.idfsCountry
				ELSE gisCountry.idfsCountry END
		AND country.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	LEFT OUTER JOIN gisStringNameTranslation region on 
		region.idfsGISBaseReference = CASE	WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsRegion
				WHEN NOT gisRayon.idfsRayon IS NULL THEN gisRayon.idfsRegion
				ELSE gisRegion.idfsRegion END
		AND region.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	LEFT OUTER JOIN gisStringNameTranslation rayon on 
		rayon.idfsGISBaseReference = CASE	WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsRayon
				ELSE gisRayon.idfsRayon END
		AND rayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	LEFT OUTER JOIN gisStringNameTranslation settlement on 
		settlement.idfsGISBaseReference = gisSettlement.idfsSettlement
		AND settlement.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	LEFT OUTER JOIN trtBaseReference adminUnit on
		adminUnit.idfsBaseReference = CASE	WHEN NOT gisSettlement.idfsSettlement IS NULL THEN 10089004
				WHEN NOT gisRayon.idfsRayon IS NULL THEN 10089002
				WHEN NOT gisRegion.idfsRegion IS NULL THEN 10089003
				WHEN NOT gisCountry.idfsCountry IS NULL THEN 10089001 END
	LEFT OUTER JOIN trtStringNameTranslation period on
		period.idfsBaseReference = case 
			WHEN DateDiff(day, datStartDate, datFinishDate)=0 THEN 10091002 /*day*/	  
			WHEN DateDiff(day, datStartDate, datFinishDate)=6 THEN 10091004 /*week - use datediff with day because datediff with week will return incorrect result if first day of week in country differ from sunday*/	      
			WHEN DateDiff(month, datStartDate, datFinishDate)=0 THEN 10091001 /*month*/	      
			WHEN DateDiff(quarter, datStartDate, datFinishDate)=0 THEN 10091003 /*quarter*/	      
			WHEN DateDiff(year, datStartDate, datFinishDate)=0 THEN 10091005 /*year*/	END 	
	AND period.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	
	LEFT OUTER JOIN tlbObservation caseObs
	on idfCaseObservation = caseObs.idfObservation
	LEFT OUTER JOIN tlbObservation diagnosticObs
	on idfDiagnosticObservation = diagnosticObs.idfObservation
	LEFT OUTER JOIN tlbObservation prophylacticObs
	on idfProphylacticObservation = prophylacticObs.idfObservation
	LEFT OUTER JOIN tlbObservation sanitaryObs
	on idfSanitaryObservation = sanitaryObs.idfObservation

		
WHERE tlbAggrCase.intRowStatus = 0
		AND tlbAggrCase.idfsAggrCaseType = @caseType

