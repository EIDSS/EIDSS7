


--##SUMMARY Selects cases created from specific AS session.
--##SUMMARY Called by AsSessionDetail form.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.12.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013


--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @idfMonitoringSession bigint
DECLARE @LangID nvarchar(50)


EXECUTE spASSessionCases_SelectDetail
   750650000000
  ,'en'

*/


CREATE     PROCEDURE [dbo].[spASSessionCases_SelectDetail]
	@idfMonitoringSession AS bigint,  --##PARAM @idfMonitoringSession - AS session ID
	@LangID NVARCHAR(50)  --##PARAM @LangID - lanquage ID
as
select		tlbVetCase.idfVetCase AS idfCase, 
			tlbVetCase.idfOutbreak,
			tlbVetCase.strCaseID, 
			tlbVetCase.idfsCaseType,
			CaseStatus.name as strCaseStatus, 
			convert(int, case when CaseStatus.idfsReference = 350000000 then 1 else 0 end) as Confirmed,
		    ISNULL(Diagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) as strDiagnosis,   
			isnull(tlbVetCase.datInvestigationDate, 
			isnull(
				(
					select max(s1.dat) from 
					(
						select tlbVetCase1.datTentativeDiagnosisDate as dat
						from tlbVetCase as tlbVetCase1 where tlbVetCase1.idfVetCase = tlbVetCase.idfVetCase
						union		All
						select tlbVetCase1.datTentativeDiagnosis1Date as dat
						from tlbVetCase as tlbVetCase1 where tlbVetCase1.idfVetCase = tlbVetCase.idfVetCase
						union		All
						select tlbVetCase1.datTentativeDiagnosis2Date as dat
						from tlbVetCase as tlbVetCase1 where tlbVetCase1.idfVetCase = tlbVetCase.idfVetCase
						union		All
						select tlbVetCase1.datFinalDiagnosisDate as dat
						from tlbVetCase as tlbVetCase1 where tlbVetCase1.idfVetCase = tlbVetCase.idfVetCase
					) s1
				),
			isnull(tlbVetCase.datReportDate,
			tlbVetCase.datEnteredDate))) as datEnteredDate,
			dbo.fnGeoLocationCoordinatesString(tlbFarm.idfFarmAddress) As strGeoLocation,
			dbo.fnAddressString(@LangID,tlbFarm.idfFarmAddress) As strAddress,
			dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strPatientName,  
			idfFarmActual   as idfRootFarm       
from		tlbVetCase 
LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
	on	tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseClassification'
	on	tlbVetCase.idfsCaseClassification = CaseStatus.idfsReference
left join	tlbFarm
	on	tlbFarm.idfFarm  = tlbVetCase.idfFarm 
	and	tlbFarm.intRowStatus = 0
left join		tlbHuman
	on	tlbHuman.idfHuman = tlbFarm.idfHuman
		and tlbHuman.intRowStatus = 0
where tlbVetCase.idfParentMonitoringSession = @idfMonitoringSession
and tlbVetCase.intRowStatus = 0


