

CREATE FUNCTION [dbo].[fn070SearchQuery__55709370000000]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflHC_TestConducted_ID], 
			[ref_sflHC_TestConducted].[name] as [sflHC_TestConducted], 
			v.[sflHC_PatientNotificationStatus_ID], 
			[ref_sflHC_PatientNotificationStatus].[name] as [sflHC_PatientNotificationStatus], 
			v.[sflHC_InvestigationStartDate], 
			v.[sflHC_PatientSex_ID], 
			[ref_sflHC_PatientSex].[name] as [sflHC_PatientSex], 
			v.[sflHC_SamplesCollected_ID], 
			[ref_sflHC_SamplesCollected].[name] as [sflHC_SamplesCollected], 
			v.[sflHC_RelatedToOutbreak_ID], 
			[ref_sflHC_RelatedToOutbreak].[name] as [sflHC_RelatedToOutbreak], 
			v.[sflHC_ReasonForNotCollectingSample_ID], 
			[ref_sflHC_ReasonForNotCollectingSample].[name] as [sflHC_ReasonForNotCollectingSample], 
			v.[sflHC_HospitalizationPlace], 
			v.[sflHC_PatientPRPhone], 
			v.[sflHC_PatientPRSettlement_ID], 
			[ref_GIS_sflHC_PatientPRSettlement].[ExtendedName] as [sflHC_PatientPRSettlement], 
			[ref_GIS_sflHC_PatientPRSettlement].[name] as [sflHC_PatientPRSettlement_ShortGISName], 
			v.[sflHC_PatientPRRegion_ID], 
			[ref_GIS_sflHC_PatientPRRegion].[ExtendedName] as [sflHC_PatientPRRegion], 
			[ref_GIS_sflHC_PatientPRRegion].[name] as [sflHC_PatientPRRegion_ShortGISName], 
			v.[sflHC_PatientPRRayon_ID], 
			[ref_GIS_sflHC_PatientPRRayon].[ExtendedName] as [sflHC_PatientPRRayon], 
			[ref_GIS_sflHC_PatientPRRayon].[name] as [sflHC_PatientPRRayon_ShortGISName], 
			v.[sflHC_PatientPRLongitude], 
			v.[sflHC_PatientPRLatitudee], 
			v.[sflHC_PatientPRForeignAddress], 
			v.[sflHC_PPRElevationm], 
			v.[sflHC_PatientPRCountry_ID], 
			[ref_GIS_sflHC_PatientPRCountry].[ExtendedName] as [sflHC_PatientPRCountry], 
			[ref_GIS_sflHC_PatientPRCountry].[name] as [sflHC_PatientPRCountry_ShortGISName], 
			v.[sflHC_PatientPRCoordinates], 
			v.[sflHC_PatientPRAddress_ID], 
			[ref_GL_sflHC_PatientPRAddress].[strDefaultShortAddressString] as [sflHC_PatientPRAddress], 
			v.[sflHC_PatientPhone], 
			v.[sflHC_PatientPersonalIDType_ID], 
			[ref_sflHC_PatientPersonalIDType].[name] as [sflHC_PatientPersonalIDType], 
			v.[sflHC_PatientPersonalID], 
			v.[sflHC_PatientName], 
			v.[sflHC_PatientEmpSettlement_ID], 
			[ref_GIS_sflHC_PatientEmpSettlement].[ExtendedName] as [sflHC_PatientEmpSettlement], 
			[ref_GIS_sflHC_PatientEmpSettlement].[name] as [sflHC_PatientEmpSettlement_ShortGISName], 
			v.[sflHC_PatientEmpRegion_ID], 
			[ref_GIS_sflHC_PatientEmpRegion].[ExtendedName] as [sflHC_PatientEmpRegion], 
			[ref_GIS_sflHC_PatientEmpRegion].[name] as [sflHC_PatientEmpRegion_ShortGISName], 
			v.[sflHC_PatientEmpRayon_ID], 
			[ref_GIS_sflHC_PatientEmpRayon].[ExtendedName] as [sflHC_PatientEmpRayon], 
			[ref_GIS_sflHC_PatientEmpRayon].[name] as [sflHC_PatientEmpRayon_ShortGISName], 
			v.[sflHC_PEMPElevationm], 
			v.[sflHC_PatientEmpAddress_ID], 
			[ref_GL_sflHC_PatientEmpAddress].[strDefaultShortAddressString] as [sflHC_PatientEmpAddress], 
			v.[sflHC_PatientCRSettlement_ID], 
			[ref_GIS_sflHC_PatientCRSettlement].[ExtendedName] as [sflHC_PatientCRSettlement], 
			[ref_GIS_sflHC_PatientCRSettlement].[name] as [sflHC_PatientCRSettlement_ShortGISName], 
			v.[sflHC_PatientCRRegion_ID], 
			[ref_GIS_sflHC_PatientCRRegion].[ExtendedName] as [sflHC_PatientCRRegion], 
			[ref_GIS_sflHC_PatientCRRegion].[name] as [sflHC_PatientCRRegion_ShortGISName], 
			v.[sflHC_PatientCRRayon_ID], 
			[ref_GIS_sflHC_PatientCRRayon].[ExtendedName] as [sflHC_PatientCRRayon], 
			[ref_GIS_sflHC_PatientCRRayon].[name] as [sflHC_PatientCRRayon_ShortGISName], 
			v.[sflHC_PatientCRLongitude], 
			v.[sflHC_PatientCRLatitudee], 
			v.[sflHC_PCRElevationm], 
			v.[sflHC_PatientCRCoordinates], 
			v.[sflHC_PatientCRAddress_ID], 
			[ref_GL_sflHC_PatientCRAddress].[strDefaultShortAddressString] as [sflHC_PatientCRAddress], 
			v.[sflHC_PatientAgeGroup], 
			v.[sflHC_Outcome_ID], 
			[ref_sflHC_Outcome].[name] as [sflHC_Outcome], 
			v.[sflHC_OutbreakID], 
			v.[sflHC_OtherLocation], 
			v.[sflHC_InvestigatedByOffice_ID], 
			[ref_sflHC_InvestigatedByOffice].[name] as [sflHC_InvestigatedByOffice], 
			v.[sflHC_InvestigatedByOfficeID], 
			v.[sflHC_PatientOccupation_ID], 
			[ref_sflHC_PatientOccupation].[name] as [sflHC_PatientOccupation], 
			v.[sflHC_SentByPerson], 
			v.[sflHC_SentByOffice_ID], 
			[ref_sflHC_SentByOffice].[name] as [sflHC_SentByOffice], 
			v.[sflHC_SentByOfficeID], 
			v.[sflHC_ReceivedByPerson], 
			v.[sflHC_ReceivedByOffice_ID], 
			[ref_sflHC_ReceivedByOffice].[name] as [sflHC_ReceivedByOffice], 
			v.[sflHC_ReceivedByOfficeID], 
			v.[sflHC_NotificationDate], 
			v.[sflHC_NonNotifiableDiagnosis_ID], 
			[ref_sflHC_NonNotifiableDiagnosis].[name] as [sflHC_NonNotifiableDiagnosis], 
			v.[sflHC_LocationSettlement_ID], 
			[ref_GIS_sflHC_LocationSettlement].[ExtendedName] as [sflHC_LocationSettlement], 
			[ref_GIS_sflHC_LocationSettlement].[name] as [sflHC_LocationSettlement_ShortGISName], 
			v.[sflHC_LocationRegion_ID], 
			[ref_GIS_sflHC_LocationRegion].[ExtendedName] as [sflHC_LocationRegion], 
			[ref_GIS_sflHC_LocationRegion].[name] as [sflHC_LocationRegion_ShortGISName], 
			v.[sflHC_LocationRayon_ID], 
			[ref_GIS_sflHC_LocationRayon].[ExtendedName] as [sflHC_LocationRayon], 
			[ref_GIS_sflHC_LocationRayon].[name] as [sflHC_LocationRayon_ShortGISName], 
			v.[sflHC_LocationLongitude], 
			v.[sflHC_LocationLatitude], 
			v.[sflHC_LocationIsForeignAddress_ID], 
			[ref_sflHC_LocationIsForeignAddress].[name] as [sflHC_LocationIsForeignAddress], 
			v.[sflHC_LocationForeignAddress], 
			v.[sflHC_LocationElevationm], 
			v.[sflHC_LocationCountry_ID], 
			[ref_GIS_sflHC_LocationCountry].[ExtendedName] as [sflHC_LocationCountry], 
			[ref_GIS_sflHC_LocationCountry].[name] as [sflHC_LocationCountry_ShortGISName], 
			v.[sflHC_LocationCoordinates], 
			v.[sflHC_HospitalizationStatus_ID], 
			[ref_sflHC_HospitalizationStatus].[name] as [sflHC_HospitalizationStatus], 
			v.[sflHC_LocalID], 
			v.[sflHC_InitialCaseClassification_ID], 
			[ref_sflHC_InitialCaseClassification].[name] as [sflHC_InitialCaseClassification], 
			v.[sflHC_Hospitalization_ID], 
			[ref_sflHC_Hospitalization].[name] as [sflHC_Hospitalization], 
			v.[sflHC_HospitalNameID], 
			v.[sflHC_CurrentLocation_ID], 
			[ref_sflHC_CurrentLocation].[name] as [sflHC_CurrentLocation], 
			v.[sflHC_FinalDiagnosisCode], 
			v.[sflHC_FinalDiagnosisIsZoonotic_ID], 
			[ref_sflHC_FinalDiagnosisIsZoonotic].[name] as [sflHC_FinalDiagnosisIsZoonotic], 
			v.[sflHC_FinalDiagnosis_ID], 
			[ref_sflHC_FinalDiagnosis].[name] as [sflHC_FinalDiagnosis], 
			v.[sflHC_FinalCaseClassification_ID], 
			[ref_sflHC_FinalCaseClassification].[name] as [sflHC_FinalCaseClassification], 
			v.[sflHC_FacilityWherePatientFSC_ID], 
			[ref_sflHC_FacilityWherePatientFSC].[name] as [sflHC_FacilityWherePatientFSC], 
			v.[sflHC_FacilityWherePatientFSCCode], 
			v.[sflHC_EpidemiologistName], 
			v.[sflHC_EnteredBySite_ID], 
			[ref_sflHC_EnteredBySite].[name] as [sflHC_EnteredBySite], 
			v.[sflHC_EnteredByOrganizationID], 
			v.[sflHC_EnteredByEmployer], 
			v.[sflHC_PatientEmployerPhone], 
			v.[sflHC_PatientEmployer], 
			v.[sflHC_DiagnosisDate], 
			v.[sflHC_DiagnosisCode], 
			v.[sflHC_DiagnosisIsZoonotic_ID], 
			[ref_sflHC_DiagnosisIsZoonotic].[name] as [sflHC_DiagnosisIsZoonotic], 
			v.[sflHC_Diagnosis_ID], 
			[ref_sflHC_Diagnosis].[name] as [sflHC_Diagnosis], 
			v.[sflHC_DiagnosesAndGroups_ID], 
			[ref_sflHC_DiagnosesAndGroups].[name] as [sflHC_DiagnosesAndGroups], 
			v.[sflHC_DaysAfterSymptOnsetUntilFSC], 
			v.[sflHC_DaysAfterFSCUntilFinalDiag], 
			v.[sflHC_DaysAfterFSCUntilEntered], 
			v.[sflHC_DaysAfterOnsetSymptUntilNotif], 
			v.[sflHC_DaysAfterNotification], 
			v.[sflHC_DaysAfterNotifUntilCaseInvest], 
			v.[sflHC_DaysAfterInitDiagUntilNotif], 
			v.[sflHC_DaysAfterInitDiagUntilFinal], 
			v.[sflHC_DaysAfterFSCUntilNotif], 
			v.[sflHC_PatientFirstSoughtCareDate], 
			v.[sflHC_SymptomOnsetDate], 
			v.[sflHC_FacilityLastVisitDate], 
			v.[sflHC_PatientHospitalizationDate], 
			v.[sflHC_FinalDiagnosisDate], 
			v.[sflHC_DateFinalCaseClassification], 
			v.[sflHC_ExposureDate], 
			v.[sflHC_PatientDischargeDate], 
			v.[sflHC_PatientDeathDate], 
			v.[sflHC_CompletionPaperFormDate], 
			v.[sflHC_ChangedDiagnosisDate], 
			v.[sflHC_PatientDOB], 
			v.[sflHC_ModificationDate], 
			v.[sflHC_EnteredDate], 
			v.[sflHC_PatientNationality_ID], 
			[ref_sflHC_PatientNationality].[name] as [sflHC_PatientNationality], 
			v.[sflHC_ChangedDiagnosisCode], 
			v.[sflHC_ChangedDiagnosisIsZoonotic_ID], 
			[ref_sflHC_ChangedDiagnosisIsZoonotic].[name] as [sflHC_ChangedDiagnosisIsZoonotic], 
			v.[sflHC_ChangedDiagnosis_ID], 
			[ref_sflHC_ChangedDiagnosis].[name] as [sflHC_ChangedDiagnosis], 
			v.[sflHC_CaseProgressStatus_ID], 
			[ref_sflHC_CaseProgressStatus].[name] as [sflHC_CaseProgressStatus], 
			v.[sflHC_CaseID], 
			v.[sflHC_CaseClassification_ID], 
			[ref_sflHC_CaseClassification].[name] as [sflHC_CaseClassification], 
			v.[sflHC_LabDiagBasis_ID], 
			[ref_sflHC_LabDiagBasis].[name] as [sflHC_LabDiagBasis], 
			v.[sflHC_EpiDiagBasis_ID], 
			[ref_sflHC_EpiDiagBasis].[name] as [sflHC_EpiDiagBasis], 
			v.[sflHC_ClinicalDiagBasis_ID], 
			[ref_sflHC_ClinicalDiagBasis].[name] as [sflHC_ClinicalDiagBasis], 
			v.[sflHC_AntimicrobialTherapy_ID], 
			[ref_sflHC_AntimicrobialTherapy].[name] as [sflHC_AntimicrobialTherapy], 
			v.[sflHC_PatientAgeType_ID], 
			[ref_sflHC_PatientAgeType].[name] as [sflHC_PatientAgeType], 
			v.[sflHC_PatientAge] 
from		vw070SearchQuery__55709370000000 v

left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_TestConducted] 
on			[ref_sflHC_TestConducted].idfsReference = v.[sflHC_TestConducted_ID] 
left join	fnReferenceRepair(@LangID, 19000035) [ref_sflHC_PatientNotificationStatus] 
on			[ref_sflHC_PatientNotificationStatus].idfsReference = v.[sflHC_PatientNotificationStatus_ID] 
left join	fnReferenceRepair(@LangID, 19000043) [ref_sflHC_PatientSex] 
on			[ref_sflHC_PatientSex].idfsReference = v.[sflHC_PatientSex_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_SamplesCollected] 
on			[ref_sflHC_SamplesCollected].idfsReference = v.[sflHC_SamplesCollected_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_RelatedToOutbreak] 
on			[ref_sflHC_RelatedToOutbreak].idfsReference = v.[sflHC_RelatedToOutbreak_ID] 
left join	fnReferenceRepair(@LangID, 19000150) [ref_sflHC_ReasonForNotCollectingSample] 
on			[ref_sflHC_ReasonForNotCollectingSample].idfsReference = v.[sflHC_ReasonForNotCollectingSample_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_PatientPRSettlement]  
on			[ref_GIS_sflHC_PatientPRSettlement].idfsReference = v.[sflHC_PatientPRSettlement_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_PatientPRRegion]  
on			[ref_GIS_sflHC_PatientPRRegion].idfsReference = v.[sflHC_PatientPRRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflHC_PatientPRRayon]  
on			[ref_GIS_sflHC_PatientPRRayon].idfsReference = v.[sflHC_PatientPRRayon_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000001) [ref_GIS_sflHC_PatientPRCountry]  
on			[ref_GIS_sflHC_PatientPRCountry].idfsReference = v.[sflHC_PatientPRCountry_ID] 
left join	fnGeoLocationTranslation(@LangID) [ref_GL_sflHC_PatientPRAddress]  
on			[ref_GL_sflHC_PatientPRAddress].idfGeoLocation = v.[sflHC_PatientPRAddress_ID] 
left join	fnReferenceRepair(@LangID, 19000148) [ref_sflHC_PatientPersonalIDType] 
on			[ref_sflHC_PatientPersonalIDType].idfsReference = v.[sflHC_PatientPersonalIDType_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_PatientEmpSettlement]  
on			[ref_GIS_sflHC_PatientEmpSettlement].idfsReference = v.[sflHC_PatientEmpSettlement_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_PatientEmpRegion]  
on			[ref_GIS_sflHC_PatientEmpRegion].idfsReference = v.[sflHC_PatientEmpRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflHC_PatientEmpRayon]  
on			[ref_GIS_sflHC_PatientEmpRayon].idfsReference = v.[sflHC_PatientEmpRayon_ID] 
left join	fnGeoLocationTranslation(@LangID) [ref_GL_sflHC_PatientEmpAddress]  
on			[ref_GL_sflHC_PatientEmpAddress].idfGeoLocation = v.[sflHC_PatientEmpAddress_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_PatientCRSettlement]  
on			[ref_GIS_sflHC_PatientCRSettlement].idfsReference = v.[sflHC_PatientCRSettlement_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_PatientCRRegion]  
on			[ref_GIS_sflHC_PatientCRRegion].idfsReference = v.[sflHC_PatientCRRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflHC_PatientCRRayon]  
on			[ref_GIS_sflHC_PatientCRRayon].idfsReference = v.[sflHC_PatientCRRayon_ID] 
left join	fnGeoLocationTranslation(@LangID) [ref_GL_sflHC_PatientCRAddress]  
on			[ref_GL_sflHC_PatientCRAddress].idfGeoLocation = v.[sflHC_PatientCRAddress_ID] 
left join	fnReferenceRepair(@LangID, 19000064) [ref_sflHC_Outcome] 
on			[ref_sflHC_Outcome].idfsReference = v.[sflHC_Outcome_ID] 
left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_InvestigatedByOffice] 
on			[ref_sflHC_InvestigatedByOffice].idfsReference = v.[sflHC_InvestigatedByOffice_ID] 
left join	fnReferenceRepair(@LangID, 19000061) [ref_sflHC_PatientOccupation] 
on			[ref_sflHC_PatientOccupation].idfsReference = v.[sflHC_PatientOccupation_ID] 
left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_SentByOffice] 
on			[ref_sflHC_SentByOffice].idfsReference = v.[sflHC_SentByOffice_ID] 
left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_ReceivedByOffice] 
on			[ref_sflHC_ReceivedByOffice].idfsReference = v.[sflHC_ReceivedByOffice_ID] 
left join	fnReferenceRepair(@LangID, 19000149) [ref_sflHC_NonNotifiableDiagnosis] 
on			[ref_sflHC_NonNotifiableDiagnosis].idfsReference = v.[sflHC_NonNotifiableDiagnosis_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000004) [ref_GIS_sflHC_LocationSettlement]  
on			[ref_GIS_sflHC_LocationSettlement].idfsReference = v.[sflHC_LocationSettlement_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000003) [ref_GIS_sflHC_LocationRegion]  
on			[ref_GIS_sflHC_LocationRegion].idfsReference = v.[sflHC_LocationRegion_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000002) [ref_GIS_sflHC_LocationRayon]  
on			[ref_GIS_sflHC_LocationRayon].idfsReference = v.[sflHC_LocationRayon_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_LocationIsForeignAddress] 
on			[ref_sflHC_LocationIsForeignAddress].idfsReference = v.[sflHC_LocationIsForeignAddress_ID] 
left join	fnGisExtendedReferenceRepair(@LangID, 19000001) [ref_GIS_sflHC_LocationCountry]  
on			[ref_GIS_sflHC_LocationCountry].idfsReference = v.[sflHC_LocationCountry_ID] 
left join	fnReferenceRepair(@LangID, 19000041) [ref_sflHC_HospitalizationStatus] 
on			[ref_sflHC_HospitalizationStatus].idfsReference = v.[sflHC_HospitalizationStatus_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_InitialCaseClassification] 
on			[ref_sflHC_InitialCaseClassification].idfsReference = v.[sflHC_InitialCaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_Hospitalization] 
on			[ref_sflHC_Hospitalization].idfsReference = v.[sflHC_Hospitalization_ID] 
left join	fnReferenceRepair(@LangID, 19000045) [ref_sflHC_CurrentLocation] 
on			[ref_sflHC_CurrentLocation].idfsReference = v.[sflHC_CurrentLocation_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_FinalDiagnosisIsZoonotic] 
on			[ref_sflHC_FinalDiagnosisIsZoonotic].idfsReference = v.[sflHC_FinalDiagnosisIsZoonotic_ID] 
left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_FinalDiagnosis] 
on			[ref_sflHC_FinalDiagnosis].idfsReference = v.[sflHC_FinalDiagnosis_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_FinalCaseClassification] 
on			[ref_sflHC_FinalCaseClassification].idfsReference = v.[sflHC_FinalCaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_FacilityWherePatientFSC] 
on			[ref_sflHC_FacilityWherePatientFSC].idfsReference = v.[sflHC_FacilityWherePatientFSC_ID] 
left join	fnReferenceRepair(@LangID, 19000046) [ref_sflHC_EnteredBySite] 
on			[ref_sflHC_EnteredBySite].idfsReference = v.[sflHC_EnteredBySite_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_DiagnosisIsZoonotic] 
on			[ref_sflHC_DiagnosisIsZoonotic].idfsReference = v.[sflHC_DiagnosisIsZoonotic_ID] 
left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_Diagnosis] 
on			[ref_sflHC_Diagnosis].idfsReference = v.[sflHC_Diagnosis_ID] 
left join	fnDiagnosesAndGroups(@LangID) [ref_sflHC_DiagnosesAndGroups] 
on			[ref_sflHC_DiagnosesAndGroups].idfsDiagnosisOrDiagnosisGroup = v.[sflHC_DiagnosesAndGroups_ID] 
left join	fnReferenceRepair(@LangID, 19000054) [ref_sflHC_PatientNationality] 
on			[ref_sflHC_PatientNationality].idfsReference = v.[sflHC_PatientNationality_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_ChangedDiagnosisIsZoonotic] 
on			[ref_sflHC_ChangedDiagnosisIsZoonotic].idfsReference = v.[sflHC_ChangedDiagnosisIsZoonotic_ID] 
left join	fnReferenceRepair(@LangID, 19000019) [ref_sflHC_ChangedDiagnosis] 
on			[ref_sflHC_ChangedDiagnosis].idfsReference = v.[sflHC_ChangedDiagnosis_ID] 
left join	fnReferenceRepair(@LangID, 19000111) [ref_sflHC_CaseProgressStatus] 
on			[ref_sflHC_CaseProgressStatus].idfsReference = v.[sflHC_CaseProgressStatus_ID] 
left join	fnReferenceRepair(@LangID, 19000011) [ref_sflHC_CaseClassification] 
on			[ref_sflHC_CaseClassification].idfsReference = v.[sflHC_CaseClassification_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_LabDiagBasis] 
on			[ref_sflHC_LabDiagBasis].idfsReference = v.[sflHC_LabDiagBasis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_EpiDiagBasis] 
on			[ref_sflHC_EpiDiagBasis].idfsReference = v.[sflHC_EpiDiagBasis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_ClinicalDiagBasis] 
on			[ref_sflHC_ClinicalDiagBasis].idfsReference = v.[sflHC_ClinicalDiagBasis_ID] 
left join	fnReferenceRepair(@LangID, 19000100) [ref_sflHC_AntimicrobialTherapy] 
on			[ref_sflHC_AntimicrobialTherapy].idfsReference = v.[sflHC_AntimicrobialTherapy_ID] 
left join	fnReferenceRepair(@LangID, 19000042) [ref_sflHC_PatientAgeType] 
on			[ref_sflHC_PatientAgeType].idfsReference = v.[sflHC_PatientAgeType_ID] 



--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 


