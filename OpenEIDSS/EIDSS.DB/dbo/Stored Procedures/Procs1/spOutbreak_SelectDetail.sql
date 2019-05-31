


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


EXECUTE spOutbreak_SelectDetail
   750650000000
  ,'en'

*/


CREATE     PROCEDURE [dbo].[spOutbreak_SelectDetail]
	@OutbreakID AS bigint,  --##PARAM @OutbreakID - outbreak ID
	@LangID NVARCHAR(50)  --##PARAM @LangID - lanquage ID
as
--0 Outbreak
SELECT tlbOutbreak.idfOutbreak
      ,idfsDiagnosisOrDiagnosisGroup
      ,idfsOutbreakStatus
      ,idfGeoLocation
      ,strOutbreakID
	  ,tlbOutbreak.datStartDate
	  ,datFinishDate
	  ,tlbOutbreak.strDescription
	  ,idfPrimaryCaseOrSession
	  ,COALESCE(tlbHumanCase.strCaseID,tlbVetCase.strCaseID, N'') + ISNULL(N', ' + Diagnosis.name,N'') as strPrimaryCase
	  ,CONVERT(bigint, 
		CASE
			when tlbHumanCase.idfHumanCase is not null then 10012001
			when tlbVetCase.idfVetCase is not null then tlbVetCase.idfsCaseType
			when tlbVectorSurveillanceSession.idfVectorSurveillanceSession is not null then 10012006
		END			
		) as idfsCasePrimaryType
		,tlbOutbreak.datModificationForArchiveDate
  FROM tlbOutbreak
LEFT JOIN tlbHumanCase ON
	tlbOutbreak.idfPrimaryCaseOrSession = tlbHumanCase.idfHumanCase
	AND tlbHumanCase.intRowStatus = 0
LEFT JOIN tlbVetCase ON
	tlbOutbreak.idfPrimaryCaseOrSession = tlbVetCase.idfVetCase
	AND tlbVetCase.intRowStatus = 0
LEFT JOIN tlbVectorSurveillanceSession ON
	tlbOutbreak.idfPrimaryCaseOrSession = tlbVectorSurveillanceSession.idfOutbreak
left join	dbo.fnReference(@LangID,19000019) as Diagnosis --'rftDiagnosis'
on			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) = Diagnosis.idfsReference

WHERE
	tlbOutbreak.idfOutbreak = @OutbreakID

--1 Outbreak cases
select		tlbHumanCase.idfHumanCase as idfCase, 
			tlbHumanCase.idfOutbreak,
			tlbHumanCase.strCaseID, 
			10012001 AS idfsCaseType,
			CaseStatus.name as strCaseStatus, 
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

			tlbHumanCase.idfPointGeoLocation as idfGeoLocation, -- for personal data acceess
			tlbHuman.idfCurrentResidenceAddress as idfAddress, -- for personal data acceess
			dbo.fnGeoLocationString(@LangID,tlbHumanCase.idfPointGeoLocation,null) As strGeoLocation,
			dbo.fnAddressString(@LangID,tlbHuman.idfCurrentResidenceAddress) As strAddress,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName
from		tlbHumanCase
inner join		tlbHuman
on				tlbHuman.idfHuman = tlbHumanCase.idfHuman
				and tlbHuman.intRowStatus = 0
left join	dbo.fnReference(@LangID,19000019) as Diagnosis --'rftDiagnosis'
on			COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) = Diagnosis.idfsReference
left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
on			COALESCE(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) = CaseStatus.idfsReference
where tlbHumanCase.idfOutbreak = @OutbreakID

union		All
select		tlbVetCase.idfVetCase as idfCase, 
			tlbVetCase.idfOutbreak,
			tlbVetCase.strCaseID, 
			tlbVetCase.idfsCaseType,
			CaseStatus.name as strCaseStatus, 
			convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as Confirmed,
		    ISNULL(Diagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) as strDiagnosis,
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

			tlbFarm.idfFarmAddress as idfGeoLocation, -- for personal data acceess
			tlbFarm.idfFarmAddress as idfAddress, -- for personal data acceess
			dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null) As strGeoLocation,
			dbo.fnAddressString(@LangID,tlbFarm.idfFarmAddress) As strAddress,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName
  

from		tlbVetCase
LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
	on	tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseStatus'
on			tlbVetCase.idfsCaseClassification = CaseStatus.idfsReference
left join	tlbFarm
	on		tlbFarm.idfFarm  = tlbVetCase.idfFarm 
	and		tlbFarm.intRowStatus = 0
left join		tlbHuman
on				tlbHuman.idfHuman = tlbFarm.idfHuman
				and tlbHuman.intRowStatus = 0
where tlbVetCase.idfOutbreak = @OutbreakID

union		All
select		vs.idfVectorSurveillanceSession as idfCase, 
			vs.idfOutbreak,
			vs.strSessionID as strCase, 
			10012006 as idfsCaseType,
			CONVERT(nvarchar,null) as  strCaseStatus, 
			convert(int, 1) as Confirmed,
		    REPLACE(dbo.fn_VsSession_GetDiagnosesNames(vs.idfVectorSurveillanceSession, @LangID),';',',') as strDiagnosis,   
			null as idfsDefaultDiagnosis,
			vs.datStartDate as datEnteredDate,
			15 as idfsSourceOfCaseSessionDate,
			vs.idfLocation as idfGeoLocation, -- for personal data acceess
			vs.idfLocation as idfAddress, -- for personal data acceess
			dbo.fnGeoLocationString(@LangID,vs.idfLocation,null) As strGeoLocation,
			dbo.fnAddressString(@LangID,vs.idfLocation) As strAddress,
			NULL as strPatientName
  

from		tlbVectorSurveillanceSession vs
where vs.idfOutbreak = @OutbreakID

--2 Outbreak notes
SELECT 
		note.idfOutbreakNote
		,note.idfOutbreak
		,note.strNote
		,note.datNoteDate
		,note.idfPerson
		,dbo.fnConcatFullName(prsn.strFamilyName, prsn.strFirstName, prsn.strSecondName) AS FullName,
		prsn.idfInstitution,
		Office.[name] as strInstitution
FROM	tlbOutbreakNote note
INNER JOIN tlbPerson prsn 
ON note.idfPerson = prsn.idfPerson
left join	dbo.fnInstitution(@LangID) as Office
on			Office.idfOffice = prsn.idfInstitution
WHERE 
		note.idfOutbreak = @OutbreakID
		and note.intRowStatus = 0


