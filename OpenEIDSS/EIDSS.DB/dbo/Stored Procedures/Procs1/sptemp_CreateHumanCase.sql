
/****** Object:  StoredProcedure [dbo].[sptemp_CreateHumanCase]    Script Date: 01/12/2016 11:46:29 ******/
--##SUMMARY Procedure produces a set of human cases with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 19.11.2013

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateHumanCase 
	@CaseCnt = 1
	, @SampleCnt = 1
	, @TestCnt = 2
	, @ParamCnt = 4
	, @my_SiteID = 1294
	, @Diagnosis = NULL
	, @LastName = NULL
	, @Age = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
	, @DateRange = 100
	, @HumanGender = 10043002
	, @LocalUserName = 'EIDSS Web Server Administrator'
	, @EmployerName = NULL
	, @FirstContactName = NULL
	, @SecondContactName = NULL
	, @PatientFinalState = NULL
	, @FinalCaseStatus = NULL
	, @Outcome = NULL
	, @SentByPerson = NULL
	, @CreateTransferOutMaterial = NULL
	, @TransferSendToOffice = NULL
	, @AmendedTestStatus = NULL
*/

CREATE PROC [dbo].[sptemp_CreateHumanCase](
	@CaseCnt INT,							--##PARAM @CaseCnt - the number of cases to generate
	@SampleCnt INT = NULL,					--##PARAM @SampleCnt - the number of samples to generate
	@TestCnt INT = NULL,					--##PARAM @TestCnt - the number of tests to generate
	@ParamCnt INT = NULL,					--##PARAM @ParamCnt - the number of ff to generate
	
	@my_SiteID INT,							--##PARAM @my_SiteID - site id for case generation
	
	@Diagnosis BIGINT = NULL,				--##PARAM @Diagnosis - ID of diagnosis
	@LastName NVARCHAR(255) = NULL,			--##PARAM @LastName - lastname of the patient
	@FirstName NVARCHAR(255) = NULL,		--##PARAM @LastName - lastname of the patient
	@Age INT = NULL,						--##PARAM @Age - age of the patient
	@Region BIGINT = NULL,					--##PARAM @Region - region of the patient
	@Rayon BIGINT = NULL,					--##PARAM @Rayon - rayon of the patient
	@StreetName NVARCHAR(200) = NULL,		--##PARAM @StreetName - street of the patient
	
	@StartDate DATETIME,					--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,							--##PARAM @DateRange - number of days for calculation dates
	
	@HumanGender BIGINT = NULL,				--##PARAM @HumanGender - gender of the patient (10043001 - Female, 10043002 - Male)
	
	@LocalUserName NVARCHAR(200) = NULL,	--##PARAM @LocalUserName - user name
	@EmployerName NVARCHAR(200) = NULL,		--##PARAM @EmployerName - employer name
	@FirstContactName NVARCHAR(200) = NULL,	--##PARAM @FirstContactName - first contact name
	@SecondContactName NVARCHAR(200) = NULL,--##PARAM @SecondContactName - second contact name
	@PatientFinalState BIGINT = NULL,		--##PARAM @PatientFinalState - patient final state /*10035001 - Dead, 10035002 - Live*/
	@FinalCaseStatus BIGINT = NULL,			--##PARAM @FinalCaseStatus - final case status
	@Outcome BIGINT = NULL,					--##PARAM @Outcome - outcome id
	@SentByPerson BIGINT = NULL,			--##PARAM @SentByPerson - sent by person id
	@CreateTransferOutMaterial BIT = NULL,	--##PARAM @CreateTransferOutMaterial - create or not transfer out material
	@TransferSendToOffice BIGINT = NULL,	--##PARAM @TransferSendToOffice - sent to office id for transfer out
	@AmendedTestStatus BIT = NULL			--##PARAM @AmendedTestStatus - set or not amended status for test
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

DECLARE @PatientLastName NVARCHAR(255)
DECLARE @PatientFirstName NVARCHAR(255)
DECLARE @EmployerNameLocal NVARCHAR(255)
DECLARE @HomePhone NVARCHAR(255)
DECLARE @WorkPhone NVARCHAR(255)

DECLARE @idfsSpecimenType BIGINT
DECLARE @idfsTestName BIGINT
DECLARE @datFieldCollectionDate DATETIME
DECLARE @datDiagnosis DATETIME 
DECLARE @idfsTentativeDiagnosis BIGINT
DECLARE @idfsFinalDiagnosis BIGINT
DECLARE @RandomDate as DATETIME
DECLARE @datNotificationDate DATETIME

DECLARE @FinalState BIGINT = ISNULL(@PatientFinalState, 10035002 /*Live*/)
DECLARE @FinalStatus BIGINT = ISNULL(@FinalCaseStatus, 350000000 /*Confirmed Case*/)

DECLARE @CaseStatus BIGINT = CASE 
								WHEN @FinalStatus = 370000000 /*Not a Case*/ THEN 10109002 /*Closed*/
								ELSE 10109001 /*In process*/
							END

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
	SET	@datNotificationDate = @RandomDate
	
	
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

	SET @PatientLastName = ISNULL(@LastName, 'Demo       ' + CONVERT(NVARCHAR, GETDATE(), 121))

	SET @PatientFirstName = ISNULL(@FirstName, (
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
	
	SET @EmployerNameLocal = ISNULL(@EmployerName, 'EN ' + CONVERT(NVARCHAR, GETDATE(), 121))
	
	SELECT TOP 1
		@HomePhone = CAST(RAND(CAST(NEWID() AS VARBINARY))*10000000000 AS BIGINT)
	FROM sysobjects
	ORDER BY NEWID()
	
	SELECT TOP 1
		@WorkPhone = CAST(RAND(CAST(NEWID() AS VARBINARY))*10000000000 AS BIGINT)
	FROM sysobjects
	ORDER BY NEWID()

	
	SELECT TOP 1 
		@idfsTentativeDiagnosis = ISNULL(@Diagnosis, td.idfsDiagnosis)
	FROM trtDiagnosis td 
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = td.idfsDiagnosis
		AND intHACode&2 = 2
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
		AND intHACode&2 = 2
	WHERE td.idfsUsingType = 10020001 
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtMaterialForDisease tmfd WHERE tmfd.idfsDiagnosis = td.idfsDiagnosis AND tmfd.intRowStatus = 0))
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtTestForDisease ttfd WHERE ttfd.idfsDiagnosis = td.idfsDiagnosis AND ttfd.intRowStatus = 0))
	ORDER BY NEWID()
	
	
	DECLARE @p10 BIGINT 
	EXEC dbo.spFFGetActualTemplate 
		@idfsGISBaseReference=@LocalCountry
		,@idfsBaseReference=@idfsFinalDiagnosis
		,@idfsFormType=10034010 /*Human Clinical Signs*/
		,@blnReturnTable = 0
		,@idfsFormTemplateActual=@p10 OUTPUT

	DECLARE @p11 BIGINT 
	EXEC dbo.spFFGetActualTemplate 
		@idfsGISBaseReference=@LocalCountry
		,@idfsBaseReference=@idfsFinalDiagnosis
		,@idfsFormType=10034011 /*Human Epi Investigations*/
		,@blnReturnTable = 0
		,@idfsFormTemplateActual=@p11 OUTPUT
	
	
	
	DECLARE @EventID BIGINT
	
	BEGIN TRAN
	
		DECLARE @p1 BIGINT
		EXEC spsysGetNewID @ID=@p1 OUTPUT

		DECLARE @p101 BIGINT
		EXEC dbo.spAudit_CreateNewEvent 
			@idfsDataAuditEventType=10016001 /*Create*/
			,@idfsDataAuditObjectType=10017026 /*Human Case*/
			,@strMainObjectTable=75610000000 /*Human Cases*/
			,@idfsMainObject=@p1
			,@strReason=NULL
			,@idfDataAuditEvent=@p101 OUTPUT

		DECLARE @PCode AS VARCHAR(10)
		SET @PCode=CAST(CAST(RAND()*10000 AS INT) AS VARCHAR)

----CurrentResidenceAddress BEGIN--
		DECLARE @p7 BIGINT 
		EXEC spsysGetNewID @ID=@p7 OUTPUT
		
		EXEC spAddress_Post 
			@idfGeoLocation=@p7
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
----CurrentResidenceAddress END--

----EmployerAddress BEGIN--	
		DECLARE @p8 BIGINT 
		EXEC spsysGetNewID @ID=@p8 OUTPUT 

		EXEC spAddress_Post 
			@idfGeoLocation=@p8
			,@idfsCountry=@LocalCountry
			,@idfsRegion=NULL
			,@idfsRayon=NULL
			,@idfsSettlement=NULL
			,@strApartment=NULL
			,@strBuilding=NULL
			,@strStreetName=NULL
			,@strHouse=NULL
			,@strPostCode=NULL
			,@blnForeignAddress=0
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=0
----EmployerAddress BEGIN--			
			
		
		
		DECLARE @CalcAge AS INT
		SET @CalcAge = ISNULL(@Age, CAST(RAND()*70 AS INT) + 1)
		
		DECLARE @DOB AS DATETIME
		SET @DOB = DATEADD(YEAR, -1*@CalcAge, DATEADD(MONTH, -1, @RandomDate))

----Patient BEGIN----
		DECLARE @p5 BIGINT 
		EXEC spsysGetNewID @ID=@p5 OUTPUT
		
		DECLARE @p9 BIGINT 
		EXEC spsysGetNewID @ID=@p9 OUTPUT
		
		SET @HumanGender = ISNULL(@HumanGender, 10043002/*Male*/)
		
		DECLARE @PersonIDType BIGINT = (
										SELECT 
											tbr.idfsBaseReference
										FROM trtBaseReference tbr 
										WHERE tbr.idfsReferenceType = 19000148 /*Person ID Type*/ 
											AND tbr.strDefault = 'Passport'
											AND tbr.intRowStatus = 0
									) 
		
		DECLARE @PersonID NVARCHAR(10) = LEFT(REPLACE(NEWID(), '-', '') , 10)
		
		EXEC spPatient_Post 
			@idfHuman=@p5
			,@idfRootHuman=@p9
			,@idfCase=NULL
			,@idfsOccupationType=NULL
			,@idfsNationality=NULL
			,@idfsHumanGender=@HumanGender
			,@idfCurrentResidenceAddress=@p7
			,@idfEmployerAddress=@p8
			,@idfRegistrationAddress=NULL
			,@datDateofBirth=NULL
			,@datDateOfDeath=NULL
			,@strLastName=@PatientLastName
			,@strSecondName=NULL
			,@strFirstName=@PatientFirstName
			,@strRegistrationPhone=NULL
			,@strEmployerName=@EmployerNameLocal
			,@strHomePhone=@HomePhone
			,@strWorkPhone=@WorkPhone
			,@idfsPersonIDType = @PersonIDType
			,@strPersonID = @PersonID
			,@datEnteredDate = NULL
			,@datModificationDate = NULL
----Patient END----

----RegistrationAddress BEGIN----		
		DECLARE @p6 BIGINT 
		EXEC spsysGetNewID @ID=@p6 OUTPUT

		EXEC spAddress_Post 
			@idfGeoLocation=@p6
			,@idfsCountry=@LocalCountry
			,@idfsRegion=NULL
			,@idfsRayon=NULL
			,@idfsSettlement=NULL
			,@strApartment=NULL
			,@strBuilding=NULL
			,@strStreetName=NULL
			,@strHouse=NULL
			,@strPostCode=NULL
			,@blnForeignAddress=0
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=0
----RegistrationAddress BEGIN----		
		

----Human Case BEGIN----		
		DECLARE @p2 BIGINT
		EXEC spsysGetNewID @ID=@p2 OUTPUT
	
		DECLARE @p3 BIGINT
		EXEC spsysGetNewID @ID=@p3 OUTPUT

		DECLARE @p4 BIGINT
		EXEC spsysGetNewID @ID=@p4 OUTPUT
		
		DECLARE @p102 NVARCHAR(200)
		EXEC spGetNextNumber 
			@NextNumberName=10057014 /*Human Case*/
			,@NextNumberValue=@p102 OUTPUT
			,@InstallationSite=NULL

		DECLARE @uidOfflineCaseID UNIQUEIDENTIFIER = NEWID()
		
		DECLARE @LocalIdentifier NVARCHAR(6) = LEFT(NEWID(), 6)	
		
		DECLARE @datFacilityLastVisit DATETIME = DATEADD(DAY, -1, @datFieldCollectionDate)
		
		DECLARE @HospitalizationStatus BIGINT = (
												SELECT TOP 1 
													tbr.idfsBaseReference
		                                        FROM trtBaseReference tbr 
												WHERE tbr.idfsReferenceType = 19000041 
													AND tbr.intRowStatus = 0
												)
		
		DECLARE @Hospital BIGINT = CASE WHEN @HospitalizationStatus = 5350000000 /*Hospital*/ THEN @LocalOffice ELSE NULL END
		DECLARE @YNHospitalization BIGINT = CASE WHEN @HospitalizationStatus = 5350000000 /*Hospital*/ THEN 10100001 /*Yes*/ ELSE NULL END
		DECLARE @DateOfDischarge DATETIME = CASE WHEN @Outcome = 10760000000 /*Recovered*/ THEN @RandomDate ELSE NULL END
		DECLARE @SentByOffice BIGINT = (SELECT tp.idfInstitution FROM tlbPerson tp WHERE tp.idfPerson = @SentByPerson)
		
		EXEC spHumanCase_Post 
			@idfCase=@p1
			,@idfOutbreak=NULL
			,@datEnteredDate=@datFieldCollectionDate
			,@strCaseID=@p102
			,@uidOfflineCaseID = @uidOfflineCaseID
			,@idfsCaseProgressStatus=@CaseStatus
			,@idfsFinalState=@FinalState
			,@idfsHospitalizationStatus=@HospitalizationStatus
			,@idfsHumanAgeType=10042003 /*Years*/
			,@idfsYNAntimicrobialTherapy=NULL
			,@idfsYNHospitalization=@YNHospitalization
			,@idfsYNSpecimenCollected=10100001 /*Yes*/
			,@idfsYNRelatedToOutbreak=NULL
			,@idfsYNTestsConducted=NULL
			,@idfsOutcome=@Outcome
			,@idfsTentativeDiagnosis=@idfsTentativeDiagnosis
			,@idfsFinalDiagnosis=@idfsFinalDiagnosis
			,@idfsInitialCaseStatus=NULL
			,@idfsFinalCaseStatus=@FinalStatus
			,@idfSentByOffice=@SentByOffice
			,@idfReceivedByOffice=@LocalOffice
			,@idfInvestigatedByOffice=@LocalOffice
			,@idfPointGeoLocation=@p2
			,@idfEpiObservation=@p3
			,@idfsEPIFormTemplate=@p11
			,@idfCSObservation=@p4
			,@idfsCSFormTemplate=@p10
			,@datNotificationDate=@datNotificationDate
			,@datCompletionPaperFormDate=NULL
			,@datFirstSoughtCareDate=NULL
			,@datModificationDate=@datFieldCollectionDate
			,@datHospitalizationDate=NULL
			,@datFacilityLastVisit=@datFacilityLastVisit
			,@datExposureDate=NULL
			,@datDischargeDate=@DateOfDischarge
			,@datOnsetDate=@datDiagnosis
			,@datInvestigationStartDate=NULL
			,@datTentativeDiagnosisDate=@datDiagnosis
			,@datFinalDiagnosisDate=@datDiagnosis
			,@strNote=NULL
			,@strCurrentLocation=NULL
			,@strHospitalizationPlace=NULL
			,@strLocalIdentifier=@LocalIdentifier
			,@idfSoughtCareFacility=NULL
			,@idfSentByPerson=@SentByPerson
			,@strSentByFirstName=NULL
			,@strSentByPatronymicName=NULL
			,@strSentByLastName=NULL
			,@idfReceivedByPerson=@person
			,@strReceivedByFirstName=NULL
			,@strReceivedByPatronymicName=NULL
			,@strReceivedByLastName=NULL
			,@idfInvestigatedByPerson=NULL
			,@strEpidemiologistsName=NULL
			,@idfsNotCollectedReason=NULL
			,@idfsNonNotifiableDiagnosis = NULL
			,@intPatientAge=@CalcAge
			,@blnClinicalDiagBasis=0
			,@blnLabDiagBasis = 1
			,@blnEpiDiagBasis = 0
			,@strClinicalNotes=NULL
			,@strSummaryNotes=NULL
			,@idfHuman = @p5
			,@idfPersonEnteredBy = @person
			,@idfsOccupationType=NULL
			,@idfRegistrationAddress = @p6
			,@datDateOfDeath=NULL
			,@strRegistrationPhone=NULL
			,@strWorkPhone=NULL
			,@blnPermantentAddressAsCurrent=1
			,@strSampleNotes=NULL
			,@datFinalCaseClassificationDate = @datDiagnosis
			,@idfHospital = @Hospital
			,@blnCheckPermissions = 0
----Human Case END		
	
	
	
----Contacts BEGIN----		
	DECLARE @1ContactName NVARCHAR(20) = ISNULL(@FirstContactName, N'Contact1')
	
	DECLARE @p118 BIGINT 
	EXEC spsysGetNewID @ID=@p118 OUTPUT 

	DECLARE @p119 BIGINT 
	EXEC spsysGetNewID @ID=@p119 OUTPUT 

	DECLARE @p120 BIGINT 
	EXEC spsysGetNewID @ID=@p120 OUTPUT 

	DECLARE @p121 BIGINT
	EXEC dbo.spAudit_CreateNewEvent 
		@idfsDataAuditEventType=10016001 /*Create*/
		,@idfsDataAuditObjectType=10017036 /*Patient*/
		,@strMainObjectTable=75600000000 /*tlbHuman (Human/Patient)*/
		,@idfsMainObject=@p118
		,@strReason=NULL
		,@idfDataAuditEvent=@p121 OUTPUT

	EXEC spAddress_Post 
		@idfGeoLocation=@p119
		,@idfsCountry=@LocalCountry
		,@idfsRegion=NULL
		,@idfsRayon=NULL
		,@idfsSettlement=NULL
		,@strApartment=NULL
		,@strBuilding=NULL
		,@strStreetName=NULL
		,@strHouse=NULL
		,@strPostCode=NULL
		,@blnForeignAddress=0
		,@strForeignAddress=NULL
		,@blnGeoLocationShared=1

	EXEC spAddress_Post 
		@idfGeoLocation=@p120
		,@idfsCountry=@LocalCountry
		,@idfsRegion=NULL
		,@idfsRayon=NULL
		,@idfsSettlement=NULL
		,@strApartment=NULL
		,@strBuilding=NULL
		,@strStreetName=NULL
		,@strHouse=NULL
		,@strPostCode=NULL
		,@blnForeignAddress=0
		,@strForeignAddress=NULL
		,@blnGeoLocationShared=1

	EXEC spPatient_Post 
		@idfHuman=@p118
		,@idfRootHuman=NULL
		,@idfCase=NULL
		,@idfsOccupationType=NULL
		,@idfsNationality=NULL
		,@idfsHumanGender=NULL
		,@idfCurrentResidenceAddress=@p119
		,@idfEmployerAddress=@p120
		,@idfRegistrationAddress=NULL
		,@datDateofBirth=NULL
		,@datDateOfDeath=NULL
		,@strLastName=@1ContactName
		,@strSecondName=NULL
		,@strFirstName=NULL
		,@strRegistrationPhone=NULL
		,@strEmployerName=NULL
		,@strHomePhone=NULL
		,@strWorkPhone=NULL
		,@idfsPersonIDType = NULL
		,@strPersonID = NULL
		,@datEnteredDate = NULL
		,@datModificationDate = NULL

	EXEC dbo.spClearContextData 
		@ClearEventID=0
		,@ClearDataAuditEvent=1
	
	DECLARE @Event BIGINT
	SET @Event = NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString=N'Human'
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event OUTPUT

	
	DECLARE @p117 BIGINT 
	EXEC spsysGetNewID @ID=@p117 OUTPUT 

	EXEC spPatient_CreateCopyOfRoot 
		@idfHuman=@p117
		,@idfRootHuman=@p118
		,@idfCase=NULL


	DECLARE @p116 BIGINT
	EXEC spsysGetNewID @ID=@p116 OUTPUT
	
	EXEC spContactedCasePerson_Post 
		@idfContactedCasePerson=@p116
		,@idfHumanCase=@p1
		,@idfHuman=@p117
		,@idfsPersonContactType=430000000 /*Family*/
		,@datDateOfLastContact=@RandomDate
		,@strPlaceInfo=NULL
		,@strComments=NULL
		
		
		
		
	DECLARE @2ContactName NVARCHAR(20) = ISNULL(@SecondContactName, N'Contact2')
	
	DECLARE @p218 BIGINT 
	EXEC spsysGetNewID @ID=@p218 OUTPUT 

	DECLARE @p219 BIGINT 
	EXEC spsysGetNewID @ID=@p219 OUTPUT 

	DECLARE @p220 BIGINT 
	EXEC spsysGetNewID @ID=@p220 OUTPUT 

	DECLARE @p221 BIGINT
	EXEC dbo.spAudit_CreateNewEvent 
		@idfsDataAuditEventType=10016001 /*Create*/
		,@idfsDataAuditObjectType=10017036 /*Patient*/
		,@strMainObjectTable=75600000000 /*tlbHuman (Human/Patient)*/
		,@idfsMainObject=@p218
		,@strReason=NULL
		,@idfDataAuditEvent=@p221 OUTPUT

	EXEC spAddress_Post 
		@idfGeoLocation=@p219
		,@idfsCountry=@LocalCountry
		,@idfsRegion=NULL
		,@idfsRayon=NULL
		,@idfsSettlement=NULL
		,@strApartment=NULL
		,@strBuilding=NULL
		,@strStreetName=NULL
		,@strHouse=NULL
		,@strPostCode=NULL
		,@blnForeignAddress=0
		,@strForeignAddress=NULL
		,@blnGeoLocationShared=1

	EXEC spAddress_Post 
		@idfGeoLocation=@p220
		,@idfsCountry=@LocalCountry
		,@idfsRegion=NULL
		,@idfsRayon=NULL
		,@idfsSettlement=NULL
		,@strApartment=NULL
		,@strBuilding=NULL
		,@strStreetName=NULL
		,@strHouse=NULL
		,@strPostCode=NULL
		,@blnForeignAddress=0
		,@strForeignAddress=NULL
		,@blnGeoLocationShared=1

	EXEC spPatient_Post 
		@idfHuman=@p218
		,@idfRootHuman=NULL
		,@idfCase=NULL
		,@idfsOccupationType=NULL
		,@idfsNationality=NULL
		,@idfsHumanGender=NULL
		,@idfCurrentResidenceAddress=@p219
		,@idfEmployerAddress=@p220
		,@idfRegistrationAddress=NULL
		,@datDateofBirth=NULL
		,@datDateOfDeath=NULL
		,@strLastName=@2ContactName
		,@strSecondName=NULL
		,@strFirstName=NULL
		,@strRegistrationPhone=NULL
		,@strEmployerName=NULL
		,@strHomePhone=NULL
		,@strWorkPhone=NULL
		,@idfsPersonIDType = NULL
		,@strPersonID = NULL
		,@datEnteredDate = NULL
		,@datModificationDate = NULL

	EXEC dbo.spClearContextData 
		@ClearEventID=0
		,@ClearDataAuditEvent=1
	
	SET @Event = NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString=N'Human'
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event OUTPUT

	
	DECLARE @p217 BIGINT 
	EXEC spsysGetNewID @ID=@p217 OUTPUT 

	EXEC spPatient_CreateCopyOfRoot 
		@idfHuman=@p217
		,@idfRootHuman=@p218
		,@idfCase=NULL


	DECLARE @p216 BIGINT
	EXEC spsysGetNewID @ID=@p216 OUTPUT
	
	EXEC spContactedCasePerson_Post 
		@idfContactedCasePerson=@p216
		,@idfHumanCase=@p1
		,@idfHuman=@p217
		,@idfsPersonContactType=430000000 /*Family*/
		,@datDateOfLastContact=@RandomDate
		,@strPlaceInfo=NULL
		,@strComments=NULL
--Contacts END----


----Samples BEGIN	
		DECLARE @s INT = 0
		
		SET @SampleCnt = ISNULL(@SampleCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

		WHILE @s < @SampleCnt
		BEGIN
			SET @s = @s + 1
			
			DECLARE @SampleFieldBarCode NVARCHAR(8) = LEFT(NEWID(), 8)
			
			SELECT TOP 1
				@idfsSpecimenType = tst.idfsSampleType 
			FROM trtSampleType tst 
			WHERE (@LocalCustomizationPackage = 51577400000000/*Armenia*/
					OR EXISTS (SELECT * FROM trtMaterialForDisease WHERE idfsSampleType = tst.idfsSampleType AND intRowStatus = 0 AND idfsDiagnosis = @idfsFinalDiagnosis)
					)
			ORDER BY NEWID()

			DECLARE @p103 BIGINT
			EXEC spLabSample_Create 
				@idfMaterial=@p103 OUTPUT
				,@strFieldBarcode= @SampleFieldBarCode
				,@idfsSampleType=@idfsSpecimenType
				,@idfParty=@p5
				,@idfCase=@p1
				,@idfMonitoringSession=NULL
				,@idfVectorSurveillanceSession=NULL
				,@datFieldCollectionDate=@datFieldCollectionDate
				,@datFieldSentDate=@datFieldCollectionDate
				,@idfFieldCollectedByOffice=NULL
				,@idfFieldCollectedByPerson=NULL
				,@idfSendToOffice=@LocalOffice
				,@idfMainTest=NULL
				,@strNote=NULL
				,@idfsBirdStatus=NULL
				
				
				
			IF @FinalStatus <> 380000000 /*Suspect*/
			BEGIN
				----AccesionIn Sample BEGIN--
				DECLARE @DAEAccesionIn BIGINT
				EXEC dbo.spAudit_CreateNewEvent 
					@idfsDataAuditEventType=10016003 /*Edit*/
					,@idfsDataAuditObjectType=10017013 /*Check In*/
					,@strMainObjectTable=75620000000 /*tlbMaterial*/
					,@idfsMainObject=@p103 /*idfMaterial*/
					,@strReason=NULL
					,@idfDataAuditEvent=@DAEAccesionIn OUTPUT

				EXEC spLabSample_Update 
					@idfMaterial=@p103
					,@strFieldBarcode=@SampleFieldBarCode
					,@idfsSampleType=@idfsSpecimenType
					,@idfParty=@p5
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
					@idfMaterial=@p103
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
				
				
				IF ISNULL(@CreateTransferOutMaterial, 0) = 1 AND @s = 3 /*���������� ������� �������� ��������� � ������� Accessioned In 
																			��� ������ ��������� ������ Transferred Out*/
				BEGIN 
					DECLARE @Barcode NVARCHAR(200)
					EXEC dbo.spGetNextNumber 
						@NextNumberName=10057026 /*Sample Transfer Barcode*/
						,@NextNumberValue=@Barcode OUTPUT
						,@InstallationSite=NULL

					DECLARE @TransferOut BIGINT
					EXEC dbo.spsysGetNewID @ID=@TransferOut OUTPUT
					
					DECLARE @SendDate DATETIME = DATEADD(DAY, 5, @datFieldCollectionDate)
					
					IF ISNULL(@TransferSendToOffice, 0) = 0
					SET @TransferSendToOffice = @SentByOffice

					EXEC dbo.spLabSampleTransfer_Post 
						@Action=4
						,@idfTransferOut=@TransferOut
						,@strBarcode=@Barcode
						,@strNote=N''
						,@idfSendFromOffice= @LocalOffice
						,@idfSendToOffice=@TransferSendToOffice
						,@idfSendByPerson=@person
						,@datSendDate=@SendDate
						,@idfsTransferStatus=10001003/*In progress*/

					EXEC dbo.spLabSampleTransfer_Send 
						@idfMaterial=@p103
						,@idfSendToOffice=@TransferSendToOffice
						,@datSendDate=@SendDate
						
					EXEC dbo.spLabSampleTransfer_Manage 
						@idfTransferOut=@TransferOut
						,@idfMaterial=@p103
						,@add=1

				END
				ELSE
				BEGIN
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
							AND intHACode & 2 = 2
						ORDER BY NEWID()
						
						IF ISNULL(@idfsTestName, '') <> ''
						BEGIN
							DECLARE @TestStatus BIGINT
							
							IF @s = 1 AND @t = 1 AND ISNULL(@AmendedTestStatus, 0) = 1
								SELECT TOP 1
									@TestStatus = tbr.idfsBaseReference
								FROM trtBaseReference tbr
								WHERE tbr.idfsReferenceType = 19000001
									AND tbr.intRowStatus = 0
									AND tbr.strDefault IN ('Amended')
								ORDER BY NEWID()
							ELSE				
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
								,@idfsMainObject=@p103
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
								,@idfMaterial=@p103
								,@idfObservation=@Observation
								,@strNote=NULL
								,@datStartedDate=@StartedDate
								,@datConcludedDate=@StartedDate
								,@idfTestedByOffice= @LocalOffice
								,@idfTestedByPerson= @person
								,@idfResultEnteredByOffice=@LocalOffice
								,@idfResultEnteredByPerson=@person
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
							
							IF @TestStatus = 10001006 /*Amended*/
							BEGIN
								DECLARE @TestResultNew BIGINT
								SELECT TOP 1
									@TestResultNew = idfsBaseReference
								FROM trtBaseReference 
								WHERE idfsReferenceType = 19000096 /*Test Result*/
									AND intRowStatus = 0
									AND idfsBaseReference <> @TestResult
								ORDER BY NEWID() 
								
								DECLARE @ValidatedByPerson BIGINT = (
																		SELECT TOP 1 
																			idfPerson 
																		FROM tlbPerson
																		WHERE idfInstitution = @LocalOffice
																			AND intRowStatus = 0
																			AND idfPerson <> @person
																	)
								
								EXEC spLabTestEditable_Post 
									@Action=16
									,@idfTesting=@Testing
									,@idfsTestStatus=@TestStatus
									,@idfsTestName=@idfsTestName
									,@idfsTestResult=@TestResultNew
									,@idfsTestCategory=@TestCategory
									,@idfsDiagnosis=@idfsFinalDiagnosis
									,@idfMaterial=@p103
									,@idfObservation=@Observation
									,@strNote=NULL
									,@datStartedDate=@StartedDate
									,@datConcludedDate=@StartedDate
									,@idfTestedByOffice=@LocalOffice
									,@idfTestedByPerson=@person
									,@idfResultEnteredByOffice=@LocalOffice
									,@idfResultEnteredByPerson=@person
									,@idfValidatedByOffice=@LocalOffice
									,@idfValidatedByPerson=@ValidatedByPerson
									,@idfsFormTemplate=@TestFormTemplate
									,@blnNonLaboratoryTest=0
									,@blnExternalTest=0
									,@datReceivedDate=NULL
									,@idfPerformedByOffice=NULL
									,@strContactPerson=NULL
									,@blnIsMainSampleTest=NULL
									
									
								DECLARE @TestAmendmentHistoryId BIGINT
								EXEC spsysGetNewID @ID = @TestAmendmentHistoryId OUTPUT
								
								EXEC spLabTestAmendmentHistory_Post 
									@idfTestAmendmentHistory=@TestAmendmentHistoryId
									,@datAmendmentDate=@datFieldCollectionDate
									,@idfsOldTestResult=@TestResult
									,@idfsNewTestResult=@TestResultNew
									,@strOldNote=NULL
									,@strNewNote=NULL
									,@strReason=N'Reactant issue'
									,@idfTesting=@Testing
									,@idfAmendByOffice=@LocalOffice
									,@idfAmendByPerson=@ValidatedByPerson
							END
						END
					END
					----Test END
				END
			END
		END

		EXEC spLabSampleReceive_ModifyCase 
			@idfCase=@p1
			,@strSampleNotes=NULL	
----Samples END----



		DECLARE @Param BIGINT = 0
		DECLARE @p INT = 0
		DECLARE @ParamCntLocal INT
		SET @ParamCntLocal = ISNULL(@ParamCnt/2, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) x ORDER BY NEWID()))

		WHILE @p < @ParamCntLocal
		BEGIN
			SET @p = @p + 1
----CS----			
			IF EXISTS 
			(
				SELECT
					fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p10
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
			)
			BEGIN 
				
				DECLARE @p30 BIGINT 
				EXEC spsysGetNewID @ID=@p30 OUTPUT 
				
				SELECT TOP 1
					@Param = fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p10
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
				ORDER BY NEWID()
					
				DECLARE @p105 BIGINT 
				SET @p105=@p30
				EXEC dbo.spFFSaveActivityParameters 
					@idfsParameter=@Param
					,@idfObservation=@p4
					,@idfsFormTemplate=@p10
					,@varValue=@p105
					,@idfRow=@p105 OUTPUT
					,@IsDynamicParameter=0

			END
----CS----

----EPI----			
			IF EXISTS 
			(
				SELECT
					fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p11
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
			)
			BEGIN 
				
				DECLARE @p301 BIGINT 
				EXEC spsysGetNewID @ID=@p301 OUTPUT 
				
				SELECT TOP 1
					@Param = fpft.idfsParameter
				FROM ffParameterForTemplate fpft 
				JOIN ffParameter fp ON
					fp.idfsParameter = fpft.idfsParameter
				WHERE fpft.idfsFormTemplate = @p11
					AND fp.idfsEditor IN (10067006 /*Memo Box*/, 10067008/*Text Box*/)
				ORDER BY NEWID()
					
				DECLARE @p1051 BIGINT 
				SET @p1051=@p301
				EXEC dbo.spFFSaveActivityParameters 
					@idfsParameter=@Param
					,@idfObservation=@p3
					,@idfsFormTemplate=@p11
					,@varValue=@p1051
					,@idfRow=@p1051 OUTPUT
					,@IsDynamicParameter=0

			END
----EPI----
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
		,@strInformationString=@StreetName
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event OUTPUT

	SET @Event=NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString=N'PostalCode'
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event output

	SET @Event=NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025002 /*Reference Table Changed*/
		,@idfObjectID=NULL
		,@strInformationString=N'Human'
		,@strNote=N''
		,@ClientID=@ContextString
		,@intProcessed=0
		,@idfUserID=@user
		,@EventID=@Event OUTPUT 

	EXEC spEventLog_EventForObjectExists 
		@idfsEventTypeID=10025010 /*New Human Case*/
		,@idfObject=@p1

	SET @Event=NULL
	EXEC spEventLog_CreateNewEvent 
		@idfsEventTypeID=10025010 /*New Human Case*/
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

