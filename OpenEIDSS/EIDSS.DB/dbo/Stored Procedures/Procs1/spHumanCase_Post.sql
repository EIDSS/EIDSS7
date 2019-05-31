
--##SUMMARY Saves information about the human case.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 28.01.2010

--##REMARKS UPDATED BY: Shatilova T.
--##REMARKS Date: 10.07.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
declare	@idfCase						bigint
declare	@idfOutbreak					bigint
declare	@datEnteredDate					datetime
declare	@strCaseID						nvarchar(200)
declare	@idfsCaseProgressStatus			bigint
declare	@idfsFinalState					bigint
declare	@idfsHospitalizationStatus		bigint
declare	@idfsHumanAgeType				bigint
declare	@idfsYNAntimicrobialTherapy		bigint
declare	@idfsYNHospitalization			bigint
declare	@idfsYNSpecimenCollected		bigint
declare	@idfsYNRelatedToOutbreak		bigint
declare	@idfsYNTestsConducted			bigint
declare	@idfsOutcome					bigint
declare	@idfsTentativeDiagnosis			bigint
declare	@idfsFinalDiagnosis				bigint
declare	@idfsInitialCaseStatus			bigint
declare	@idfsFinalCaseStatus			bigint
declare	@idfSentByOffice				bigint
declare	@idfReceivedByOffice			bigint
declare	@idfInvestigatedByOffice		bigint
declare	@idfPointGeoLocation			bigint
declare	@idfEpiObservation				bigint
declare	@idfsEPIFormTemplate			bigint
declare	@idfCSObservation				bigint
declare	@idfsCSFormTemplate				bigint
declare	@datNotificationDate			datetime
declare	@datCompletionPaperFormDate		datetime
declare	@datFirstSoughtCareDate			datetime
declare	@datModificationDate			datetime
declare	@datHospitalizationDate			datetime
declare	@datFacilityLastVisit			datetime
declare	@datExposureDate				datetime
declare	@datDischargeDate				datetime
declare	@datOnsetDate					datetime
declare	@datInvestigationStartDate		datetime
declare	@datTentativeDiagnosisDate		datetime
declare	@datFinalDiagnosisDate			datetime
declare	@strNote						nvarchar(2000)
declare	@strCurrentLocation				nvarchar(200)
declare	@strHospitalizationPlace		nvarchar(200)
declare	@strLocalIdentifier				nvarchar(200)
declare	@idfSoughtCareFacility			bigint
declare	@idfSentByPerson				nvarchar(200)
declare	@strSentByFirstName				nvarchar(200)
declare	@strSentByPatronymicName		nvarchar(200)
declare	@strSentByLastName				nvarchar(200)
declare	@idfReceivedByPerson			nvarchar(200)
declare	@strReceivedByFirstName			nvarchar(200)
declare	@strReceivedByPatronymicName	nvarchar(200)
declare	@strReceivedByLastName			nvarchar(200)
declare	@idfInvestigatedByPerson		nvarchar(200)
declare	@strEpidemiologistsName			nvarchar(200)
declare	@idfsNotCollectedReason			bigint
declare	@idfsNonNotifiableDiagnosis		bigint
declare	@intPatientAge					int
declare	@blnClinicalDiagBasis			bit
declare	@blnLabDiagBasis				bit
declare	@blnEpiDiagBasis				bit
declare	@strClinicalNotes				nvarchar(2000)
declare	@strSummaryNotes				nvarchar(2000)
declare	@idfHuman						bigint
declare	@idfPersonEnteredBy				bigint
declare	@idfsOccupationType				bigint
declare	@idfRegistrationAddress			bigint
declare	@datDateOfDeath					datetime
declare	@strRegistrationPhone			nvarchar(200)
declare	@strWorkPhone					nvarchar(200)
declare @blnPermantentAddressAsCurrent	bit
declare @strSampleNotes                 nvarchar(1000)


exec spHumanCase_Post 
	 @idfCase
	,@idfOutbreak
	,@datEnteredDate
	,@strCaseID
	,@idfsCaseProgressStatus
	,@idfsFinalState
	,@idfsHospitalizationStatus
	,@idfsHumanAgeType
	,@idfsYNAntimicrobialTherapy
	,@idfsYNHospitalization
	,@idfsYNSpecimenCollected
	,@idfsYNRelatedToOutbreak
	,@idfsYNTestsConducted
	,@idfsOutcome
	,@idfsTentativeDiagnosis
	,@idfsFinalDiagnosis
	,@idfsInitialCaseStatus
	,@idfsFinalCaseStatus
	,@idfSentByOffice
	,@idfReceivedByOffice
	,@idfInvestigatedByOffice
	,@idfPointGeoLocation
	,@idfEpiObservation
	,@idfsEPIFormTemplate
	,@idfCSObservation
	,@idfsCSFormTemplate
	,@datNotificationDate
	,@datCompletionPaperFormDate
	,@datFirstSoughtCareDate
	,@datModificationDate
	,@datHospitalizationDate
	,@datFacilityLastVisit
	,@datExposureDate
	,@datDischargeDate
	,@datOnsetDate
	,@datInvestigationStartDate
	,@datTentativeDiagnosisDate
	,@datFinalDiagnosisDate
	,@strNote
	,@strCurrentLocation
	,@strHospitalizationPlace
	,@strLocalIdentifier
	,@idfSoughtCareFacility
	,@idfSentByPerson
	,@strSentByFirstName
	,@strSentByPatronymicName
	,@strSentByLastName
	,@idfReceivedByPerson
	,@strReceivedByFirstName
	,@strReceivedByPatronymicName
	,@strReceivedByLastName
	,@idfInvestigatedByPerson
	,@strEpidemiologistsName
	,@idfsNotCollectedReason
	,@idfsNonNotifiableDiagnosis
	,@intPatientAge
	,@blnClinicalDiagBasis
	,@blnLabDiagBasis
	,@blnEpiDiagBasis
	,@strClinicalNotes
	,@strSummaryNotes
	,@idfHuman
	,@idfPersonEnteredBy
	,@idfsOccupationType
	,@idfRegistrationAddress
	,@datDateOfDeath
	,@strRegistrationPhone
	,@strWorkPhone
	,@blnPermantentAddressAsCurrent
	,@strSampleNotes
*/


create	procedure	[dbo].[spHumanCase_Post]
(	 @idfCase						bigint			--##PARAM @idfCase Case Id
	,@idfOutbreak					bigint			--##PARAM @idfOutbreak Id of the outbreak, which includes a case (reference to tlbOutbreak)
	,@datEnteredDate				datetime		--##PARAM @datEnteredDate - date when case is entered in the system
	,@strCaseID						nvarchar(200)	--##PARAM @strCaseID Unique human readable Code generated by the system
	,@uidOfflineCaseID				uniqueidentifier
	,@idfsCaseProgressStatus		bigint			--##PARAM @idfsCaseProgressStatus - Id of case progress status (reference to rftCaseProgressStatus)
	,@idfsFinalState				bigint			--##PARAM @idfsFinalState Id of the status of the patient at time of notification (reference to trtBaseReference with Type rftFinalState (19000035))
	,@idfsHospitalizationStatus		bigint			--##PARAM @idfsHospitalizationStatus Id of the current patient location Type (reference to trtBaseReference with Type rftHospStatus (19000041))
	,@idfsHumanAgeType				bigint			--##PARAM @idfsHumanAgeType Id of the patient age unit (reference to trtBaseReference with Type rftHumanAgeType (19000042))
	,@idfsYNAntimicrobialTherapy	bigint			--##PARAM @idfsYNAntimicrobialTherapy Id of the value indicating whether antibiotics were assigned (reference to trtBaseReference with Type rftYesNoValue (19000100))
	,@idfsYNHospitalization			bigint			--##PARAM @idfsYNHospitalization Id of the value indicating whether patient was hospitalized (reference to trtBaseReference with Type rftYesNoValue (19000100))
	,@idfsYNSpecimenCollected		bigint			--##PARAM @idfsYNSpecimenCollected Id of the value indicating whether specimens were collected (reference to trtBaseReference with Type rftYesNoValue (19000100))
	,@idfsYNRelatedToOutbreak		bigint			--##PARAM @idfsYNRelatedToOutbreak Id of the value indicating whether case is included into the outbreak (reference to trtBaseReference with Type rftYesNoValue (19000100))
	,@idfsYNTestsConducted			bigint			--##PARAM @idfsYNTestsConducted Id of the value indicating whether case is tests conducted (reference to trtBaseReference with Type rftYesNoValue (19000100))
	,@idfsOutcome					bigint			--##PARAM @idfsOutcome Id of the case outcome (reference to trtBaseReference with Type rftOutcome (19000064))
	,@idfsTentativeDiagnosis		bigint			--##PARAM @idfsTentativeDiagnosis Id of the initial diagnosis (reference to trtDiagnosis)
	,@idfsFinalDiagnosis			bigint			--##PARAM @idfsFinalDiagnosis Id of the changed diagnosis (reference to trtDiagnosis)
	,@idfsInitialCaseStatus			bigint			--##PARAM @idfsInitialCaseStatus Id of the initial case classification (reference to trtBaseReference with Type rftCaseStatus (19000011))
	,@idfsFinalCaseStatus			bigint			--##PARAM @idfsFinalCaseStatus Id of the final case classification (reference to trtBaseReference with Type rftCaseStatus (19000011))
	,@idfSentByOffice				bigint			--##PARAM @idfSentByOffice Id of the organization that sent the notification (reference to tlbOffice)
	,@idfReceivedByOffice			bigint			--##PARAM @idfReceivedByOffice Id of the organization that received the notification (reference to tlbOffice)
	,@idfInvestigatedByOffice		bigint			--##PARAM @idfInvestigatedByOffice Id of the organization that conducted the investigation (reference to tlbOffice)
	,@idfPointGeoLocation			bigint			--##PARAM @idfPointGeoLocation Id of the case geografical location (reference to tlbGeoLocation)
	,@idfEpiObservation				bigint			--##PARAM @idfEpiObservation Id of the observation related to the epidemiological investigation of the case (reference to tlbObservation)
	,@idfsEPIFormTemplate			bigint			--##PARAM @idfsEPIFormTemplate Id of the flexible form template for the epidemiological investigations (reference to ffFormTemplate)
	,@idfCSObservation				bigint			--##PARAM @idfCSObservation Id of the observations related to the clinical signs of the case (reference to tlbObservation)
	,@idfsCSFormTemplate			bigint			--##PARAM @idfsCSFormTemplate Id of the flexible form template for the clinical signs (reference to ffFormTemplate)
	,@datNotificationDate			datetime		--##PARAM @datNotificationDate Date of notification
	,@datCompletionPaperFormDate	datetime		--##PARAM @datCompletionPaperFormDate Date of completion of paper form
	,@datFirstSoughtCareDate		datetime		--##PARAM @datFirstSoughtCareDate Date the patient first sought care
	,@datModificationDate			datetime		--##PARAM @datModificationDate Date of last case modification
	,@datHospitalizationDate		datetime		--##PARAM @datHospitalizationDate Date of hospitalization (makes sense only if the @idfsYNHospitalization parameter is valued "Yes" (10100001))
	,@datFacilityLastVisit			datetime		--##PARAM @datFacilityLastVisit Date of last presence at work, study and preschool institution
	,@datExposureDate				datetime		--##PARAM @datExposure Date Date of exposure
	,@datDischargeDate				datetime		--##PARAM @datDischarge Date Date of discharge
	,@datOnsetDate					datetime		--##PARAM @datOnsetDate Date of onset
	,@datInvestigationStartDate		datetime		--##PARAM @datInvestigationStartDate Investigation start date
	,@datTentativeDiagnosisDate		datetime		--##PARAM @datTentativeDiagnosisDate Date of initial diagnosis
	,@datFinalDiagnosisDate			datetime		--##PARAM @datFinalDiagnosisDate Date of changed diagnosis
	,@strNote						nvarchar(2000)	--##PARAM @strNote Additional information/Comments including movement of patient during period of maximum incubation
	,@strCurrentLocation			nvarchar(200)	--##PARAM @strCurrentLocation Current location of the patient when idfsHospitalizationStatus = HospitalizationStatus.Other(5360000000)
	,@strHospitalizationPlace		nvarchar(200)	--##PARAM @strHospitalizationPlace Place of hospitalization (makes sense only if the @idfsYNHospitalization parameter is valued "Yes" (10100001))
	,@strLocalIdentifier			nvarchar(200)	--##PARAM @strLocalIdentifier Local identifier of the case, created by the user
	,@idfSoughtCareFacility			bigint			--##PARAM @idfSoughtCareFacility Facility where the patient first sought care
	,@idfSentByPerson				bigint			--##PARAM @idfSentByPerson identifier of the employee that sent the notification (reference to tlbPerson)
	,@strSentByFirstName			nvarchar(200)	--##PARAM @strSentByFirstName First name of the employee that sent the notification
	,@strSentByPatronymicName		nvarchar(200)	--##PARAM @strSentByPatronymicName Second name of the employee that sent the notification
	,@strSentByLastName				nvarchar(200)	--##PARAM @strSentByLastName Last name of the employee that sent the notification
	,@idfReceivedByPerson			bigint			--##PARAM @idfReceivedByPerson identifier name of the employee that received the notification (reference to tlbPerson)
	,@strReceivedByFirstName		nvarchar(200)	--##PARAM @strReceivedByFirstName First name of the employee that received the notification
	,@strReceivedByPatronymicName	nvarchar(200)	--##PARAM @strReceivedByPatronymicName Second name of the employee that received the notification
	,@strReceivedByLastName			nvarchar(200)	--##PARAM @strReceivedByLastName Last name of the employee that received the notification
	,@idfInvestigatedByPerson		bigint			--##PARAM @idfInvestigatedByPerson Id of the employee that conducted the investigation (reference to tlbPerson)
	,@strEpidemiologistsName		nvarchar(200)	--##PARAM @strEpidemiologistsName Epidemiologist name
	,@idfsNotCollectedReason		bigint			--##PARAM @idfsNotCollectedReason The reason that specimens were not collected (makes sense only if the @idfsYNSpecimenCollected parameter is valued "No" (10100002))
	,@idfsNonNotifiableDiagnosis	bigint			--##PARAM @idfsNonNotifiableDiagnosis Non-notifiable diagnosis from the facility where the patient first sought care
	,@intPatientAge					int				--##PARAM @intPatientAge Age of the patient (numerical value)
	,@blnClinicalDiagBasis			bit				--##PARAM @blnClinicalDiagBasis Value indicating whether the clinical signs are basis of the diagnosis
	,@blnLabDiagBasis				bit				--##PARAM @blnLabDiagBasis Value indicating whether the laboratory tests are basis of the diagnosis
	,@blnEpiDiagBasis				bit				--##PARAM @blnEpiDiagBasis Value indicating whether the epidemiological investigations are basis of the diagnosis
	,@strClinicalNotes				nvarchar(2000)	--##PARAM @strClinicalNotes Comments on the clinical information
	,@strSummaryNotes				nvarchar(2000)	--##PARAM @strSummaryNotes General comments
	,@idfHuman						bigint			--##PARAM @idfHuman Id of the human case patient (reference to tlbHuman)
	,@idfPersonEnteredBy			bigint			--##PARAM @idfPersonEnteredBy - reference to person that entered case into system
	,@idfsOccupationType			bigint			--##PARAM @idfsOccupationType Id of the occupation (reference to trtBaseReference with Type rftOccupationType (19000061))
	,@idfRegistrationAddress		bigint			--##PARAM @idfRegistrationAddress Id of the registration address (reference to tlbGeoLocation)
	,@datDateOfDeath				datetime		--##PARAM @datDateOfDeath Date of completion of death
	,@strRegistrationPhone			nvarchar(200)	--##PARAM @strRegistrationPhone Phone number of the registration residence
	,@strWorkPhone					nvarchar(200)	--##PARAM @strWorkPhone Phone number of the employer, children's facility, and school
	,@blnPermantentAddressAsCurrent	bit				--##PARAM @blnPermantentAddressAsCurrent
	,@strSampleNotes                nvarchar(1000)  --##PARAM @strSampleNotes - arbitraty text data related with case specimens
	,@datFinalCaseClassificationDate date			--##PARAM @datFinalCaseClassificationDate - Final Case Classification Date
	,@idfHospital bigint							--##PARAM @idfHospital - Current location of the patient when idfsHospitalizationStatus = HospitalizationStatus.Hospital (5350000000)
	,@datModificationForArchiveDate	datetime = NULL
	,@blnCheckPermissions BIT = 1
)
as

if @idfCase is null return -1

IF @blnCheckPermissions = 1
BEGIN
	declare @check int
	IF Exists (SELECT idfHumanCase FROM dbo.tlbHumanCase WHERE idfHumanCase = @idfCase) 
		OR Exists (SELECT idfVetCase FROM dbo.tlbVetCase WHERE idfVetCase = @idfCase)
	BEGIN
		execute @check=spCheckPermission @idfsSystemFunction=10094027,@idfsObjectOperation=10059004,@idfObjectID=@idfCase --human,write
	END
	else
	BEGIN
		execute @check=spCheckPermission @idfsSystemFunction=10094027,@idfsObjectOperation=10059001,@idfObjectID=@idfCase --human,create
	END	

	if @check<>1 
		begin
   			RAISERROR ('msgHumanCasePermission', 16, 1)
			return -1
		end
END

declare	@idfsCaseStatus	bigint
set	@idfsCaseStatus = IsNull(@idfsFinalCaseStatus, @idfsInitialCaseStatus)

declare	@idfsCaseType	bigint
set	@idfsCaseType = null
select	@idfsCaseType = CaseType.idfsBaseReference
from	trtBaseReference CaseType
where	CaseType.idfsBaseReference = 10012001		-- Routine Human Case Report
		and CaseType.idfsReferenceType = 19000012	-- rftCaseType


EXECUTE spOutbreak_CheckPrimaryCase @idfCase, @idfOutbreak


if not exists	(
	select	*
	from	tlbGeoLocation GeoLocation
	where	GeoLocation.idfGeoLocation = @idfPointGeoLocation
				)
begin
	insert into	tlbGeoLocation
	(	idfGeoLocation
	)
	values
	(	@idfPointGeoLocation
	)
end

-- Post Epi & CS observations
exec spObservation_Post @idfEpiObservation, @idfsEPIFormTemplate
exec spObservation_Post @idfCSObservation, @idfsCSFormTemplate

-- Post tlbHumanCase
if exists	(
	select	*
	from	tlbHumanCase
	where	idfHumanCase = @idfCase
			)
begin
	update	tlbHumanCase
	set		idfsFinalState				=	@idfsFinalState,
			idfsHospitalizationStatus	=	@idfsHospitalizationStatus,
			idfsHumanAgeType			=	@idfsHumanAgeType,
			idfsYNAntimicrobialTherapy	=	@idfsYNAntimicrobialTherapy,
			idfsYNHospitalization		=	@idfsYNHospitalization,
			idfsYNSpecimenCollected		=	@idfsYNSpecimenCollected,
			idfsYNRelatedToOutbreak		=	@idfsYNRelatedToOutbreak,
			idfsYNTestsConducted		=	@idfsYNTestsConducted,
			idfsOutcome					=	@idfsOutcome,
			idfsTentativeDiagnosis		=	@idfsTentativeDiagnosis,
			idfsFinalDiagnosis			=	@idfsFinalDiagnosis,
			idfsInitialCaseStatus		=	@idfsInitialCaseStatus,
			idfsFinalCaseStatus			=	@idfsFinalCaseStatus,
			idfSentByOffice				=	@idfSentByOffice,
			idfReceivedByOffice			=	@idfReceivedByOffice,
			idfInvestigatedByOffice		=	@idfInvestigatedByOffice,
			idfPointGeoLocation			=	@idfPointGeoLocation,
			idfEpiObservation			=	@idfEpiObservation,
			idfCSObservation			=	@idfCSObservation,
			datNotificationDate			=	@datNotificationDate,
			datCompletionPaperFormDate	=	@datCompletionPaperFormDate,
			datFirstSoughtCareDate		=	@datFirstSoughtCareDate,
			datModificationDate			=	@datModificationDate,
			datHospitalizationDate		=	@datHospitalizationDate,
			datFacilityLastVisit		=	@datFacilityLastVisit,
			datExposureDate				=	@datExposureDate,
			datDischargeDate			=	@datDischargeDate,
			datOnSetDate				=	@datOnsetDate,
			datInvestigationStartDate	=	@datInvestigationStartDate,
			datTentativeDiagnosisDate	=	@datTentativeDiagnosisDate,
			datFinalDiagnosisDate		=	@datFinalDiagnosisDate,
			strNote						=	@strNote,
			strCurrentLocation			=	@strCurrentLocation,
			strHospitalizationPlace		=	@strHospitalizationPlace,
			strLocalIdentifier			=	@strLocalIdentifier,
			idfSoughtCareFacility		=	@idfSoughtCareFacility,
			idfSentByPerson				=	@idfSentByPerson,
			strSentByFirstName			=	@strSentByFirstName,
			strSentByPatronymicName		=	@strSentByPatronymicName,
			strSentByLastName			=	@strSentByLastName,
			idfReceivedByPerson			=	@idfReceivedByPerson,
			strReceivedByFirstName		=	@strReceivedByFirstName,
			strReceivedByPatronymicName	=	@strReceivedByPatronymicName,
			strReceivedByLastName		=	@strReceivedByLastName,
			idfInvestigatedByPerson		=	@idfInvestigatedByPerson,
			strEpidemiologistsName		=	@strEpidemiologistsName,
			idfsNotCollectedReason		=	@idfsNotCollectedReason,
			idfsNonNotifiableDiagnosis	=	@idfsNonNotifiableDiagnosis,
			intPatientAge				=	@intPatientAge,
			blnClinicalDiagBasis		=	@blnClinicalDiagBasis,
			blnLabDiagBasis				=	@blnLabDiagBasis,
			blnEpiDiagBasis				=	@blnEpiDiagBasis,
			strClinicalNotes			=	@strClinicalNotes,
			strSummaryNotes				=	@strSummaryNotes,
			idfHuman					=	@idfHuman,
			idfsCaseProgressStatus		=	@idfsCaseProgressStatus,
			idfOutbreak					=	@idfOutbreak,
			--datEnteredDate				=	@datEnteredDate,
			--strCaseID					=	@strCaseID,
			uidOfflineCaseID			=	@uidOfflineCaseID,
			strSampleNotes				=	@strSampleNotes
			,datFinalCaseClassificationDate = @datFinalCaseClassificationDate
			,idfHospital				= @idfHospital
			,datModificationForArchiveDate = getdate()
	where	idfHumanCase = @idfCase
end
else begin
	insert into	tlbHumanCase
	(	idfHumanCase,
		idfsFinalState,
		idfsHospitalizationStatus,
		idfsHumanAgeType,
		idfsYNAntimicrobialTherapy,
		idfsYNHospitalization,
		idfsYNSpecimenCollected,
		idfsYNRelatedToOutbreak,
		idfsYNTestsConducted,
		idfsOutcome,
		idfsTentativeDiagnosis,
		idfsFinalDiagnosis,
		idfsInitialCaseStatus,
		idfsFinalCaseStatus,
		idfSentByOffice,
		idfReceivedByOffice,
		idfInvestigatedByOffice,
		idfPointGeoLocation,
		idfEpiObservation,
		idfCSObservation,
		datNotificationDate,
		datCompletionPaperFormDate,
		datFirstSoughtCareDate,
		datModificationDate,
		datHospitalizationDate,
		datFacilityLastVisit,
		datExposureDate,
		datDischargeDate,
		datOnSetDate,
		datInvestigationStartDate,
		datTentativeDiagnosisDate,
		datFinalDiagnosisDate,
		strNote,
		strCurrentLocation,
		strHospitalizationPlace,
		strLocalIdentifier,
		idfSoughtCareFacility,
		idfSentByPerson,
		strSentByFirstName,
		strSentByPatronymicName,
		strSentByLastName,
		idfReceivedByPerson,
		strReceivedByFirstName,
		strReceivedByPatronymicName,
		strReceivedByLastName,
		idfInvestigatedByPerson,
		strEpidemiologistsName,
		idfsNotCollectedReason,
		idfsNonNotifiableDiagnosis,
		intPatientAge,
		blnClinicalDiagBasis,
		blnLabDiagBasis,
		blnEpiDiagBasis,
		strClinicalNotes,
		strSummaryNotes,
		idfHuman,
		idfPersonEnteredBy,
		idfsCaseProgressStatus,
		idfOutbreak,
		datEnteredDate,
		strCaseID,
		uidOfflineCaseID,
		strSampleNotes
		,datFinalCaseClassificationDate
		,idfHospital
		,datModificationForArchiveDate
	)
	values
	(	@idfCase,
		@idfsFinalState,
		@idfsHospitalizationStatus,
		@idfsHumanAgeType,
		@idfsYNAntimicrobialTherapy,
		@idfsYNHospitalization,
		@idfsYNSpecimenCollected,
		@idfsYNRelatedToOutbreak,
		@idfsYNTestsConducted,
		@idfsOutcome,
		@idfsTentativeDiagnosis,
		@idfsFinalDiagnosis,
		@idfsInitialCaseStatus,
		@idfsFinalCaseStatus,
		@idfSentByOffice,
		@idfReceivedByOffice,
		@idfInvestigatedByOffice,
		@idfPointGeoLocation,
		@idfEpiObservation,
		@idfCSObservation,
		@datNotificationDate,
		@datCompletionPaperFormDate,
		@datFirstSoughtCareDate,
		@datModificationDate,
		@datHospitalizationDate,
		@datFacilityLastVisit,
		@datExposureDate,
		@datDischargeDate,
		@datOnsetDate,
		@datInvestigationStartDate,
		@datTentativeDiagnosisDate,
		@datFinalDiagnosisDate,
		@strNote,
		@strCurrentLocation,
		@strHospitalizationPlace,
		@strLocalIdentifier,
		@idfSoughtCareFacility,
		@idfSentByPerson,
		@strSentByFirstName,
		@strSentByPatronymicName,
		@strSentByLastName,
		@idfReceivedByPerson,
		@strReceivedByFirstName,
		@strReceivedByPatronymicName,
		@strReceivedByLastName,
		@idfInvestigatedByPerson,
		@strEpidemiologistsName,
		@idfsNotCollectedReason,
		@idfsNonNotifiableDiagnosis,
		@intPatientAge,
		@blnClinicalDiagBasis,
		@blnLabDiagBasis,
		@blnEpiDiagBasis,
		@strClinicalNotes,
		@strSummaryNotes,
		@idfHuman,
		@idfPersonEnteredBy,
		@idfsCaseProgressStatus,
		@idfOutbreak,
		@datEnteredDate,
		@strCaseID,
		@uidOfflineCaseID,
		@strSampleNotes
		,@datFinalCaseClassificationDate
		,@idfHospital
		,getdate()
	)
end

if exists	(
	select		*
	from		tlbHuman
	where		tlbHuman.idfHuman = @idfHuman
			)
begin
	-- Post tlbHuman
	update	tlbHuman
	set		idfsOccupationType		= @idfsOccupationType,
			idfRegistrationAddress	= @idfRegistrationAddress,
			datDateOfDeath			= @datDateOfDeath,
			strRegistrationPhone	= @strRegistrationPhone,
			strWorkPhone			= @strWorkPhone,
			blnPermantentAddressAsCurrent = @blnPermantentAddressAsCurrent
	where	idfHuman = @idfHuman

	declare @idfHumanActual bigint
	declare @idfRegistrationAdressActual bigint
	select		@idfHumanActual=ha.idfHumanActual,
				@idfRegistrationAdressActual = ha.idfRegistrationAddress
	from		tlbHuman h
	inner join	tlbHumanActual ha 
	on			ha.idfHumanActual = h.idfHumanActual
	where		h.idfHuman = @idfHuman
	if @idfRegistrationAdressActual is null and not @idfRegistrationAddress is null
		exec spsysGetNewID @idfRegistrationAdressActual output

	if not @idfRegistrationAdressActual is null
		exec spGeoLocation_CreateCopy	
			@idfRegistrationAddress,
			@idfRegistrationAdressActual,
			1

	update	tlbHumanActual
	set		idfsOccupationType		= @idfsOccupationType,
			idfRegistrationAddress	= @idfRegistrationAdressActual,
			datDateOfDeath			= @datDateOfDeath,
			strRegistrationPhone	= @strRegistrationPhone,
			strWorkPhone			= @strWorkPhone
	where	idfHumanActual = @idfHumanActual


end

