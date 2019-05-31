SELECT 
	VC.[idfVetCase]
	,VC.[strCaseID]
	,MS.strMonitoringSessionID 
	,CT.strDefault [CaseType]
	,CC.strDefault [CaseClassification]
	,F.strNationalName
	,VC.[strDefaultDisplayDiagnosis]
	,D.strIDC10
	, VC.[datFinalDiagnosisDate]
	,PE.strFirstName + ' ' + PE.strFamilyName [EnteredBy]
	,PR.strFirstName + ' ' + PR.strFamilyName [ReportedBy]
	,VC.[datReportDate]
	,PIN.strFirstName + ' ' + PIN.strFamilyName [InvestigatedBy]
	,S.strSiteName
	,YNTest.strDefault [TestConducted]
	,CASE WHEN VC.[intRowStatus] = 0 THEN 'Active' ELSE 'Inactive' END AS [Rowstatus]
	,VC.[idfReportedByOffice]
	,VC.[idfInvestigatedByOffice]
	,VC.[idfsCaseReportType]
	,VC.[idfParentMonitoringSession]
FROM 
	[tlbVetCase] VC
	LEFT JOIN tlbPerson PE ON VC.idfPersonEnteredBy = PE.idfPerson
	LEFT JOIN tlbPerson PR ON VC.idfPersonReportedBy = PR.idfPerson
	LEFT JOIN tlbPerson PIN ON VC.idfPersonInvestigatedBy = PIN.idfPerson
	LEFT JOIN tstSite S ON VC.idfsSite = S.idfsSite
	LEFT JOIN trtDiagnosis D on VC.idfsFinalDiagnosis = D.idfsDiagnosis
	LEFT JOIN tlbFarm F On VC.idfFarm = F.idfFarm
	LEFT JOIN trtBaseReference CC ON VC.idfsCaseClassification = CC.idfsBaseReference
	LEFT JOIN trtBaseReference CPS ON VC.[idfsCaseProgressStatus] = CPS.idfsBaseReference
	LEFT JOIN trtBaseReference CT ON VC.[idfsCaseType] = CT.idfsBaseReference
	LEFT JOIN trtBaseReference YNTest ON [idfsYNTestsConducted] = YNTest.idfsBaseReference
	LEFT JOIN tlbMonitoringSession MS ON VC.[idfParentMonitoringSession] = MS.idfMonitoringSession
Where 
	VC.strCaseID = @VetCaseID