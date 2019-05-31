

CREATE VIEW [dbo].[vw_AVR_VetCasesWithSamplesAndTestsReport_Both]
as

select		vc.idfVetCase as [PKField], 
			bt.idfBatchTest as [PKField_4582590000000], 
			f_adr.idfGeoLocation as [PKField_4582610000000], 
			f_loc.idfGeoLocation as [PKField_4582630000000], 
			f_h.idfHuman as [PKField_4582640000000], 
			Herd.idfHerd as [PKField_4582660000000], 
			m.idfMaterial as [PKField_4582950000000], 
			t.idfTesting as [PKField_4582990000000], 
			vc.idfVetCase as [PKField_4583010000000], 
			vc_fd.idfsDiagnosis as [PKField_4583030000000], 
			Species.idfSpecies as [PKField_4583090000090], 
			Animal.idfAnimal as [PKField_4583090000091], 
			vc.strCaseID as [sflVC_CaseID], 
			vc.idfsCaseClassification as [sflVC_CaseClassification_ID], 
			vc.idfsCaseType as [sflVC_CaseType_ID], 
			f_adr.idfsCountry as [sflVC_FarmAddressCountry_ID], 
			vc.datEnteredDate as [sflVC_EnteredDate], 
			f_vc.strFarmCode as [sflVC_FarmID], 
			IsNull(f_vc.strNationalName, f_vc.strInternationalName) as [sflVC_FarmName], 
			dbo.fnConcatFullName(f_h.strLastName, f_h.strFirstName, f_h.strSecondName) as [sflVC_FarmOwner], 
			vc_fd.idfsDiagnosis as [sflVC_FinalDiagnosis_ID], 
			vc.datReportDate as [sflVC_ReportDate], 
			f_adr.idfsRayon as [sflVC_FarmAddressRayon_ID], 
			f_adr.idfsRegion as [sflVC_FarmAddressRegion_ID], 
			f_adr.idfsSettlement as [sflVC_FarmAddressSettlement_ID], 
			Animal.strAnimalCode  as [sflVCSample_AnimalID], 
			m.datFieldCollectionDate as [sflVCSample_CollectionDate], 
			isnull(t.datStartedDate, bt.datPerformedDate) as [sflVCTest_PerformedDate], 
			DATEDIFF(D, m.datFieldCollectionDate, m.datAccession) as [sflVCSample_DaysInTransit], 
			m.strBarcode as [sflVCSample_LabSampleID], 
			m.datAccession as [sflVCSample_AccessionDate], 
			Species.idfsSpeciesType  as [sflVCSample_Species_ID], 
			m.idfsSampleType as [sflVCSample_SampleType_ID], 
			t.idfsTestName as [sflVCTest_TestType_ID], 
			t.idfsTestResult as [sflVCTest_TestResult_ID], 
			t.idfsTestStatus as [sflVCTest_TestStatus_ID], 
			vc.idfsCaseProgressStatus as [sflVC_CaseProgressStatus_ID], 
			IsNull(N'(' + cast(f_loc.dblLatitude as nvarchar) + N'; ' + cast(f_loc.dblLongitude as nvarchar) + N')', N'') as [sflVC_FarmLocationCoordinates], 
			t.idfsDiagnosis as [sflVCTest_Diagnosis_ID], 
			
  case 
      when vc.idfsFinalDiagnosis is not null then vc.idfsFinalDiagnosis

      when vc.idfsFinalDiagnosis is null and 
           vc.datTentativeDiagnosisDate is not null and
           vc.idfsTentativeDiagnosis is not null and
           vc.datTentativeDiagnosisDate >= isnull(vc.datTentativeDiagnosis1Date, 0) and
           vc.datTentativeDiagnosisDate >= isnull(vc.datTentativeDiagnosis2Date, 0)
           then vc.idfsTentativeDiagnosis
           
      when vc.idfsFinalDiagnosis is null and 
           vc.datTentativeDiagnosis1Date is not null and
           vc.idfsTentativeDiagnosis1 is not null and
           vc.datTentativeDiagnosis1Date >= isnull(vc.datTentativeDiagnosisDate, 0) and
           vc.datTentativeDiagnosis1Date >= isnull(vc.datTentativeDiagnosis2Date, 0)
           then vc.idfsTentativeDiagnosis1
           
      when vc.idfsFinalDiagnosis is null and 
           vc.datTentativeDiagnosis2Date is not null and
           vc.idfsTentativeDiagnosis2 is not null and
           vc.datTentativeDiagnosis2Date >= isnull(vc.datTentativeDiagnosisDate, 0) and
           vc.datTentativeDiagnosis2Date >= isnull(vc.datTentativeDiagnosis1Date, 0)
           then vc.idfsTentativeDiagnosis2
           
      when vc.idfsFinalDiagnosis is null and 
           vc.datTentativeDiagnosisDate is null and
           vc.datTentativeDiagnosis1Date is null and
           vc.datTentativeDiagnosis2Date is null 
           then IsNull(vc.idfsTentativeDiagnosis2, IsNull(vc.idfsTentativeDiagnosis1, vc.idfsTentativeDiagnosis))    
      else null
  end
 as [sflVC_Diagnosis_ID], 
			vc.idfsCaseReportType as [sflVC_CaseReportType_ID]

from 


	tlbVetCase vc 
	inner join	tlbFarm f_vc 
	on			f_vc.idfFarm = vc.idfFarm 
				and f_vc.intRowStatus = 0 
 


left join 

 
	 tlbHerd Herd
 

ON Herd.idfFarm = f_vc.idfFarm and Herd.intRowStatus = 0 
left join 

 
	tlbSpecies Species 
 

ON Species.idfHerd = Herd.idfHerd and Species.intRowStatus = 0  
left join 

 
	tlbAnimal Animal 
 

ON Animal.idfSpecies = Species.idfSpecies and Animal.intRowStatus = 0 
left join 
 
	tlbMaterial m 
 
ON ((m.idfSpecies = Species.idfSpecies and m.idfAnimal is null) or (m.idfAnimal = Animal.idfAnimal and m.idfSpecies is null)) AND m.intRowStatus = 0 
left join 

 
	tlbTesting AS t
 

ON m.idfMaterial = t.idfMaterial AND t.intRowStatus = 0 
left join 

 
	tlbBatchTest AS bt
 

ON bt.idfBatchTest = t.idfBatchTest AND bt.intRowStatus = 0 






left join 

 
	tlbGeoLocation f_adr 
 

ON f_adr.idfGeoLocation = f_vc.idfFarmAddress AND f_adr.intRowStatus = 0 

left join 

 
	tlbGeoLocation f_loc 
 

ON f_loc.idfGeoLocation = f_vc.idfFarmAddress AND f_loc.intRowStatus = 0 

left join 

 
	tlbHuman f_h 
 

ON f_h.idfHuman = f_vc.idfHuman 

left join 

 
	trtDiagnosis AS vc_fd
 

ON vc_fd.idfsDiagnosis = vc.idfsFinalDiagnosis 



where		vc.intRowStatus = 0


