
--##SUMMARY Procedure produces a set of Campaign with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 10.02.2016


--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_Campaign 
	@CampaignCnt = 1
	, @my_SiteID = 1100
	, @StartDate = '2015-01-01 12:00:00:00'
	, @DateRange = 100
	, @DiseaseAndSpeciesCnt = 3
	, @ASSessionCnt = 3
*/

CREATE PROC [dbo].[sptemp_Campaign](
	@CampaignCnt INT,					--##PARAM @ASSessionCnt - the number of ASSession to generate
	@my_SiteID INT,						--##PARAM @TestCnt - the number of tests to generate
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	@DiseaseAndSpeciesCnt INT = NULL,
	@SpeciesTypeId BIGINT = NULL,
	@SampleTypeId BIGINT = NULL,
	@DiagnosisId BIGINT = NULL,
	@CampaignAdministrator NVARCHAR(200) = NULL,
	@ASSessionCnt INT = NULL,
	@FarmOwnerLastName NVARCHAR(255) = NULL,		--##PARAM @LastName - lastname of the owner
	@FarmOwnerFirstName NVARCHAR(255) = NULL	--##PARAM @FirstName - first name of the owner
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


DECLARE @cmp INT = 0

WHILE @cmp < @CampaignCnt
BEGIN
	SET @cmp = @cmp + 1
	
	
	DECLARE @CampaignId BIGINT 
	EXEC spsysGetNewID @ID=@CampaignId OUTPUT	
	DECLARE @StrCampaignID NVARCHAR(50)
	
	DECLARE @CampaignTypeId BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000116 AND intRowStatus = 0 ORDER BY NEWID())

	SET @RandomDate = DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)
	SET @EndDate = DATEADD(DAY, 20, @RandomDate)
	
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
	
	DECLARE @CampaignName NVARCHAR(200)
	SET @CampaignName = (SELECT strDefault FROM trtBaseReference WHERE idfsBaseReference = @Diagnosis AND intRowStatus = 0)
	SET @CampaignName = @CampaignName + ' ' + (SELECT strDefault FROM trtBaseReference WHERE idfsBaseReference = @CampaignTypeId AND intRowStatus = 0)
	SET @CampaignName = @CampaignName + ' ' + CONVERT(NVARCHAR(30), @RandomDate, 120)
	
	EXEC spASCampaign_Post 
		@Action=4
		,@idfCampaign=@CampaignId OUTPUT
		,@idfsCampaignType=@CampaignTypeId
		,@idfsCampaignStatus=10140001 /*Open*/
		,@datCampaignDateStart=@RandomDate
		,@datCampaignDateEnd=@EndDate
		,@strCampaignID=@StrCampaignID OUTPUT
		,@strCampaignName=@CampaignName
		,@strCampaignAdministrator=@CampaignAdministrator
		,@strComments=NULL
		,@strConclusion=NULL

	
	DECLARE @d INT = 0
		
	SET @DiseaseAndSpeciesCnt = ISNULL(@DiseaseAndSpeciesCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

	WHILE @d < @DiseaseAndSpeciesCnt
	BEGIN
		SET @d = @d + 1

		DECLARE @CampaignToDiagnosis BIGINT
		EXEC spsysGetNewID @ID=@CampaignToDiagnosis OUTPUT
		
		DECLARE @PlannedNumber INT = (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) x ORDER BY NEWID())

		DECLARE @SpeciesType BIGINT
		SELECT TOP 1 
			@SpeciesType = ISNULL(@SpeciesTypeId, tbr.idfsBaseReference)
		FROM trtBaseReference tbr 
		WHERE tbr.idfsReferenceType = 19000086 /*SpeciesType*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode & 32 = 32
		ORDER BY NEWID()
			
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

		EXEC spASCampaignDiagnosis_Post 
			@Action=4
			,@idfCampaignToDiagnosis=@CampaignToDiagnosis OUTPUT
			,@idfCampaign=@CampaignId
			,@idfsDiagnosis=@Diagnosis
			,@intOrder=0
			,@idfsSpeciesType=@SpeciesType
			,@intPlannedNumber=@PlannedNumber
			,@idfsSampleType=@SampleType
	END
	
	
	DECLARE @ses INT = 0
		
	SET @ASSessionCnt = ISNULL(@ASSessionCnt, (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3) x ORDER BY NEWID()))

	WHILE @ses < @ASSessionCnt
	BEGIN
		SET @ses = @ses + 1
		
		SELECT TOP 1
			@SpeciesType = tctd.idfsSpeciesType
			, @SampleType = tctd.idfsSampleType
		FROM tlbCampaignToDiagnosis tctd
		WHERE tctd.idfCampaign = @CampaignId
		ORDER BY NEWID()
		

		EXEC sptemp_CreateASSession 
			@ASSessionCnt = 1
			, @InfoCnt = 2
			, @my_SiteID = @my_SiteID
			, @StartDate = @StartDate
			, @DateRange = @DateRange
			, @LocalUserName = @LocalUserName
			, @CampaignId = @CampaignId
			, @CampaignStartDate = @RandomDate
			, @CampaignEndDate = @EndDate
			, @LastName = @FarmOwnerLastName
			, @FirstName = @FarmOwnerFirstName
			, @SpeciesTypeId = @SpeciesType
			, @SampleTypeId = @SampleType
			, @DiagnosisId = @Diagnosis
	END
END

EXEC dbo.spSetContext @ContextString=''
