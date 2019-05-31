
--##SUMMARY 

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 29.01.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateOutbreak 
	@OutbreakCnt = 1
	,@CaseCnt = 2
	, @my_SiteID = 1294
	, @Diagnosis = NULL
	, @Region = NULL
	, @Rayon = NULL
	, @Settlement = NULL
	, @LocalUserName = 'EIDSS Web Server Administrator'
	, @OutbreakStatus = NULL
*/

CREATE PROC [dbo].[sptemp_CreateOutbreak](
	@OutbreakCnt INT,						--##PARAM @OutbreakCnt - the number of outbreaks to generate
	@CaseCnt INT = NULL,					--##PARAM @OutbreakCnt - the number of cases to generate for each outbreak
	@my_SiteID INT,							--##PARAM @my_SiteID - site id for outbreaks generation
	@Diagnosis BIGINT = NULL,				--##PARAM @Diagnosis - ID of diagnosis
	@Region BIGINT = NULL,					--##PARAM @Region - ID of region
	@Rayon BIGINT = NULL,					--##PARAM @Rayon - ID of rayon
	@Settlement NVARCHAR(200) = NULL,		--##PARAM @Settlement - ID of settlement
	@LocalUserName NVARCHAR(200) = NULL,	--##PARAM @LocalUserName - user name
	@OutbreakStatus BIGINT = NULL			--##PARAM @OutbreakStatus - uotbreak status id
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

DECLARE @RegionLocal BIGINT
	, @RayonLocal BIGINT
	, @SettlementLocal BIGINT
	, @GroudTypeId BIGINT
	, @DiagnosisLocal BIGINT
	, @OutbreakStatusId BIGINT
	, @HumanCaseID BIGINT
	, @PrimaryCaseOrSession BIGINT
	, @StartDate DATETIME
	, @FinishDate DATETIME

DECLARE @i INT = 0

WHILE @i < @OutbreakCnt
BEGIN
	SET @i = @i + 1
	
	SELECT TOP 1 
		@RegionLocal = ISNULL(@Region, gr.idfsRegion)
	FROM gisRegion gr
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRegion
	WHERE gr.idfsCountry = @LocalCountry
		AND gbr.strDefault <> 'Other'
	ORDER BY NEWID()

	SELECT TOP 1 
		@RayonLocal = ISNULL(@Rayon, gr.idfsRayon)
	FROM gisRayon gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsRayon
	WHERE gr.idfsCountry = @LocalCountry 
		AND gr.idfsRegion = @RegionLocal
	ORDER BY NEWID()

	SELECT TOP 1 
		@SettlementLocal = ISNULL(@Settlement, gr.idfsSettlement)
	FROM gisSettlement gr 
	JOIN gisBaseReference gbr ON 
		gbr.idfsGISBaseReference = gr.idfsSettlement
	WHERE gr.idfsCountry = @LocalCountry 
		AND gr.idfsRegion = @RegionLocal
		AND gr.idfsRayon = @RayonLocal
	ORDER BY NEWID()
	
	SELECT TOP 1 
		@DiagnosisLocal = ISNULL(@Diagnosis, td.idfsDiagnosis)
	FROM trtDiagnosis td 
	JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = td.idfsDiagnosis
		AND intHACode&2 = 2
	WHERE td.idfsUsingType = 10020001 
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtMaterialForDisease tmfd WHERE tmfd.idfsDiagnosis = td.idfsDiagnosis AND tmfd.intRowStatus = 0))
		AND (@LocalCustomizationPackage = 51577400000000/*Armenia*/
				OR EXISTS (SELECT * FROM trtTestForDisease ttfd WHERE ttfd.idfsDiagnosis = td.idfsDiagnosis AND ttfd.intRowStatus = 0))
		AND (SELECT COUNT(*) FROM tlbHumanCase WHERE intRowStatus = 0 AND idfOutbreak IS NULL AND idfsFinalDiagnosis = td.idfsDiagnosis) > 1
	ORDER BY NEWID()
	
	IF @DiagnosisLocal IS NOT NULL AND (SELECT COUNT(*) FROM tlbHumanCase WHERE intRowStatus = 0 AND idfOutbreak IS NULL AND idfsFinalDiagnosis = @DiagnosisLocal) > 1
	BEGIN
		SELECT TOP 1
			@GroudTypeId = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000038/*Ground Type*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @GeoLocationId BIGINT
		EXEC spsysGetNewID @ID=@GeoLocationId OUTPUT
		EXEC spGeoLocation_Post 
			@idfGeoLocation=@GeoLocationId
			,@idfsGroundType=@GroudTypeId
			,@idfsGeoLocationType=10036004/*Relative Point*/
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@RegionLocal
			,@idfsRayon=@RayonLocal
			,@idfsSettlement=@SettlementLocal
			,@strDescription=NULL
			,@dblLatitude=NULL
			,@dblLongitude=NULL
			,@dblRelLatitude=NULL
			,@dblRelLongitude=NULL
			,@dblAccuracy=NULL
			,@dblDistance=NULL
			,@dblAlignment=NULL
			,@strForeignAddress=NULL
			,@blnGeoLocationShared=NULL
		
		SELECT TOP 1
			@OutbreakStatusId = ISNULL(@OutbreakStatus, tbr.idfsBaseReference)
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000063/*Outbreak Status*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		
		DECLARE @OutbreakId BIGINT
		EXEC spsysGetNewID @ID=@OutbreakId OUTPUT
		
		DECLARE @strOutbreakID NVARCHAR(200)
		EXEC spOutbreak_Post 
			@Action=4
			,@idfOutbreak=@OutbreakId
			,@idfsDiagnosisOrDiagnosisGroup=@DiagnosisLocal
			,@idfsOutbreakStatus=@OutbreakStatusId
			,@idfGeoLocation=@GeoLocationId
			,@strOutbreakID=@strOutbreakID OUTPUT
			,@datStartDate=NULL
			,@datFinishDate=NULL
			,@strDescription=NULL
			,@idfPrimaryCaseOrSession=NULL
			
		SET @StartDate = GETDATE()
		SET @PrimaryCaseOrSession = 0
		SET @FinishDate = '01.01.1990'
		
		DECLARE @cc INT = 0
		WHILE @cc < @CaseCnt
		BEGIN 
			SET @cc = @cc + 1		
			
			SELECT TOP 1
				@HumanCaseID = idfHumanCase
				, @PrimaryCaseOrSession = CASE WHEN datOnSetDate < @StartDate THEN idfHumanCase ELSE @PrimaryCaseOrSession END
				, @StartDate = CASE WHEN datOnSetDate < @StartDate THEN datOnSetDate ELSE @StartDate END
				, @FinishDate =CASE WHEN datEnteredDate > @FinishDate THEN datEnteredDate ELSE @FinishDate END
			FROM tlbHumanCase
			WHERE intRowStatus = 0 
				AND idfOutbreak IS NULL 
				AND idfsFinalDiagnosis = @DiagnosisLocal
			ORDER BY NEWID()
			
			EXEC spOutbreak_PostCaseList 
				@Action=4
				,@idfOutbreak=@OutbreakId
				,@idfCase=@HumanCaseID
		END

		UPDATE tlbOutbreak
		SET	idfPrimaryCaseOrSession = @PrimaryCaseOrSession
			, datStartDate = @StartDate
			, datFinishDate = @FinishDate
		WHERE idfOutbreak = @OutbreakId
	END
END

EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;
