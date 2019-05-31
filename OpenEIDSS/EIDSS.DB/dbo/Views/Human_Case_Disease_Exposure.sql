
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

CREATE VIEW [dbo].[Human_Case_Disease_Exposure]
as

select		hc.idfHumanCase as [PKField], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.datFinalDiagnosisDate as [sflHC_ChangedDiagnosisDate], 
			hc.datExposureDate as [sflHC_ExposureDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			gl_hc.idfsRayon as [sflHC_LocationRayon_ID], 
			gl_hc.idfsRegion as [sflHC_LocationRegion_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			gl_hc.idfsSettlement as [sflHC_LocationSettlement_ID], 
			hc.datFirstSoughtCareDate as [sflHC_PatientFirstSoughtCareDate], 
			IsNull(N'(' + cast(gl_hc.dblLatitude as nvarchar) + N')', N'') as [sflHC_LocationCoordinatesLatitude],
			IsNull(N'(' + cast(gl_hc.dblLongitude as nvarchar) + N')', N'') as [sflHC_LocationCoordinatesLongitude]
from 
( 
	tlbHumanCase hc
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join tlbGeoLocation gl_hc
ON gl_hc.idfGeoLocation = hc.idfPointGeoLocation AND gl_hc.intRowStatus = 0 
left join trtDiagnosis d_changed_hc 
ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join trtDiagnosis d_fin_hc 
ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join trtDiagnosis d_init_hc 
ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
) 
where		hc.intRowStatus = 0

