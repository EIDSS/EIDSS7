
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

CREATE VIEW [dbo].[Human_Case_Epi_Investigation]
as

select		hc.idfHumanCase as [PKField], 
			hc.strCaseID as [sflHC_CaseID], 
			ccp_h.idfCurrentResidenceAddress as [sflHCContact_Information_ID], 
			ccp_h.strLastName + IsNull(N' ' + ccp_h.strFirstName, N'') + IsNull(N' ' + ccp_h.strSecondName, N'') as [sflHCContact_Name], 
			ccp.datDateOfLastContact as [sflHCContact_LastContactDate], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			ccp.idfsPersonContactType as [sflHCContact_Relation_ID], 
			ccp.strPlaceInfo as [sflHCContact_LastContactPlace], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			hc.idfsYNRelatedToOutbreak as [sflHC_RelatedToOutbreak_ID], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			o_inv_hc.idfsOfficeName as [sflHC_InvestigatedByOffice_ID], 
			outb.strOutbreakID as [sflHC_OutbreakID], 
			hc.datInvestigationStartDate as [sflHC_InvestigationStartDate], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate]
from 
( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join tlbOffice o_inv_hc 
ON o_inv_hc.idfOffice = hc.idfInvestigatedByOffice AND o_inv_hc.intRowStatus = 0 
left join tlbOutbreak outb 
ON outb.idfOutbreak = hc.idfOutbreak AND outb.intRowStatus = 0 
left join trtDiagnosis d_changed_hc 
ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join trtDiagnosis d_fin_hc 
ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) 
left join trtDiagnosis d_init_hc 
ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
left join 
( 
   tlbContactedCasePerson ccp
      INNER JOIN	tlbHuman AS ccp_h
           ON ccp_h.idfHuman = ccp.idfHuman
      LEFT JOIN	tlbGeoLocation AS ccp_gl
           ON ccp_gl.idfGeoLocation = ccp_h.idfCurrentResidenceAddress AND
              ccp_gl.intRowStatus = 0 
) 
ON ccp.idfHumanCase = hc.idfHumanCase AND ccp.intRowStatus = 0 
) 
where		hc.intRowStatus = 0
