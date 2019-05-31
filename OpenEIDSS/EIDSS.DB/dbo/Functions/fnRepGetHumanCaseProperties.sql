

-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- ============================================= 


--##SUMMARY Select Human case properties from different tables.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from dbo.fnRepGetHumanCaseProperties ('en')
*/

create Function [dbo].[fnRepGetHumanCaseProperties]
(
	@LangID as nvarchar(50) = 'en'
)
Returns	 Table
AS
return
	select 
	tHumanCase.idfHumanCase					as idfCase,
	ISNULL(tHumanCase.idfsFinalCaseStatus, tHumanCase.idfsInitialCaseStatus)					as idfsCaseStatus,
	tHumanCase.idfsCaseProgressStatus		as idfsCaseProgressStatus,
	10012003								as idfsCaseType,
	tHumanCase.idfOutbreak					as idfOutbreak,
	tHumanCase.datEnteredDate				AS datEnteredDate,
	tHuman.idfsOccupationType				as idfsOccupationType,
	tHuman.idfCurrentResidenceAddress		as idfCurrentResidenceAddress,
	tHuman.idfEmployerAddress				as idfEmployerAddress,
	tHuman.idfRegistrationAddress			as idfRegistrationAddress,
	tHuman.idfsNationality					as idfsNationality,
	tHumanCase.idfsInitialCaseStatus		as idfsInitialCaseStatus,
	tHumanCase.idfsHospitalizationStatus	as idfsHospitalizationStatus,
	tHumanCase.idfsYNAntimicrobialTherapy	as idfsYNAntimicrobialTherapy,
	tHumanCase.idfsYNHospitalization		as idfsYNHospitalization,
	tHumanCase.idfsYNSpecimenCollected		as idfsYNSpecimenCollected,
	tHumanCase.idfsYNRelatedToOutbreak		as idfsYNRelatedToOutbreak,
	tHumanCase.idfsOutcome					as idfsOutcome,
	tHumanCase.idfSentByOffice				as idfSentByOffice,
	tHumanCase.idfReceivedByOffice			as idfReceivedByOffice,
	tHumanCase.idfInvestigatedByOffice		as idfInvestigatedByOffice,
	tHumanCase.idfSoughtCareFacility		as idfSoughtCareFacility,
	tHumanCase.datNotificationDate			as datNotificationDate,
	tHumanCase.datCompletionPaperFormDate	as datCompletionPaperFormDate,
	tHumanCase.datFirstSoughtCareDate		as datFirstSoughtCareDate,
	tHumanCase.datModificationDate			as datModificationDate,
	tHumanCase.datHospitalizationDate		as datHospitalizationDate,
	tHumanCase.datFacilityLastVisit			as datFacilityLastVisit,
	tHumanCase.datExposureDate				as datExposureDate,
	tHumanCase.datDischargeDate				as datDischargeDate,
	tHumanCase.datOnSetDate					as datOnSetDate,
	tHumanCase.datInvestigationStartDate	as datInvestigationStartDate,
	tHumanCase.datTentativeDiagnosisDate	as datTentativeDiagnosisDate,
	tHumanCase.datFinalDiagnosisDate		as datFinalDiagnosisDate,
	fnGeoLocation.name						as strGeoLocation,			
	tHuman.datDateofBirth					as datDateofBirth,
	tHuman.datDateOfDeath					as datDateOfDeath,
	tHumanAct.strPersonID					as strPersonID,
	rfPersonIDType.[name]					AS strPersonIDType,
	tHumanCase.strCaseID					as strCaseID,
	tHumanCase.strLocalIdentifier			as strLocalIdentifier,
	rfGender.[name]							as strPatientGender,
	rfDiagnosis.[name]						as strTentetiveDiagnosis,
	rfChangedDiagnosis.[name]				as strFinalDiagnosis,
	rfNonNotifiableDiagnosis.[name]			as strClinicalDiagnosis,
	tHumanCase.strHospitalizationPlace		as strHospitalizationPlace,
	tHumanCase.strCurrentLocation			as strCurrentLocation,
	tHuman.strEmployerName					as strEmployerName,
	tHuman.strRegistrationPhone				as strRegistrationPhone,
	tHuman.strHomePhone						as strHomePhone,
	tHuman.strWorkPhone						as strWorkPhone,
	dbo.fnConcatFullName(tHuman.strLastName, tHuman.strFirstName, tHuman.strSecondName) as strPatientFullName,
	dbo.fnConcatFullName(receivedPerson.strFamilyName, receivedPerson.strFirstName, receivedPerson.strSecondName) as strReceivedByFullName,
	dbo.fnConcatFullName(sentPerson.strFamilyName, sentPerson.strFirstName, sentPerson.strSecondName) as strSentByFullName,
	rfFinalState.[name]						as strFinalState,
	rfSoughtCareFacility.idfsOfficeAbbreviation		as strSoughtCareFacility,
	rfNotCollectedReason.[name]				as strNotCollectedReason, 
	tHumanCase.strNote						as strNote,
	tHumanCase.strSummaryNotes				as strSummaryNotes,
	tHumanCase.strClinicalNotes				as strClinicalNotes,
	dbo.fnConcatFullName(invPerson.strFamilyName, invPerson.strFirstName, invPerson.strSecondName) as strEpidemiologistsName,
	rfAgeType.[name]						as strPatientAgeType,
	tHumanCase.intPatientAge				as intPatientAge,
	tHumanCase.blnClinicalDiagBasis			as blnClinicalDiagBasis,
	tHumanCase.blnLabDiagBasis				as blnLabDiagBasis,
	tHumanCase.blnEpiDiagBasis				as blnEpiDiagBasis,
	tHumanCase.idfHospital					as idfHospital,
	tHumanCase.datFinalCaseClassificationDate as datFinalCaseClassificationDate,
	tHumanCase.strSampleNotes				as strSampleNotes
	
	-- get case
		  from 
			 dbo.tlbHumanCase as tHumanCase
			 
	-- Get patient
	 left join	dbo.tlbHuman as tHuman
			on	tHumanCase.idfHuman = tHuman.idfHuman and
			    tHuman.intRowStatus = 0
	-- Get patient person id type
	 left join	dbo.tlbHumanActual as tHumanAct
			on	tHumanAct.idfHumanActual = tHuman.idfHumanActual 
     left join	dbo.fnReferenceRepair(@LangID, 19000148) rfPersonIDType ON
				rfPersonIDType.idfsReference = tHumanAct.idfsPersonIDType
			
	-- Get Age Type 
	 left join	fnReference(@LangID, 19000042 /* rftHumanAgeType*/) rfAgeType
			on	tHumanCase.idfsHumanAgeType	= rfAgeType.idfsReference
	-- Get Gender
	 left join	fnReference(@LangID, 19000043 /* rftHumanGender*/) rfGender
			on	tHuman.idfsHumanGender	= rfGender.idfsReference
	-- Get Diagnosis
	 left join	fnReference(@LangID, 19000019/*'rftDiagnosis' */) as rfDiagnosis
			on	rfDiagnosis.idfsReference=tHumanCase.idfsTentativeDiagnosis
	-- Get Final Diagnosis
	 left join	fnReference(@LangID, 19000019/*'rftDiagnosis' */) as rfChangedDiagnosis
			on	rfChangedDiagnosis.idfsReference=tHumanCase.idfsFinalDiagnosis
	-- Get Final State
	 left join	fnReference(@LangID, 19000035/*'rftFinalState' */) as rfFinalState
			on  rfFinalState.idfsReference=tHumanCase.idfsFinalState
	 left join	fnInstitution(@LangID) as rfSoughtCareFacility
			on  rfSoughtCareFacility.idfOffice=tHumanCase.idfSoughtCareFacility
	 left join	fnReference(@LangID, 19000150/*'rftNotCollectedReason' */) as rfNotCollectedReason
			on  rfNotCollectedReason.idfsReference=tHumanCase.idfsNotCollectedReason
	 left join	fnReference(@LangID, 19000149/*'rftNonNotifiableDiagnosis' */) as rfNonNotifiableDiagnosis
			on  rfNonNotifiableDiagnosis.idfsReference=tHumanCase.idfsNonNotifiableDiagnosis
	  
	-- Get Received by person
	 left join	tlbPerson as receivedPerson
			on  receivedPerson.idfPerson=tHumanCase.idfReceivedByPerson
	-- Get Received by person
	 left join	tlbPerson as sentPerson
			on  sentPerson.idfPerson=tHumanCase.idfSentByPerson
	-- Get Investigated by person
	 left join	tlbPerson as invPerson
			on  invPerson.idfPerson=tHumanCase.idfInvestigatedByPerson
						
			
	 left join  fnGeoLocationTranslation(@LangID) fnGeoLocation
			on	fnGeoLocation.idfGeoLocation = tHumanCase.idfPointGeoLocation

	WHERE tHumanCase.intRowStatus = 0
