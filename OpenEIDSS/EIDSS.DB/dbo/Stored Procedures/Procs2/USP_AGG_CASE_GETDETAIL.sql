
--*************************************************************
-- Name 				: USP_AGG_CASE_GETDETAIL
-- Description			: Returns one case depending on case type and Case ID.
--          
-- Author               : Arnold Kennedy
-- Revision History		:
--		Name				Date       Change Detail
--		Arnold Kennedy		1-27-19		Removed  input parms except caseID
-- Testing code:
--
-- Legends
/*
	Case Type
	AggregateCase = 10102001
	VetAggregateCase = 10102002
	VetAggregateAction = 10102003
*/

/* Aggregate Case Type
    HumanAggregateCase = 10102001
    VetAggregateCase = 10102002
    VetAggregateAction = 10102003
	exec USP_AGG_CASE_GETDETAIL 'en', @idfsAggrCaseType=10102001, @idfAggrCase=4
*/ 
--*************************************************************
  

CREATE PROCEDURE [dbo].[USP_AGG_CASE_GETDETAIL]
	(
	@LangID						AS NVARCHAR(50)				--##PARAM @LangID - language ID
	,@idfsAggrCaseType			AS BIGINT			= NULL	--tlbAggrCase.idfsAggrCaseType
	,@idfAggrCase				AS BIGINT			= NULL	--tlbAggrCase.idfAggrCase
	)
AS

DECLARE @returnCode	INT = 0 
DECLARE	@returnMsg	NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY

		SELECT 
		tlbAggrCase.idfAggrCase
		,tlbAggrCase.idfsAggrCaseType
		,tlbAggrCase.idfsAdministrativeUnit
		,tlbAggrCase.idfReceivedByOffice
		,ReceivedByOffice.FullName As strReceivedByOffice
		,tlbAggrCase.idfReceivedByPerson
		,tlbAggrCase.idfSentByOffice
		,SentByOffice.FullName as strSentByOffice
		,tlbAggrCase.idfSentByPerson
		,tlbAggrCase.idfEnteredByOffice
		,EnteredByOffice.FullName As strEnteredByOffice
		,tlbAggrCase.idfEnteredByPerson
		,dbo.FN_GBL_FormatDate(tlbAggrCase.datReceivedByDate, 'mm/dd/yyyy') AS datReceivedByDate
		,dbo.FN_GBL_FormatDate(tlbAggrCase.datSentByDate, 'mm/dd/yyyy') AS datSentByDate
		,dbo.FN_GBL_FormatDate(tlbAggrCase.datEnteredByDate, 'mm/dd/yyyy') AS datEnteredByDate
		,dbo.FN_GBL_FormatDate(tlbAggrCase.datStartDate, 'mm/dd/yyyy') AS datStartDate
		,dbo.FN_GBL_FormatDate(tlbAggrCase.datFinishDate, 'mm/dd/yyyy') AS datFinishDate
		,tlbAggrCase.strCaseID
		,AdminUnit.idfsBaseReference AS idfsAreaType
		,ISNULL(Country.idfsGISBaseReference,'') AS idfsCountry
		,ISNULL(Country.strTextString,'') AS strCountry
		,ISNULL(Region.idfsGISBaseReference,'') AS idfsRegion
		,ISNULL(Region.strTextString,'') AS strRegion
		,ISNULL(Rayon.idfsGISBaseReference,'') AS idfsRayon
		,ISNULL(Rayon.strTextString,'') AS strRayon
		,ISNULL(Settlement.idfsGISBaseReference,'') AS idfsSettlement
		,ISNULL(Settlement.strTextString ,'') AS strSettlement

		,Period.idfsBaseReference AS idfsPeriodType
		,Period.strTextString AS strPeriodName
		,tlbAggrCase.idfCaseObservation
		,tlbAggrCase.idfDiagnosticObservation
		,tlbAggrCase.idfProphylacticObservation
		,tlbAggrCase.idfSanitaryObservation
		,DiagnosticObs.idfsFormTemplate as idfsDiagnosticFormTemplate
		,ProphylacticObs.idfsFormTemplate as idfsProphylacticFormTemplate
		,SanitaryObs.idfsFormTemplate as idfsSanitaryFormTemplate
		,CaseObs.idfsFormTemplate as idfsCaseFormTemplate
		,NULL AS Organization												-- ToDo: Get details on which organization to send
	FROM 
		tlbAggrCase

		LEFT JOIN dbo.FN_GBL_Institution(@LangID) ReceivedByOffice ON
			tlbAggrCase.idfReceivedByOffice = ReceivedByOffice.idfOffice

		INNER JOIN dbo.FN_GBL_Institution(@LangID) EnteredByOffice ON
			tlbAggrCase.idfEnteredByOffice = EnteredByOffice.idfOffice

		INNER JOIN dbo.FN_GBL_Institution(@LangID) SentByOffice ON
			tlbAggrCase.idfSentByOffice = SentByOffice.idfOffice
		LEFT OUTER JOIN gisCountry ON
			gisCountry.idfsCountry = tlbAggrCase.idfsAdministrativeUnit

			 
		LEFT OUTER JOIN VW_GBL_REGIONS_GET AS gisRegion ON
			gisRegion.idfsRegion = tlbAggrCase.idfsAdministrativeUnit 
			AND 
			gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN VW_GBL_RAYONS_GET as gisRayon ON
			gisRayon.idfsRayon = tlbAggrCase.idfsAdministrativeUnit
			AND 
			gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN gisSettlement ON
			gisSettlement.idfsSettlement = tlbAggrCase.idfsAdministrativeUnit  
		LEFT OUTER JOIN gisStringNameTranslation Country ON 
			Country.idfsGISBaseReference =	CASE WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsCountry
											WHEN NOT gisRayon.idfsRayon IS NULL THEN gisRayon.idfsCountry
											WHEN NOT gisRegion.idfsRegion IS NULL THEN gisRegion.idfsCountry
											ELSE gisCountry.idfsCountry 
											END
			AND 
			Country.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN gisStringNameTranslation Region ON 
			Region.idfsGISBaseReference =	CASE WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsRegion	
											WHEN NOT gisRayon.idfsRayon IS NULL THEN gisRayon.idfsRegion
											ELSE gisRegion.idfsRegion 
											END
			AND 
			Region.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN gisStringNameTranslation Rayon ON 
			Rayon.idfsGISBaseReference =	CASE WHEN NOT gisSettlement.idfsSettlement IS NULL THEN gisSettlement.idfsRayon
											ELSE gisRayon.idfsRayon 
											END
			AND 
			Rayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN gisStringNameTranslation Settlement ON 
			Settlement.idfsGISBaseReference = gisSettlement.idfsSettlement	
			AND 
			Settlement.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN trtBaseReference AdminUnit ON
			AdminUnit.idfsBaseReference =	CASE WHEN NOT gisSettlement.idfsSettlement IS NULL THEN 10089004
											WHEN NOT gisRayon.idfsRayon IS NULL THEN 10089002
											WHEN NOT gisRegion.idfsRegion IS NULL THEN 10089003
											WHEN NOT gisCountry.idfsCountry IS NULL THEN 10089001 
											END
		LEFT OUTER JOIN trtStringNameTranslation Period ON
			Period.idfsBaseReference =	CASE 
										WHEN DateDiff(day, datStartDate, datFinishDate) = 0 THEN 10091002		/*day*/	  
										WHEN DateDiff(day, datStartDate, datFinishDate) = 6 THEN 10091004		/*week - use datediff with day because datediff with week will return incorrect result if first day of week in country differ from sunday*/	      
										WHEN DateDiff(month, datStartDate, datFinishDate) = 0 THEN 10091001		/*month*/	      
										WHEN DateDiff(quarter, datStartDate, datFinishDate) = 0 THEN 10091003	/*quarter*/	      
										WHEN DateDiff(year, datStartDate, datFinishDate) = 0 THEN 10091005		/*year*/	
										END	
			AND 
			Period.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		LEFT OUTER JOIN tlbObservation CaseObs ON 
			idfCaseObservation = CaseObs.idfObservation
		LEFT OUTER JOIN tlbObservation DiagnosticObs ON 
			idfDiagnosticObservation = DiagnosticObs.idfObservation
		LEFT OUTER JOIN tlbObservation ProphylacticObs ON 
			idfProphylacticObservation = ProphylacticObs.idfObservation
		LEFT OUTER JOIN tlbObservation SanitaryObs ON 
			idfSanitaryObservation = SanitaryObs.idfObservation
	WHERE 
		tlbAggrCase.intRowStatus = 0
		AND
		(CASE WHEN @idfsAggrCaseType IS NULL THEN 1 WHEN ISNULL(tlbAggrCase.idfsAggrCaseType, '') = @idfsAggrCaseType THEN 1 ELSE 0 END = 1) 
				AND
		(CASE WHEN @idfAggrCase IS NULL THEN 1 WHEN ISNULL(tlbAggrCase.idfAggrCase, '') = @idfAggrCase THEN 1 ELSE 0 END = 1) 

	END TRY  

	BEGIN CATCH 
	Throw;

	END CATCH
END
