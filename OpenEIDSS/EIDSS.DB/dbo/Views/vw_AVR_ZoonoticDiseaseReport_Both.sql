

CREATE VIEW [dbo].[vw_AVR_ZoonoticDiseaseReport_Both]
as

select		hc.idfHumanCase as [PKField], 
			null as [PKField_4582610000000], 
			null as [PKField_4582630000000], 
			null as [PKField_4582660000000], 
			hc.idfHumanCase as [PKField_4582670000000], 
			gl_cr_hc.idfGeoLocation as [PKField_4582700000000], 
			gl_emp_hc.idfGeoLocation as [PKField_4582710000000], 
			d_fin_hc.idfsDiagnosis as [PKField_4582730000000], 
			gl_hc.idfGeoLocation as [PKField_4582770000000], 
			null as [PKField_4583010000000], 
			null as [PKField_4583090000023], 
			null as [PKField_4583090000024], 
			null as [PKField_4583090000039], 
			diag_hc.idfsDiagnosis as [PKField_4583090000040], 
			null as [PKField_4583090000090], 
			hc.strCaseID as [sflZD_CaseID], 
			10012001 as [sflZD_CaseType_ID], 
			gl_cr_hc.idfsCountry as [sflZD_Country_ID], 
			gl_cr_hc.idfsRegion as [sflZD_Region_ID], 
			gl_cr_hc.idfsRayon as [sflZD_Rayon_ID], 
			gl_cr_hc.idfsSettlement as [sflZD_Settlement_ID], 
			IsNull(N'(' + cast(gl_cr_hc.dblLatitude as nvarchar) + N'; ' + cast(gl_cr_hc.dblLongitude as nvarchar) + N')', N'') as [sflZD_Coordinates], 
			hc.datNotificationDate as [sflZD_NotificationOrReportDate], 
			hc.datInvestigationStartDate as [sflZD_InvestigationDate], 
			hc.datOnSetDate as [sflZD_SymptomOnsetOrStartOfSignDate], 
			IsNull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) as [sflZD_Diagnosis_ID], 
			IsNull(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) as [sflZD_CaseClassification_ID], 
			hc.datExposureDate as [sflZD_HumanCaseExposureDate], 
			h_hc.datDateOfDeath as [sflZD_PatientDeathDate], 
			hc.datHospitalizationDate as [sflZD_PatientHospitalizationDate], 
			hc.datFirstSoughtCareDate as [sflZD_PatientFirstSoughtCareDate], 
			hc.intPatientAge as [sflZD_PatientAge], 
			hc.idfsHumanAgeType as [sflZD_PatientAgeType_ID], 
			h_hc.idfsHumanGender as [sflZD_PatientSex_ID], 
			h_hc.idfsOccupationType as [sflZD_PatientOccupation_ID], 
			h_hc.idfsNationality as [sflZD_PatientCitizenship_ID], 
			gl_hc.idfsCountry as [sflZD_LocationOfHCExposureCountry_ID], 
			gl_hc.idfsRegion as [sflZD_LocationOfHCExposureRegion_ID], 
			gl_hc.idfsRayon as [sflZD_LocationOfHCExposureRayon_ID], 
			gl_hc.idfsSettlement as [sflZD_LocationOfHCExposureSettlement_ID], 
			IsNull(N'(' + cast(gl_hc.dblLatitude as nvarchar) + N'; ' + cast(gl_hc.dblLongitude as nvarchar) + N')', N'') as [sflZD_LocationOfHCExposureCoord], 
			gl_emp_hc.idfsCountry as [sflZD_PatientEmployerCountry_ID], 
			gl_emp_hc.idfsRegion as [sflZD_PatientEmployerRegion_ID], 
			gl_emp_hc.idfsRayon as [sflZD_PatientEmployerRayon_ID], 
			gl_emp_hc.idfsSettlement as [sflZD_PatientEmployerSettlement_ID], 
			null as [sflZD_LivestockAgeRangeOfDeadAnimals], 
			null as [sflZD_LivestockAgeRangeOfSickAnimals], 
			null as [sflZD_Species_ID], 
			null as [sflZD_TotalNumberOfAnimalsForSpecies], 
			null as [sflZD_NumberOfSickAnimalsForSpecies], 
			null as [sflZD_NumberOfDeadAnimalsForSpecies], 
			4578940000002 as [sflZD_ReportType_ID], 
			(IsNull(diag_hc.blnZoonotic, 0) * 10100001 + (1 - IsNull(diag_hc.blnZoonotic, 0)) * 10100002) as [sflZD_IsZoonotic_ID], 
			IsNull(hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate)  as [sflZD_DiagnosisDate]

from 

( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

  	 
  		trtDiagnosis diag_hc 
  			outer apply (
  				select min(group_diag_hc.idfsDiagnosisGroup) as idfsDiagnosisGroup
  				from dbo.trtDiagnosisToDiagnosisGroup group_diag_hc
  				where group_diag_hc.idfsDiagnosis = diag_hc.idfsDiagnosis
  			) as gr_diag_hc
  	 
  
ON diag_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join 

 
	tlbGeoLocation gl_cr_hc 
 

ON gl_cr_hc.idfGeoLocation = h_hc.idfCurrentResidenceAddress AND gl_cr_hc.intRowStatus = 0 
left join 

 
	tlbGeoLocation gl_emp_hc 
 

ON gl_emp_hc.idfGeoLocation = h_hc.idfEmployerAddress AND gl_emp_hc.intRowStatus = 0 
left join 

 
	tlbGeoLocation gl_hc 
 

ON gl_hc.idfGeoLocation = hc.idfPointGeoLocation AND gl_hc.intRowStatus = 0 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
) 



where		hc.intRowStatus = 0

union
select		vc.idfVetCase as [PKField], 
			f_adr.idfGeoLocation as [PKField_4582610000000], 
			f_loc.idfGeoLocation as [PKField_4582630000000], 
			Herd.idfHerd as [PKField_4582660000000], 
			null as [PKField_4582670000000], 
			null as [PKField_4582700000000], 
			null as [PKField_4582710000000], 
			null as [PKField_4582730000000], 
			null as [PKField_4582770000000], 
			vc.idfVetCase as [PKField_4583010000000], 
			vc.idfVetCase as [PKField_4583090000023], 
			vc.idfVetCase as [PKField_4583090000024], 
			diag_vc.idfsDiagnosis as [PKField_4583090000039], 
			null as [PKField_4583090000040], 
			Species.idfSpecies as [PKField_4583090000090], 
			vc.strCaseID as [sflZD_CaseID], 
			vc.idfsCaseType as [sflZD_CaseType_ID], 
			f_adr.idfsCountry as [sflZD_Country_ID], 
			f_adr.idfsRegion as [sflZD_Region_ID], 
			f_adr.idfsRayon as [sflZD_Rayon_ID], 
			f_adr.idfsSettlement as [sflZD_Settlement_ID], 
			IsNull(N'(' + cast(f_loc.dblLatitude as nvarchar) + N'; ' + cast(f_loc.dblLongitude as nvarchar) + N')', N'') as [sflZD_Coordinates], 
			vc.datReportDate as [sflZD_NotificationOrReportDate], 
			vc.datInvestigationDate as [sflZD_InvestigationDate], 
			Species.datStartOfSignsDate as [sflZD_SymptomOnsetOrStartOfSignDate], 
			case when vc.idfsFinalDiagnosis is not null then vc.idfsFinalDiagnosis when vc.idfsFinalDiagnosis is null and vc.idfsTentativeDiagnosis2 is not null and (IsNull(vc.datTentativeDiagnosis2Date, '19000101') >= IsNull(vc.datTentativeDiagnosis1Date, '19000101') or vc.idfsTentativeDiagnosis1 is null) and (IsNull(vc.datTentativeDiagnosis2Date, '19000101') >= IsNull(vc.datTentativeDiagnosisDate, '19000101') or vc.idfsTentativeDiagnosis is null) then vc.idfsTentativeDiagnosis2 when vc.idfsFinalDiagnosis is null and vc.idfsTentativeDiagnosis1 is not null and (IsNull(vc.datTentativeDiagnosis1Date, '19000101') > IsNull(vc.datTentativeDiagnosis2Date, '19000101') or vc.idfsTentativeDiagnosis2 is null) and (IsNull(vc.datTentativeDiagnosis1Date, '19000101') >= IsNull(vc.datTentativeDiagnosisDate, '19000101') or vc.idfsTentativeDiagnosis is null) then vc.idfsTentativeDiagnosis1 when vc.idfsFinalDiagnosis is null and vc.idfsTentativeDiagnosis is not null and (IsNull(vc.datTentativeDiagnosisDate, '19000101') > IsNull(vc.datTentativeDiagnosis2Date, '19000101') or vc.idfsTentativeDiagnosis2 is null) and (IsNull(vc.datTentativeDiagnosisDate, '19000101') > IsNull(vc.datTentativeDiagnosis1Date, '19000101') or vc.idfsTentativeDiagnosis1 is null) then vc.idfsTentativeDiagnosis else vc.idfsFinalDiagnosis end as [sflZD_Diagnosis_ID], 
			vc.idfsCaseClassification as [sflZD_CaseClassification_ID], 
			null as [sflZD_HumanCaseExposureDate], 
			null as [sflZD_PatientDeathDate], 
			null as [sflZD_PatientHospitalizationDate], 
			null as [sflZD_PatientFirstSoughtCareDate], 
			null as [sflZD_PatientAge], 
			null as [sflZD_PatientAgeType_ID], 
			null as [sflZD_PatientSex_ID], 
			null as [sflZD_PatientOccupation_ID], 
			null as [sflZD_PatientCitizenship_ID], 
			f_adr.idfsCountry as [sflZD_LocationOfHCExposureCountry_ID], 
			f_adr.idfsRegion as [sflZD_LocationOfHCExposureRegion_ID], 
			f_adr.idfsRayon as [sflZD_LocationOfHCExposureRayon_ID], 
			f_adr.idfsSettlement as [sflZD_LocationOfHCExposureSettlement_ID], 
			IsNull(N'(' + cast(f_loc.dblLatitude as nvarchar) + N'; ' + cast(f_loc.dblLongitude as nvarchar) + N')', N'') as [sflZD_LocationOfHCExposureCoord], 
			null as [sflZD_PatientEmployerCountry_ID], 
			null as [sflZD_PatientEmployerRegion_ID], 
			null as [sflZD_PatientEmployerRayon_ID], 
			null as [sflZD_PatientEmployerSettlement_ID], 
			cast(ap_AgeRangeOfDeadAnimals.varValue as nvarchar) as [sflZD_LivestockAgeRangeOfDeadAnimals], 
			cast(ap_AgeRangeOfSickAnimals.varValue as nvarchar) as [sflZD_LivestockAgeRangeOfSickAnimals], 
			Species.idfsSpeciesType as [sflZD_Species_ID], 
			Species.intTotalAnimalQty as [sflZD_TotalNumberOfAnimalsForSpecies], 
			Species.intSickAnimalQty as [sflZD_NumberOfSickAnimalsForSpecies], 
			Species.intDeadAnimalQty as [sflZD_NumberOfDeadAnimalsForSpecies], 
			vc.idfsCaseReportType as [sflZD_ReportType_ID], 
			(IsNull(diag_vc.blnZoonotic, 0) * 10100001 + (1 - IsNull(diag_vc.blnZoonotic, 0)) * 10100002) as [sflZD_IsZoonotic_ID], 
				case
		when vc.datFinalDiagnosisDate is not null 
			then vc.datFinalDiagnosisDate
		when vc.datFinalDiagnosisDate is null and vc.datTentativeDiagnosis2Date is not null and 
		 (IsNull(vc.datTentativeDiagnosis2Date, '19000101') >= IsNull(vc.datTentativeDiagnosis1Date, '19000101') or vc.datTentativeDiagnosis1Date is null) and 
		 (IsNull(vc.datTentativeDiagnosis2Date, '19000101') >= IsNull(vc.datTentativeDiagnosisDate, '19000101') or vc.datTentativeDiagnosisDate is null) 
			then vc.datTentativeDiagnosis2Date 
		when vc.datFinalDiagnosisDate is null and vc.datTentativeDiagnosis1Date is not null and 
		(IsNull(vc.datTentativeDiagnosis1Date, '19000101') > IsNull(vc.datTentativeDiagnosis2Date, '19000101') or vc.datTentativeDiagnosis2Date is null) and 
		(IsNull(vc.datTentativeDiagnosis1Date, '19000101') >= IsNull(vc.datTentativeDiagnosisDate, '19000101') or vc.datTentativeDiagnosisDate is null) 
			then vc.datTentativeDiagnosis1Date 
		when vc.datFinalDiagnosisDate is null and vc.datTentativeDiagnosisDate is not null and 
		(IsNull(vc.datTentativeDiagnosisDate, '19000101') > IsNull(vc.datTentativeDiagnosis2Date, '19000101') or vc.datTentativeDiagnosis2Date is null) and 
		(IsNull(vc.datTentativeDiagnosisDate, '19000101') > IsNull(vc.datTentativeDiagnosis1Date, '19000101') or vc.datTentativeDiagnosis1Date is null) 
			then vc.datTentativeDiagnosisDate 
		else vc.datFinalDiagnosisDate 
	end  as [sflZD_DiagnosisDate]

from 

(
	tlbVetCase vc 
	inner join	tlbFarm f_vc 
	on			f_vc.idfFarm = vc.idfFarm 
				and f_vc.intRowStatus = 0 
left join 

  	 
  		trtDiagnosis diag_vc 
  			outer apply (
  				select min(group_diag_vc.idfsDiagnosisGroup) as idfsDiagnosisGroup
  				from dbo.trtDiagnosisToDiagnosisGroup group_diag_vc
  				where group_diag_vc.idfsDiagnosis = diag_vc.idfsDiagnosis 		
  			) as group_diag_vc
  	 
  
ON diag_vc.idfsDiagnosis = case  when vc.idfsFinalDiagnosis is not null then vc.idfsFinalDiagnosis when vc.idfsFinalDiagnosis is null and vc.datTentativeDiagnosisDate is not null and vc.idfsTentativeDiagnosis is not null and vc.datTentativeDiagnosisDate >= isnull(vc.datTentativeDiagnosis1Date, 0) and  vc.datTentativeDiagnosisDate >= isnull(vc.datTentativeDiagnosis2Date, 0)  then vc.idfsTentativeDiagnosis when vc.idfsFinalDiagnosis is null and vc.datTentativeDiagnosis1Date is not null and  vc.idfsTentativeDiagnosis1 is not null and  vc.datTentativeDiagnosis1Date >= isnull(vc.datTentativeDiagnosisDate, 0) and  vc.datTentativeDiagnosis1Date >= isnull(vc.datTentativeDiagnosis2Date, 0)  then vc.idfsTentativeDiagnosis1  when vc.idfsFinalDiagnosis is null and vc.datTentativeDiagnosis2Date is not null and   vc.idfsTentativeDiagnosis2 is not null and vc.datTentativeDiagnosis2Date >= isnull(vc.datTentativeDiagnosisDate, 0) and vc.datTentativeDiagnosis2Date >= isnull(vc.datTentativeDiagnosis1Date, 0) then vc.idfsTentativeDiagnosis2  when vc.idfsFinalDiagnosis is null and  vc.datTentativeDiagnosisDate is null and  vc.datTentativeDiagnosis1Date is null and  vc.datTentativeDiagnosis2Date is null then IsNull(vc.idfsTentativeDiagnosis2, IsNull(vc.idfsTentativeDiagnosis1, vc.idfsTentativeDiagnosis))else null end  
left join 

 
	tlbGeoLocation f_adr 
 

ON f_adr.idfGeoLocation = f_vc.idfFarmAddress AND f_adr.intRowStatus = 0 
left join 

 
	tlbGeoLocation f_loc 
 

ON f_loc.idfGeoLocation = f_vc.idfFarmAddress AND f_loc.intRowStatus = 0 
left join 

( 
	 tlbHerd Herd
left join 

( 
	tlbSpecies Species 
left join 

(
	tlbObservation o_AgeRangeOfDeadAnimals 
	inner join	tasSearchFieldToFFParameter sf_to_p_AgeRangeOfDeadAnimals
	on			sf_to_p_AgeRangeOfDeadAnimals.idfsSearchField = 10080488	-- Zoonotic disease – Livestock Age Range of Dead Animals
	inner join	tlbActivityParameters ap_AgeRangeOfDeadAnimals
	on			ap_AgeRangeOfDeadAnimals.idfsParameter = sf_to_p_AgeRangeOfDeadAnimals.idfsParameter
				and ap_AgeRangeOfDeadAnimals.idfObservation = o_AgeRangeOfDeadAnimals.idfObservation
				and ap_AgeRangeOfDeadAnimals.intRowStatus = 0
	left join	tlbActivityParameters ap_min_AgeRangeOfDeadAnimals
	on			ap_min_AgeRangeOfDeadAnimals.idfsParameter = sf_to_p_AgeRangeOfDeadAnimals.idfsParameter
				and ap_min_AgeRangeOfDeadAnimals.idfObservation = o_AgeRangeOfDeadAnimals.idfObservation
				and ap_min_AgeRangeOfDeadAnimals.intRowStatus = 0
				and ap_min_AgeRangeOfDeadAnimals.idfRow < ap_AgeRangeOfDeadAnimals.idfRow
) 

ON o_AgeRangeOfDeadAnimals.idfObservation = Species.idfObservation and o_AgeRangeOfDeadAnimals.intRowStatus = 0 and ap_min_AgeRangeOfDeadAnimals.idfActivityParameters is null 
left join 

(
	tlbObservation o_AgeRangeOfSickAnimals 
	inner join	tasSearchFieldToFFParameter sf_to_p_AgeRangeOfSickAnimals
	on			sf_to_p_AgeRangeOfSickAnimals.idfsSearchField = 10080489	-- Zoonotic disease – Livestock Age Range of Sick Animals
	inner join	tlbActivityParameters ap_AgeRangeOfSickAnimals
	on			ap_AgeRangeOfSickAnimals.idfsParameter = sf_to_p_AgeRangeOfSickAnimals.idfsParameter
				and ap_AgeRangeOfSickAnimals.idfObservation = o_AgeRangeOfSickAnimals.idfObservation
				and ap_AgeRangeOfSickAnimals.intRowStatus = 0
	left join	tlbActivityParameters ap_min_AgeRangeOfSickAnimals
	on			ap_min_AgeRangeOfSickAnimals.idfsParameter = sf_to_p_AgeRangeOfSickAnimals.idfsParameter
				and ap_min_AgeRangeOfSickAnimals.idfObservation = o_AgeRangeOfSickAnimals.idfObservation
				and ap_min_AgeRangeOfSickAnimals.intRowStatus = 0
				and ap_min_AgeRangeOfSickAnimals.idfRow < ap_AgeRangeOfSickAnimals.idfRow
) 

ON o_AgeRangeOfSickAnimals.idfObservation = Species.idfObservation and o_AgeRangeOfSickAnimals.intRowStatus = 0 and ap_min_AgeRangeOfSickAnimals.idfActivityParameters is null 
) 

ON Species.idfHerd = Herd.idfHerd and Species.intRowStatus = 0  
) 

ON Herd.idfFarm = f_vc.idfFarm and Herd.intRowStatus = 0 
) 



where		vc.intRowStatus = 0


