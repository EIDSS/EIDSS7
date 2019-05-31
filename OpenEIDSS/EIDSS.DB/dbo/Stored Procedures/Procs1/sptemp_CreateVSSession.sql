
--##SUMMARY

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 01.02.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateVSSession 
	@VSSCnt = 1
	, @InfoCnt = 4
	, @SampleCnt = 2
	, @my_SiteID = 1294
	, @Region = NULL
	, @Rayon = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
	, @DateRange = 100
	, @LocalUserName = 'EIDSS Web Server Administrator'
*/

CREATE PROC [dbo].[sptemp_CreateVSSession](
	@VSSCnt INT,						--##PARAM @VSSCnt - the number of vss to generate
	@InfoCnt INT,						--##PARAM @InfoCnt - the number of info to generate for each vss
	@SampleCnt INT,						--##PARAM @SampleCnt - the number of sample to generate for each vss
	@my_SiteID INT,						--##PARAM @my_SiteID - site id for case generation
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	@Region BIGINT = NULL,				--##PARAM @Region - region of the vss
	@Rayon BIGINT = NULL				--##PARAM @Rayon - rayon of the vss
)
AS

SET NOCOUNT ON;

DECLARE @LocalSite BIGINT
	, @LocalCountry BIGINT
	, @LocalOffice BIGINT
	, @LocalCustomization BIGINT
	
SET @LocalSite=@my_SiteID
SELECT 
	@LocalCountry = tcpac.idfsCountry 
	, @LocalOffice = ts.idfOffice
	, @LocalCustomization = tcpac.idfCustomizationPackage
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


DECLARE @RandomDate as DATETIME
	, @CloseDate DATETIME
	, @CollectionDate DATETIME
	, @DateIdentified DATETIME
DECLARE @idfsRegion BIGINT
	, @idfsRayon BIGINT
	, @idfsSettlement BIGINT
DECLARE @StatusProgressCnt INT = @VSSCnt / 100.0 * 20
	, @StatusProgressCntTotal INT = 0
	
DECLARE @idfsSpecimenType BIGINT


DECLARE @i INT = 0

WHILE @i < @VSSCnt
BEGIN
	SET @i = @i + 1

	SET @RandomDate=DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)
	SET @CloseDate = DATEADD(DAY, 5, @RandomDate)
	
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
	
	DECLARE @VectorSurveillanceSessionLocation BIGINT
	EXEC spsysGetNewID @ID=@VectorSurveillanceSessionLocation OUTPUT	
	EXEC spGeoLocation_Post 
		@idfGeoLocation=@VectorSurveillanceSessionLocation
		,@idfsGroundType=NULL
		,@idfsGeoLocationType=10036003/*Exact Point*/
		,@idfsCountry= @LocalCountry
		,@idfsRegion=@idfsRegion
		,@idfsRayon=@idfsRayon
		,@idfsSettlement=@idfsSettlement
		,@strDescription=N''
		,@dblLatitude=NULL
		,@dblLongitude=NULL
		,@dblRelLatitude=NULL
		,@dblRelLongitude=NULL
		,@dblAccuracy=NULL
		,@dblDistance=NULL
		,@dblAlignment=NULL
		,@strForeignAddress=N''
		,@blnGeoLocationShared=0
	
	DECLARE @Status BIGINT	
	IF @StatusProgressCntTotal <= @StatusProgressCnt
	BEGIN 
		SET @Status = 10310001/*In Process*/
		SET @StatusProgressCntTotal = @StatusProgressCntTotal + 1
		SET @CloseDate = NULL
	END
	ELSE
		SET @Status = 10310002/*Closed*/
		
	DECLARE @CollectionEffort INT = (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) x ORDER BY NEWID())

	DECLARE @FieldSessionID NVARCHAR(8) = LEFT(NEWID(), 8)
	
	DECLARE @VectorSurveillanceSessionID BIGINT 
	DECLARE @StrSessionID NVARCHAR(50)
	EXEC spVsSession_Post 
		@Action=4
		,@idfVectorSurveillanceSession=@VectorSurveillanceSessionID OUTPUT
		,@strSessionID=@StrSessionID OUTPUT
		,@strFieldSessionID=@FieldSessionID
		,@idfsVectorSurveillanceStatus=@Status
		,@datStartDate=@RandomDate
		,@datCloseDate=@CloseDate
		,@idfLocation=@VectorSurveillanceSessionLocation
		,@idfOutbreak=NULL
		,@strDescription=N''
		,@intCollectionEffort=@CollectionEffort
		
	
	DECLARE @DICnt INT = @InfoCnt / 2
	DECLARE @Mosquito BIT = 0
	
	DECLARE @di INT = 0
	WHILE @di < @DICnt
	BEGIN
		SET @di = @di + 1
		
		DECLARE @VectorLocation BIGINT
		EXEC spsysGetNewID @ID=@VectorLocation OUTPUT
		EXEC spGeoLocation_Post 
			@idfGeoLocation=@VectorLocation
			,@idfsGroundType=NULL
			,@idfsGeoLocationType=10036003/*Exact Point*/
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
			,@idfsRayon=@idfsRayon
			,@idfsSettlement=@idfsSettlement
			,@strDescription=N''
			,@dblLatitude=NULL
			,@dblLongitude=NULL
			,@dblRelLatitude=NULL
			,@dblRelLongitude=NULL
			,@dblAccuracy=NULL
			,@dblDistance=NULL
			,@dblAlignment=NULL
			,@strForeignAddress=N''
			,@blnGeoLocationShared=0
			
		DECLARE @VectorType BIGINT
		SELECT TOP 1
			@VectorType = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000140/*Vector type*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		IF @Mosquito = 0
		BEGIN
			SELECT TOP 1
				@VectorType = tbr.idfsBaseReference
			FROM trtBaseReference tbr
			WHERE tbr.idfsReferenceType = 19000140/*Vector type*/
				AND tbr.intRowStatus = 0
				AND tbr.strDefault = N'Mosquitos'
			ORDER BY NEWID()
			
			SET @Mosquito = 1
		END	
		
		DECLARE @VectorSubType BIGINT
		SELECT TOP 1
			@VectorSubType = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		JOIN trtVectorSubType tvst ON
			tvst.idfsVectorSubType = tbr.idfsBaseReference
			AND tvst.intRowStatus = 0
			AND tvst.idfsVectorType = @VectorType
		WHERE tbr.idfsReferenceType = 19000141/*Vector sub type*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @Surrounding BIGINT
		SELECT TOP 1
			@Surrounding = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000139/*Surrounding*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @CollectionMethod BIGINT
		SELECT TOP 1
			@CollectionMethod = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000135/*CollectionMethod*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode&128 = 128
		ORDER BY NEWID()
		
		DECLARE @BasisOfRecord BIGINT
		SELECT TOP 1
			@BasisOfRecord = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000137/*BasisOfRecord*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @Sex BIGINT
		SELECT TOP 1
			@Sex = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000007/*Sex*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode&128 = 128
		ORDER BY NEWID()
		
		DECLARE @IdentificationMethod BIGINT
		SELECT TOP 1
			@IdentificationMethod = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000138/*IdentificationMethod*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @Quantity INT = (SELECT TOP 1 a FROM (SELECT 5 a UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) x ORDER BY NEWID())
		
		DECLARE @Observation BIGINT
		EXEC dbo.spsysGetNewID @ID=@Observation OUTPUT
		
		DECLARE @FormTemplate BIGINT
		SELECT
			@FormTemplate = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000033
			AND tbr.strDefault = 'Mosquito Specific Data'
			AND tbr.intRowStatus = 0
			
		DECLARE @CollectionDay INT = (SELECT TOP 1 a FROM (SELECT 1 a UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) x ORDER BY NEWID())
		SET @CollectionDate = DATEADD(DAY, @CollectionDay, @RandomDate)
		SET @DateIdentified = DATEADD(DAY, -1, @CollectionDate)
		
		DECLARE @DayPeriod BIGINT = (SELECT TOP 1 idfsBaseReference FROM trtBaseReference WHERE idfsReferenceType = 19000136/*Collection time period*/ AND intRowStatus = 0 ORDER BY NEWID())
		
		DECLARE @FieldVectorID NVARCHAR(8) = LEFT(NEWID(), 8)
		
		DECLARE @VectorId BIGINT
		EXEC spsysGetNewID @ID=@VectorId OUTPUT
		EXEC spVector_Post 
			@Action=4
			,@idfVector=@VectorId
			,@idfVectorSurveillanceSession=@VectorSurveillanceSessionID
			,@idfHostVector=NULL
			,@strVectorID=NULL
			,@strFieldVectorID=@FieldVectorID
			,@idfLocation=@VectorLocation
			,@intElevation=100
			,@idfsSurrounding=@Surrounding
			,@strGEOReferenceSources=N''
			,@idfCollectedByOffice= @LocalOffice
			,@idfCollectedByPerson= @person
			,@datCollectionDateTime= @CollectionDate
			,@idfsCollectionMethod=@CollectionMethod
			,@idfsBasisOfRecord=@BasisOfRecord
			,@idfsVectorType=@VectorType
			,@idfsVectorSubType=@VectorSubType
			,@intQuantity=@Quantity
			,@idfsSex=@Sex
			,@idfIdentifiedByOffice=@LocalOffice
			,@idfIdentifiedByPerson=@person
			,@datIdentifiedDateTime= @DateIdentified
			,@idfsIdentificationMethod=@IdentificationMethod
			,@idfObservation=@Observation
			,@idfsFormTemplate=@FormTemplate
			,@idfsDayPeriod=@DayPeriod
			,@strComment=N''
			,@idfsEctoparasitesCollected=NULL
			
		IF EXISTS (SELECT * FROM trtBaseReference tbr WHERE tbr.idfsBaseReference = @VectorType AND tbr.intRowStatus = 0 AND tbr.strDefault = N'Mosquitos')	
		BEGIN
			
			DECLARE @Parameter BIGINT
				, @ParameterType BIGINT
			SELECT
				@Parameter = tbr.idfsBaseReference
				, @ParameterType = fp.idfsParameterType
			FROM trtBaseReference tbr
			JOIN ffParameter fp ON
				fp.idfsParameter = tbr.idfsBaseReference
				AND fp.intRowStatus = 0
			WHERE tbr.idfsReferenceType = 19000066
				AND tbr.strDefault = 'Mosquito feeding status'
				AND tbr.intRowStatus = 0
				
			DECLARE @Value BIGINT
			SELECT TOP 1
				@Value = fpfpv.idfsParameterFixedPresetValue
			FROM ffParameterFixedPresetValue fpfpv
			WHERE fpfpv.idfsParameterType = @ParameterType
				AND fpfpv.intRowStatus = 0
			ORDER BY NEWID()
			
			DECLARE @Row BIGINT = 0
			DECLARE @ActivityParameters BIGINT
			EXEC spsysGetNewID @ActivityParameters OUTPUT
			EXEC spFFSaveActivityParameters 
				@idfsParameter=@Parameter
				,@idfObservation=@Observation
				,@idfsFormTemplate=@FormTemplate
				,@varValue=@Value
				,@idfRow=@Row OUTPUT
				,@IsDynamicParameter=0
				,@idfActivityParameters=@ActivityParameters OUTPUT
				
			SELECT
				@Parameter = tbr.idfsBaseReference
				, @ParameterType = fp.idfsParameterType
			FROM trtBaseReference tbr
			JOIN ffParameter fp ON
				fp.idfsParameter = tbr.idfsBaseReference
				AND fp.intRowStatus = 0
			WHERE tbr.idfsReferenceType = 19000066
				AND tbr.strDefault = 'Mosquito life stage'
				AND tbr.intRowStatus = 0
				
			SELECT TOP 1
				@Value = fpfpv.idfsParameterFixedPresetValue
			FROM ffParameterFixedPresetValue fpfpv
			WHERE fpfpv.idfsParameterType = @ParameterType
				AND fpfpv.intRowStatus = 0
			ORDER BY NEWID()
			
			EXEC spsysGetNewID @ActivityParameters OUTPUT
			EXEC spFFSaveActivityParameters 
				@idfsParameter=@Parameter
				,@idfObservation=@Observation
				,@idfsFormTemplate=@FormTemplate
				,@varValue=@Value
				,@idfRow=@Row OUTPUT
				,@IsDynamicParameter=0
				,@idfActivityParameters=@ActivityParameters OUTPUT
		END
		
		
		
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
			JOIN trtBaseReference tbr ON
				tbr.idfsBaseReference = tst.idfsSampleType
				AND tbr.intRowStatus = 0
				AND tbr.intHACode&128 = 128
			/*JOIN trtSampleTypeForVectorType tstfvt ON
				tstfvt.idfsSampleType = tst.idfsSampleType
				AND tstfvt.idfsVectorType = @VectorType
				AND tstfvt.intRowStatus = 0*/
			ORDER BY NEWID()
				
			declare @MaterialId bigint
			EXEC spLabSample_Create 
				@idfMaterial=@MaterialId OUTPUT
				,@strFieldBarcode=@SampleFieldBarCode
				,@idfsSampleType=@idfsSpecimenType
				,@idfParty= @VectorId
				,@idfCase=NULL
				,@idfMonitoringSession=NULL
				,@idfVectorSurveillanceSession= @VectorSurveillanceSessionID
				,@datFieldCollectionDate=@CollectionDate
				,@datFieldSentDate=NULL
				,@idfFieldCollectedByOffice= @LocalOffice
				,@idfFieldCollectedByPerson= @person
				,@idfSendToOffice=NULL
				,@idfMainTest=NULL
				,@strNote=NULL
				,@idfsBirdStatus=NULL

		END
----Samples END----
		
		
		
	END
	
	
	DECLARE @SICnt INT = @InfoCnt - @DICnt
	
	DECLARE @si INT = 0
	WHILE @si < @SICnt
	BEGIN
		SET @si = @si + 1
		
		DECLARE @SummaryLocation BIGINT
		EXEC spsysGetNewID @ID=@SummaryLocation OUTPUT
		EXEC spGeoLocation_Post 
			@idfGeoLocation=@SummaryLocation
			,@idfsGroundType=NULL
			,@idfsGeoLocationType=10036003/*Exact Point*/
			,@idfsCountry=@LocalCountry
			,@idfsRegion=@idfsRegion
			,@idfsRayon=@idfsRayon
			,@idfsSettlement=@idfsSettlement
			,@strDescription=N''
			,@dblLatitude=NULL
			,@dblLongitude=NULL
			,@dblRelLatitude=NULL
			,@dblRelLongitude=NULL
			,@dblAccuracy=NULL
			,@dblDistance=NULL
			,@dblAlignment=NULL
			,@strForeignAddress=N''
			,@blnGeoLocationShared=0
			
			
		DECLARE @CollectionDaySummary INT = (SELECT TOP 1 a FROM (SELECT 0 a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4) x ORDER BY NEWID())
		SET @CollectionDate = DATEADD(DAY, @CollectionDaySummary, @StartDate)
		
		DECLARE @VectorTypeSummary BIGINT
		SELECT TOP 1
			@VectorTypeSummary = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000140/*Vector type*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @VectorSubTypeSummary BIGINT
		SELECT TOP 1
			@VectorSubTypeSummary = tvst.idfsVectorSubType
		FROM trtBaseReference tbr
		JOIN trtVectorSubType tvst ON
			tvst.idfsVectorSubType = tbr.idfsBaseReference
			AND tvst.intRowStatus = 0
			AND tvst.idfsVectorType = @VectorTypeSummary
		WHERE tbr.idfsReferenceType = 19000141/*Vector sub type*/
			AND tbr.intRowStatus = 0
		ORDER BY NEWID()
		
		DECLARE @SexSummary BIGINT
		SELECT TOP 1
			@SexSummary = tbr.idfsBaseReference
		FROM trtBaseReference tbr
		WHERE tbr.idfsReferenceType = 19000007/*Sex*/
			AND tbr.intRowStatus = 0
			AND tbr.intHACode&128 = 128
		ORDER BY NEWID()
		
		DECLARE @QuantitySummary INT
		SET @QuantitySummary = (SELECT TOP 1 a FROM (SELECT 5 a UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) x ORDER BY NEWID())
		
		DECLARE @VSSessionSummary BIGINT
		EXEC spsysGetNewID @VSSessionSummary OUTPUT
		DECLARE @VSSessionSummaryID NVARCHAR(200)
		EXEC spVsSessionSummary_Post 
			@Action=4
			,@idfsVSSessionSummary=@VSSessionSummary OUTPUT
			,@idfVectorSurveillanceSession=@VectorSurveillanceSessionID
			,@strVSSessionSummaryID=@VSSessionSummaryID OUTPUT
			,@idfGeoLocation=@SummaryLocation
			,@datCollectionDateTime=@CollectionDate
			,@idfsVectorSubType=@VectorSubTypeSummary
			,@idfsSex=@SexSummary
			,@intQuantity=@QuantitySummary
			
		DECLARE @PositiveQuantitySummary INT
		SET @PositiveQuantitySummary = @QuantitySummary - (@QuantitySummary / 2.0)
		
		DECLARE @Diagnosis BIGINT
		SELECT TOP 1
			@Diagnosis = td.idfsDiagnosis
		FROM trtDiagnosis td 
		JOIN trtBaseReference tbr ON
			tbr.idfsBaseReference = td.idfsDiagnosis
			AND tbr.intRowStatus = 0
		WHERE tbr.intRowStatus = 0
			AND tbr.intHACode&128 = 128
		ORDER BY NEWID()

		DECLARE @VSSessionSummaryDiagnosis BIGINT
		EXEC spsysGetNewID @VSSessionSummaryDiagnosis OUTPUT
		exec spVsSessionSummaryDiagnosis_Post 
			@Action=4
			,@idfsVSSessionSummaryDiagnosis=@VSSessionSummaryDiagnosis OUTPUT
			,@idfsVSSessionSummary=@VSSessionSummary
			,@idfsDiagnosis=@Diagnosis
			,@intPositiveQuantity=@PositiveQuantitySummary
	END
END

EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;
