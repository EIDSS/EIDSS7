
--##SUMMARY Procedure produces a set of syndromic surveillances with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 06.02.2014

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateSyndromicSurveillance 
	@SSCnt = 10000
	, @my_SiteID = 1100
	, @LastName = NULL
	, @FirstName = NULL
	, @Age = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @StreetName = NULL
	, @StartDate = '2013-01-01 12:00:00:00'
	, @DateRange = 100
	, @LocalUserName = 'EIDSS Web Server Administrator'
	, @EmployerName = NULL
	, @HumanGender = NULL
*/

CREATE PROC [dbo].[sptemp_CreateSyndromicSurveillance](
	@SSCnt INT,							--##PARAM @SSCnt - the number of syndromic surveillances to generate
	@my_SiteID INT,						--##PARAM @my_SiteID - site id for syndromic surveillances generation
	@LastName NVARCHAR(255) = NULL,		--##PARAM @LastName - lastname of the patient
	@FirstName NVARCHAR(255) = NULL,	--##PARAM @FirstName - first name of the patient
	@Age INT = NULL,					--##PARAM @Age - age of the patient
	@Region BIGINT = NULL,				--##PARAM @Region - region id of the patient
	@Rayon BIGINT = NULL,				--##PARAM @Rayon - rayon id of the patient
	@StreetName NVARCHAR(200) = NULL,	--##PARAM @StreetName - street name of the patient
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name
	@EmployerName NVARCHAR(200) = NULL,	--##PARAM @EmployerName - employer name
	@HumanGender BIGINT = NULL			--##PARAM @HumanGender - gender of the patient
)
AS


SET NOCOUNT ON;

DECLARE @LocalSite BIGINT
	, @LocalCountry BIGINT
	, @idfHospital BIGINT
SET @LocalSite=@my_SiteID

SELECT 
	@LocalCountry = tcpac.idfsCountry 
	, @idfHospital = ts.idfOffice
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
DECLARE @idfEnteredBy BIGINT

DECLARE @PatientLastName NVARCHAR(255)
DECLARE @PatientFirstName NVARCHAR(255)
DECLARE @EmployerNameLocal NVARCHAR(255)
DECLARE @HomePhone NVARCHAR(255)
DECLARE @WorkPhone NVARCHAR(255)

DECLARE @datEnteredDate DATETIME
DECLARE @datDateOfSymptomsOnset DATETIME 
DECLARE @RandomDate as DATETIME

DECLARE @blnRespiratorySystem BIT
	, @blnAsthma BIT
	, @blnDiabetes BIT
	, @blnCardiovascular BIT
	, @blnObesity BIT
	, @blnRenal BIT
	, @blnLiver BIT
	, @blnNeurological BIT
	, @blnImmunodeficiency BIT
	, @blnUnknownEtiology BIT


DECLARE @i INT = 0

WHILE @i < @SSCnt
BEGIN
	SET @i = @i + 1
	
	RandomDateSet:
	SET @RandomDate=DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)
	IF @RandomDate >= GETDATE()
		GOTO RandomDateSet
		
	SET @datEnteredDate = @RandomDate			
	SET @datDateOfSymptomsOnset = DATEADD(DAY, CAST(RAND()*@DateRange AS INT) * -1, @datEnteredDate)
		
	
	
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
	
	SELECT TOP 1
		@idfEnteredBy = tp.idfPerson
	FROM tlbPerson tp
	WHERE tp.intRowStatus = 0
		AND tp.idfInstitution = @idfHospital
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
	
	
	BEGIN TRAN

		DECLARE @pBasicSyndromicSurveillance BIGINT
		EXEC spsysGetNewID @ID=@pBasicSyndromicSurveillance OUTPUT

		DECLARE @pNewEvent BIGINT
		EXEC dbo.spAudit_CreateNewEvent 
			@idfsDataAuditEventType=10016001 /*Create*/
			,@idfsDataAuditObjectType=10017069 /*Vector Surveillance Session*/ --?
			,@strMainObjectTable=4575210000000 /*tlbVectorSurveillanceSession*/ --?
			,@idfsMainObject=@pBasicSyndromicSurveillance
			,@strReason=NULL
			,@idfDataAuditEvent=@pNewEvent OUTPUT

		DECLARE @PCode AS VARCHAR(10)
		SET @PCode=CAST(CAST(RAND()*10000 AS INT) AS VARCHAR)

----CurrentResidenceAddress BEGIN--
		DECLARE @pCurrentResidenceAddress BIGINT 
		EXEC spsysGetNewID @ID=@pCurrentResidenceAddress OUTPUT
		
		EXEC spAddress_Post 
			@idfGeoLocation=@pCurrentResidenceAddress
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
		DECLARE @pEmployerAddress BIGINT 
		EXEC spsysGetNewID @ID=@pEmployerAddress OUTPUT 

		EXEC spAddress_Post 
			@idfGeoLocation=@pEmployerAddress
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
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
----EmployerAddress END--	

----RegistrationAddress BEGIN--	
		DECLARE @pRegistrationAddress BIGINT 
		EXEC spsysGetNewID @ID=@pRegistrationAddress OUTPUT 

		EXEC spAddress_Post 
			@idfGeoLocation=@pRegistrationAddress
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
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
----RegistrationAddress END--			
			
		
		
		DECLARE @CalcAge AS INT
		SET @CalcAge = ISNULL(@Age, CAST(RAND()*70 AS INT) + 1)
		
		DECLARE @DOB AS DATETIME
		SET @DOB = DATEADD(YEAR, -1*@CalcAge, DATEADD(MONTH, -1, @RandomDate))

----Patient BEGIN----
		DECLARE @pHuman BIGINT 
		EXEC spsysGetNewID @ID=@pHuman OUTPUT
		
		DECLARE @pRootHuman BIGINT 
		EXEC spsysGetNewID @ID=@pRootHuman OUTPUT
		
		SET @HumanGender = ISNULL(@HumanGender, 10043002/*Male*/)

		EXEC spPatient_Post 
			@idfHuman=@pHuman
			,@idfRootHuman=@pRootHuman
			,@idfCase=0
			,@idfsOccupationType=NULL
			,@idfsNationality=NULL
			,@idfsHumanGender=@HumanGender
			,@idfCurrentResidenceAddress=@pCurrentResidenceAddress
			,@idfEmployerAddress=@pEmployerAddress
			,@idfRegistrationAddress=@pRegistrationAddress
			,@datDateofBirth=@DOB
			,@datDateOfDeath=NULL
			,@strLastName=@PatientLastName
			,@strSecondName=NULL
			,@strFirstName=@PatientFirstName
			,@strRegistrationPhone=NULL
			,@strEmployerName= @EmployerNameLocal
			,@strHomePhone=@HomePhone
			,@strWorkPhone=@WorkPhone
			,@idfsPersonIDType = NULL
			,@strPersonID = NULL
			,@datEnteredDate = NULL
			,@datModificationDate = NULL
----Patient END----


----BasicSyndromicSurveillance BEGIN----	
		SELECT TOP 1 @blnRespiratorySystem = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnAsthma = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnDiabetes = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnCardiovascular = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnObesity = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnRenal = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnLiver = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnNeurological = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnImmunodeficiency = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		SELECT TOP 1 @blnUnknownEtiology = x FROM (SELECT 0 x UNION SELECT 1) a ORDER BY NEWID()
		
		DECLARE @BasicSyndromicSurveillanceType BIGINT = (
															SELECT TOP 1
																tbr.idfsBaseReference
															FROM trtBaseReference tbr
															WHERE tbr.idfsReferenceType = 19000159 /*Basic Syndromic Surveillance - Type*/
																AND tbr.intRowStatus = 0
															ORDER BY NEWID()
														)
		
		DECLARE @Outcome BIGINT = (
									SELECT TOP 1
										tbr.idfsBaseReference
									FROM trtBaseReference tbr
									WHERE tbr.idfsReferenceType = 19000064 /*Outcome*/
										AND tbr.intRowStatus = 0
									ORDER BY NEWID()
								)
		
		
		DECLARE @YNPatientWasInER BIGINT = (
												SELECT TOP 1
													tbr.idfsBaseReference
												FROM trtBaseReference tbr
												WHERE tbr.idfsReferenceType = 19000100 /*Yes/No Value List*/
													AND tbr.intRowStatus = 0
												ORDER BY NEWID()
											)
		DECLARE @YNTreatment  BIGINT = (
												SELECT TOP 1
													tbr.idfsBaseReference
												FROM trtBaseReference tbr
												WHERE tbr.idfsReferenceType = 19000100 /*Yes/No Value List*/
													AND tbr.intRowStatus = 0
												ORDER BY NEWID()
											)
		DECLARE @TestResult BIGINT = CASE 
										WHEN @Outcome = 10770000000 /*Died*/ 
											THEN (SELECT tbr.idfsBaseReference FROM trtBaseReference tbr WHERE tbr.idfsBaseReference = 808040000000/*Positive*/ AND tbr.intRowStatus = 0)
										ELSE (SELECT TOP 1 tbr.idfsBaseReference FROM trtBaseReference tbr WHERE tbr.idfsReferenceType = 19000096 AND tbr.intRowStatus = 0 ORDER BY NEWID())
									END
		
		DECLARE @YNPregnant BIGINT = CASE WHEN @HumanGender = 10043002/*Male*/ THEN 10100002/*No*/ 
											ELSE (SELECT TOP 1 tbr.idfsBaseReference FROM trtBaseReference tbr WHERE tbr.idfsReferenceType = 19000100 /*Yes/No Value List*/ AND tbr.intRowStatus = 0 ORDER BY NEWID())
		                             END
		DECLARE @YNPostpartumPeriod BIGINT = CASE WHEN @YNPregnant = 10100001/*Yes*/ OR @HumanGender = 10043002/*Male*/ THEN NULL
												ELSE (SELECT TOP 1 tbr.idfsBaseReference FROM trtBaseReference tbr WHERE tbr.idfsReferenceType = 19000100 /*Yes/No Value List*/ AND tbr.intRowStatus = 0 ORDER BY NEWID())                      
											END
		  
		DECLARE @SampleID NVARCHAR(8) = LEFT(NEWID(), 8)  
		                             
		EXEC spBasicSyndromicSurveillance_Post 
			@Action=4
			,@idfBasicSyndromicSurveillance=@pBasicSyndromicSurveillance
			,@strFormID=N'(new)'
			,@datDateEntered=@datEnteredDate
			,@idfEnteredBy=@idfEnteredBy
			,@idfsSite=@LocalSite
			,@idfsBasicSyndromicSurveillanceType=@BasicSyndromicSurveillanceType
			,@idfHospital=@idfHospital
			,@datReportDate=@datEnteredDate
			,@intAgeYear=@CalcAge
			,@intAgeMonth=NULL
			,@strPersonalID=NULL
			,@idfsYNPregnant=@YNPregnant
			,@idfsYNPostpartumPeriod=@YNPostpartumPeriod
			,@datDateOfSymptomsOnset=@datDateOfSymptomsOnset
			,@idfsYNFever=10100001
			,@idfsMethodOfMeasurement=50791950000000 /*Axillary*/
			,@strMethod=N''
			,@idfsYNCough=10100001
			,@idfsYNShortnessOfBreath=10100001
			,@idfsYNSeasonalFluVaccine=NULL
			,@datDateOfCare=@datDateOfSymptomsOnset
			,@idfsYNPatientWasHospitalized=10100001
			,@idfsOutcome=@Outcome
			,@idfsYNPatientWasInER=@YNPatientWasInER
			,@idfsYNTreatment=@YNTreatment
			,@idfsYNAdministratedAntiviralMedication=10100002 /*No*/
			,@strNameOfMedication=N''
			,@datDateReceivedAntiviralMedication=NULL
			,@blnRespiratorySystem=@blnRespiratorySystem
			,@blnAsthma=@blnAsthma
			,@blnDiabetes=@blnDiabetes
			,@blnCardiovascular=@blnCardiovascular
			,@blnObesity=@blnObesity
			,@blnRenal=@blnRenal
			,@blnLiver=@blnLiver
			,@blnNeurological=@blnNeurological
			,@blnImmunodeficiency=@blnImmunodeficiency
			,@blnUnknownEtiology=@blnUnknownEtiology
			,@datSampleCollectionDate=@datEnteredDate
			,@strSampleID=@SampleID
			,@idfsTestResult=@TestResult
			,@datTestResultDate=@datEnteredDate
			,@datModificationForArchiveDate=NULL
			,@idfHuman=@pHuman

----BasicSyndromicSurveillance END		
		
	IF @@ERROR <> 0
		ROLLBACK TRAN
	ELSE
		COMMIT TRAN
		
END

EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;

