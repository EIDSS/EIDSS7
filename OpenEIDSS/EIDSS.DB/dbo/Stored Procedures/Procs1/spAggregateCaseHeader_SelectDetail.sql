



--##SUMMARY Selects data for header of all aggregate forms.
--##SUMMARY These data are common for all aggreage cases.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 01.12.2009

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfAggrCase bigint
DECLARE @idfsAggrCaseType bigint
SET @idfsAggrCaseType = 10102002 --Vet aggregate case
EXECUTE spAggregateCaseHeader_SelectDetail 4016750000871, 10102001
	@idfAggrCase
	,@idfsAggrCaseType

*/




CREATE PROC	spAggregateCaseHeader_SelectDetail
		@idfAggrCase	bigint --##PARAM @idfAggrCase - aggregate case ID
		,@idfsAggrCaseType bigint --##PARAM @idfsAggrCaseType - aggregate case Type
		,@LangID		nvarchar(50) = 'en' --##PARAM @LangID - language ID
as

exec dbo.spSetFirstDay

--IF @idfsAggrCaseType IS NULL
--	EXECUTE spThrowException 'Aggregate case Type is not defined'

SELECT idfAggrCase
      ,idfsAggrCaseType
	  ,CASE idfsAggrCaseType WHEN 10102001 THEN 2 ELSE 32 END AS intHACode
      ,idfsAdministrativeUnit
      ,idfReceivedByOffice
      ,idfReceivedByPerson
			,tlbReceivedByOffice.[name] as strReceivedByOffice
			,dbo.fnConcatFullName(tlbReceivedByPerson.strFamilyName, tlbReceivedByPerson.strFirstName, tlbReceivedByPerson.strSecondName) as strReceivedByPerson
      ,idfSentByOffice
      ,idfSentByPerson
			,tlbSentByOffice.[name] as strSentByOffice
			,dbo.fnConcatFullName(tlbSentByPerson.strFamilyName, tlbSentByPerson.strFirstName, tlbSentByPerson.strSecondName) as strSentByPerson
      ,idfEnteredByOffice
      ,idfEnteredByPerson
			,tlbEnteredByOffice.[name] as strEnteredByOffice
			,dbo.fnConcatFullName(tlbEnteredByPerson.strFamilyName, tlbEnteredByPerson.strFirstName, tlbEnteredByPerson.strSecondName) as strEnteredByPerson
      ,idfCaseObservation
      ,CaseObservation.idfsFormTemplate as idfsCaseObservationFormTemplate
      ,idfDiagnosticObservation
      ,DiagnosticObservation.idfsFormTemplate as idfsDiagnosticObservationFormTemplate
      ,idfProphylacticObservation
      ,ProphylacticObservation.idfsFormTemplate as idfsProphylacticObservationFormTemplate
      ,idfSanitaryObservation
      ,SanitaryObservation.idfsFormTemplate as idfsSanitaryObservationFormTemplate
	  ,idfVersion
	  ,idfDiagnosticVersion
	  ,idfProphylacticVersion
	  ,idfSanitaryVersion
      ,datReceivedByDate
      ,datSentByDate
      ,datEnteredByDate
      ,datStartDate
      ,datFinishDate
      ,strCaseID
		,YearForAggr = cast(
			case when DateDiff(day, datStartDate, datFinishDate) < 2 then Year(datStartDate)
			     when dbo.fnWeekDatediff(datStartDate, datFinishDate) < 2 then Year(dateadd(day, 4 - DATEPART(dw, datStartDate) , datStartDate))
			     else Year(datStartDate)
			end as bigint)
		,QuarterForAggr = cast(
			case when DateDiff(day, datStartDate, datFinishDate) < 2 then DatePart(quarter, datStartDate)
			     when dbo.fnWeekDatediff(datStartDate, datFinishDate) < 2 then DatePart(quarter, dateadd(day, 4 - DATEPART(dw, datStartDate) , datStartDate))
				 when DateDiff(quarter, datStartDate, datFinishDate) < 2 then DatePart(quarter, datStartDate)
				else null
			end as bigint)
		,MonthForAggr = cast(
			case when DateDiff(day, datStartDate, datFinishDate) < 2 then DatePart(month, datStartDate)
			     when dbo.fnWeekDatediff(datStartDate, datFinishDate) < 2 then DatePart(month, dateadd(day, 4 - DATEPART(dw, datStartDate) , datStartDate))
			     when DateDiff(month, datStartDate, datFinishDate) < 2 then DatePart(month, datStartDate)
				else null
			end as bigint)
		,WeekForAggr = cast(
			case when dbo.fnWeekDatediff(datStartDate, datFinishDate) < 2 then dbo.fnWeekDatepart(datStartDate)
				 else null
			end as bigint)
		,DayForAggr =
			case when DateDiff(day, datStartDate, datFinishDate) < 2 then datStartDate
				else null
			end
		,gisCountry.idfsCountry 
		,gisRegion.idfsRegion
		,gisRayon.idfsRayon
		,gisSettlement.idfsSettlement
		,CAST (NULL as bigint) as CurPeriodType
		,CAST (NULL as bigint) as CurAreaType
		,datModificationForArchiveDate
  FROM tlbAggrCase
		left outer join tlbObservation CaseObservation
		on		CaseObservation.idfObservation = tlbAggrCase.idfCaseObservation
				and CaseObservation.intRowStatus=0
		left outer join tlbObservation DiagnosticObservation
		on		DiagnosticObservation.idfObservation = tlbAggrCase.idfDiagnosticObservation
				and DiagnosticObservation.intRowStatus=0
		left outer join tlbObservation ProphylacticObservation
		on		ProphylacticObservation.idfObservation = tlbAggrCase.idfProphylacticObservation
				and ProphylacticObservation.intRowStatus=0
		left outer join tlbObservation SanitaryObservation
		on		SanitaryObservation.idfObservation = tlbAggrCase.idfSanitaryObservation
				and SanitaryObservation.intRowStatus=0
		left outer join gisCountry
		on		gisCountry.idfsCountry = idfsAdministrativeUnit 
				or exists(
					select	* 
					from	vwRegionAggr as gisRegion
					where	gisRegion.idfsRegion = idfsAdministrativeUnit
							and gisRegion.idfsCountry = gisCountry.idfsCountry
							and gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
							)
				or exists(
					select	* 
					from	vwRayonAggr as gisRayon
					where	gisRayon.idfsRayon = idfsAdministrativeUnit
							and gisRayon.idfsCountry = gisCountry.idfsCountry
							and gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
							)
				or exists(
					select	* 
					from	gisSettlement 
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsCountry = gisCountry.idfsCountry)
		left outer join vwRegionAggr as gisRegion
		on		gisRegion.idfsRegion = idfsAdministrativeUnit
				and gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID) 
				or exists(
					select	* 
					from	vwRayonAggr as gisRayon
					where	gisRayon.idfsRayon = idfsAdministrativeUnit
							and gisRayon.idfsCountry = gisCountry.idfsCountry
							and gisRayon.idfsRegion = gisRegion.idfsRegion
							and gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
							and gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
							)
				or exists(
					select	* 
					from	gisSettlement
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsRegion = gisRegion.idfsRegion
							and gisRegion.idfsLanguage = dbo.fnGetLanguageCode(@LangID))
		left outer join vwRayonAggr as gisRayon
		on		gisRayon.idfsRayon = idfsAdministrativeUnit
				and gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID) 
				or exists(
					select	* 
					from	gisSettlement
					where	gisSettlement.idfsSettlement = idfsAdministrativeUnit
							and gisSettlement.idfsRayon = gisRayon.idfsRayon
							and gisRayon.idfsLanguage = dbo.fnGetLanguageCode(@LangID))
		left outer join gisSettlement
		on		gisSettlement.idfsSettlement = idfsAdministrativeUnit

		left join	dbo.fnInstitution(@LangID) as tlbSentByOffice 
		on			tlbSentByOffice.idfOffice = idfSentByOffice
		left join	dbo.fnInstitution(@LangID) as tlbReceivedByOffice
		on			tlbReceivedByOffice.idfOffice = idfReceivedByOffice
		left join	dbo.fnInstitution(@LangID) as tlbEnteredByOffice
		on			tlbEnteredByOffice.idfOffice = idfEnteredByOffice
		left join	tlbPerson as tlbSentByPerson
		on			tlbSentByPerson.idfPerson = idfSentByPerson
		left join	tlbPerson as tlbReceivedByPerson
		on			tlbReceivedByPerson.idfPerson = idfReceivedByPerson
		left join	tlbPerson as tlbEnteredByPerson
		on			tlbEnteredByPerson.idfPerson = idfEnteredByPerson

WHERE 
	idfAggrCase = @idfAggrCase

SELECT @idfsAggrCaseType = ISNULL(idfsAggrCaseType,@idfsAggrCaseType)
FROM
	tlbAggrCase
WHERE 
	idfAggrCase = @idfAggrCase

EXEC spAggregateSettings_SelectDetail @idfsAggrCaseType


