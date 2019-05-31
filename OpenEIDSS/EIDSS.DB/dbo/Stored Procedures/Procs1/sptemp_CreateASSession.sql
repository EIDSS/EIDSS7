
--##SUMMARY Procedure produces a set of ASSessions with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 21.05.2014


--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateASSession 
	@ASSessionCnt = 3
	, @InfoCnt = 2
	, @my_SiteID = 1100
	, @StartDate = '2015-01-01 12:00:00:00'
	, @DateRange = 100
*/

CREATE PROC [dbo].[sptemp_CreateASSession](
	@ASSessionCnt INT,					--##PARAM @ASSessionCnt - the number of ASSession to generate
	@InfoCnt INT,						--##PARAM @InfoCnt - the number of info to generate for each ASSession	
	@my_SiteID INT,						--##PARAM @TestCnt - the number of tests to generate
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	@Region BIGINT = NULL,				--##PARAM @Region - region of the ASSession
	@Rayon BIGINT = NULL,				--##PARAM @Rayon - rayon of the ASSession
	@CampaignId BIGINT = NULL,
	@CampaignStartDate DATETIME = NULL,
	@CampaignEndDate DATETIME = NULL,
	@LastName NVARCHAR(255) = NULL,		--##PARAM @LastName - lastname of the owner
	@FirstName NVARCHAR(255) = NULL,	--##PARAM @FirstName - first name of the owner
	@SpeciesTypeId BIGINT = NULL,
	@SampleTypeId BIGINT = NULL,
	@DiagnosisId BIGINT = NULL
)
AS
	
SET NOCOUNT ON;


DECLARE @LocalSite BIGINT
	, @LocalCountry BIGINT
	, @LocalOffice BIGINT
	, @LocalCustomizationPackage BIGINT
	
SET @LocalSite=@my_SiteID
SELECT 
	@LocalCountry = tcpac.idfsCountry
	, @LocalOffice = ts.idfOffice
	, @LocalCustomizationPackage = tcpac.idfCustomizationPackage
FROM tstSite ts 
JOIN tstCustomizationPackage tcpac ON
	tcpac.idfCustomizationPackage = ts.idfCustomizationPackage
WHERE ts.idfsSite = @LocalSite


DECLARE @ContextString NVARCHAR(36) = NEWID()
------------------------------------------------------
EXEC dbo.spSetContext @ContextString=@ContextString

DECLARE @user BIGINT = 0
DECLARE @person BIGINT = 0
SELECT 
	@user = tut.idfUserID
	, @person = tut.idfPerson 
FROM tstUserTable tut 
WHERE tut.strAccountName = ISNULL(@LocalUserName, 'test_admin')

IF @user = 0 
BEGIN
	RAISERROR ('No account required', 1, 1)
	RETURN
END

IF NOT EXISTS (SELECT * FROM tstLocalConnectionContext tlcc WHERE tlcc.strConnectionContext = @ContextString)
INSERT INTO tstLocalConnectionContext
(strConnectionContext,idfUserID,idfDataAuditEvent,idfEventID, binChallenge,idfsSite,datLastUsed)
VALUES
(@ContextString, @user, NULL, NULL, CAST('0xD804D8AE0F9F1A43B8F211C803334555' AS VARBINARY), @LocalSite, GETDATE())
----------------------------------------------------
	
	
	
DECLARE @RandomDate as DATETIME
	, @EndDate DATETIME
	, @CollectionDate DATETIME
DECLARE @idfsRegion BIGINT
	, @idfsRayon BIGINT
	, @idfsSettlement BIGINT


DECLARE @ses INT = 0

WHILE @ses < @ASSessionCnt
BEGIN
	SET @ses = @ses + 1
	
	IF @CampaignStartDate IS NULL 
		SET @RandomDate=DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)
	ELSE
	BEGIN 
		DECLARE @RandomStartDay INT = (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) x ORDER BY NEWID())
		SET @RandomDate = DATEADD(DAY, @RandomStartDay, @CampaignStartDate)
	END
	
	SELECT TOP 1 
		@idfsRegion = ISNULL(@Region, gr.idfsRegion)
	FROM gisRegion gr
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRegion
	WHERE gr.idfsCountry = @LocalCountry
	ORDER BY NEWID()

	SELECT TOP 1 
		@idfsRayon = ISNULL(@Rayon, gr.idfsRayon)
	FROM gisRayon gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRayon
	WHERE gr.idfsCountry = @LocalCountry 
		AND gr.idfsRegion = @idfsRegion 
	ORDER BY NEWID()

	SELECT TOP 1 
		@idfsSettlement = gr.idfsSettlement 
	FROM gisSettlement gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsSettlement
	WHERE gr.idfsCountry = @LocalCountry 
		AND gr.idfsRegion = @idfsRegion 
		AND gr.idfsRayon = @idfsRayon
	ORDER BY NEWID()
	
	
	SET @EndDate = NULL
	DECLARE @Status BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000117 AND intRowStatus = 0 ORDER BY NEWID())
	IF @Status = 10160001/*Closed*/
	BEGIN
		IF @CampaignEndDate IS NULL
			SET @EndDate = DATEADD(DAY, 10, @RandomDate)
		BEGIN 
			DECLARE @RandomEndDay INT = (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) x ORDER BY NEWID())
			SET @EndDate = DATEADD(DAY, @RandomEndDay * -1, @CampaignEndDate)
		END
	END	
	
	DECLARE @idfMonitoringSession BIGINT
	EXEC spsysGetNewID @ID=@idfMonitoringSession OUTPUT		
	DECLARE @strMonitoringSessionID NVARCHAR(50) = NULL		
	EXEC spASSession_Post 
		@Action=4
		,@idfMonitoringSession=@idfMonitoringSession OUTPUT
		,@idfsMonitoringSessionStatus=@Status
		,@idfsCountry=@LocalCountry
		,@idfsRegion=@idfsRegion
		,@idfsRayon=@idfsRayon
		,@idfsSettlement=@idfsSettlement
		,@idfPersonEnteredBy=@person
		,@idfCampaign=@CampaignId
		,@idfsSite=@LocalSite
		,@datEnteredDate=@RandomDate
		,@datStartDate=@RandomDate
		,@datEndDate=@EndDate
		,@strMonitoringSessionID=@strMonitoringSessionID OUTPUT
		
	DECLARE @Diagnosis BIGINT
	SELECT TOP 1 
		@Diagnosis = ISNULL(@DiagnosisId, td.idfsDiagnosis)
	FROM trtDiagnosis td 
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = td.idfsDiagnosis
		AND tbr.intHACode & 32 = 32
	WHERE td.idfsUsingType = 10020001 
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
			OR EXISTS (SELECT * FROM trtMaterialForDisease tmfd WHERE tmfd.idfsDiagnosis = td.idfsDiagnosis AND tmfd.intRowStatus = 0))
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
			OR EXISTS (SELECT * FROM trtTestForDisease ttfd WHERE ttfd.idfsDiagnosis = td.idfsDiagnosis AND ttfd.intRowStatus = 0))
		AND EXISTS (SELECT * FROM trtSampleType tst JOIN trtBaseReference tbr2 ON tbr2.idfsBaseReference = tst.idfsSampleType AND tbr2.intHACode & 32 = 32 JOIN trtMaterialForDisease tmfd ON tmfd.idfsSampleType = tst.idfsSampleType AND tmfd.idfsDiagnosis = td.idfsDiagnosis)
	ORDER BY NEWID()
		
	DECLARE @MonitoringSessionToDiagnosisId BIGINT
	EXEC spsysGetNewID @ID=@MonitoringSessionToDiagnosisId OUTPUT	
	EXEC spASSessionDiagnosis_Post 
		@Action=4
		,@idfMonitoringSessionToDiagnosis=@MonitoringSessionToDiagnosisId OUTPUT
		,@idfMonitoringSession=@idfMonitoringSession
		,@idfsDiagnosis=@Diagnosis
		,@idfsSpeciesType=NULL
		,@intOrder=0
		,@idfsSampleType=NULL
	
	DECLARE @DICnt INT = @InfoCnt / 2
	
	DECLARE @di INT = 0
	WHILE @di < @DICnt
	BEGIN
		SET @di = @di + 1
		
		----FarmAddress BEGIN----
		DECLARE @FarmAddress BIGINT
		EXEC spsysGetNewID @ID=@FarmAddress OUTPUT

		EXEC spAddress_Post 
			@idfGeoLocation=@FarmAddress
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
			,@idfsRayon=@idfsRayon
			,@idfsSettlement=@idfsSettlement
			,@strApartment=N''
			,@strBuilding=N''
			,@strStreetName=N''
			,@strHouse=N''
			,@strPostCode=NULL
			,@blnForeignAddress=0
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=0
		----FarmAddress END----		
		
		
		----Farm BEGIN----
		DECLARE @FarmId BIGINT
		EXEC spsysGetNewID @ID=@FarmId OUTPUT
		
		DECLARE @OwnerId BIGINT
		EXEC spsysGetNewID @ID=@OwnerId OUTPUT

		DECLARE @RootFarmId BIGINT		
		DECLARE @FarmCode NVARCHAR(200) = NULL
		DECLARE @RootOwnerId BIGINT
		
		DECLARE @ContactPhone NVARCHAR(255)
		SELECT @ContactPhone = CAST(RAND(CAST(NEWID() AS VARBINARY))*10000000000 AS BIGINT)
		
		DECLARE @OwnerLastName NVARCHAR(255)
		DECLARE @OwnerFirstName NVARCHAR(255)
		SET @OwnerLastName = ISNULL(@LastName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))
		SET @OwnerFirstName =  ISNULL(@FirstName, (
							SELECT TOP 1 
								[NAME]
							FROM (
									SELECT 'Jacob' AS [NAME] UNION ALL
									SELECT 'Ethan' UNION ALL
									SELECT 'Michael' UNION ALL
									SELECT 'Alexander' UNION ALL
									SELECT 'William' UNION ALL
									SELECT 'Joshua' UNION ALL
									SELECT 'Daniel' UNION ALL
									SELECT 'Jayden' UNION ALL
									SELECT 'Noah' UNION ALL
									SELECT 'Anthony'
								) x
							ORDER BY NEWID()
						))
		
		DECLARE @FarmName NVARCHAR(255) = ISNULL(@OwnerLastName + ' ' + @OwnerFirstName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))
		
		EXEC spFarmPanel_Post 
			@Action=4
			,@idfFarm=@FarmId
			,@idfRootFarm=@RootFarmId OUTPUT
			,@idfCase=NULL
			,@idfMonitoringSession=@idfMonitoringSession
			,@strContactPhone=@ContactPhone
			,@strInternationalName=@FarmName
			,@strNationalName=@FarmName
			,@strFarmCode=@FarmCode OUTPUT
			,@strFax=NULL
			,@strEmail=NULL
			,@idfFarmAddress=@FarmAddress
			,@idfOwner=@OwnerId
			,@idfRootOwner=@RootOwnerId OUTPUT
			,@strOwnerLastName=@OwnerLastName
			,@strOwnerFirstName=@OwnerFirstName
			,@strOwnerMiddleName=NULL
			,@idfsOwnershipStructure=NULL
			,@idfsLivestockProductionType=NULL
			,@idfsGrazingPattern=NULL
			,@idfsMovementPattern=NULL
			,@idfsAvianFarmType=NULL
			,@idfsAvianProductionType=NULL
			,@idfsIntendedUse=NULL
			,@intBirdsPerBuilding=NULL
			,@intBuidings=NULL
			,@blnRootFarm=0
			,@intHACode=32/*Livestock*/
		----Farm END----
		
		
		--Herds and Species
		DECLARE @h INT = 0	
		DECLARE @TotalFarmAnimalQty INT = 0
			--, @DeadFarmAnimalQty INT = 0
			--, @SickFarmAnimalQty INT = 0
		
		DECLARE @HerdCnt INT
		SET @HerdCnt = 2/*ISNULL(@HerdCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))*/

		WHILE @h < @HerdCnt
		BEGIN
			SET @h = @h + 1
		
			DECLARE @HerdId BIGINT 
			EXEC spsysGetNewID @ID=@HerdId OUTPUT
			
			DECLARE @TotalAnimalQty INT
			SELECT TOP 1
				@TotalAnimalQty = rn
			FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
			) x
			WHERE rn BETWEEN 5 AND 40
			ORDER BY NEWID()
			
			--DECLARE @DeadAnimalQty INT = (SELECT TOP 1 a FROM(SELECT 0 a UNION ALL SELECT 1) x ORDER BY NEWID())
			--DECLARE @SickAnimalQty INT = CAST(@TotalAnimalQty / 100.0 * 40 AS INT)
			
			SET @TotalFarmAnimalQty += @TotalAnimalQty
			--SET @SickFarmAnimalQty += @SickAnimalQty
			--SET @DeadFarmAnimalQty += @DeadAnimalQty

			DECLARE @p106 NVARCHAR(200) = NULL
			EXEC spVetFarmTree_Post 
				@Action=4
				,@idfCase=NULL
				,@idfMonitoringSession= @idfMonitoringSession
				,@idfParty=@HerdId
				,@idfsPartyType=10072003 /*Herd*/
				,@strName=@p106 OUTPUT
				,@idfParentParty=@FarmId
				,@idfObservation=NULL
				,@idfsFormTemplate=NULL
				,@intTotalAnimalQty=@TotalAnimalQty
				,@intSickAnimalQty=NULL
				,@intDeadAnimalQty=NULL
				,@strAverageAge=NULL
				,@datStartOfSignsDate=NULL
				,@strNote=NULL
				,@idfsCaseType = NULL
				
			
			DECLARE @SpeciesId BIGINT 
			EXEC spsysGetNewID @ID=@SpeciesId OUTPUT 

			/*DECLARE @p11 BIGINT 
			EXEC spsysGetNewID @ID=@p11 OUTPUT*/
			
			DECLARE @SpeciesType BIGINT
		
			SELECT TOP 1 
				@SpeciesType = ISNULL(@SpeciesTypeId, tbr.idfsBaseReference)
			FROM trtBaseReference tbr 
			WHERE tbr.idfsReferenceType = 19000086 /*SpeciesType*/
				AND tbr.intRowStatus = 0
				AND tbr.intHACode & 32 = 32
				AND EXISTS (SELECT * FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = ISNULL(@SpeciesTypeId, tbr.idfsBaseReference) AND intRowStatus = 0)
			ORDER BY NEWID()
			
			/*DECLARE @SpeciesFormTemplateId BIGINT
			EXEC dbo.spFFGetActualTemplate 
				@idfsGISBaseReference=@LocalCountry
				,@idfsBaseReference=-1
				,@idfsFormType=10034016 /*Livestock Species CS*/
				,@blnReturnTable = 0
				,@idfsFormTemplateActual=@SpeciesFormTemplateId OUTPUT*/
			
			EXEC spVetFarmTree_Post 
				@Action=4
				,@idfCase=NULL
				,@idfMonitoringSession=@idfMonitoringSession
				,@idfParty=@SpeciesId
				,@idfsPartyType=10072004 /*Species*/
				,@strName=@SpeciesType OUTPUT
				,@idfParentParty=@HerdId
				,@idfObservation=NULL
				,@idfsFormTemplate=NULL
				,@intTotalAnimalQty=@TotalAnimalQty
				,@intSickAnimalQty=NULL
				,@intDeadAnimalQty=NULL
				,@strAverageAge=NULL
				,@datStartOfSignsDate=NULL
				,@strNote=NULL
				,@idfsCaseType = NULL
				
			
			DECLARE @a INT = 0
			DECLARE @AnimalCnt INT	
			SET @AnimalCnt = 3/*ISNULL(@AnimalCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))*/

			WHILE @a < @AnimalCnt
			BEGIN
				SET @a = @a + 1
				
				DECLARE @AnimalId BIGINT
				EXEC spsysGetNewID @ID=@AnimalId OUTPUT

				/*DECLARE @AnimalObservationId BIGINT
				EXEC spsysGetNewID @ID=@AnimalObservationId OUTPUT*/

				DECLARE @AnimalCode NVARCHAR(200) = NULL
				DECLARE @AnimalAge BIGINT
				
				SELECT TOP 1 
					@AnimalAge = tbr.idfsBaseReference
				FROM trtBaseReference tbr 
				WHERE tbr.idfsReferenceType = 19000005--AnimalAge
					AND tbr.intHACode & 32 = 32
					AND tbr.intRowStatus = 0
					AND EXISTS (SELECT * FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = @SpeciesType AND idfsAnimalAge = tbr.idfsBaseReference AND intRowStatus = 0)
				ORDER BY NEWID()
				
				/*DECLARE @AnimalFormTemplateId BIGINT
				EXEC dbo.spFFGetActualTemplate 
					@idfsGISBaseReference=@LocalCountry
					,@idfsBaseReference=-1
					,@idfsFormType=10034013 /*Livestock Animal CS*/
					,@blnReturnTable = 0
					,@idfsFormTemplateActual=@AnimalFormTemplateId OUTPUT*/
				
				EXEC spVetCaseAnimals_Post 
					@Action=4
					,@idfAnimal=@AnimalId
					,@idfHerd=@HerdId
					,@idfsAnimalAge=@AnimalAge
					,@idfsAnimalGender=10007001 /*Female*/
					,@strAnimalCode=@AnimalCode OUTPUT
					,@strDescription=NULL
					,@idfsAnimalCondition=NULL
					,@idfSpecies=@SpeciesId
					,@idfObservation=NULL
					,@idfsFormTemplate=NULL
					,@idfCase=NULL
					
					
					
					
				----Samples BEGIN----
				DECLARE @s INT = 0
				
				DECLARE @SampleCnt INT
				SET @SampleCnt = 1/*ISNULL(@SampleCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))*/

				WHILE @s < @SampleCnt
				BEGIN
					SET @s = @s + 1
					
					DECLARE @SampleFieldBarCode NVARCHAR(8) = LEFT(NEWID(), 8)
					
					/*SELECT TOP 1 
						@DiagnosisId = ISNULL(@DiagnosisId, td.idfsDiagnosis)
					FROM trtDiagnosis td 
					JOIN trtBaseReference tbr ON
						tbr.idfsBaseReference = td.idfsDiagnosis
						AND tbr.intHACode & 32 = 32
					WHERE td.idfsUsingType = 10020001 
					ORDER BY NEWID()*/	
					
					DECLARE @SampleType BIGINT
					SELECT TOP 1 
						@SampleType = ISNULL(@SampleTypeId, tst.idfsSampleType)
					FROM trtSampleType tst
					JOIN trtBaseReference tbr ON
						tbr.idfsBaseReference = tst.idfsSampleType
						AND tbr.intHACode & 32 = 32
					WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
							OR EXISTS (SELECT * FROM trtMaterialForDisease WHERE idfsSampleType = tst.idfsSampleType AND intRowStatus = 0 AND idfsDiagnosis = @Diagnosis))
					ORDER BY NEWID()
					
					DECLARE @FieldCollectionDate DATETIME = DATEADD(DAY, 2, @RandomDate)
					
					DECLARE @p113 BIGINT
					EXEC spLabSample_Create 
						@idfMaterial=@p113 OUTPUT
						,@strFieldBarcode=@SampleFieldBarCode
						,@idfsSampleType=@SampleType
						,@idfParty= @AnimalId
						,@idfCase=NULL
						,@idfMonitoringSession= @idfMonitoringSession
						,@idfVectorSurveillanceSession=NULL
						,@datFieldCollectionDate=@FieldCollectionDate
						,@datFieldSentDate=@FieldCollectionDate
						,@idfFieldCollectedByOffice=NULL
						,@idfFieldCollectedByPerson=NULL
						,@idfMainTest=NULL
						,@idfSendToOffice=@LocalOffice
						,@idfsBirdStatus=NULL
						
							
					DECLARE @strBarcode NVARCHAR(200) = NULL
					EXEC spGetNextNumber 
						@NextNumberName=10057020 /*Sample/Aliquot/Derivative*/
						,@NextNumberValue=@strBarcode OUTPUT
						,@InstallationSite=NULL

					EXEC spLabSampleReceive_PostDetail 
						@idfMaterial=@p113
						,@strBarcode=@strBarcode
						,@datAccession=@FieldCollectionDate
						,@idfDepartment=NULL
						,@strCondition=NULL
						,@idfsAccessionCondition=10108001 /*Accepted in Good Condition*/
						,@strNote=NULL
						,@idfSubdivision=NULL
						,@idfAccesionByPerson=@person

					----Test BEGIN	
					DECLARE @t INT = 0
					DECLARE @TestCnt INT
					SET @TestCnt = 1/*ISNULL(@TestCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))*/

					WHILE @t < @TestCnt
					BEGIN
						SET @t = @t + 1
						
						DECLARE @TestNameId BIGINT
						SELECT TOP 1 
							@TestNameId = idfsBaseReference
						FROM trtBaseReference tbr
						WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
								OR EXISTS (SELECT * FROM trtTestForDisease WHERE idfsTestName = tbr.idfsBaseReference AND intRowStatus = 0 AND idfsDiagnosis = @Diagnosis))
							AND idfsReferenceType = 19000097
							AND intHACode & 32 = 32
						ORDER BY NEWID()
						
						IF ISNULL(@TestNameId, '') <> ''
						BEGIN					
							DECLARE @TestStatus BIGINT				
							SELECT TOP 1
								@TestStatus = tbr.idfsBaseReference
							FROM trtBaseReference tbr
							WHERE tbr.idfsReferenceType = 19000001
								AND tbr.intRowStatus = 0
								AND tbr.strDefault IN ('Final', 'In progress', 'Preliminary', 'Not Started')
							ORDER BY NEWID()
											
							DECLARE @TestCategory BIGINT
							SELECT TOP 1 
								@TestCategory = tbr.idfsBaseReference
							FROM trtBaseReference tbr
							WHERE tbr.idfsReferenceType = 19000095
								AND tbr.intRowStatus = 0
								
							DECLARE @TestFormTemplate BIGINT 
							EXEC dbo.spFFGetActualTemplate 
								@idfsGISBaseReference= @LocalCountry
								,@idfsBaseReference=@TestNameId
								,@idfsFormType=10034018 /*Test Details*/
								,@idfsFormTemplateActual=@TestFormTemplate OUTPUT
								,@blnReturnTable=0
							
							DECLARE @Testing BIGINT
							EXEC spsysGetNewID @ID=@Testing OUTPUT

							DECLARE @Observation BIGINT
							EXEC spsysGetNewID @ID=@Observation OUTPUT
								
							DECLARE @StartedDate DATETIME = CASE 
																WHEN @TestStatus IN (10001001 /*Final*/, 10001004 /*Preliminary*/) 
																	THEN DATEADD(DAY, 1, @FieldCollectionDate) 
																ELSE NULL 
															END

							DECLARE @TestResult BIGINT
							SET @TestResult = NULL
							IF EXISTS (SELECT * FROM trtBaseReference WHERE idfsBaseReference = @TestStatus AND strDefault IN ('Amended', 'Final', 'Preliminary'))
							BEGIN																
								SELECT TOP 1
									@TestResult = idfsBaseReference
								FROM trtBaseReference 
								WHERE idfsReferenceType = 19000096 /*Test Result*/
									AND intRowStatus = 0
								ORDER BY NEWID()
							END

							EXEC spLabSample_TestsPost 
								@Action=4
								,@idfTesting=@Testing
								,@idfsTestStatus=@TestStatus
								,@idfsTestName=@TestNameId
								,@idfsTestResult=@TestResult
								,@idfsTestCategory=@TestCategory
								,@idfsDiagnosis=@Diagnosis
								,@idfMaterial=@p113
								,@idfObservation=@Observation
								,@strNote=NULL
								,@datStartedDate=@StartedDate
								,@datConcludedDate=@StartedDate
								,@idfTestedByOffice=@LocalOffice
								,@idfTestedByPerson=@person
								,@idfResultEnteredByOffice=NULL
								,@idfResultEnteredByPerson=NULL
								,@idfValidatedByOffice=NULL
								,@idfValidatedByPerson=NULL
								,@idfsFormTemplate=@TestFormTemplate
								,@blnNonLaboratoryTest=0
								,@blnExternalTest=0
								,@datReceivedDate=NULL
								,@strContactPerson=NULL
								,@idfPerformedByOffice=NULL								
							
							IF @TestStatus = 10001001 /*Final*/
							BEGIN 
								DECLARE @TestValidationId BIGINT
								EXEC spsysGetNewID @ID = @TestValidationId OUTPUT
								
								DECLARE @InterpretedStatus BIGINT = (
																		SELECT TOP 1
																			tbr.idfsBaseReference															
																		FROM trtBaseReference tbr
																		WHERE tbr.idfsReferenceType = 19000106
																			AND tbr.intRowStatus = 0
																		ORDER BY NEWID()
																	)
								
								EXEC spCaseTestsValidation_Update 
									@idfTestValidation=@TestValidationId
									,@idfTesting=@Testing
									,@idfsDiagnosis= @Diagnosis
									,@idfsInterpretedStatus=@InterpretedStatus
									,@idfInterpretedByPerson= @person
									,@datInterpretationDate=@StartedDate
									,@strInterpretedComment=NULL
									,@blnValidateStatus=1
									,@idfValidatedByPerson=@person
									,@datValidationDate=@StartedDate
									,@strValidateComment=NULL
							END
						END
					END
					----Test END
				END
		----Samples END----	
					
					
					
			END
		END
		
		/*DECLARE @FarmObservationId BIGINT 
		EXEC spsysGetNewID @ID=@FarmObservationId OUTPUT
		
		DECLARE @FarmFormTemplateId BIGINT
		EXEC dbo.spFFGetActualTemplate 
			@idfsGISBaseReference=@LocalCountry
			,@idfsBaseReference=-1
			,@idfsFormType=10034015 /*Livestock Farm EPI*/
			,@blnReturnTable = 0
			,@idfsFormTemplateActual=@FarmFormTemplateId OUTPUT*/

		DECLARE @p105 NVARCHAR(200)
		EXEC spVetFarmTree_Post 
			@Action=4
			,@idfCase=NULL
			,@idfMonitoringSession= @idfMonitoringSession
			,@idfParty= @FarmId
			,@idfsPartyType=10072005 /*Farm*/
			,@strName=@p105 OUTPUT
			,@idfParentParty=NULL
			,@idfObservation=NULL
			,@idfsFormTemplate=NULL
			,@intTotalAnimalQty=@TotalFarmAnimalQty
			,@intSickAnimalQty=NULL
			,@intDeadAnimalQty=NULL
			,@strAverageAge=NULL
			,@datStartOfSignsDate=NULL
			,@strNote=NULL
			,@idfsCaseType = NULL

		--DECLARE @OwnershipStructure BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000065 AND intRowStatus = 0)
		EXEC spLivestockFarmProduction_Post 
			@idfFarm=@FarmId
			,@idfRootFarm= @RootFarmId
			,@idfsOwnershipStructure=NULL/*@OwnershipStructure*/
			,@idfsLivestockProductionType=NULL
			,@idfsGrazingPattern=NULL
			,@idfsMovementPattern=NULL				
	END
	
	
	
	
	
	
	DECLARE @SICnt INT = @InfoCnt - @DICnt
	
	DECLARE @si INT = 0
	WHILE @si < @SICnt
	BEGIN
		SET @si = @si + 1
		
		----FarmAddress BEGIN----
		DECLARE @SummaryFarmAddress BIGINT
		EXEC spsysGetNewID @ID=@SummaryFarmAddress OUTPUT

		EXEC spAddress_Post 
			@idfGeoLocation=@SummaryFarmAddress
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
			,@idfsRayon=@idfsRayon
			,@idfsSettlement=@idfsSettlement
			,@strApartment=N''
			,@strBuilding=N''
			,@strStreetName=N''
			,@strHouse=N''
			,@strPostCode=NULL
			,@blnForeignAddress=0
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=0
		----FarmAddress END----		
		
		
		----Farm BEGIN----
		DECLARE @SummaryFarmId BIGINT
		EXEC spsysGetNewID @ID=@SummaryFarmId OUTPUT
		
		DECLARE @SummaryOwnerId BIGINT
		EXEC spsysGetNewID @ID=@SummaryOwnerId OUTPUT

		DECLARE @SummaryRootFarmId BIGINT		
		DECLARE @SummaryFarmCode NVARCHAR(200) = NULL		
		DECLARE @SummaryRootOwnerId BIGINT
		
		DECLARE @SummaryContactPhone NVARCHAR(255)
		SELECT @SummaryContactPhone = CAST(RAND(CAST(NEWID() AS VARBINARY))*10000000000 AS BIGINT)
		
		DECLARE @SummaryOwnerLastName NVARCHAR(255)
		DECLARE @SummaryOwnerFirstName NVARCHAR(255)
		SET @SummaryOwnerLastName = ISNULL(@LastName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))
		SET @SummaryOwnerFirstName =  ISNULL(@FirstName, (
							SELECT TOP 1 
								[NAME]
							FROM (
									SELECT 'Jacob' AS [NAME] UNION ALL
									SELECT 'Ethan' UNION ALL
									SELECT 'Michael' UNION ALL
									SELECT 'Alexander' UNION ALL
									SELECT 'William' UNION ALL
									SELECT 'Joshua' UNION ALL
									SELECT 'Daniel' UNION ALL
									SELECT 'Jayden' UNION ALL
									SELECT 'Noah' UNION ALL
									SELECT 'Anthony'
								) x
							ORDER BY NEWID()
						))
		
		DECLARE @SummaryFarmName NVARCHAR(255) = ISNULL(@SummaryOwnerLastName + ' ' + @SummaryOwnerFirstName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))
		
		EXEC spFarmPanel_Post 
			@Action=4
			,@idfFarm=@SummaryFarmId
			,@idfRootFarm=@SummaryRootFarmId OUTPUT
			,@idfCase=NULL
			,@idfMonitoringSession= @idfMonitoringSession
			,@strContactPhone=@SummaryContactPhone
			,@strInternationalName=@SummaryFarmName
			,@strNationalName=@SummaryFarmName
			,@strFarmCode=@SummaryFarmCode OUTPUT
			,@strFax=NULL
			,@strEmail=NULL
			,@idfFarmAddress=@SummaryFarmAddress
			,@idfOwner=@SummaryOwnerId
			,@idfRootOwner=@SummaryRootOwnerId OUTPUT
			,@strOwnerLastName=@SummaryOwnerLastName
			,@strOwnerFirstName=@SummaryOwnerFirstName
			,@strOwnerMiddleName=NULL
			,@idfsOwnershipStructure=NULL
			,@idfsLivestockProductionType=NULL
			,@idfsGrazingPattern=NULL
			,@idfsMovementPattern=NULL
			,@idfsAvianFarmType=NULL
			,@idfsAvianProductionType=NULL
			,@idfsIntendedUse=NULL
			,@intBirdsPerBuilding=NULL
			,@intBuidings=NULL
			,@blnRootFarm=0
			,@intHACode=32/*Livestock*/
		----Farm END----
		
		
		--Herds and Species
		DECLARE @SummaryTotalFarmAnimalQty INT = 0
		
		DECLARE @SummaryHerdId BIGINT 
		EXEC spsysGetNewID @ID=@SummaryHerdId OUTPUT
		
		DECLARE @SummaryTotalAnimalQty INT
		SELECT TOP 1
			@SummaryTotalAnimalQty = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn BETWEEN 5 AND 40
		ORDER BY NEWID()
		
		SET @SummaryTotalFarmAnimalQty += @SummaryTotalAnimalQty

		DECLARE @SummaryHerdName NVARCHAR(200)
		EXEC spVetFarmTree_Post 
			@Action=4
			,@idfCase=NULL
			,@idfMonitoringSession= NULL
			,@idfParty=@SummaryHerdId
			,@idfsPartyType=10072003 /*Herd*/
			,@strName=@SummaryHerdName OUTPUT
			,@idfParentParty=@SummaryFarmId
			,@idfObservation=NULL
			,@idfsFormTemplate=NULL
			,@intTotalAnimalQty=@SummaryTotalAnimalQty
			,@intSickAnimalQty=NULL
			,@intDeadAnimalQty=NULL
			,@strAverageAge=NULL
			,@datStartOfSignsDate=NULL
			,@strNote=NULL
			,@idfsCaseType = NULL
			
		
		DECLARE @SummarySpeciesId BIGINT 
		EXEC spsysGetNewID @ID=@SummarySpeciesId OUTPUT 

		SELECT TOP 1 
			@SpeciesType = ISNULL(@SpeciesTypeId, tbr.idfsBaseReference)
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000086 /*SpeciesType*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode & 32 = 32
			AND EXISTS (SELECT * FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = ISNULL(@SpeciesTypeId, tbr.idfsBaseReference) AND intRowStatus = 0)
		ORDER BY NEWID()
		
		EXEC spVetFarmTree_Post 
			@Action=4
			,@idfCase=NULL
			,@idfMonitoringSession=NULL
			,@idfParty=@SummarySpeciesId
			,@idfsPartyType=10072004 /*Species*/
			,@strName=@SpeciesType OUTPUT
			,@idfParentParty=@SummaryHerdId
			,@idfObservation=NULL
			,@idfsFormTemplate=NULL
			,@intTotalAnimalQty=@SummaryTotalAnimalQty
			,@intSickAnimalQty=NULL
			,@intDeadAnimalQty=NULL
			,@strAverageAge=NULL
			,@datStartOfSignsDate=NULL
			,@strNote=NULL
			,@idfsCaseType = NULL
			
		
		DECLARE @MonitoringSessionSummaryId BIGINT 
		EXEC spsysGetNewID @ID=@MonitoringSessionSummaryId OUTPUT
		
		DECLARE @AnimalSexSummary BIGINT
		SELECT TOP 1
			@AnimalSexSummary = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000007/*Animal Sex*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode&32 = 32
			AND EXISTS (SELECT * FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = @SpeciesType AND idfsAnimalAge = tbr.idfsBaseReference AND intRowStatus = 0)
		ORDER BY NEWID()
		
		DECLARE @SampledAnimalsQty INT = (SELECT TOP 1 a FROM (SELECT 5 a UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) x ORDER BY NEWID())
		DECLARE @PositiveAnimalsQty INT = @SampledAnimalsQty - 1
		
		DECLARE @CollectionDaySummary INT = (SELECT TOP 1 a FROM (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) x ORDER BY NEWID())
		SET @CollectionDate = DATEADD(DAY, @CollectionDaySummary, @RandomDate)
		
		EXEC spASSessionSummary_Post 
			@Action=4
			,@idfMonitoringSessionSummary=@MonitoringSessionSummaryId
			,@idfMonitoringSession=@idfMonitoringSession
			,@idfFarm= @SummaryFarmId OUTPUT
			,@strFarmCode= @SummaryFarmCode OUTPUT
			,@idfFarmActual= @SummaryRootFarmId OUTPUT
			,@idfSpecies=@SummarySpeciesId
			,@idfsAnimalSex=@AnimalSexSummary
			,@intSampledAnimalsQty=@SampledAnimalsQty
			,@intSamplesQty=2
			,@datCollectionDate=@CollectionDate
			,@intPositiveAnimalsQty=@PositiveAnimalsQty
			
		EXEC spASSessionSummaryDiagnosis_Post 
			@idfMonitoringSessionSummary=@MonitoringSessionSummaryId
			,@idfsDiagnosis= @Diagnosis
			,@blnChecked=1
			
		
		SET @s = 0

		SET @SampleCnt = 2/*ISNULL(@SampleCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))*/

		WHILE @s < @SampleCnt
		BEGIN
			SET @s = @s + 1		
			
			
			DECLARE @SummarySampleType BIGINT
			SELECT TOP 1 
				@SummarySampleType = ISNULL(@SampleTypeId, tst.idfsSampleType)
			FROM trtSampleType tst
			JOIN trtBaseReference tbr ON
				tbr.idfsBaseReference = tst.idfsSampleType
				AND tbr.intHACode & 32 = 32
			WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
					OR EXISTS (SELECT * FROM trtMaterialForDisease WHERE idfsSampleType = tst.idfsSampleType AND intRowStatus = 0 AND idfsDiagnosis = @Diagnosis))
			ORDER BY NEWID()
			
			EXEC spASSessionSummarySample_Post 
				@idfMonitoringSessionSummary=@MonitoringSessionSummaryId
				,@idfsSampleType=@SummarySampleType
				,@blnChecked=1
		END
			
	END
	
	
	
	
	------ MonitoringSessionAction BEGIN ------
	DECLARE @MonitoringSessionActionTypeId BIGINT = (SELECT idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000127 AND strDefault = 'Quarantine' AND intRowStatus = 0)
	DECLARE @ActionDate DATETIME = DATEADD(DAY, 2, @RandomDate)
	DECLARE @MonitoringSessionActionStatusId BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000128 AND intRowStatus = 0 ORDER BY NEWID())
	
	DECLARE @MonitoringSessionActionId BIGINT
	EXEC spsysGetNewID @ID=@MonitoringSessionActionId OUTPUT
	EXEC spAsSessionAction_Post 
		@Action=4
		,@idfMonitoringSessionAction=@MonitoringSessionActionId OUTPUT
		,@idfsMonitoringSessionActionStatus=@MonitoringSessionActionStatusId
		,@idfMonitoringSession= @idfMonitoringSession
		,@idfPersonEnteredBy= @person
		,@datActionDate= @ActionDate
		,@idfsMonitoringSessionActionType=@MonitoringSessionActionTypeId
		,@strComments=NULL
	------ MonitoringSessionAction END ------


	
	EXEC dbo.spClearContextData 
		@ClearEventID=0
		,@ClearDataAuditEvent=1
END

EXEC dbo.spSetContext @ContextString=''


