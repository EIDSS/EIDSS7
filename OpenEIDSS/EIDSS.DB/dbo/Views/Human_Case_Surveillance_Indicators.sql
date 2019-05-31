
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

CREATE VIEW [dbo].[Human_Case_Surveillance_Indicators]
as

select		hc.idfHumanCase as [PKField], 
			m.datFieldCollectionDate as [sflHCSample_CollectionDate], 
			bt.datPerformedDate as [sflHCTest_PerformedDate], 
			DATEDIFF(D, m.datFieldCollectionDate, m.datAccession) as [sflHCSample_DaysInTransit], 
			hc.strCaseID as [sflHC_CaseID], 
			d_changed_hc.idfsDiagnosis as [sflHC_ChangedDiagnosis_ID], 
			hc.datEnteredDate as [sflHC_EnteredDate], 
			hc.datOnSetDate as [sflHC_SymptomOnsetDate], 
			d_init_hc.idfsDiagnosis as [sflHC_Diagnosis_ID], 
			hc.datTentativeDiagnosisDate as [sflHC_DiagnosisDate], 
			hc.datNotificationDate as [sflHC_NotificationDate], 
			hc.idfsYNSpecimenCollected as [sflHC_SamplesCollected_ID], 
			d_fin_hc.idfsDiagnosis as [sflHC_FinalDiagnosis_ID], 
			m.datAccession as [sflHCSample_AccessionDate], 
			m.datFieldSentDate as [sflHCSample_SentDate], 
			hc.idfsFinalCaseStatus as [sflHC_FinalCaseClassification_ID], 
			case when IsNull(hc.idfsFinalDiagnosis, -1) > 0 then hc.datFinalDiagnosisDate else hc.datTentativeDiagnosisDate end as [sflHC_FinalDiagnosisDate], 
			DATEDIFF(DD, hc.datTentativeDiagnosisDate, hc.datNotificationDate) as [sflHC_DaysAfterInitDiagUntilNotif], 
			DATEDIFF(DD, hc.datOnSetDate, hc.datNotificationDate) as [sflHC_DaysAfterOnsetSymptUntilNotif], 
			DATEDIFF(DD, hc.datOnSetDate, hc.datFirstSoughtCareDate) as [sflHC_DaysAfterSymptOnsetUntilFSC], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, hc.datNotificationDate) as [sflHC_DaysAfterFSCUntilNotif], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, hc.datEnteredDate) as [sflHC_DaysAfterFSCUntilEntered], 
			DATEDIFF(DD, hc.datNotificationDate, hc.datInvestigationStartDate) as [sflHC_DaysAfterNotifUntilCaseInvest], 
			DATEDIFF(DD, hc.datTentativeDiagnosisDate, isnull(hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate)) as [sflHC_DaysAfterInitDiagUntilFinal], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, isnull(hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate)) as [sflHC_DaysAfterFSCUntilFinalDiag], 
			DATEDIFF(DD, hc.datNotificationDate, m.datFieldCollectionDate) as [sflHCSample_DaysAfterNotifUntilSC], 
			DATEDIFF(DD, hc.datFirstSoughtCareDate, m.datFieldCollectionDate) as [sflHCSample_DaysAfterFSCuntilSC], 
			DATEDIFF(DD, m.datFieldCollectionDate, m.datFieldSentDate) as [sflHCSample_DaysUntilSent_Collect], 
			DATEDIFF(DD, m.datFieldSentDate, m.datAccession) as [sflHCSample_DaysUntAccesSinceSent], 
			DATEDIFF(DD, m.datFieldSentDate, t.datConcludedDate) as [sflHCTest_DaysUntilTest_SmplSent], 
			DATEDIFF(DD, m.datAccession, t.datConcludedDate) as [sflHCTest_DaysUntilTest_SmplAcces]

from 

( 
	tlbHumanCase hc 
	inner join	tlbHuman h_hc 
	on			h_hc.idfHuman = hc.idfHuman 
				and h_hc.intRowStatus = 0 
left join 

 
	trtDiagnosis d_changed_hc 
 

ON d_changed_hc.idfsDiagnosis = hc.idfsFinalDiagnosis 
left join 

 
	trtDiagnosis d_fin_hc 
 

ON d_fin_hc.idfsDiagnosis = ISNULL(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
left join 

 
	trtDiagnosis d_init_hc 
 

ON d_init_hc.idfsDiagnosis = hc.idfsTentativeDiagnosis 
left join 

( 
	tlbMaterial m 
	  left join tlbHuman h_m
	  on h_m.idfHuman = m.idfHuman
	  and h_m.intRowStatus = 0
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






