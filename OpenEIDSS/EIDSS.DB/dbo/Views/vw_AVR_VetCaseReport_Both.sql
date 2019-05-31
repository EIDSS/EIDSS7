

CREATE VIEW [dbo].[vw_AVR_VetCaseReport_Both]
as

select		vc.idfVetCase as [PKField], 
			f_adr.idfGeoLocation as [PKField_4582610000000], 
			f_loc.idfGeoLocation as [PKField_4582630000000], 
			f_h.idfHuman as [PKField_4582640000000], 
			vc.idfVetCase as [PKField_4583010000000], 
			vc_fd.idfsDiagnosis as [PKField_4583030000000], 
			vc_td.idfsDiagnosis as [PKField_4583070000000], 
			vc_td1.idfsDiagnosis as [PKField_4583080000000], 
			vc_td2.idfsDiagnosis as [PKField_4583090000000], 
			vc.datAssignedDate as [sflVC_AssignedDate], 
			vc.strCaseID as [sflVC_CaseID], 
			vc.idfsCaseClassification as [sflVC_CaseClassification_ID], 
			vc.idfsCaseType as [sflVC_CaseType_ID], 
			f_adr.idfsCountry as [sflVC_FarmAddressCountry_ID], 
			vc.datEnteredDate as [sflVC_EnteredDate], 
			f_vc.strFarmCode as [sflVC_FarmID], 
			IsNull(f_vc.strNationalName, f_vc.strInternationalName) as [sflVC_FarmName], 
			dbo.fnConcatFullName(f_h.strLastName, f_h.strFirstName, f_h.strSecondName) as [sflVC_FarmOwner], 
			vc.strFieldAccessionID as [sflVC_FieldAccessionID], 
			vc_fd.idfsDiagnosis as [sflVC_FinalDiagnosis_ID], 
			vc.datFinalDiagnosisDate as [sflVC_FinalDiagnosisDate], 
			vc_fd.strOIECode as [sflVC_FinalDiagnosisCode], 
			vc_td.idfsDiagnosis as [sflVC_TentativeDiagnosis1_ID], 
			vc.datTentativeDiagnosisDate as [sflVC_TentativeDiagnosisDate1], 
			vc_td.strOIECode as [sflVC_TentativeDiagnosisCode1], 
			vc_td1.idfsDiagnosis as [sflVC_TentativeDiagnosis2_ID], 
			vc.datTentativeDiagnosis1Date as [sflVC_TentativeDiagnosisDate2], 
			vc_td1.strOIECode as [sflVC_TentativeDiagnosisCode2], 
			vc_td2.idfsDiagnosis as [sflVC_TentativeDiagnosis3_ID], 
			vc.datTentativeDiagnosis2Date as [sflVC_TentativeDiagnosisDate3], 
			vc_td2.strOIECode as [sflVC_TentativeDiagnosisCode3], 
			vc.datReportDate as [sflVC_ReportDate], 
			vc.datInvestigationDate as [sflVC_InvestigationDate], 
			f_adr.idfsRayon as [sflVC_FarmAddressRayon_ID], 
			f_adr.idfsRegion as [sflVC_FarmAddressRegion_ID], 
			f_adr.idfsSettlement as [sflVC_FarmAddressSettlement_ID], 
			vc.idfsCaseProgressStatus as [sflVC_CaseProgressStatus_ID], 
			IsNull(N'(' + cast(f_loc.dblLatitude as nvarchar) + N'; ' + cast(f_loc.dblLongitude as nvarchar) + N')', N'') as [sflVC_FarmLocationCoordinates], 
			
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

(
	tlbVetCase vc 
	inner join	tlbFarm f_vc 
	on			f_vc.idfFarm = vc.idfFarm 
				and f_vc.intRowStatus = 0 
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
left join 

 
	trtDiagnosis AS vc_td
 

ON vc_td.idfsDiagnosis = vc.idfsTentativeDiagnosis 
left join 

 
	trtDiagnosis AS vc_td1
 

ON vc_td1.idfsDiagnosis = vc.idfsTentativeDiagnosis1 
left join 

 
	trtDiagnosis AS vc_td2
 

ON vc_td2.idfsDiagnosis = vc.idfsTentativeDiagnosis2 
) 



where		vc.intRowStatus = 0


