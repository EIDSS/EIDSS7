

CREATE VIEW [dbo].[vw_AVR_BasicSyndromicSurveillanceReport]
as

select		bss.idfBasicSyndromicSurveillance as [PKField], 
			bss.idfBasicSyndromicSurveillance as [PKField_4583090000064], 
			p_ent_bss.idfPerson as [PKField_4583090000065], 
			site_bss.idfsSite as [PKField_4583090000066], 
			hosp_bss.idfOffice as [PKField_4583090000067], 
			human_bss.idfHuman as [PKField_4583090000068], 
			glcra_human_bss.idfGeoLocation as [PKField_4583090000069], 
			s_glcra_human_bss.idfsSettlement as [PKField_4583090000070], 
			whoAG_bss.idfsDiagnosisAgeGroup as [PKField_4583090000071], 
			cdcAG_bss.idfsDiagnosisAgeGroup as [PKField_4583090000072], 
			bss.strFormID as [sflBss_FormID], 
			bss.datDateEntered as [sflBss_DateEntered], 
			bss.datDateLastSaved as [sflBss_DateLastSaved], 
			dbo.fnConcatFullName(p_ent_bss.strFamilyName, p_ent_bss.strFirstName, p_ent_bss.strSecondName) as [sflBss_EnteredBy], 
			office_bss.idfsOfficeAbbreviation as [sflBss_Site_ID], 
			bss.idfsBasicSyndromicSurveillanceType as [sflBss_NotificationOf_ID], 
			hosp_bss.idfsOfficeAbbreviation as [sflBss_NameOfHospital_ID], 
			bss.datReportDate as [sflBss_ReportDate], 
			dbo.fnConcatFullName(human_bss.strLastName, human_bss.strFirstName, human_bss.strSecondName) as [sflBss_PatientName], 
			bss.strPersonalID as [sflBss_PersonalID], 
			human_bss.idfsHumanGender as [sflBss_Sex_ID], 
			bss.idfsYNPregnant as [sflBss_Pregnant_ID], 
			bss.idfsYNPostpartumPeriod as [sflBss_PostpartumPeriod_ID], 
			human_bss.datDateofBirth as [sflBss_DateOfBirth], 
			bss.intAgeFullMonth as [sflBss_CompletePatientAgeMonths], 
			bss.intAgeFullYear as [sflBss_CompletePatientAgeYears], 
			isnull(cast(bss.intAgeYear as varchar) + ' years ', '') +  isnull(cast(bss.intAgeMonth as varchar) + ' month', '') as [sflBss_CompletePatientAgeYM], 
			glcra_human_bss.idfsRegion as [sflBss_Region_ID], 
			glcra_human_bss.idfsRayon as [sflBss_Rayon_ID], 
			glcra_human_bss.idfsSettlement as [sflBss_Settlement_ID], 
			s_glcra_human_bss.intElevation as [sflBss_Elevationm], 
			bss.datDateOfSymptomsOnset as [sflBss_DateOfSymptomsOnset], 
			bss.idfsYNFever as [sflBss_Fever_ID], 
			bss.idfsMethodOfMeasurement as [sflBss_MethodOfMeasurement_ID], 
			bss.strMethod as [sflBss_OtherMethodOfMeasurement], 
			bss.idfsYNCough as [sflBss_Cough_ID], 
			bss.idfsYNShortnessOfBreath as [sflBss_ShortnessOfBreath_ID], 
			bss.idfsYNSeasonalFluVaccine as [sflBss_SeasonalFluVaccine_ID], 
			bss.datDateOfCare as [sflBss_DateOfCare], 
			bss.idfsYNPatientWasInER as [sflBss_PatientWasInER_ID], 
			bss.idfsYNPatientWasHospitalized as [sflBss_PatientWasHospitalized1N_ID], 
			bss.idfsOutcome as [sflBss_Outcome_ID], 
			bss.idfsYNTreatment as [sflBss_Treatment_ID], 
			bss.idfsYNAdministratedAntiviralMedication as [sflBss_AdminAntiviralMedication_ID], 
			bss.strNameOfMedication as [sflBss_NameOfMedication], 
			bss.datDateReceivedAntiviralMedication as [sflBss_DateReceivedAntiviralMed], 
			(IsNull(bss.blnRespiratorySystem, 0) * 10100001 + (1 - IsNull(bss.blnRespiratorySystem, 0)) * 10100002) as [sflBss_RespiratorySystem_ID], 
			(IsNull(bss.blnAsthma, 0) * 10100001 + (1 - IsNull(bss.blnAsthma, 0)) * 10100002) as [sflBss_Asthma_ID], 
			(IsNull(bss.blnDiabetes, 0) * 10100001 + (1 - IsNull(bss.blnDiabetes, 0)) * 10100002) as [sflBss_Diabetes_ID], 
			(IsNull(bss.blnCardiovascular, 0) * 10100001 + (1 - IsNull(bss.blnCardiovascular, 0)) * 10100002) as [sflBss_Cardiovascular_ID], 
			(IsNull(bss.blnObesity, 0) * 10100001 + (1 - IsNull(bss.blnObesity, 0)) * 10100002) as [sflBss_Obesity_ID], 
			(IsNull(bss.blnRenal, 0) * 10100001 + (1 - IsNull(bss.blnRenal, 0)) * 10100002) as [sflBss_Renal_ID], 
			(IsNull(bss.blnLiver, 0) * 10100001 + (1 - IsNull(bss.blnLiver, 0)) * 10100002) as [sflBss_Liver_ID], 
			(IsNull(bss.blnNeurological, 0) * 10100001 + (1 - IsNull(bss.blnNeurological, 0)) * 10100002) as [sflBss_Neurological_ID], 
			(IsNull(bss.blnImmunodeficiency, 0) * 10100001 + (1 - IsNull(bss.blnImmunodeficiency, 0)) * 10100002) as [sflBss_Immunodeficiency_ID], 
			(IsNull(bss.blnUnknownEtiology, 0) * 10100001 + (1 - IsNull(bss.blnUnknownEtiology, 0)) * 10100002) as [sflBss_UnknownEtiology_ID], 
			bss.datSampleCollectionDate as [sflBss_SampleCollectionDate], 
			bss.strSampleID as [sflBss_SampleID], 
			bss.idfsTestResult as [sflBss_TestResult_ID], 
			bss.datTestResultDate as [sflBss_ResultDate], 
			cdcAG_bss.idfsDiagnosisAgeGroup as [sflBss_CDCAgeGroup_ID], 
			whoAG_bss.idfsDiagnosisAgeGroup as [sflBss_WHOAgeGroup_ID]

from 

( 
	tlbBasicSyndromicSurveillance bss
left join 

 
	tlbOffice hosp_bss
 

ON hosp_bss.idfOffice = bss.idfHospital 
left join 

 
	tlbPerson p_ent_bss
 

ON p_ent_bss.idfPerson = bss.idfEnteredBy 
left join 

 
	vwBssAgeGroups cdcAG_bss
 

ON	cdcAG_bss.strAgeGroup = 'CDCAgeGroup' and
			bss.intAgeFullYear >= cdcAG_bss.intLowerBoundary and 
			bss.intAgeFullYear <= cdcAG_bss.intUpperBoundary
      
left join 

 
	vwBssAgeGroups whoAG_bss
 

ON	whoAG_bss.strAgeGroup = 'WHOAgeGroup' and
			bss.intAgeFullYear >= whoAG_bss.intLowerBoundary and 
			bss.intAgeFullYear <= whoAG_bss.intUpperBoundary
      
left join 

( 
	tlbHuman human_bss
left join 

( 
	tlbGeoLocation glcra_human_bss
left join 

 
	dbo.gisSettlement s_glcra_human_bss
 

ON s_glcra_human_bss.idfsSettlement = glcra_human_bss.idfsSettlement
) 

ON human_bss.idfCurrentResidenceAddress = glcra_human_bss.idfGeoLocation
) 

ON human_bss.idfHuman = bss.idfHuman 
left join 

( 
	tstSite site_bss
		inner join tlbOffice office_bss
		on site_bss.idfOffice = office_bss.idfOffice
) 

ON site_bss.idfsSite = bss.idfsSite 
) 



where		bss.intRowStatus = 0


