


--##SUMMARY Selects outbreak data for OutbreakDetail form.
--##SUMMARY Called by OutbreakDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @OutbreakID bigint
DECLARE @LangID nvarchar(50)


EXECUTE spOutbreak_PopulateCaseInfo
   750650000000
  ,'en'

*/


CREATE     PROCEDURE [dbo].[spOutbreak_PopulateCaseInfo]
	@CaseID AS bigint,  --##PARAM @CaseID - case ID
	@LangID NVARCHAR(50)  --##PARAM @LangID - lanquage ID
as

DECLARE @CaseType AS BIGINT

SELECT
	@CaseType = idfsCaseType
FROM (		
	SELECT		10012001 AS idfsCaseType
	FROM		tlbHumanCase
	WHERE		idfHumanCase = @CaseID
				and intRowStatus = 0	
	UNION ALL
	SELECT		10012006 AS idfsCaseType
	FROM		tlbVectorSurveillanceSession
	WHERE		idfVectorSurveillanceSession = @CaseID
				and intRowStatus = 0	
	UNION ALL
	SELECT		idfsCaseType
	FROM		tlbVetCase
	WHERE		idfVetCase = @CaseID
				and intRowStatus = 0	
) x	

IF @CaseType IS NULL
	RETURN 1

IF @CaseType = 10012001 --human case
BEGIN
	select		CaseStatus.name as strCaseStatus, 
				convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as Confirmed,
				Diagnosis.name as strDiagnosis, 
				isnull(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) as idfsDefaultDiagnosis,

				isnull(tlbHumanCase.datOnSetDate,
				isnull(datFirstSoughtCareDate,
				isnull(isnull(datFinalDiagnosisDate,datTentativeDiagnosisDate),
				isnull(tlbHumanCase.datNotificationDate, 
				tlbHumanCase.datEnteredDate)))) as datEnteredDate,

				case when tlbHumanCase.datOnSetDate is not null then 1
				 	when datFirstSoughtCareDate is not null then 2
				 	when isnull(datFinalDiagnosisDate,datTentativeDiagnosisDate) is not null then 3
				 	when tlbHumanCase.datNotificationDate is not null then 4 
				else 5 end as idfsSourceOfCaseSessionDate,
					
				tlbHumanCase.idfPointGeoLocation as idfGeoLocation,
				tlbHuman.idfCurrentResidenceAddress as idfAddress,
				dbo.fnGeoLocationString(@LangID,tlbHumanCase.idfPointGeoLocation,null) As strGeoLocation,
				dbo.fnAddressString(@LangID,tlbHuman.idfCurrentResidenceAddress) As strAddress,
				dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName,
				tlbHumanCase.strCaseID as strCaseID,
				@CaseType as idfsCaseType
	from		tlbHumanCase
	inner join	tlbHuman
	on				tlbHuman.idfHuman = tlbHumanCase.idfHuman
					and tlbHuman.intRowStatus = 0
	left join	dbo.fnReference(@LangID,19000019) as Diagnosis --'rftDiagnosis'
	on			ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) = Diagnosis.idfsReference
	left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
	on			ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) = CaseStatus.idfsReference
	where tlbHumanCase.idfHumanCase = @CaseID
END
ELSE IF @CaseType = 10012006 --vector
BEGIN
	select		
			CONVERT(nvarchar,null) as  strCaseStatus, 
			convert(int, 1) as Confirmed,
		    dbo.fn_VsSession_GetDiagnosesNames(vs.idfVectorSurveillanceSession, @LangID) as strDiagnosis,   
			convert(bigint, null) as idfsDefaultDiagnosis,
			vs.datStartDate as datEnteredDate,
			15 as idfsSourceOfCaseSessionDate,
			vs.idfLocation as idfGeoLocation,
			vs.idfLocation as idfAddress,
			dbo.fnGeoLocationString(@LangID,vs.idfLocation,null) As strGeoLocation,
			dbo.fnAddressString(@LangID,vs.idfLocation) As strAddress,
			NULL as strPatientName,
			vs.strSessionID as strCaseID,
			@CaseType as idfsCaseType

	from	tlbVectorSurveillanceSession vs
	where	vs.idfVectorSurveillanceSession = @CaseID
END
ELSE --vet case
BEGIN
	select		
				CaseStatus.name as strCaseStatus, 
				convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as Confirmed,
				ISNULL(Diagnosis.strDisplayDiagnosis, tlbVetCase.strDefaultDisplayDiagnosis) as strDiagnosis,   
				tlbVetCase.idfsShowDiagnosis as idfsDefaultDiagnosis,

				isnull(
					(
						select min(datStartOfSignsDate) from tlbSpecies
						inner JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd and tlbHerd.intRowStatus = 0
						where tlbHerd.idfFarm = tlbVetCase.idfFarm and tlbSpecies.intRowStatus = 0
					),
				isnull(case when isnull(tlbVetCase.datReportDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datReportDate end,
				isnull(case when isnull(tlbVetCase.datAssignedDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datAssignedDate end,
				isnull(case when isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101') then tlbVetCase.datInvestigationDate end, 
				isnull(case when isnull(tlbVetCase.datTentativeDiagnosisDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosisDate end,
				isnull(case when isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosis1Date end,
				isnull(case when isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then tlbVetCase.datTentativeDiagnosis2Date end,
				isnull(tlbVetCase.datFinalDiagnosisDate,
				tlbVetCase.datEnteredDate)))))))) as datEnteredDate,
			 
				case when
				 	(
						select min(datStartOfSignsDate) from tlbSpecies
						inner JOIN tlbHerd ON tlbHerd.idfHerd = tlbSpecies.idfHerd and tlbHerd.intRowStatus = 0
						where tlbHerd.idfFarm = tlbVetCase.idfFarm and tlbSpecies.intRowStatus = 0
				 	) is not null then 6
				 	when isnull(tlbVetCase.datReportDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 7
				 	when isnull(tlbVetCase.datAssignedDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 8
				 	when isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosisDate,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000101')
						 and isnull(tlbVetCase.datInvestigationDate,'30000102')<=isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000101') then 9 
				 	when isnull(tlbVetCase.datTentativeDiagnosisDate,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 10
				 	when isnull(tlbVetCase.datTentativeDiagnosis1Date,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 11
				 	when isnull(tlbVetCase.datTentativeDiagnosis2Date,'30000102')<=isnull(tlbVetCase.datFinalDiagnosisDate,'30000101') then 12
				 	when tlbVetCase.datFinalDiagnosisDate is not null then 13
				else 14 end as idfsSourceOfCaseSessionDate,

				tlbFarm.idfFarmAddress as idfGeoLocation,
				tlbFarm.idfFarmAddress as idfAddress,
				dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null) As strGeoLocation,
				dbo.fnAddressString(@LangID,tlbFarm.idfFarmAddress) As strAddress,
				dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName,
				tlbVetCase.strCaseID as strCaseID,
				@CaseType as idfsCaseType

	from		tlbVetCase
	LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
	on	tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
	on			tlbVetCase.idfsCaseClassification = CaseStatus.idfsReference
	left join tlbFarm
			on		tlbFarm.idfFarm = tlbVetCase.idfFarm
			and		tlbFarm.intRowStatus = 0
	left join		tlbHuman
			on		tlbHuman.idfHuman = tlbFarm.idfHuman
					and tlbHuman.intRowStatus = 0
	where tlbVetCase.idfVetCase = @CaseID

END



