
--##SUMMARY Procedure produces a set of veterinary cases with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 19.11.2013


--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateVetCase 
	@CaseCnt = 1
	, @SampleCnt = 1
	, @TestCnt = 2
	, @PensideTestCnt = 1
	, @ParamCnt = 4
	, @HerdCnt = 2
	, @AnimalCnt = 3
	, @my_SiteID = 1100
	, @Diagnosis = NULL
	, @LastName = NULL
	, @FirstName = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @StreetName = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
	, @DateRange = 100
	, @CaseType = 10012003
	, @LocalUserName = NULL
	, @FinalCaseStatus = NULL
	, @PersonReportedBy = NULL
*/

CREATE PROC [dbo].[sptemp_CreateVetCase](
	@CaseCnt INT,						--##PARAM @CaseCnt - the number of cases to generate
	@SampleCnt INT = NULL,				--##PARAM @SampleCnt - the number of samples to generate
	@TestCnt INT = NULL,				--##PARAM @TestCnt - the number of tests to generate
	@PensideTestCnt INT = NULL,			--##PARAM @PensideTestCnt - the number of penside tests to generate
	@ParamCnt INT = NULL,				--##PARAM @ParamCnt - the number of ff to generate
	@HerdCnt INT = NULL,				--##PARAM @HerdCnt - the number of herds to generate
	@AnimalCnt INT = NULL,				--##PARAM @AnimalCnt - the number of animals to generate
	
	@my_SiteID INT,						--##PARAM @my_SiteID - site id for case generation
	
	@Diagnosis BIGINT = NULL,			--##PARAM @Diagnosis - ID of diagnosis
	@LastName NVARCHAR(255) = NULL,		--##PARAM @LastName - lastname of the owner
	@FirstName NVARCHAR(255) = NULL,	--##PARAM @FirstName - first name of the owner
	@Region BIGINT = NULL,				--##PARAM @Region - region of the owner
	@Rayon BIGINT = NULL,				--##PARAM @Rayon - rayon of the owner
	@StreetName NVARCHAR(200) = NULL,	--##PARAM @StreetName - street name of the owner
	
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	
	@CaseType BIGINT,					--##PARAM @CaseType - type of new vet case /*10012003 - Livestock, 10012003 - Avian*/
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name for case generation
	@FinalCaseStatus BIGINT = NULL,		--##PARAM @FinalCaseStatus - final case status
	@PersonReportedBy BIGINT = NULL		--##PARAM @PersonReportedBy - reported by person id
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
(@ContextString, @user, NULL, NULL, CAST('0xD804D8AE0F9F1A43B8F211C803334522' AS VARBINARY), @LocalSite, GETDATE())
----------------------------------------------------


DECLARE @idfsRegion BIGINT
DECLARE @idfsRayon BIGINT
DECLARE @idfsSettlement BIGINT

DECLARE @idfsSpecimenType BIGINT
DECLARE @idfsPensideTestName BIGINT
DECLARE @idfsTestName BIGINT
DECLARE @datFieldCollectionDate DATETIME
DECLARE @datDiagnosis DATETIME

DECLARE @strInternationalName NVARCHAR(255)
DECLARE @strNationalName NVARCHAR(255)
DECLARE @OwnerLastName NVARCHAR(255)
DECLARE @OwnerFirstName NVARCHAR(255)

DECLARE @idfsTentativeDiagnosis BIGINT
DECLARE @idfsFinalDiagnosis BIGINT
DECLARE @RandomDate AS DATETIME 

DECLARE @i INT = 0

WHILE @i < @CaseCnt
BEGIN
	SET @i = @i + 1
	
	RandomDateSet:
	SET @RandomDate=DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)
	IF @RandomDate >= GETDATE()
		GOTO RandomDateSet
	
	SET @datFieldCollectionDate = @RandomDate		
	SET @datDiagnosis = @RandomDate
		
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
	SET @strInternationalName = ISNULL(@OwnerLastName + ' ' + @OwnerFirstName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))
	SET @strNationalName = @strInternationalName
	
	SELECT TOP 1 
		@idfsTentativeDiagnosis = ISNULL(@Diagnosis, td.idfsDiagnosis)
	FROM trtDiagnosis td 
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = td.idfsDiagnosis
		AND (
				(@CaseType = 10012003 AND tbr.intHACode & 32 = 32)
				OR (@CaseType = 10012004 AND tbr.intHACode & 64 = 64)
			)
	WHERE td.idfsUsingType = 10020001 
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtMaterialForDisease tmfd WHERE tmfd.idfsDiagnosis = td.idfsDiagnosis AND tmfd.intRowStatus = 0))
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtTestForDisease ttfd WHERE ttfd.idfsDiagnosis = td.idfsDiagnosis AND ttfd.intRowStatus = 0))
	ORDER BY NEWID()
	
	SELECT TOP 1 
		@idfsFinalDiagnosis = ISNULL(@Diagnosis, td.idfsDiagnosis)
	FROM trtDiagnosis td 
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = td.idfsDiagnosis
		AND (
				(@CaseType = 10012003 AND tbr.intHACode & 32 = 32)
				OR (@CaseType = 10012004 AND tbr.intHACode & 64 = 64)
			)
	WHERE td.idfsUsingType = 10020001 
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtMaterialForDisease tmfd WHERE tmfd.idfsDiagnosis = td.idfsDiagnosis AND tmfd.intRowStatus = 0))
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtTestForDisease ttfd WHERE ttfd.idfsDiagnosis = td.idfsDiagnosis AND ttfd.intRowStatus = 0))
	ORDER BY NEWID()		





	DECLARE @p4 BIGINT --@idfsFormTemplate in spVetCase_Post
	EXEC dbo.spFFGetActualTemplate 
		@idfsGISBaseReference=@LocalCountry
		,@idfsBaseReference=-1
		,@idfsFormType=10034014 /*Livestock Control Measures*/
		,@blnReturnTable = 0
		,@idfsFormTemplateActual=@p4 OUTPUT

	DECLARE @p12 BIGINT
	IF @CaseType = 10012003 /*Livestock*/
		EXEC dbo.spFFGetActualTemplate 
			@idfsGISBaseReference=@LocalCountry
			,@idfsBaseReference=-1
			,@idfsFormType=10034015 /*Livestock Farm EPI*/
			,@blnReturnTable = 0
			,@idfsFormTemplateActual=@p12 OUTPUT
	ELSE 
		EXEC dbo.spFFGetActualTemplate 
			@idfsGISBaseReference=@LocalCountry
			,@idfsBaseReference=-1
			,@idfsFormType=10034007 /*Avian Farm EPI*/
			,@blnReturnTable = 0
			,@idfsFormTemplateActual=@p12 OUTPUT

	DECLARE @p13 BIGINT
	IF @CaseType = 10012003 /*Livestock*/
		EXEC dbo.spFFGetActualTemplate 
			@idfsGISBaseReference=@LocalCountry
			,@idfsBaseReference=-1
			,@idfsFormType=10034016 /*Livestock Species CS*/
			,@blnReturnTable = 0
			,@idfsFormTemplateActual=@p13 OUTPUT
	ELSE 
		EXEC dbo.spFFGetActualTemplate 
			@idfsGISBaseReference=@LocalCountry
			,@idfsBaseReference=-1
			,@idfsFormType=10034008 /*Avian Species CS*/
			,@blnReturnTable = 0
			,@idfsFormTemplateActual=@p13 OUTPUT

	DECLARE @p28 BIGINT
	exec dbo.spFFGetActualTemplate 
		@idfsGISBaseReference=@LocalCountry
		,@idfsBaseReference=784220000000 /*Anthrax*/
		,@idfsFormType=10034013 /*Livestock Animal CS*/
		,@blnReturnTable = 0
		,@idfsFormTemplateActual=@p28 output




	DECLARE @EventID BIGINT

	BEGIN TRAN

		DECLARE @p1 BIGINT
		EXEC spsysGetNewID @ID=@p1 OUTPUT
		
		DECLARE @p101 BIGINT
		EXEC dbo.spAudit_CreateNewEvent 
			@idfsDataAuditEventType=10016001 /*Create*/
			,@idfsDataAuditObjectType=10017059 /*Veterinary Case*/
			,@strMainObjectTable=75800000000 /*Veterinary Cases*/
			,@idfsMainObject=@p1
			,@strReason=NULL
			,@idfDataAuditEvent=@p101 OUTPUT

		DECLARE @PCode AS VARCHAR(10)
		SET @PCode = CAST(CAST(RAND()*10000 AS INT) AS VARCHAR)

----FarmAddress BEGIN----
		DECLARE @p6 BIGINT
		EXEC spsysGetNewID @ID=@p6 OUTPUT

		EXEC spAddress_Post 
			@idfGeoLocation=@p6
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
			,@idfsRayon=@idfsRayon
			,@idfsSettlement=@idfsSettlement
			,@strApartment=N'3'
			,@strBuilding=N'1'
			,@strStreetName=@StreetName
			,@strHouse=N'2'
			,@strPostCode=@PCode
			,@blnForeignAddress=0
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=0
----FarmAddress END----


----Vet Case BEGIN----
		DECLARE @p2 BIGINT
		EXEC spsysGetNewID @ID=@p2 OUTPUT
		
		DECLARE @p36 BIGINT
		EXEC spsysGetNewID @ID=@p36 OUTPUT

		DECLARE @HACode INT = CASE WHEN @CaseType = 10012003 THEN 32 WHEN @CaseType = 10012004 THEN 64 ELSE NULL END
		
		DECLARE @ContactPhone NVARCHAR(255)
		SELECT @ContactPhone = CAST(RAND(CAST(NEWID() AS VARBINARY))*10000000000 AS BIGINT)
		
		DECLARE @p102 BIGINT
		DECLARE @p103 NVARCHAR(200)
		DECLARE @p104 bigint
		EXEC spFarmPanel_Post 
			@Action=4
			,@idfFarm=@p2
			,@idfRootFarm=@p102 OUTPUT
			,@idfCase=@p1
			,@idfMonitoringSession=NULL
			,@strContactPhone=@ContactPhone
			,@strInternationalName=@strInternationalName
			,@strNationalName=@strNationalName
			,@strFarmCode=@p103 OUTPUT
			,@strFax=NULL
			,@strEmail=NULL
			,@idfFarmAddress=@p6
			,@idfOwner=@p36
			,@idfRootOwner=@p104 OUTPUT
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
			,@intHACode=@HACode


		DECLARE @p3 BIGINT
		EXEC spsysGetNewID @ID=@p3 OUTPUT
		
		DECLARE @p110 NVARCHAR(200)
		EXEC spGetNextNumber 
			@NextNumberName=10057024
			,@NextNumberValue=@p110 OUTPUT
			,@InstallationSite=NULL
			
		DECLARE @FinalStatus BIGINT = ISNULL(@FinalCaseStatus, 350000000 /*Confirmed Case*/)
		DECLARE @CaseStatus BIGINT = CASE 
										WHEN @FinalStatus = 370000000 /*Not a Case*/ THEN 10109002 /*Closed*/
										ELSE 10109001 /*In process*/
									END

		DECLARE @FieldAccessionID NVARCHAR(8) = CAST(RAND(CAST(NEWID() AS VARBINARY))*100000000 AS BIGINT) 

		EXEC spVetCase_Post 
			@idfCase=@p1
			,@idfOutbreak=NULL
			,@idfsCaseClassification=@FinalStatus
			,@idfsCaseProgressStatus=@CaseStatus
			,@idfsCaseType=@CaseType
			,@datEnteredDate=@datFieldCollectionDate
			,@strCaseID=@p110
			,@uidOfflineCaseID=NULL
			,@idfsTentativeDiagnosis=@idfsTentativeDiagnosis
			,@idfsTentativeDiagnosis1=NULL
			,@idfsTentativeDiagnosis2=NULL
			,@idfsFinalDiagnosis=@idfsFinalDiagnosis
			,@idfPersonInvestigatedBy=@PersonReportedBy
			,@idfPersonEnteredBy=NULL
			,@idfPersonReportedBy=@PersonReportedBy
			,@idfObservation=@p3
			,@idfsFormTemplate=@p4
			,@idfsSite=@LocalSite
			,@datReportDate=@datFieldCollectionDate
			,@datAssignedDate=@datFieldCollectionDate
			,@datInvestigationDate=@datFieldCollectionDate
			,@datTentativeDiagnosisDate=@datDiagnosis
			,@datTentativeDiagnosis1Date=NULL
			,@datTentativeDiagnosis2Date=NULL
			,@datFinalDiagnosisDate=@datDiagnosis
			,@strSampleNotes=NULL
			,@strTestNotes=NULL
			,@strSummaryNotes=NULL
			,@strClinicalNotes=NULL
			,@strFieldAccessionID=@FieldAccessionID
			,@idfFarm=@p2
			,@idfsYNTestsConducted=NULL
			,@idfReportedByOffice=NULL
			,@idfInvestigatedByOffice=NULL
			,@idfsCaseReportType=4578940000002 /*Passive*/
			,@blnCheckPermissions = 0
		
		EXEC spAvianFarmDetail_Post 
			@idfFarm=@p2
			,@intBuidings=NULL
			,@intBirdsPerBuilding=NULL


		--Herds and Species
		DECLARE @h INT = 0	
		DECLARE @TotalFarmAnimalQty INT = 0
			, @DeadFarmAnimalQty INT = 0
			, @SickFarmAnimalQty INT = 0
		SET @HerdCnt = ISNULL(@HerdCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

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
			
			DECLARE @DeadAnimalQty INT = (SELECT TOP 1 a FROM(SELECT 0 a UNION ALL SELECT 1) x ORDER BY NEWID())
			DECLARE @SickAnimalQty INT = CAST(@TotalAnimalQty / 100.0 * 40 AS INT)
			
			SET @TotalFarmAnimalQty += @TotalAnimalQty
			SET @SickFarmAnimalQty += @SickAnimalQty
			SET @DeadFarmAnimalQty += @DeadAnimalQty

			DECLARE @p106 NVARCHAR(200)
			EXEC spVetFarmTree_Post 
				@Action=4
				,@idfCase=@p1
				,@idfMonitoringSession=null
				,@idfParty=@HerdId
				,@idfsPartyType=10072003 /*Herd*/
				,@strName=@p106 OUTPUT
				,@idfParentParty=@p2
				,@idfObservation=NULL
				,@idfsFormTemplate=NULL
				,@intTotalAnimalQty=@TotalAnimalQty
				,@intSickAnimalQty=@SickAnimalQty
				,@intDeadAnimalQty=@DeadAnimalQty
				,@strAverageAge=NULL
				,@datStartOfSignsDate=NULL
				,@strNote=NULL
				,@idfsCaseType = NULL
				
			
			DECLARE @SpeciesId BIGINT 
			EXEC spsysGetNewID @ID=@SpeciesId OUTPUT 

			DECLARE @p11 BIGINT 
			EXEC spsysGetNewID @ID=@p11 OUTPUT

			DECLARE @p107 NVARCHAR(200)
			SELECT TOP 1 
				@p107 = tbr.idfsBaseReference
			FROM trtBaseReference tbr 
			WHERE tbr.idfsReferenceType = 19000086 /*SpeciesType*/
				AND tbr.intRowStatus = 0
				AND (
						(@CaseType = 10012003 AND tbr.intHACode & 32 = 32)
						OR (@CaseType = 10012004 AND tbr.intHACode & 64 = 64)
					)
			ORDER BY NEWID()
			
			EXEC spVetFarmTree_Post 
				@Action=4
				,@idfCase=@p1
				,@idfMonitoringSession=null
				,@idfParty=@SpeciesId
				,@idfsPartyType=10072004 /*Species*/
				,@strName=@p107 OUTPUT
				,@idfParentParty=@HerdId
				,@idfObservation=@p11
				,@idfsFormTemplate=@p13
				,@intTotalAnimalQty=@TotalAnimalQty
				,@intSickAnimalQty=@SickAnimalQty
				,@intDeadAnimalQty=@DeadAnimalQty
				,@strAverageAge=NULL
				,@datStartOfSignsDate=@datFieldCollectionDate
				,@strNote=NULL
				,@idfsCaseType = NULL
				
			
			DECLARE @a INT = 0	
			SET @AnimalCnt = ISNULL(@AnimalCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

			WHILE @a < @AnimalCnt
			BEGIN
				SET @a = @a + 1
				
				DECLARE @p26 BIGINT
				EXEC spsysGetNewID @ID=@p26 OUTPUT

				DECLARE @p27 BIGINT
				EXEC spsysGetNewID @ID=@p27 OUTPUT

				DECLARE @AnimalCode NVARCHAR(200) = NULL
				DECLARE @AnimalAge NVARCHAR(200)
				
				SELECT TOP 1 
					@AnimalAge = tbr.idfsBaseReference
				FROM trtBaseReference tbr 
				WHERE tbr.idfsReferenceType = 19000005--AnimalAge
					AND tbr.intRowStatus = 0
				ORDER BY NEWID()
				
				IF @CaseType = 10012003 /*Livestock*/
					EXEC spVetCaseAnimals_Post 
						@Action=4
						,@idfAnimal=@p26
						,@idfHerd=@HerdId
						,@idfsAnimalAge=@AnimalAge
						,@idfsAnimalGender=10007001 /*Female*/
						,@strAnimalCode=@AnimalCode OUTPUT
						,@strDescription=NULL
						,@idfsAnimalCondition=NULL
						,@idfSpecies=@SpeciesId
						,@idfObservation=@p27
						,@idfsFormTemplate=@p28
						,@idfCase=NULL
			END
		END
		
		DECLARE @p8 BIGINT 
		EXEC spsysGetNewID @ID=@p8 OUTPUT

		DECLARE @p105 NVARCHAR(200)
		EXEC spVetFarmTree_Post 
			@Action=4
			,@idfCase=@p1
			,@idfMonitoringSession=null
			,@idfParty=@p2
			,@idfsPartyType=10072005 /*Farm*/
			,@strName=@p105 OUTPUT
			,@idfParentParty=NULL
			,@idfObservation=@p8
			,@idfsFormTemplate=@p12
			,@intTotalAnimalQty=@TotalFarmAnimalQty
			,@intSickAnimalQty=@SickFarmAnimalQty
			,@intDeadAnimalQty=@DeadFarmAnimalQty
			,@strAverageAge=NULL
			,@datStartOfSignsDate=NULL
			,@strNote=NULL
			,@idfsCaseType = NULL

		IF @CaseType = 10012004 /*Avian*/
			EXEC spAvianFarmProduction_Post 
				@idfFarm=@p2
				,@idfRootFarm=@p102
				,@idfsAvianFarmType=NULL
				,@idfsAvianProductionType=NULL
				,@idfsIntendedUse=NULL
		ELSE /*Livestock*/
		BEGIN
			DECLARE @OwnershipStructure BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000065 AND intRowStatus = 0)
			EXEC spLivestockFarmProduction_Post 
				@idfFarm=@p2
				,@idfRootFarm=/*@p19*/@p102
				,@idfsOwnershipStructure=@OwnershipStructure
				,@idfsLivestockProductionType=NULL
				,@idfsGrazingPattern=NULL
				,@idfsMovementPattern=NULL
		END
		
		DECLARE @VaccinationId BIGINT
		EXEC spsysGetNewID @ID=@VaccinationId OUTPUT
		
		DECLARE @VaccinationDate DATETIME = DATEADD(MONTH, -1, @datFieldCollectionDate)
		
		DECLARE @VaccinationType BIGINT = (
											SELECT TOP 1
												tbr.idfsBaseReference
											FROM trtBaseReference tbr
											WHERE tbr.idfsReferenceType = 19000099
												AND tbr.intRowStatus = 0
											ORDER BY NEWID()
											)
		DECLARE @VaccinationRoute BIGINT = (
											SELECT TOP 1
												tbr.idfsBaseReference
											FROM trtBaseReference tbr
											WHERE tbr.idfsReferenceType = 19000098
												AND tbr.intRowStatus = 0
											ORDER BY NEWID()
											)
		
		DECLARE @LotNumber NVARCHAR(5) = CAST(RAND(CAST(NEWID() AS VARBINARY))*100000 AS BIGINT)
		DECLARE @NumberVaccinated INT
		SELECT TOP 1
			@NumberVaccinated = rn
		FROM (
			SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
		) x
		WHERE rn < @TotalAnimalQty
		ORDER BY NEWID()
		
		EXECUTE spVaccination_Post 
		   @Action = 4
		  ,@idfVaccination = @VaccinationId
		  ,@idfVetCase = @p1
		  ,@idfSpecies = @SpeciesId
		  ,@idfsVaccinationType = @VaccinationType
		  ,@idfsVaccinationRoute = @VaccinationRoute
		  ,@idfsDiagnosis = @idfsFinalDiagnosis
		  ,@datVaccinationDate = @VaccinationDate
		  ,@strManufacturer = NULL
		  ,@strLotNumber = @LotNumber
		  ,@intNumberVaccinated = @NumberVaccinated
		  ,@strNote	= NULL
		
----Vet Case END----


----Samples BEGIN----
		DECLARE @s INT = 0
		
		SET @SampleCnt = ISNULL(@SampleCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

		WHILE @s < @SampleCnt
		BEGIN
			SET @s = @s + 1
			
			DECLARE @SampleFieldBarCode NVARCHAR(8) = LEFT(NEWID(), 8)
			
			SELECT TOP 1 
				@idfsSpecimenType = tst.idfsSampleType 
			FROM trtSampleType tst
			JOIN trtBaseReference tbr ON
				tbr.idfsBaseReference = tst.idfsSampleType
				AND (
						(@CaseType = 10012003 AND tbr.intHACode & 32 = 32)
						OR (@CaseType = 10012004 AND tbr.intHACode & 64 = 64)
				)
			WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
					OR EXISTS (SELECT * FROM trtMaterialForDisease WHERE idfsSampleType = tst.idfsSampleType AND intRowStatus = 0 AND idfsDiagnosis = @idfsFinalDiagnosis)
					)
			ORDER BY NEWID()
			
			
			DECLARE @Party BIGINT = CASE WHEN @CaseType = 10012003 THEN @p26 ELSE @SpeciesId END
			
			DECLARE @p113 BIGINT
			EXEC spLabSample_Create 
				@idfMaterial=@p113 OUTPUT
				,@strFieldBarcode=@SampleFieldBarCode
				,@idfsSampleType=@idfsSpecimenType
				,@idfParty=@Party
				,@idfCase=@p1
				,@idfMonitoringSession=NULL
				,@idfVectorSurveillanceSession=NULL
				,@datFieldCollectionDate=@datFieldCollectionDate
				,@datFieldSentDate=@datFieldCollectionDate
				,@idfFieldCollectedByOffice=NULL
				,@idfFieldCollectedByPerson=NULL
				,@idfMainTest=NULL
				,@idfSendToOffice=@LocalOffice
				,@idfsBirdStatus=NULL
				
				
			IF @FinalStatus <> 380000000 /*Suspect*/
			BEGIN	
				----AccesionIn Sample BEGIN--
				DECLARE @DAEAccesionIn BIGINT
				EXEC dbo.spAudit_CreateNewEvent 
					@idfsDataAuditEventType=10016003 /*Edit*/
					,@idfsDataAuditObjectType=10017013 /*Check In*/
					,@strMainObjectTable=75620000000 /*tlbMaterial*/
					,@idfsMainObject=@p113 /*idfMaterial*/
					,@strReason=NULL
					,@idfDataAuditEvent=@DAEAccesionIn OUTPUT

				EXEC spLabSample_Update 
					@idfMaterial=@p113
					,@strFieldBarcode=@SampleFieldBarCode
					,@idfsSampleType=@idfsSpecimenType
					,@idfParty=@Party
					,@datFieldCollectionDate=@datFieldCollectionDate
					,@datFieldSentDate=@datFieldCollectionDate
					,@idfFieldCollectedByOffice=NULL
					,@idfFieldCollectedByPerson=NULL
					,@idfMainTest=NULL
					,@idfSendToOffice=@LocalOffice
					,@idfsBirdStatus=NULL

				EXEC spLabSampleReceive_ModifyCase 
					@idfCase=@p1
					,@strSampleNotes=NULL
					
				DECLARE @strBarcode NVARCHAR(200)
				EXEC spGetNextNumber 
					@NextNumberName=10057020 /*Sample/Aliquot/Derivative*/
					,@NextNumberValue=@strBarcode OUTPUT
					,@InstallationSite=NULL

				EXEC spLabSampleReceive_PostDetail 
					@idfMaterial=@p113
					,@strBarcode=@strBarcode
					,@datAccession=@datFieldCollectionDate
					,@idfDepartment=NULL
					,@strCondition=NULL
					,@idfsAccessionCondition=10108001 /*Accepted in Good Condition*/
					,@strNote=NULL
					,@idfSubdivision=NULL
					,@idfAccesionByPerson=@person

				EXEC dbo.spClearContextData 
					@ClearEventID=0
					,@ClearDataAuditEvent=1

				----Test BEGIN	
				DECLARE @t INT = 0
				
				SET @TestCnt = ISNULL(@TestCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

				WHILE @t < @TestCnt
				BEGIN
					SET @t = @t + 1
					
					SELECT TOP 1 
						@idfsTestName = idfsBaseReference
					FROM trtBaseReference tbr
					WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
							OR EXISTS (SELECT * FROM trtTestForDisease WHERE idfsTestName = tbr.idfsBaseReference AND intRowStatus = 0 AND idfsDiagnosis = @idfsFinalDiagnosis))
						AND idfsReferenceType = 19000097
						AND (
							(@CaseType = 10012003 AND intHACode & 32 = 32)
							OR (@CaseType = 10012004 AND intHACode & 64 = 64)
						)
					ORDER BY NEWID()
					
					IF ISNULL(@idfsTestName, '') <> ''
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
							,@idfsBaseReference=@idfsTestName
							,@idfsFormType=10034018 /*Test Details*/
							,@idfsFormTemplateActual=@TestFormTemplate OUTPUT
							,@blnReturnTable=0
						
						DECLARE @Testing BIGINT
						EXEC spsysGetNewID @ID=@Testing OUTPUT

						DECLARE @Observation BIGINT
						EXEC spsysGetNewID @ID=@Observation OUTPUT

						DECLARE @DAETest BIGINT
						EXEC dbo.spAudit_CreateNewEvent 
							@idfsDataAuditEventType=10016003 /*Edit*/
							,@idfsDataAuditObjectType=10017045 /*Sample*/
							,@strMainObjectTable=75620000000 /*tlbMaterial*/
							,@idfsMainObject=@p113
							,@strReason=NULL
							,@idfDataAuditEvent=@DAETest OUTPUT
							
						DECLARE @StartedDate DATETIME = CASE 
															WHEN @TestStatus IN (10001001 /*Final*/, 10001004 /*Preliminary*/) 
																THEN DATEADD(DAY, 1, @datFieldCollectionDate) 
															ELSE NULL 
														END
						
						DECLARE @TestResult BIGINT
						SET @TestResult = NULL
						IF EXISTS (SELECT * FROM trtBaseReference WHERE idfsBaseReference = @TestStatus AND strDefault IN ('Amended', 'Final', 'Preliminary'))
						BEGIN																
							IF @FinalStatus = 370000000 /*Not a Case*/
								SELECT 
									@TestResult = idfsBaseReference
								FROM trtBaseReference 
								WHERE idfsReferenceType = 19000096 /*Test Result*/
									AND intRowStatus = 0
									AND strDefault = N'Negative'
									
							IF @FinalStatus = 350000000 /*Confirmed*/
								SELECT 
									@TestResult = idfsBaseReference
								FROM trtBaseReference 
								WHERE idfsReferenceType = 19000096 /*Test Result*/
									AND intRowStatus = 0
									AND strDefault = N'Positive'
									
							IF @FinalStatus = 360000000 /*Probable*/
								SELECT TOP 1
									@TestResult = idfsBaseReference
								FROM trtBaseReference 
								WHERE idfsReferenceType = 19000096 /*Test Result*/
									AND intRowStatus = 0
									AND strDefault IN (N'Negative', N'Indeterminate')
								ORDER BY NEWID()
								
							IF @FinalStatus = 12137920000000 /*Lost to Follow-up*/
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
							,@idfsTestName=@idfsTestName
							,@idfsTestResult=@TestResult
							,@idfsTestCategory=@TestCategory
							,@idfsDiagnosis=@idfsFinalDiagnosis
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

						EXEC dbo.spClearContextData 
							@ClearEventID=0
							,@ClearDataAuditEvent=1

						EXEC spEventLog_EventForObjectExists 
							@idfsEventTypeID=10025126 /*Test result for sample transferred out from your laboratory  is entered*/
							,@idfObject=@Testing
						
						DECLARE @Event BIGINT
						SET @Event = NULL
						EXEC spEventLog_CreateNewEvent 
							@idfsEventTypeID=10025126 /*Test result for sample transferred out from your laboratory  is entered*/
							,@idfObjectID=@Testing
							,@strInformationString=N''
							,@strNote=N''
							,@ClientID=@ContextString
							,@intProcessed=2
							,@idfUserID=NULL
							,@EventID=@Event OUTPUT

						EXEC spEventLog_IsNtfyServiceRunning 
							@idfsClient=@ContextString
						
						SET @Event = NULL
						EXEC spEventLog_CreateNewEvent 
							@idfsEventTypeID=10025109 /*Replication requested by user*/
							,@idfObjectID=NULL
							,@strInformationString=N''
							,@strNote=N''
							,@ClientID=@ContextString
							,@intProcessed=0
							,@idfUserID=NULL
							,@EventID=@Event OUTPUT
							
						
						IF @TestStatus = 10001001 /*Final*/ AND EXISTS (SELECT * FROM trtBaseReference 
																		WHERE idfsReferenceType = 19000096 
																			AND strDefault = 'Positive' 
																			AND idfsBaseReference = @TestResult 
																			AND intRowStatus = 0)
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
								,@idfsDiagnosis=@idfsFinalDiagnosis
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


				----Penside Test BEGIN	
				DECLARE @pt INT = 0
				
				SET @PensideTestCnt = ISNULL(@PensideTestCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

				WHILE @pt < @PensideTestCnt
				BEGIN
					SET @pt = @pt + 1

						SELECT TOP 1 
							@idfsPensideTestName = idfsBaseReference
						FROM trtBaseReference
						WHERE idfsReferenceType = 19000104 /*Penside Test Name*/
							AND (
								(@CaseType = 10012003 AND intHACode & 32 = 32)
								OR (@CaseType = 10012004 AND intHACode & 64 = 64)
							)
						ORDER BY NEWID()
					
					DECLARE @PensideTesting BIGINT
					EXEC spsysGetNewID @ID=@PensideTesting OUTPUT
						
					EXEC spPensideTest_Post
						@Action = 4
						, @idfPensideTest = @PensideTesting
						, @idfVetCase = NULL
						, @idfParty = NULL
						, @idfsPensideTestResult = NULL 
						, @idfsPensideTestName = @idfsPensideTestName
						, @idfMaterial = @p113
				END
				----Penside Test END
			END	
		END
		
		EXEC spLabSampleReceive_ModifyCase 
			@idfCase=@p1
			,@strSampleNotes=NULL
----Samples END----


--ff
		DECLARE @Param BIGINT = 0
		DECLARE @p INT = 0
		DECLARE @ParamCntLocal INT
		SET @ParamCntLocal = ISNULL(@ParamCnt/2, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) x ORDER BY NEWID()))

		WHILE @p < @ParamCntLocal
		BEGIN
			SET @p = @p + 1
----EPI----			
			IF EXISTS 
			(
				SELECT
					fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p12
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
			)
			BEGIN 
				
				DECLARE @p300 BIGINT 
				EXEC spsysGetNewID @ID=@p300 OUTPUT 
				
				SELECT TOP 1
					@Param = fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p12
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
				ORDER BY NEWID()
					
				DECLARE @p1050 BIGINT 
				SET @p1050=@p300
				EXEC dbo.spFFSaveActivityParameters 
					@idfsParameter=@Param
					,@idfObservation=@p8
					,@idfsFormTemplate=@p12
					,@varValue=NULL
					,@idfRow=@p1050 OUTPUT
					,@IsDynamicParameter=0

			END
----EPI----

----CS----			
			IF EXISTS 
			(
				SELECT
					fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p13
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
			)
			BEGIN 
				
				DECLARE @p3010 BIGINT 
				EXEC spsysGetNewID @ID=@p3010 OUTPUT 
				
				SELECT TOP 1
					@Param = fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p13
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
				ORDER BY NEWID()
					
				DECLARE @p10510 BIGINT 
				SET @p10510=@p3010
				EXEC dbo.spFFSaveActivityParameters 
					@idfsParameter=@Param
					,@idfObservation=@p11
					,@idfsFormTemplate=@p13
					,@varValue=NULL
					,@idfRow=@p10510 OUTPUT
					,@IsDynamicParameter=0

			END
----CS----
		END

		EXEC dbo.spClearContextData 
			@ClearEventID=0
			,@ClearDataAuditEvent=1

		SET @EventID = @p1

	IF @@ERROR <> 0
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN
		
		
	SET @Event = NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString= @PCode
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event OUTPUT

	SET @Event=NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString= @StreetName
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event output

	EXEC spEventLog_EventForObjectExists 
		@idfsEventTypeID=10025014  /*New Human Case*/
		,@idfObject=@p1

	SET @Event=NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025014 /*New Vet Case*/
		,@idfObjectID=@p1
		,@strInformationString=N''
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=2
		,@idfUserID=NULL
		,@EventID=@Event OUTPUT 
END

EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;

