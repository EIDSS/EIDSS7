
--*************************************************************
-- Name 				: USP_HUM_DISEASE_GETDetail
-- Description			: List Human Disease Report
--          
-- Author               : Mandar Kulkarni
-- Revision History
-- Name	Date		Change Detail
-- JWJ	20180418	Added cols for hum disease summary section of the hum disease page
-- HAP  20180801    Added columns DiseaseReportTypeID and strMonitoringSessionID to be returned
-- HAP  20181102    Added column LegacyCaseID to be returned 
-- HAP  20181130    Added columns blnClinicalDiagBasis, blnLabDiagBasis, blnEpiDiagBasis, DateofClassification, idfsYNExposureLocationKnown to be returned
-- HAP  20181207    Added column tlbOutBreak.strOutbreakID to be returned
-- HAP  20181213    Removed VaccinationName and VaccinationDate columns to be returned
-- HAP  20190210    Added column idfCSObservation to be returned for Flex Form integration
-- HAP  20190409    Added columns parentHumanDiseaseReportID and relatedHumanDiseaseReportIdList to be returned for use case HUC11 Changed Diagnosis Human Disease Report​ 
--
-- Testing code:
-- EXEC USP_HUM_DISEASE_GETDetail 'en', 569
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_DISEASE_GETDetail] 

	@LangID								NVARCHAR(50) , 
	@SearchHumanCaseId					BIGINT = NULL

AS
BEGIN
	DECLARE @returnMsg VARCHAR(MAX) = 'Success'
	DECLARE @returnCode BIGINT = 0

	BEGIN TRY  	
		SELECT	tlbHumanCase.idfHumanCase  'idfHumanCase',
		        HumanDiseaseReportRelationship.RelateToHumanDiseaseReportID as parentHumanDiseaseReportID,  
		        (SELECT Distinct
				 STUFF((SELECT ',' + CAST(t2.HumanDiseaseReportID AS varchar)
				   FROM HumanDiseaseReportRelationship t2
				   WHERE t2.RelateToHumanDiseaseReportID = tlbHumanCase.idfHumanCase AND t2.intRowStatus = 0
				   FOR XML PATH('')), 1 ,1, '') 
				   FROM HumanDiseaseReportRelationship t1) as relatedHumanDiseaseReportIdList,
				tlbHumanCase.idfHuman,
				tlbHumanCase.idfsHospitalizationStatus,
				tlbHumanCase.idfsYNSpecimenCollected,
				tlbHumanCase.idfsHumanAgeType,
				tlbHumanCase.idfsYNAntimicrobialTherapy,
				tlbHumanCase.idfsYNHospitalization,
				tlbHUmanCase.idfsYNRelatedToOutbreak,
				tlbHumanCase.idfsOutCome,
				tlbHumanCase.idfsInitialCaseStatus,
				tlbHumanCase.idfsFinalDiagnosis,
				tlbHumanCase.idfsFinalCaseStatus,
				tlbHumanCase.idfSentByOffice,
				tlbHumanCase.idfInvestigatedByOffice,
				tlbHumanCase.idfReceivedByOffice,
				tlbHumanCase.idfEpiObservation,
				tlbHumanCase.idfCSObservation,
				tlbHumanCase.datNotificationDate,
				tlbHumanCase.datCompletionPaperFormDate,
				tlbHumanCase.datFirstSoughtCareDate,
				tlbHumanCase.datHospitalizationDate,
				tlbHumanCase.datFacilityLastVisit,
				tlbHumanCase.datExposureDate,
				tlbHumanCase.datDischargeDate,
				tlbHumanCase.datOnSetDate,
				tlbHumanCase.datInvestigationStartDate 'StartDateofInvestigation',
				tlbHumanCase.datTentativeDiagnosisDate 'datDateOfDiagnosis',
				tlbHumanCase.datFinalDiagnosisDate,
				tlbHumanCase.strNote,
				tlbHumanCase.strCurrentLocation,
				tlbHumanCase.strHospitalizationPlace,
				tlbHumanCase.strLocalIdentifier,
				tlbHumanCase.strSoughtCareFacility,
				tlbHumanCase.strSentByFirstName,
				tlbHumanCase.strSentByPatronymicName,
				tlbHumanCase.strSentByLastName,
				tlbHumanCase.strReceivedByFirstName,
				tlbHumanCase.strReceivedByPatronymicName,
				tlbHumanCase.strReceivedByLastName,
				tlbHumanCase.strEpidemiologistsName,
				tlbHumanCase.strClinicalDiagnosis,
				tlbHumanCase.strClinicalNotes,
				tlbHumanCase.strSummaryNotes,
				tlbHumanCase.intPatientAge,
				tlbHumanCase.blnClinicalDiagBasis,
				tlbHumanCase.blnLabDiagBasis,
				tlbHumanCase.blnEpiDiagBasis,
				tlbHumanCase.idfPersonEnteredBy,
				tlbHumanCase.idfPointGeoLocation,
				tlbHumanCase.idfSentByPerson,
				tlbHumanCase.idfReceivedByPerson,
				tlbHumanCase.idfInvestigatedByPerson,
				tlbHumanCase.idfsYNTestsConducted,
				tlbHumanCase.idfSoughtCareFacility,
				tlbHumanCase.idfsNonNotifiableDiagnosis,
				tlbHumanCase.idfOutbreak,
				tlbHumanCase.strCaseId,
				tlbHumanCase.idfsCaseProgressStatus,
				tlbHumanCase.idfsSite,
				tlbHumanCase.strSampleNotes,
				tlbHumanCase.uidOfflineCaseID,
				tlbHumanCase.datFinalCaseClassificationDate,
				tlbHumanCase.idfHospital,   
				tlbHumanCase.idfsYNSpecificVaccinationAdministered,
				tlbHumanCase.idfsNotCollectedReason,
				tlbHumanCase.idfsYNPreviouslySoughtCare,
				tlbHumanCase.idfsYNExposureLocationKnown,
				tlbHumanCase.datEnteredDate,
				tlbHumanCase.datModificationDate,
				tlbHumanCase.idfsFinalDiagnosis as idfsDiagnosis,			--possible duplicate
				tlbHumanCase.idfsCaseProgressStatus,
				tlbHumanCase.idfsFinalState​,
				tlbHumanCase.DiseaseReportTypeID,
				tlbHumanCase.LegacyCaseID,
				tlbHumanCase.blnClinicalDiagBasis,
				tlbHumanCase.blnLabDiagBasis, 
				tlbHumanCase.blnEpiDiagBasis,
				tlbHumanCase.datFinalCaseClassificationDate	'DateofClassification',
				tlbHumanCase.idfsYNExposureLocationKnown,
				
				tlbOutBreak.strOutbreakID,
				tlbOutBreak.strDescription,

				 tlbHuman.strPersonId,




				Region.name 'Region',
				Rayon.name 'Rayon',
				humanAge.name  'HumanAgeType',
				Outcome.name 'Outcome',
				
				NonNotifiableDiagnosis.name 'NonNotifiableDiagnosis',
				
				NotCollectedReason.name 'NotCollectedReason',
				
				CaseProgressStatus.name 'CaseProgressStatus',
				
				SpecificVaccinationAdministered.name 'SpecificVaccinationAdministered',
				
				PreviouslySoughtCare.name 'PreviouslySoughtCare',
				
				ExposureLocationKnown.name 'ExposureLocationKnown',
				
				
				HospitalizationStatus.name  'HospitalizationStatus',
				
			    Hospitalization.name 'YNHospitalization',
			
				AntimicrobialTherapy.Name 'YNAntimicrobialTherapy',
				
				
				SpecimenCollection.name 'YNSpecimentCollected',
				
				RelatedToOutBreak.name 'YNRelatedToOutBreak',
			
				
				
				tentativeDiagnosis.name 'TentativeDiagnosis',
				
				FinalDiagnosis.name 'SummaryIdfsFinalDiagnosis',
				InitialCaseClassification.name 'InitialCaseStatus',
				FinalCaseClassification.name 'FinalCaseStatus',
				SentByOffice.FullName 'SentByOffice',
				ReceivedByOffice.FullName 'ReceivedByOffice',
				InvestigateByOffice.FullName 'InvestigatedByOffice',
			    TestConducted.name 'YNTestConducted',
				MonitoringSession.strMonitoringSessionID,
				PersonEnteredBy.OrganizationFullName,
	
				isnull(FinalCaseClassification.name, InitialCaseClassification.name) as SummaryCaseClassification,

				ISNULL(SentByPerson.strFamilyName, N'') + ISNULL(' ' + SentByPerson.strFirstName, '') + ISNULL(' ' +SentByPerson.strSecondName, '') 'SentByPerson',
				ISNULL(PersonEnteredBy.strFamilyName, N'') + ISNULL(' ' + PersonEnteredBy.strFirstName, '') + ISNULL(' ' +PersonEnteredBy.strSecondName, '') 'EnteredByPerson',
			    ISNULL(SentByOffice.FullName + '/','') + ISNULL(SentByPerson.strFirstName, '') + ' ' + ISNULL(SentByPerson.strSecondName, '') + ' ' + ISNULL(SentByPerson.strFamilyName, N'') 'strNotificationSentby',
			  
			   ISNULL(ReceivedByPerson.strFamilyName, N'') + ISNULL(' ' + ReceivedByPerson.strFirstName, '') + ISNULL(' ' +ReceivedByPerson.strSecondName, '') 'ReceivedByPerson',
			   ISNULL(ReceivedByOffice.FullName + '/','') + ISNULL(ReceivedByPerson.strFirstName, '')+ ' ' + ISNULL(ReceivedByPerson.strSecondName, '') + ' ' + ISNULL(ReceivedByPerson.strFamilyName, N'') 'strNotificationReceivedby',
			  
			   ISNULL(InvestigatedByPerson.strFamilyName, N'') + ISNULL(' ' + InvestigatedByPerson.strFirstName, '') + ISNULL(' ' +InvestigatedByPerson.strSecondName, '') 'InvestigatedByPerson',
			    ISNULL(tlbHuman.strLastName, N'') + ', ' + ISNULL(' ' + tlbHuman.strFirstName, '') + ISNULL(' ' +tlbHuman.strSecondName, '') 'strPersonName'

		FROM		dbo.tlbHumanCase

		LEFT JOIN	tlbOutbreak	ON	tlbOutbreak.idfOutbreak= tlbHumanCase.idfOutbreak

		LEFT JOIN	tlbHuman ON	tlbHuman.idfHuman = tlbHumanCase.idfHuman

		LEFT JOIN	HumanDiseaseReportRelationship on HumanDiseaseReportRelationship.HumanDiseaseReportID = tlbHumanCase.idfHumanCase AND HumanDiseaseReportRelationship.intRowStatus = 0

		LEFT JOIN	tlbHumanActual ON tlbHumanActual.idfHumanActual = tlbHuman.idfHumanActual AND tlbHuman.intRowStatus = 0
		
		LEFT JOIN	tlbGeoLocation gl
		ON			gl.idfGeoLocation = tlbHumanCase.idfPointGeoLocation AND gl.intRowStatus = 0 
  
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000002) Rayon
		ON			Rayon.idfsReference = gl.idfsRayon
  
		LEFT JOIN	FN_GBL_GIS_REFERENCE(@LangID,19000003) Region
		ON			Region.idfsReference = gl.idfsRegion

		
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000042) HumanAge
		ON			HumanAge.idfsReference = tlbHumanCase.idfsHumanAgeType

				LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000064) Outcome
		ON			Outcome.idfsReference = tlbHumanCase.idfsOutcome


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) FinalDiagnosis
		ON			FinalDiagnosis.idfsReference = tlbHumanCase.idfsFinalDiagnosis

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000111) InitialCaseClassification
		ON			InitialCaseClassification.idfsReference = tlbHumanCase.idfsInitialCaseStatus

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000011) FinalCaseClassification
		ON			FinalCaseClassification.idfsReference = tlbHumanCase.idfsFinalCaseStatus

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000111) Reportstatus
		ON			Reportstatus.idfsReference = tlbHumanCase.idfsCaseProgressStatus

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) NonNotifiableDiagnosis
		ON			NonNotifiableDiagnosis.idfsReference = tlbHumanCase.idfsNonNotifiableDiagnosis


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) NotCollectedReason
		ON			NotCollectedReason.idfsReference = tlbHumanCase.idfsNotCollectedReason


		
		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) CaseProgressStatus
		ON			CaseProgressStatus.idfsReference = tlbHumanCase.idfsCaseProgressStatus


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) SpecificVaccinationAdministered
		ON			SpecificVaccinationAdministered.idfsReference = tlbHumanCase.idfsYNSpecificVaccinationAdministered


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) PreviouslySoughtCare
		ON			PreviouslySoughtCare.idfsReference = tlbHumanCase.idfsYNPreviouslySoughtCare

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) ExposureLocationKnown
		ON			ExposureLocationKnown.idfsReference = tlbHumanCase.idfsYNExposureLocationKnown

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) HospitalizationStatus
		ON			HospitalizationStatus.idfsReference = tlbHumanCase.idfsHospitalizationStatus

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) Hospitalization
		ON			Hospitalization.idfsReference = tlbHumanCase.idfsYNHospitalization

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) AntimicrobialTherapy
		ON			AntimicrobialTherapy.idfsReference = tlbHumanCase.idfsYNAntimicrobialTherapy


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) SpecimenCollection
		ON			SpecimenCollection.idfsReference = tlbHumanCase.idfsYNSpecimenCollected

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) RelatedToOutBreak
		ON			RelatedToOutBreak.idfsReference = tlbHumanCase.idfsYNRelatedToOutbreak


		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000019) tentativeDiagnosis
		ON			tentativeDiagnosis.idfsReference = tlbHumanCase.idfsTentativeDiagnosis

		LEFT JOIN	FN_GBL_Institution(@LangID) SentByOffice
		ON			SentByOffice.idfOffice = tlbHumanCase.idfSentByOffice

		LEFT JOIN	FN_GBL_Institution(@LangID) ReceivedByOffice
		ON			ReceivedByOffice.idfOffice = tlbHumanCase.idfReceivedByOffice

		LEFT JOIN	FN_GBL_Institution(@LangID) InvestigateByOffice
		ON			InvestigateByOffice.idfOffice = tlbHumanCase.idfInvestigatedByOffice

		LEFT JOIN	FN_PERSON_SELECTLIST(@LangID) PersonEnteredBy
		ON			PersonEnteredBy.idfEmployee = tlbHumanCase.idfPersonEnteredBy

	

		LEFT JOIN	FN_GBL_ReferenceRepair(@LangID,19000100) TestConducted
		ON			TestConducted.idfsReference = tlbHumanCase.idfsYNTestsConducted

		LEFT JOIN	dbo.tlbMonitoringSession MonitoringSession
		ON			MonitoringSession.idfMonitoringSession = tlbHumanCase.idfParentMonitoringSession
			
		LEFT JOIN	FN_PERSON_SELECTLIST(@LangID) SentByPerson
		ON			SentByPerson.idfEmployee = tlbHumanCase.idfSentByPerson

		LEFT JOIN	FN_PERSON_SELECTLIST(@LangID) ReceivedByPerson
		ON			ReceivedByPerson.idfEmployee = tlbHumanCase.idfReceivedByPerson

		LEFT JOIN	FN_PERSON_SELECTLIST(@LangID) InvestigatedByPerson
		ON			InvestigatedByPerson.idfEmployee = tlbHumanCase.idfInvestigatedByPerson





		WHERE		tlbHumanCase.idfHumanCase =  ISNULL(@SearchHumanCaseId, tlbHumanCase.idfHumanCase)   
		--SELECT @returnCode, @returnMsg;
		
	END TRY  
	BEGIN CATCH 
	THROW
	END CATCH;
END

