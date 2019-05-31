

CREATE VIEW [dbo].[vw_AVR_HumanCasesWithSamplesAndTestsReport]
as

select		hc.idfHumanCase as [PKField], 
			bt.idfBatchTest as [PKField_4582590000000], 
			hc.idfHumanCase as [PKField_4582670000000], 
			d_changed_hc.idfsDiagnosis as [PKField_4582680000000], 
			gl_cr_hc.idfGeoLocation as [PKField_4582700000000], 
			d_fin_hc.idfsDiagnosis as [PKField_4582730000000], 
			d_init_hc.idfsDiagnosis as [PKField_4582740000000], 
			m.idfMaterial as [PKField_4582950000000], 
			t.idfTesting as [PKField_4582990000000], 
			m.datFieldCollectionDate as [sflHCSample_CollectionDate], 
			isnull(t.datStartedDate, bt.datPerformedDate) as [sflHCTest_PerformedDate], 
			hc.intPatientAge as [sflHC_PatientAge], 
			case
	when	(	hc.idfsHumanAgeType = 10042002 and -- Month
				hc.intPatientAge between 0 and 11) or
			(	hc.idfsHumanAgeType = 10042001 and -- Days
				hc.intPatientAge between 0 and 364) or
			(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge = 0)
		then	cast(N' <1' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 1 and 4) or
			(	hc.idfsHumanAgeType = 10042002 and -- Month
				hc.intPatientAge between 12 and 48)
		then	cast(N' 1-4' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 5 and 14)
		then	cast(N' 5-14' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 15 and 19)
		then	cast(N'15-19' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 20 and 29)
		then	cast(N'20-29' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge between 30 and 59)
		then	cast(N'30-59' as nvarchar(100))
	when	(	hc.idfsHumanAgeType = 10042003 and -- Years
				hc.intPatientAge >= 60)
		then	cast(N'60+' as nvarchar(100))
	else	cast(null as nvarchar(100))
end as [sflHC_PatientAgeGroup], 
			IsNull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) as [sflHC_CaseClassification_ID], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.datEnteredDate as [sflHC_EnteredDate], 
			h_hc.datDateofBirth as [sflHC_PatientDOB], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datCompletionPaperFormDate as [sflHC_CompletionPaperFormDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			dbo.fnConcatFullName(h_hc.strLastName, h_hc.strFirstName, h_hc.strSecondName) as [sflHC_PatientName], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			gl_cr_hc.idfsRayon as [sflHC_PatientCRRayon_ID], 
			gl_cr_hc.idfsRegion as [sflHC_PatientCRRegion_ID], 
			gl_cr_hc.idfsSettlement as [sflHC_PatientCRSettlement_ID], 
			h_hc.idfsHumanGender as [sflHC_PatientSex_ID], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			m.strBarcode as [sflHCSample_LabSampleID], 
			m.datAccession as [sflHCSample_AccessionDate], 
			m.idfsSampleType as [sflHCSample_SampleType_ID], 
			t.idfsTestName as [sflHCTest_TestType_ID], 
			t.idfsTestResult as [sflHCTest_TestResult_ID], 
			t.idfsTestStatus as [sflHCTest_TestStatus_ID], 
			hc.idfsCaseProgressStatus as [sflHC_CaseProgressStatus_ID], 
			hc.idfsInitialCaseStatus as [sflHC_InitialCaseClassification_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			hc.idfsHumanAgeType as [sflHC_PatientAgeType_ID], 
			m.idfsAccessionCondition as [sflHCSample_AccessionCondition_ID], 
			t.idfsDiagnosis as [sflHCTest_Diagnosis_ID], 
			t.idfsTestCategory as [sflHCTest_TestCategory_ID]

from 

( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

 
	tlbGeoLocation gl_cr_hc 
 

ON gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
left join 

 
	trtDiagnosis d_changed_hc 
 

ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join 

 
	trtDiagnosis d_init_hc 
 

ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
left join 
( 
	tlbMaterial m 
left join 

( 
	tlbTesting AS t
left join 

 
	tlbBatchTest AS bt
 

ON bt.idfBatchTest = t.idfBatchTest AND bt.intRowStatus = 0 
) 

ON m.idfMaterial = t.idfMaterial AND t.intRowStatus = 0 
) 
ON h_hc.idfHuman = m.idfHuman AND m.intRowStatus = 0 
) 



where		hc.intRowStatus = 0


