

--*************************************************************
-- Name 				:	USP_HUM_HUMAN_DISEASE_SET
-- Description			:	Insert OR UPDATE human disease record
--          
-- Author               :	Mandar Kulkarni
-- Revision History
--Name  Date		Change Detail
--JWJ	20180403	Added new param to end for ReportStatus
--HAP   20180801    Added new @DiseaseReportTypeID input paramenter
--HAP   20181130    Added new @blnClinicalDiagBasis, @blnLabDiagBasis, @blnEpiDiagBasis input parameters for Basis of Diagnosis 
--                  and new @DateofClassification input parameter 
--HAP   20181205    Added new @StartDateofInvestigation input parameter. Corrected @idfSoughtCareFacility input parameter spelling.	
--HAP	20181206	Removed updating Primary Key column for tlbHumanCase update.
--HAP   20181213    Removed @VaccinationName and @VaccinationDate input paramenters
--HAP   20181221    Changed @Sample as tlbHdrMaterialGetListSPType and @Tests as tlbHdrTestGetListSPType parameters and replaced as NVARCHAR
--HAP   20181227    Changed @Sample parameter to @SampleParameters and changed parameter @Tests to @TestsParameters. 
--LJM   01/02/18    Changed @idfHumanCase from OutputParameter and added to Select Statement
--HAP   01/04/18    Added new input paramters @AntiviralTherapiesParameters and @VaccinationsParameters	
--LJM  1/11/19		SUPRESSED Result Sets in  ALL STORED PROCS
--HAP  1/21/2019    Added @ContactsParameters input parameter 
--HAP  1/27/2019    Added @strSummaryNotes input parameter
--HAP  2/10/2019    Added @idfEpiObservation and @idfCSObservation	input paremeters for Flex Forms integration. 
--
-- Testing code:
--  exec USP_HUM_HUMAN_DISEASE_SET  null, 27, null, '(new)',784050000000
--*************************************************************
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_DISEASE_SET_HAP_Observation]
(
 @idfHumanCase					BIGINT = NULL , -- tlbHumanCase.idfHumanCase Primary Key
 @idfHuman						BIGINT = NULL, -- tlbHumanCase.idfHuman
 @idfHumanActual				BIGINT, -- tlbHumanActual.idfHumanActual
 @strHumanCaseId				NVARCHAR(200) = '(new)',
 @idfsFinalDiagnosis					BIGINT, -- tlbhumancase.idfsTentativeDiagnosis/idfsFinalDiagnosis
 @datDateOfDiagnosis			DATETIME = NULL, --tlbHumanCase.datTentativeDiagnosisDate/datFinalDiagnosisDate
 @datNotificationDate			DATETIME = NULL, --tlbHumanCase.DatNotIFicationDate
 @idfsFinalState				BIGINT = NULL, --tlbHumanCase.idfsFinalState

 @idfSentByOffice	BIGINT = NULL, -- tlbHumanCase.idfSentByOffice
 @strSentByFirstName	NVARCHAR(200)= NULL,--tlbHumanCase.strSentByFirstName
 @strSentByPatronymicName	NVARCHAR(200)= NULL, --tlbHumancase.strSentByPatronymicName
 @strSentByLastName	NVARCHAR(200)= NULL, --tlbHumanCase.strSentByLastName
 @idfSentByPerson				BIGINT = NULL, --tlbHumcanCase.idfSentByPerson

 @idfReceivedByOffice	BIGINT = NULL,-- tlbHumanCase.idfReceivedByOffice
 @strReceivedByFirstName	NVARCHAR(200)= NULL, --tlbHumanCase.strReceivedByFirstName
 @strReceivedByPatronymicName	NVARCHAR(200)= NULL, --tlbHumanCase.strReceivedByPatronymicName
 @strReceivedByLastName	NVARCHAR(200)= NULL, --tlbHuanCase.strReceivedByLastName
 @idfReceivedByPerson				BIGINT = NULL, -- tlbHumanCase.idfReceivedByPerson

 @idfsHospitalizationStatus		BIGINT = NULL,  -- tlbHumanCase.idfsHospitalizationStatus
 @idfHospital				BIGINT = NULL, -- tlbHumanCase.idfHospital
 @strCurrentLocation				NVARCHAR(200)= NULL, -- tlbHumanCase.strCurrentLocation
 @datOnSetDate			DATETIME = NULL,	-- tlbHumanCase.datOnSetDate
 --@idfsInitialCaseClassification	BIGINT = NULL, -- tlbHumanCase.idfsInitialCaseStatus 
 @idfsInitialCaseStatus	BIGINT = NULL, -- tlbHumanCase.idfsInitialCaseStatus
 --@strComments					NVARCHAR(MAX)= NULL, --strClinicalNotes
 @idfsYNPreviouslySoughtCare	BIGINT = NULL,	--idfsYNPreviouslySoughtCare
 @datFirstSoughtCareDate		DATETIME = NULL, --tlbHumanCase.datFirstSoughtCareDate
 @idfSoughtCareFacility			BIGINT = NULL, --tlbHumanCase.idfSoughtCareFacility
 @idfsNonNotIFiableDiagnosis	BIGINT = NULL,	--tlbHumanCase.idfsNonNotIFiableDiagnosis
 @idfsYNHospitalization			BIGINT = NULL, -- tlbHumanCase.idfsYNHospitalization
 @datHospitalizationDate		DATETIME = NULL,  --tlbHumanCase.datHospitalizationDate 
 @datDischargeDate			DATETIME = NULL,	-- tlbHumanCase.datDischargeDate
 @strHospitalName				NVARCHAR(200)= NULL, --tlbHumanCase.strHospitalizationPlace  
 @idfsYNAntimicrobialTherapy	BIGINT = NULL, --  tlbHumanCase.idfsYNAntimicrobialTherapy 
 @strAntibioticName				NVARCHAR(200)= NULL, -- tlbHumanCase.strAntimicrobialTherapyName
 @strDosage						NVARCHAR(200)= NULL, --tlbHumanCase.strDosage
--(idfs)DoseMeasurements		BIGINT, --??
 @datFirstAdministeredDate		DATETIME = NULL, -- tlbHumanCase.datFirstAdministeredDate
 @strAntibioticComments			NVARCHAR(MAX)= NULL, -- tlbHumanCase.strClinicalNotes , or strSummaryNotes
 @idfsYNSpecIFicVaccinationAdministered	BIGINT = NULL, --  tlbHumanCase.idfsYNSpecIFicVaccinationAdministered
 --@VaccinationName				NVARCHAR(200) = NULL,  --tlbHumanCase.VaccinationName
 --@VaccinationDate				DATETIME = NULL, --tlbHumanCase.VaccinationDate
 @idfInvestigatedByOffice		BIGINT = NULL, -- tlbHumanCase.idfInvestigatedByOffice 
 @StartDateofInvestigation		DATETIME = NULL, -- tlbHumanCase.datInvestigationStartDate
 @idfsYNRelatedToOutbreak		BIGINT = NULL, -- tlbHumanCase.idfsYNRelatedToOutbreak
 @idfOutbreak					BIGINT = NULL, --idfOutbreak  
 @idfsYNExposureLocationKnown	BIGINT = NULL, --tlbHumanCase.idfsYNExposureLocationKnown
 @idfPointGeoLocation			BIGINT = NULL, --tlbHumanCase.idfPointGeoLocation
 @datExposureDate				DATETIME = NULL, -- tlbHumanCase.datExposureDate 
 @strLocationDescription		NVARCHAR(MAX) = NULL, --tlbGeolocation.Description
 @idfsLocationCountry			BIGINT = NULL, --tlbGeolocation.idfsCountry
 @idfsLocationRegion			BIGINT = NULL, --tlbGeolocation.idfsRegion
 @idfsLocationRayon				BIGINT = NULL,--tlbGeolocation.idfsRayon
 @idfsLocationSettlement		BIGINT = NULL,--tlbGeolocation.idfsSettlement
 @intLocationLatitude			FLOAT = NULL, --tlbGeolocation.Latittude
 @intLocationLongitude			FLOAT = NULL,--tlbGeolocation.Longitude
 @idfsLocationGroundType		BIGINT = NULL, --tlbGeolocation.GroundType
 @intLocationDistance			FLOAT = NULL, --tlbGeolocation.Distance
 --@idfsFinalClassIFication		BIGINT = NULL, --tlbHuanCase.idfsFinalCaseStatus
 @idfsFinalCaseStatus			BIGINT = NULL, --tlbHuanCase.idfsFinalCaseStatus 
 @idfsOutcome					BIGINT = NULL, -- --tlbHumanCase.idfsOutcome 
 @datDateofDeath				DATETIME = NULL, -- tlbHumanCase.datDateOfDeath 
 @idfsCaseProgressStatus		BIGINT = 10109001,	--	tlbHumanCase.reportStatus, default = In-process
 @idfPersonEnteredBy			BIGINT = NULL,
 @strClinicalNotes				NVARCHAR(2000) = NULL,
 @idfsYNSpecimenCollected		BIGINT = NULL,
 @DiseaseReportTypeID			BIGINT = NULL, 
 @blnClinicalDiagBasis          BIT = NULL,
 @blnLabDiagBasis				BIT = NULL,
 @blnEpiDiagBasis				BIT = NULL,
 @DateofClassification			DATETIME = NULL,
 @strSummaryNotes				NVARCHAR(MAX) = NULL,
 @idfEpiObservation				BIGINT = NULL,
 @idfCSObservation				BIGINT = NULL,
 @SamplesParameters				NVARCHAR(MAX) = NULL,
 @TestsParameters				NVARCHAR(MAX) = NULL,
 @AntiviralTherapiesParameters	NVARCHAR(MAX) = NULL,
 @VaccinationsParameters		NVARCHAR(MAX) = NULL,
 @ContactsParameters			NVARCHAR(MAX) = NULL 	



 --@Samples						tlbHdrMaterialGetListSPType READONLY, 
 --@Tests							tlbHdrTestGetListSPType READONLY
 --, 
 --@Contacts						tlbHdrContactGetListSPType READONLY

)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @tmpCSObservation			BIGINT = null
DECLARE @tmpEpiObservation			BIGINT = null
DECLARE @idfsSite                   BIGINT = 1
DECLARE @idfsFormTemplate			BIGINT = 1

--DECLARE										@SamplesTemp dbo.tlbHdrMaterialGetListSPType;
--INSERT INTO									@SamplesTemp SELECT * FROM @Samples;
--DECLARE										@TestsTemp dbo.tlbHdrTestGetListSPType;
--INSERT INTO									@TestsTemp SELECT * FROM @Tests;
--DECLARE										@ContactsTemp dbo.tlbHdrContactGetListSPType;
--INSERT INTO									@ContactsTemp SELECT * FROM @Contacts;

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
			Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
			Declare @SupressSelectHumanCase table
			( retrunCode int,
			  returnMessage varchar(200),
			  idfHumanCase BigInt
			)
			DECLARE @COPYHUMANACTUALTOHUMAN_ReturnCode int = 0

			-- Create a human record from Human Actual if not already present
			IF @idfHuman IS NULL AND @idfHumanCase IS NULL
				BEGIN
				--insert into @SupressSelect
					EXEC USP_HUM_COPYHUMANACTUALTOHUMAN @idfHumanActual, @idfHuman OUTPUT, @returnCode OUTPUT, @returnMsg OUTPUT
				--SET @COPYHUMANACTUALTOHUMAN_ReturnCode = dbo.FN_COPYHUMANACTUALTOHUMAN(@idfHumanActual, @idfHuman)
					IF @returnCode <> 0 
						BEGIN
							--SELECT @returnCode, @returnMsg
							RETURN
						END
				END

			-- Set geo location 
			IF @idfsLocationRegion IS NOT NULL AND @idfsLocationRegion IS NOT NULL 
			insert into @SupressSelect
				EXECUTE dbo.USP_GBL_GEOLOCATION_SET
											@idfPointGeoLocation OUTPUT,
											@idfsLocationGroundType,
											NULL,
											@idfsLocationCountry,
											@idfsLocationRegion,
											@idfsLocationRayon,
											@idfsLocationSettlement,
											@strLocationDescription,
											@intLocationLatitude,
											@intLocationLongitude,
											NULL,
											NULL,
											NULL,
											@intLocationDistance,
											NULL,
											NULL,
											NULL
	
			IF NOT EXISTS (SELECT idfHumanCase FROM dbo.tlbHumanCase WHERE idfHumanCase = @idfHumanCase AND	intRowStatus = 0)
				BEGIN
					-- Get next key value
						INSERT INTO @SupressSelect
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbHumanCase', @idfHumanCase OUTPUT

					-- Create a stringId for Human Case
					IF LEFT(ISNULL(@strHumanCaseID, '(new'),4) = '(new'
					BEGIN
						INSERT INTO @SupressSelect
						EXEC dbo.USP_GBL_NextNumber_GET 'Human Case', @strHumanCaseID OUTPUT , NULL --N'AS Session'
					END

					Select 	@tmpCSObservation = idfCSObservation from tlbHumanCase 
					Where idfHumanCase = @idfHumanCase
					AND		intRowStatus = 0

					Select @tmpEpiObservation = idfEpiObservation from tlbHumanCase 
					Where idfHumanCase = @idfHumanCase
					AND		intRowStatus = 0

					If @tmpEpiObservation is NULL 
					BEGIN
						
						INSERT INTO @SupressSelect
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbObservation', @tmpEpiObservation OUTPUT;

						INSERT INTO					dbo.tlbObservation
						(						
													idfObservation, 
													idfsFormTemplate, 
													intRowStatus, 
													strMaintenanceFlag, 
													idfsSite
						)
						VALUES
						(
													@tmpCSObservation, 
													@idfsFormTemplate, 
													0, 
													null, 
													@idfsSite
							);	
					END

					If @tmpCSObservation is NULL 
					BEGIN
						
						INSERT INTO @SupressSelect
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbObservation', @tmpCSObservation OUTPUT;

						INSERT INTO					dbo.tlbObservation
						(						
													idfObservation, 
													idfsFormTemplate, 
													intRowStatus, 
													strMaintenanceFlag, 
													idfsSite
						)
						VALUES
						(
													@tmpCSObservation, 
													@idfsFormTemplate, 
													0, 
													null, 
													@idfsSite
							);	
					END				

					
					INSERT 
					INTO	tlbHumanCase
							(
							 idfHumanCase,		
							 idfHuman,
							 strCaseId,				
							 idfsFinalDiagnosis,
							 datTentativeDiagnosisDate,
							 datNotIFicationDate,			
							 idfsFinalState,
							 				
							 idfSentByOffice,	
							 strSentByFirstName,	
							 strSentByPatronymicName,	
							 strSentByLastName,	
							 idfSentByPerson,
							 	
							 idfReceivedByOffice,	
							 strReceivedByFirstName,	
							 strReceivedByPatronymicName,	
							 strReceivedByLastName,	
							 idfReceivedByPerson,
							 				
							 idfsHospitalizationStatus,		
							 idfHospital,				
							 strCurrentLocation,				
							 datOnSetDate,			
							 idfsInitialCaseStatus ,	
							 --@strComments,					
							 idfsYNPreviouslySoughtCare,	
							 datFirstSoughtCareDate,		
							 idfSoughtCareFacility,			
							 idfsNonNotIFiableDiagnosis,	
							 idfsYNHospitalization,			
							 datHospitalizationDate,		
							 datDischargeDate,			
							 strHospitalizationPlace ,				
							 idfsYNAntimicrobialTherapy,	
							 strClinicalNotes,			
							 --VaccinationName,
							 --VaccinationDate,
							 idfsYNSpecIFicVaccinationAdministered,
							 idfInvestigatedByOffice,	
							 datInvestigationStartDate,
							 idfsYNRelatedToOutbreak,	
							 idfOutbreak,					
							 --@strCaseInvestigationOutbreakID, 
							 idfPointGeoLocation,
							 idfsYNExposureLocationKnown,
							 datExposureDate,				
							 idfsFinalCaseStatus,	
							 idfsOutcome,					
							 --datDateOfDeath,
							 intRowStatus,
							 idfsCaseProgressStatus,
							 datModificationDate,
							 datEnteredDate,
							 idfPersonEnteredBy,
							 idfsYNSpecimenCollected,
							 DiseaseReportTypeID,
							 blnClinicalDiagBasis,
							 blnLabDiagBasis,
							 blnEpiDiagBasis,
							 datFinalCaseClassificationDate,	
							 strsummarynotes,
							 idfEpiObservation,	
							 idfCSObservation			
							)
					VALUES (
							 @idfHumanCase,
							 @idfHuman,		
							 @strHumanCaseId,				
							 @idfsFinalDiagnosis,					
							 @datDateOfDiagnosis,
							 @datNotificationDate,			
							 @idfsFinalState,
							 				
							 @idfSentByOffice,	
							 @strSentByFirstName,	
							 @strSentByPatronymicName,	
							 @strSentByLastName,	
							 @idfSentByPerson,	
							 	
							 @idfReceivedByOffice,	
							 @strReceivedByFirstName,	
							 @strReceivedByPatronymicName,	
							 @strReceivedByLastName,	
							 @idfReceivedByPerson,
							 				
							 @idfsHospitalizationStatus,		
							 @idfHospital,				
							 @strCurrentLocation,				
							 @datOnSetDate,			
							 --@idfsInitialCaseClassIFication,
							 @idfsInitialCaseStatus,	
							 --@strComments,					
							 @idfsYNPreviouslySoughtCare,	
							 @datFirstSoughtCareDate,		
							 @idfSoughtCareFacility,			
							 @idfsNonNotIFiableDiagnosis,	
							 @idfsYNHospitalization,			
							 @datHospitalizationDate,		
							 @datDischargeDate,			
							 @strHospitalName,	
							 @idfsYNAntimicrobialTherapy,			
							 @strClinicalNotes,			
							 --@VaccinationName,
							 --@VaccinationDate,
							 @idfsYNSpecIFicVaccinationAdministered,
							 @idfInvestigatedByOffice,	
							 @StartDateofInvestigation ,
							 @idfsYNRelatedToOutbreak,	
							 @idfOutbreak,					
							 --@strCaseInvestigationOutbreakID, 
							 @idfPointGeoLocation,
							 @idfsYNExposureLocationKnown,
							 @datExposureDate,				
							 --@idfsFinalClassIFication,
							 @idfsFinalCaseStatus,
							 @idfsOutcome,					
							 --@datDateofDeath,
							 0,
							 @idfsCaseProgressStatus,
							 getdate(),			--datModificationDate	
							 getDate(),			--datEnteredDate		
							 @idfPersonEnteredBy,
							 @idfsYNSpecimenCollected,
							 @DiseaseReportTypeID,
							 @blnClinicalDiagBasis,
							 @blnLabDiagBasis,
							 @blnEpiDiagBasis,
							 @DateofClassification,
							 @strSummaryNotes,
							 @tmpEpiObservation,
							 @tmpCSObservation	
							)
				END
			ELSE
				BEGIN
					UPDATE dbo.tlbHumanCase
					SET							
							strCaseId =  @strHumanCaseId,
							idfsTentativeDiagnosis =  @idfsFinalDiagnosis,
							idfsFinalDiagnosis =  @idfsFinalDiagnosis,
							datTentativeDiagnosisDate =  @datDateOfDiagnosis,
							datFinalDiagnosisDate =  @datDateOfDiagnosis,
							datNotIFicationDate =  @datNotificationDate,
							idfsFinalState=  @idfsFinalState,

							idfSentByOffice =  @idfSentByOffice,
							strSentByFirstName =  @strSentByFirstName,
							strSentByPatronymicName =  @strSentByPatronymicName,
							strSentByLastName =  @strSentByLastName,
							--idfSentByPerson =  @idfSentByPerson,
							idfSentByPerson = @idfSentByPerson,

							idfReceivedByOffice =  @idfReceivedByOffice,
							strReceivedByFirstName =  @strReceivedByFirstName,
							strReceivedByPatronymicName =  @strReceivedByPatronymicName,
							strReceivedByLastName =  @strReceivedByLastName,
							--idfRecdByPerson =  @idfRecdByPerson,
							idfReceivedByPerson = @idfReceivedByPerson,

							idfsHospitalizationStatus =  @idfsHospitalizationStatus,
							idfHospital =  @idfHospital,
							strCurrentLocation =  @strCurrentLocation,
							datOnSetDate =  @datOnSetDate,
							--idfsInitialCaseStatus  =  @idfsInitialCaseClassIFication,	--initialCaseStatus is the classification
							idfsInitialCaseStatus  =  @idfsInitialCaseStatus,	
							--@strComments =  --@strComments,
							idfsYNPreviouslySoughtCare = @idfsYNPreviouslySoughtCare,
							datFirstSoughtCareDate =  @datFirstSoughtCareDate,
							idfSoughtCareFacility =  @idfSoughtCareFacility	,
							idfsNonNotIFiableDiagnosis =  @idfsNonNotIFiableDiagnosis,
							idfsYNHospitalization =  @idfsYNHospitalization,
							datHospitalizationDate  =  @datHospitalizationDate,
							datDischargeDate =  @datDischargeDate,
							strHospitalizationPlace  =  @strHospitalName,
							idfsYNAntimicrobialTherapy =  @idfsYNAntimicrobialTherapy,
							--strClinicalNotes =  @strAntibioticComments,
							strClinicalNotes = @strClinicalNotes,
							--VaccinationName = @VaccinationName,
							--VaccinationDate = @VaccinationDate,
							idfsYNSpecIFicVaccinationAdministered = idfsYNSpecIFicVaccinationAdministered,
							idfInvestigatedByOffice =  @idfInvestigatedByOffice,
							datInvestigationStartDate = @StartDateofInvestigation, 
							idfsYNRelatedToOutbreak = @idfsYNRelatedToOutbreak,
							idfOutbreak =  @idfOutbreak,
							idfsYNExposureLocationKnown = @idfsYNExposureLocationKnown,
							idfPointGeoLocation = @idfPointGeoLocation,
							datExposureDate =  @datExposureDate,
							--idfsFinalCaseStatus  =  @idfsFinalClassIFication,			--finalCaseStatus is the classification
							idfsFinalCaseStatus  =  @idfsFinalCaseStatus,
							idfsOutcome =  @idfsOutcome,
							--datDateOfDeath =  @datDateofDeath,
							idfsCaseProgressStatus = @idfsCaseProgressStatus,
							datModificationDate = getdate(),
							idfsYNSpecimenCollected = @idfsYNSpecimenCollected,
							DiseaseReportTypeID = @DiseaseReportTypeID,
							blnClinicalDiagBasis = @blnClinicalDiagBasis,
							blnLabDiagBasis = @blnLabDiagBasis,
							blnEpiDiagBasis	= @blnEpiDiagBasis,
							datFinalCaseClassificationDate = @DateofClassification,
							strsummarynotes = @strSummaryNotes,
							idfEpiObservation = @idfEpiObservation,
							idfCSObservation = @idfCSObservation	

					WHERE	idfHumanCase = @idfHumanCase
					AND		intRowStatus = 0

				END
				
				--set Samples for this idfHumanCase	
				If @SamplesParameters is not null
				EXEC USSP_HUMAN_DISEASE_SAMPLES_SET @idfHumanCase,@SamplesParameters;
		
				--set Tests for this idfHumanCase
				If @TestsParameters is not null
				EXEC USSP_HUMAN_DISEASE_TESTS_SET @idfHumanCase,@TestsParameters;

				----set AntiviralTherapies for this idfHumanCase
				If @AntiviralTherapiesParameters is not null
				EXEC USSP_HUMAN_DISEASE_ANTIVIRALTHERAPIES_SET @idfHumanCase,@AntiviralTherapiesParameters;	

				----set Vaccinations for this idfHumanCase
				If @VaccinationsParameters is not null
				EXEC USSP_HUMAN_DISEASE_VACCINATIONS_SET @idfHumanCase,@VaccinationsParameters;

				--set Contacts for this idfHumanCase
				--If @ContactsParameters is not null
				--EXEC USSP_HUMAN_DISEASE_CONTACT_SET @idfHumanCase,@ContactsParameters; 

				-- update tlbHuman IF datDateofDeath is provided.
				IF @datDateofDeath IS NOT NULL
					BEGIN
						UPDATE dbo.tlbHuman
						SET		datDateofDeath = @datDateofDeath
						WHERE idfHuman = @idfHuman
					END
		
		IF @@TRANCOUNT > 0 
			COMMIT
        
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfHumanCase 'idfHumanCase', @strHumanCaseID 'strHumanCaseID'

	END TRY
	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK;

				THROW;

	END CATCH
	
END

