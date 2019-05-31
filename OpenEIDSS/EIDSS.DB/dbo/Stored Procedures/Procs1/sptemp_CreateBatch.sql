
--##SUMMARY

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 28.01.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateBatch 
	@BatchCnt = 1
	, @TestCnt = 2
	, @my_SiteID = 1294
	, @LocalUserName = 'EIDSS Web Server Administrator'
	, @SetTestResult = NULL
	, @ResultEnteredByPerson = NULL
*/

CREATE PROC [dbo].[sptemp_CreateBatch](
	@BatchCnt INT,							--##PARAM @BatchCnt - the number of batches to generate
	@TestCnt INT,							--##PARAM @TestCnt - the number of tests to generate for each batch
	@my_SiteID INT,							--##PARAM @my_SiteID - site id for batch generation
	@LocalUserName NVARCHAR(200) = NULL,	--##PARAM @LocalUserName - user name
	@SetTestResult BIT = NULL,				--##PARAM @SetTestResult - set or not test result
	@ResultEnteredByPerson BIGINT = NULL	--##PARAM @ResultEnteredByPerson - result entered by person id
)
AS

SET NOCOUNT ON;

DECLARE @LocalSite BIGINT
	, @LocalCountry BIGINT
	, @LocalOffice BIGINT
	
SET @LocalSite=@my_SiteID
SELECT 
	@LocalCountry = tcpac.idfsCountry 
	, @LocalOffice = ts.idfOffice
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

DECLARE @TestName BIGINT

SELECT
	@TestName = tbr.idfsBaseReference
FROM trtBaseReference tbr
WHERE tbr.idfsReferenceType = 19000097 /*Test Name*/
	AND tbr.strDefault = 'PCR'
	AND tbr.intRowStatus = 0

DECLARE @FormTemplateActual BIGINT 
EXEC dbo.spFFGetActualTemplate 
	@idfsGISBaseReference=@LocalCountry
	,@idfsBaseReference=@TestName
	,@idfsFormType=10034019 /*Test Run*/
	,@blnReturnTable = 0
	,@idfsFormTemplateActual=@FormTemplateActual OUTPUT


DECLARE @i INT = 0

WHILE @i < @BatchCnt
BEGIN
	SET @i = @i + 1
	
	DECLARE @BatchTestId BIGINT
	EXEC spsysGetNewID @ID=@BatchTestId OUTPUT
	
	DECLARE @NewEventId BIGINT
	EXEC dbo.spAudit_CreateNewEvent 
		@idfsDataAuditEventType=10016001 /*Create*/
		,@idfsDataAuditObjectType=10017012 /*Batch Test*/
		,@strMainObjectTable=75480000000 /*tlbBatchTest*/
		,@idfsMainObject=@BatchTestId
		,@strReason=NULL
		,@idfDataAuditEvent=@NewEventId OUTPUT 
		
	DECLARE @ObservationId BIGINT
	EXEC spsysGetNewID @ID=@ObservationId OUTPUT	
	DECLARE @Barcode NVARCHAR(200)
	EXEC spLabBatch_Create 
		@idfBatchTest=@BatchTestId
		,@idfsTestName=@TestName
		,@idfPerformedByOffice=@LocalOffice
		,@strBarcode=@Barcode OUTPUT
		,@idfObservation=@ObservationId		
		
	DECLARE @t INT = 0
	WHILE @t < @TestCnt
	BEGIN
		SET @t = @t + 1
		
		DECLARE @TestId BIGINT
			, @TestObservationId BIGINT
			, @TestCategory BIGINT
			, @PerformedDate DATETIME
			
		SET @PerformedDate = '01.01.2000'
			
		SELECT TOP 1
			@TestId = tt.idfTesting
			, @TestObservationId = tt.idfObservation
			, @TestCategory = tt.idfsTestCategory
			, @PerformedDate = CASE WHEN tm.datAccession > @PerformedDate THEN tm.datAccession ELSE @PerformedDate END
		FROM tlbTesting tt
		JOIN tlbMaterial tm ON
			tm.idfMaterial = tt.idfMaterial
		WHERE tt.idfBatchTest IS NULL
			AND tt.intRowStatus = 0
			AND tt.idfsTestStatus = 10001005 /*Not Started*/
			AND tm.datAccession IS NOT NULL
		ORDER BY NEWID()
		
		EXEC spLabBatch_AddTest 
			@idfBatchTest=@BatchTestId
			,@idfTesting=@TestId
			
		
		DECLARE @TestResult BIGINT
			, @ResultEnteredByPersonLocal BIGINT
		SET @TestResult = NULL
		SET @ResultEnteredByPersonLocal = NULL
		IF ISNULL(@SetTestResult, 0) = 1
		BEGIN
			SELECT TOP 1
				@TestResult = idfsBaseReference
			FROM trtBaseReference 
			WHERE idfsReferenceType = 19000096 /*Test Result*/
				AND intRowStatus = 0
			ORDER BY NEWID()
			SET @ResultEnteredByPersonLocal = @ResultEnteredByPerson
		END
		ELSE 
			SET @PerformedDate = NULL

		EXEC spLabTest_Update 
			@idfTesting=@TestId
			,@idfsTestResult=@TestResult
			,@intTestNumber=0
			,@idfsTestStatus=NULL
			,@idfResultEnteredByPerson=@ResultEnteredByPersonLocal
			,@idfsTestCategory=@TestCategory

		EXEC spObservation_Post 
			@idfObservation= @TestObservationId
			,@idfsFormTemplate=NULL
	END		
	
	EXEC spLabBatch_Update 
		@idfBatchTest=@BatchTestId
		,@strBarcode=@Barcode
		,@idfsTestName=@TestName
		,@datPerformedDate=@PerformedDate
		,@idfPerformedByPerson=@person
		,@datValidatedDate=@PerformedDate
		,@idfValidatedByPerson=NULL
		,@idfResultEnteredByOffice=@LocalOffice
		,@idfResultEnteredByPerson=@person
	
END

EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;
