

--##SUMMARY
--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
exec [spRepASSessionCases]  5410000870, 'ru'
*/

create  Procedure [dbo].[spRepASSessionCases]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	

declare @intTotalCases int

select @intTotalCases = count (tlbVetCase.idfVetCase)
from		tlbVetCase 
where tlbVetCase.idfParentMonitoringSession = @idfCase
and tlbVetCase.intRowStatus = 0		 


select  tlbVetCase.idfVetCase				as	idfsKey,
		tlbVetCase.strCaseID				as	strCaseID,
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
			tlbVetCase.datEnteredDate))) 		as	datCaseDate,
		CaseStatus.name							as	strCaseClassification,
		ISNULL(Diagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis)		as	strDiagnosis,
		dbo.fnGeoLocationString(@LangID,tlbFarm.idfFarmAddress,null)				as	strLocation,
		dbo.fnAddressString(@LangID,tlbFarm.idfFarmAddress)				as	strAddress,
		@intTotalCases				as  intTotalCases
from		tlbVetCase 
left join   dbo.tlbVetCaseDisplayDiagnosis Diagnosis
	on	tlbVetCase.idfVetCase = Diagnosis.idfVetCase AND Diagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	dbo.fnReference(@LangID,19000011) as CaseStatus --'rftCaseClassification'
	on	tlbVetCase.idfsCaseClassification = CaseStatus.idfsReference
left join	tlbFarm
	on	tlbFarm.idfFarm  = tlbVetCase.idfFarm 
	and	tlbFarm.intRowStatus = 0

where tlbVetCase.idfParentMonitoringSession = @idfCase
and tlbVetCase.intRowStatus = 0		 






