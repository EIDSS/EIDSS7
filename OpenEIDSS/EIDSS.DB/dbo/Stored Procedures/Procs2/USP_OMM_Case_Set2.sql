
--*************************************************************
-- Name: [USP_OMM_Session_Set]
-- Description: Insert/Update for Outbreak Case
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Case_Set2]
(    
	@LangID										NVARCHAR(50), 
	@OutBreakCaseReportUID						BIGINT = -1,
	@idfOutbreak								BIGINT = NULL,
	@strOutbreakCaseID							NVARCHAR(200) = NULL,
	@idfHumanCase								BIGINT = NULL,
	@idfVetCase									BIGINT = NULL,
	@diseaseID									BIGINT = NULL,
	@OutbreakCaseObservationID					BIGINT = NULL,
	@CaseMonitoringObservationID				BIGINT = NULL,
	--Outbreak Case Details
	@OutbreakCaseClassificationID				BIGINT = NULL,
	@intRowStatus								INT = 0,
	@User										NVARCHAR(100) = NULL,
	@DTM										DATETIME = NULL,
	--Human Disease related items for creation
	@idfHumanActual								BIGINT = -1,
	@idfsDiagnosisOrDiagnosisGroup				BIGINT = -1,
	--Human Disease Notification
	@datNotificationDate						DATETIME = NULL,
	@idfSentByOffice							BIGINT = NULL,
	@strSentByFirstName							NVARCHAR(200) = NULL,
	@strSentByLastName							NVARCHAR(200) = NULL,
	@idfReceivedByOffice						BIGINT = NULL,
	@strReceivedByFirstName						NVARCHAR(200) = NULL,
	@strReceivedByLastName						NVARCHAR(200) = NULL,
	--Human Disease Location
	@idfsLocationCountry						BIGINT = NULL,
	@idfsLocationRegion							BIGINT = NULL,
	@idfsLocationRayon							BIGINT = NULL,
	@idfsLocationSettlement						BIGINT = NULL,
	@intLocationLatitude						FLOAT = NULL,
	@intLocationLongitude						FLOAT = NULL,
	@strStreet									NVARCHAR(200) = NULL,
	@strHouse									NVARCHAR(200) = NULL,
	@strBuilding								NVARCHAR(200) = NULL,
	@strApartment								NVARCHAR(200) = NULL,
	@strPostalCode								NVARCHAR(200) = NULL,
	--Human Disease Clinical Information
	@CaseStatusID								BIGINT = NULL,
	@datOnSetDate								DATETIME = NULL,
	@datFinalDiagnosisDate						DATETIME = NULL,
	@strHospitalizationPlace					NVARCHAR(200) = NULL,
	@datHospitalizationDate						DATETIME = NULL,
	@datDischargeDate							DATETIME = NULL,
	@strAntibioticName							NVARCHAR(200) = NULL,
	@strDosage									NVARCHAR(200) = NULL,
	@datFirstAdministeredDate					DATETIME = NULL,
	@vaccinations								NVARCHAR(MAX)= NULL,
	@strClinicalComments						NVARCHAR(500) = NULL,

	@idfsYNSpecIFicVaccinationAdministered		BIGINT = NULL,
	@StartDateofInvestigation					DATETIME = NULL,
	--Outbreak Investigation
	@idfInvestigatedByOffice					BIGINT = NULL,
	@idfInvestigatedByPerson					BIGINT = NULL,
	@datInvestigationStartDate					DATETIME = NULL,
	@IsPrimaryCaseFlag							NVARCHAR(1) = NULL,
	@strOutbreakInvestigationComments			NVARCHAR(500) = NULL,
	--Case Monitoring
	@datMonitoringDate							DATETIME = NULL,
	@CaseMonitoringAdditionalComments			NVARCHAR(500) = NULL,
	@CaseInvestigatorOrganziation				NVARCHAR(200) = NULL,
	@CaseInvestigatorName						NVARCHAR(200) = NULL,
	--Case Contacts
	@CaseContacts								NVARCHAR(MAX)= NULL,
	--Case Samples
	@CaseSamples								NVARCHAR(MAX)= NULL,
	@datAccessionDate							DATETIME = NULL,
	@SampleConditionReceived					NVARCHAR(200) = NULL,
	@VaccinationName							NVARCHAR(200) = NULL,
	@datDateOfVaccination						DATETIME
)
AS

BEGIN    

	DECLARE	@returnCode					INT = 0;
	DECLARE @returnMsg					NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @outbreakLocation			BIGINT = NULL

	BEGIN TRY

		if @User = '' OR @User IS NULL
			BEGIN
				--Used to get poco to push the following result set first so that the correct model can be produced for a real run of data.
				SELECT	@returnCode as returnCode, @returnMsg as returnMsg, @OutBreakCaseReportUID as OutBreakCaseReportUID
			END
		ELSE
			BEGIN
				Declare @SupressSelect table
				( retrunCode int,
				  returnMsg varchar(200)
				)

				IF EXISTS (SELECT * FROM OutbreakCaseReport WHERE OutBreakCaseReportUID = @OutBreakCaseReportUID)
					BEGIN
						UPDATE		OutbreakCaseReport
						SET 
									OutBreakCaseReportUID = @OutBreakCaseReportUID,
									idfOutbreak = @idfOutbreak,
									strOutbreakCaseID = @strOutbreakCaseID,
									idfHumanCase = @idfHumanCase,
									idfVetCase = @idfVetCase,
									OutbreakCaseObservationID = @OutbreakCaseObservationID,
									CaseMonitoringObservationID = @CaseMonitoringObservationID,
									OutbreakCaseStatusID = @CaseStatusID,
									OutbreakCaseClassificationID = @OutbreakCaseClassificationID,
									IsPrimaryCaseFlag = @IsPrimaryCaseFlag,
									intRowStatus = @intRowStatus,
									AuditUpdateUser = @User,
									AuditUpdateDTM = @DTM
						WHERE
									OutBreakCaseReportUID=@OutBreakCaseReportUID
					END
				ELSE
					BEGIN
						INSERT INTO @SupressSelect
						EXEC	dbo.USP_GBL_NEXTKEYID_GET 'OutbreakCaseReport', @OutBreakCaseReportUID OUTPUT;

						IF @idfHumanCase IS NOT NULL-- AND @idfHumanCase <> -1
							BEGIN
								--Check to make sure a record doesn't already exist for an import process
								--If not, create it (done for both import and create procedures)
								IF NOT EXISTS (
										SELECT 
												OutBreakCaseReportUID 
										FROM 
												OutbreakCaseReport 
										WHERE 
												idfOutbreak = @idfOutbreak AND 
												idfHumanCase = @idfHumanCase AND 
												intRowStatus = 0
									)
									BEGIN
										INSERT INTO @SupressSelect
										EXEC	dbo.USP_GBL_NextNumber_GET 'Human Outbreak Case', @strOutbreakCaseID OUTPUT , NULL;		
									END
								ELSE
									BEGIN

										SET @OutBreakCaseReportUID = -1
									END
							END
						ELSE IF @idfHumanActual IS NOT NULL
							BEGIN
								INSERT INTO @SupressSelect
								EXEC	dbo.USP_GBL_NextNumber_GET 'Human Outbreak Case', @strOutbreakCaseID OUTPUT , NULL;		

								EXEC	USP_OMM_HUMAN_DISEASE_SET
										@idfHumanCase OUTPUT,
										@idfHumanActual = @idfHumanActual,
										@idfsFinalDiagnosis = @idfsDiagnosisOrDiagnosisGroup,
										@strHospitalName = @strHospitalizationPlace,
										@datHospitalizationDate = @datHospitalizationDate,
										@datDischargeDate = @datDischargeDate,
										@strAntibioticName = @strAntibioticName,
										@strDosage = @strDosage,
										@datFirstAdministeredDate = @datFirstAdministeredDate,
										@strAntibioticComments = @strClinicalComments,
										@idfsYNSpecIFicVaccinationAdministered = @idfsYNSpecIFicVaccinationAdministered,
										@idfInvestigatedByOffice = @idfInvestigatedByOffice,
										@StartDateofInvestigation = @StartDateofInvestigation,
										@datNotificationDate = @datNotificationDate,
										@idfSentByOffice = @idfSentByOffice,
										@strSentByFirstName = @strSentByFirstName,
										@strSentByLastName = @strSentByLastName,
										@idfReceivedByOffice = @idfReceivedByOffice,
										@strReceivedByFirstName = @strReceivedByFirstName,
										@strReceivedByLastName = @strReceivedByLastName,
										@idfsLocationCountry = @idfsLocationCountry,
										@idfsLocationRegion = @idfsLocationRegion,
										@idfsLocationRayon = @idfsLocationRayon,
										@idfsLocationSettlement = @idfsLocationSettlement,
										@intLocationLatitude = @intLocationLatitude,
										@intLocationLongitude = @intLocationLongitude

										DECLARE		@idfContactCasePerson			BIGINT
										DECLARE		@ContactRelationshipTypeID		BIGINT
										DECLARE		@DateOfLastContact				DATETIME
										DECLARE		@PlaceOfLastContact				NVARCHAR(200)
										DECLARE		@ContactStatusID				BIGINT
										DECLARE		@DateOfLastContact2				VARCHAR(10)
										DECLARE		@idfsPersonContactType			BIGINT
										DECLARE		@idfHuman						BIGINT
										DECLARE		@idfContactedCasePerson			BIGINT
										DECLARE		@SQL							VARCHAR(MAX)

										DECLARE		@contacts TABLE (
													idfContactCasePerson			BIGINT,
													ContactType						NVARCHAR(200),
													ContactName						NVARCHAR(200) NULL,
													Relation						NVARCHAR(200) NULL,
													DateOfLastContact				DATETIME2 NULL,
													PlaceOfLastContact				NVARCHAR(200) NULL,
													ContactStatus					NVARCHAR(200) NULL,
													idfsPersonContactType			BIGINT,
													ContactRelationshipTypeID		BIGINT,
													ContactStatusID					BIGINT
										)

										INSERT INTO @contacts 
										SELECT 
											* 
										FROM OPENJSON(@CaseContacts) 
										WITH (
													idfContactCasePerson			BIGINT, 
													ContactType						NVARCHAR(200), 
													ContactName						NVARCHAR(200), 
													Relation						NVARCHAR(200), 
													DateOfLastContact				DATETIME2, 
													PlaceOfLastContact				NVARCHAR(200), 
													ContactStatus					NVARCHAR(200), 
													idfsPersonContactType			BIGINT, 
													ContactRelationshipTypeID		BIGINT, 
													ContactStatusID					BIGINT
										) 
									
										--Modifications to a Table Variable prevents Adding a column. Code was modified to produce this feild
										--Now we need to get a FK for each row and insert it one at a time so that the "Next Key" generation will be proper.
										WHILE (SELECT COUNT(idfContactCasePerson) FROM @contacts) > 0  
											BEGIN 
											    --Get the first row so that we can insert them one at a time
												SELECT	
														TOP 1 @idfContactCasePerson = idfContactCasePerson,
														@ContactRelationshipTypeID = ContactRelationshipTypeID,
														@DateOfLastContact = DateOfLastContact,
														@PlaceOfLastContact = PlaceOfLastContact,
														@ContactStatusID = ContactStatusID,
														@idfsPersonContactType = idfsPersonContactType

												FROM
														@contacts

												--In order to reuse remote module SP's, we need the idfHuman to create contacts.
												SELECT
														@idfHuman = idfHuman
												FROM
													tlbHumanCase
												WHERE
														idfHumanCase = @idfHumanCase

												--The Json blob needs DATETIME2, we have to convert this over to a string for the upcoming contact save
												SET @DateOfLastContact2 = RTRIM(LEFT(CONVERT(VARCHAR(10), @DateOfLastContact, 23), 10))

												--Generate the Human side of the contacted person
												INSERT INTO @SupressSelect
												EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbContactedCasePerson', @idfContactedCasePerson OUTPUT

												INSERT INTO [dbo].[tlbContactedCasePerson]
													   (
														   idfContactedCasePerson,
														   idfsPersonContactType,
														   idfHuman,
														   idfHumanCase,
														   datDateOfLastContact,
														   strPlaceInfo,
														   intRowStatus
													   )
												 VALUES
													   (
															@idfContactedCasePerson,
															@idfsPersonContactType ,
															@idfHuman ,
															@idfHumanCase,
															@DateOfLastContact2,
															@PlaceOfLastContact,
															0 
													   )
												
												IF @strOutbreakCaseID IS NOT NULL OR @strOutbreakCaseID <> ''
													BEGIN
														INSERT INTO	dbo.OutbreakCaseReport
														(
																OutBreakCaseReportUID,
																idfOutbreak,
																strOutbreakCaseID,
																idfHumanCase,
																idfVetCase,
																OutbreakCaseObservationID,
																CaseMonitoringObservationID,
																OutbreakCaseStatusID,
																OutbreakCaseClassificationID,
																IsPrimaryCaseFlag,
																intRowStatus,
																AuditCreateUser,
																AuditCreateDTM,
																AuditUpdateUser,
																AuditUpdateDTM
														)
														VALUES
														(
																@OutBreakCaseReportUID,
																@idfOutbreak,
																@strOutbreakCaseID,
																@idfHumanCase,
																@idfVetCase,
																@OutbreakCaseObservationID,
																@CaseMonitoringObservationID,
																@CaseStatusID,
																@OutbreakCaseClassificationID,
																@IsPrimaryCaseFlag,
																COALESCE(@intRowStatus,0),
																@User,
																@DTM,
																@User,
																@DTM
														)

														--Update the tblHumanCase with the Outbreak Id related by the import process.
														UPDATE	
																	tlbHumanCase
														SET		
																	idfOutbreak = @idfOutbreak
														WHERE	
																	idfHumanCase = @idfHumanCase
							
													END

												--Generate the Outbreak side of the contacted person
												SET @SQL = 'EXEC	USP_OMM_Contact_Set
														@LangID = ''' + @LangID  + ''' ,
														@OutbreakCaseContactUID = -1,
														@OutBreakCaseReportUID = ' + CAST(@OutBreakCaseReportUID AS NVARCHAR(MAX)) + ',
														@ContactRelationshipTypeID = ' + CAST(@ContactRelationshipTypeID AS NVARCHAR(MAX)) + ', 
														@DateOfLastContact = ''' + @DateOfLastContact2 + ''',
														@contactLocationidfsCountry = NULL,
														@contactLocationidfsRegion = NULL,
														@contactLocationidfsRayon = NULL,
														@contactLocationidfsSettlement = NULL,
														@strStreetName = NULL,
														@strPostCode = NULL,
														@strBuilding = NULL,
														@strHouse = NULL,
														@strApartment = NULL,
														@strAddressString = NULL,
														@Phone = NULL,
														@PlaceOfLastContact = ''' + @PlaceOfLastContact + ''',
														@CommentText = NULL,
														@ContactStatusID = ' + CAST(@ContactStatusID AS NVARCHAR(MAX)) + ',
														@intRowStatus = 0,
														@AuditUser = ''' + CAST(@User AS NVARCHAR(MAX)) + ''',
														@AuditDTM = ''' + CONVERT(VARCHAR(50), @DTM, 23) + ''',
														@FunctionCall = 1'
					
												EXEC (@SQL)

												--Delete the Species type that we have been working with so that the loop will decrement and fall out when 0.
												DELETE FROM 
														@contacts
												WHERE
														idfContactCasePerson = @idfContactCasePerson
											END  
							END
					
						IF @idfVetCase IS NOT NULL
							BEGIN
								IF NOT EXISTS (
										SELECT
												OutBreakCaseReportUID 
										FROM 
												OutbreakCaseReport 
										WHERE 
												idfOutbreak = @idfOutbreak AND 
												idfVetCase = @idfVetCase AND 
												intRowStatus = 0
										)
									BEGIN
										INSERT INTO @SupressSelect
										EXEC	dbo.USP_GBL_NextNumber_GET 'Vet Outbreak Case', @strOutbreakCaseID OUTPUT , NULL; 
									END
								ELSE
									BEGIN
										SET @OutBreakCaseReportUID = -1
									END
							END


				END
			END
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		throw;
	END CATCH
	
	--SELECT	COALESCE(@returnCode,0) as returnCode, COALESCE(@returnMsg,0) as returnMsg, COALESCE(@OutBreakCaseReportUID,0) as OutBreakCaseReportUID
	SELECT	@returnCode as returnCode, @returnMsg as returnMsg, @OutBreakCaseReportUID as OutBreakCaseReportUID

END