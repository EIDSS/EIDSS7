

--##SUMMARY Selects data for specific veterinary case.
--##SUMMARY These data are shared between several case conrols.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 10.11.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
@idfCase @idfAnimal bigint

EXECUTE spVetCase_SelectDetail
   @idfCase
  ,'en'
*/



CREATE            Proc	[dbo].[spVetCase_SelectDetail]
		@idfCase	bigint,  --##PARAM @idfCase - case ID
		@LangID		nvarchar(50) --##PARAM @LangID - language ID
As

declare @blnEnableTestsConducted bit

if (exists (select * from tlbTesting t --all tests are completed
	inner join tlbMaterial m on 
		t.idfMaterial = m.idfMaterial
	where 
		(t.idfsTestStatus = 10001001 or t.idfsTestStatus = 10001006) --completed or amended
		and t.intRowStatus = 0
		--and isnull(t.blnNonLaboratoryTest,0) = 0
		and (m.idfHumanCase = @idfCase OR m.idfVetCase = @idfCase)
	))
	SET @blnEnableTestsConducted = 0
else
	SET @blnEnableTestsConducted = 1



-- 0 Case Activity
Select 

	tlbVetCase.idfVetCase AS idfCase
	,tlbVetCase.idfsCaseClassification
	,tlbVetCase.idfsCaseProgressStatus
	,tlbVetCase.idfsShowDiagnosis
	,tlbVetCase.idfsCaseType
	,tlbVetCase.idfOutbreak
	,tlbOutbreak.strOutbreakID
	,tlbVetCase.idfParentMonitoringSession
	,tlbMonitoringSession.strMonitoringSessionID
	,tlbVetCase.datEnteredDate
	,tlbVetCase.uidOfflineCaseID
	,tlbVetCase.strCaseID
	,tlbVetCase.idfsTentativeDiagnosis
	,tlbVetCase.idfsTentativeDiagnosis1
	,tlbVetCase.idfsTentativeDiagnosis2
	,tlbVetCase.idfsFinalDiagnosis	
	,tlbVetCase.idfsYNTestsConducted
	,@blnEnableTestsConducted as blnEnableTestsConducted
--	,idfOfficeInvestigatedBy = tlbPersonInvestigatedBy.idfInstitution
	,idfInvestigatedByOffice = ISNULL(tlbVetCase.idfInvestigatedByOffice, tlbPersonInvestigatedBy.idfInstitution )
	,strInvestigatedByOffice = tlbInvestigatedByOffice.[name]
	,tlbVetCase.idfPersonInvestigatedBy
	,strPersonInvestigatedBy = dbo.fnConcatFullName(tlbPersonInvestigatedBy.strFamilyName, tlbPersonInvestigatedBy.strFirstName, tlbPersonInvestigatedBy.strSecondName)
	,tlbVetCase.idfPersonEnteredBy
	,strPersonEnteredByName = dbo.fnConcatFullName(tlbPersonEnteredBy.strFamilyName, tlbPersonEnteredBy.strFirstName, tlbPersonEnteredBy.strSecondName)
--	,idfOfficeReportedBy = tlbPersonReportedBy.idfInstitution
	,idfReportedByOffice = ISNULL(tlbVetCase.idfReportedByOffice, tlbPersonReportedBy.idfInstitution)
	,strReportedByOffice = tlbReportedByOffice.[name]
	,tlbVetCase.idfPersonReportedBy
	,strPersonReportedBy = dbo.fnConcatFullName(tlbPersonReportedBy.strFamilyName, tlbPersonReportedBy.strFirstName, tlbPersonReportedBy.strSecondName)
	,tlbVetCase.idfObservation
	,tlbObservation.idfsFormTemplate
	,tlbVetCase.idfsSite
	,tlbVetCase.datReportDate
	,tlbVetCase.datAssignedDate
	,tlbVetCase.datInvestigationDate
	,tlbVetCase.datTentativeDiagnosisDate
	,tlbVetCase.datTentativeDiagnosis1Date
	,tlbVetCase.datTentativeDiagnosis2Date
	,tlbVetCase.datFinalDiagnosisDate
	,tlbVetCase.idfsCaseReportType
	,tlbVetCase.strSampleNotes
	,tlbVetCase.strTestNotes
	,tlbVetCase.strSummaryNotes
	,tlbVetCase.strClinicalNotes
	,tlbVetCase.strFieldAccessionID
	,tlbVetCase.idfFarm	
	,tlbFarm.idfFarmActual  as idfRootFarm
	,FinalDiagnosis.strOIECode as strFinalDiagnosisOIECode
	,TentativeDiagnosis.strOIECode as strTentativeDiagnosisOIECode
	,TentativeDiagnosis1.strOIECode as strTentativeDiagnosis1OIECode
	,TentativeDiagnosis2.strOIECode as strTentativeDiagnosis2OIECode
	,tlbVetCase.datModificationForArchiveDate
FROM tlbVetCase
LEFT OUTER JOIN tlbFarm ON
	tlbFarm.idfFarm = tlbVetCase.idfFarm
	AND tlbFarm.intRowStatus = 0
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbVetCase.idfObservation
	AND tlbObservation.intRowStatus = 0
LEFT OUTER JOIN tlbOutbreak ON
	tlbOutbreak.idfOutbreak = tlbVetCase.idfOutbreak
	AND tlbOutbreak.intRowStatus = 0
LEFT OUTER JOIN tlbMonitoringSession ON
	tlbMonitoringSession.idfMonitoringSession = tlbVetCase.idfParentMonitoringSession
	AND tlbMonitoringSession.intRowStatus = 0
LEFT OUTER JOIN trtDiagnosis FinalDiagnosis ON
	FinalDiagnosis.idfsDiagnosis = tlbVetCase.idfsFinalDiagnosis
LEFT OUTER JOIN trtDiagnosis TentativeDiagnosis ON
	TentativeDiagnosis.idfsDiagnosis = tlbVetCase.idfsTentativeDiagnosis
LEFT OUTER JOIN trtDiagnosis TentativeDiagnosis1 ON
	TentativeDiagnosis1.idfsDiagnosis = tlbVetCase.idfsTentativeDiagnosis1
LEFT OUTER JOIN trtDiagnosis TentativeDiagnosis2 ON
	TentativeDiagnosis2.idfsDiagnosis = tlbVetCase.idfsTentativeDiagnosis2
LEFT OUTER JOIN tlbPerson tlbPersonEnteredBy ON
	tlbVetCase.idfPersonEnteredBy = tlbPersonEnteredBy.idfPerson
LEFT OUTER JOIN tlbPerson tlbPersonReportedBy ON 
	tlbVetCase.idfPersonReportedBy = tlbPersonReportedBy.idfPerson
LEFT OUTER JOIN	dbo.fnInstitution(@LangID) as tlbReportedByOffice on
	ISNULL(tlbVetCase.idfReportedByOffice, tlbPersonReportedBy.idfInstitution ) = tlbReportedByOffice.idfOffice	
LEFT OUTER JOIN tlbPerson tlbPersonInvestigatedBy ON 
	tlbVetCase.idfPersonInvestigatedBy = tlbPersonInvestigatedBy.idfPerson
LEFT OUTER JOIN	dbo.fnInstitution(@LangID) as tlbInvestigatedByOffice on
	ISNULL(tlbVetCase.idfInvestigatedByOffice, tlbPersonInvestigatedBy.idfInstitution) = tlbInvestigatedByOffice.idfOffice	
Where 
	tlbVetCase.idfVetCase=@idfCase
	and tlbVetCase.intRowStatus=0

