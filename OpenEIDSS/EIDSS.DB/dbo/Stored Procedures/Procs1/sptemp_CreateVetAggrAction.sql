
--##SUMMARY Procedure produces a set of Vet aggr Action with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 15.01.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateVetAggrAction 
	@CaseCnt = 5
	, @my_SiteID = 1100
	, @LocalUserName = NULL
	, @SentByPerson = NULL
	, @StartDate = '2015-01-01 12:00:00:00'
	, @DateRange = 100
*/

CREATE PROC [dbo].[sptemp_CreateVetAggrAction](
	@CaseCnt INT,						--##PARAM @CaseCnt - the number of aggr cases to generate
	@my_SiteID INT,						--##PARAM @my_SiteID - site id for aggr case generation
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name for case generation
	@AdministrativeUnit BIGINT = NULL,	--##PARAM @AdministrativeUnit - administrative unit id for aggr case
	@SentByPerson BIGINT = NULL,		--##PARAM @SentByPerson - sent by person id for aggr case
	@StartDate DATETIME,				--##PARAM @StartDate - min date for calculation dates
	@DateRange INT,						--##PARAM @DateRange - number of days for calculation dates
	@PeriodStartDate DATETIME = NULL,	--##PARAM @PeriodStartDate - period start date
	@PeriodFinishDate DATETIME = NULL	--##PARAM @PeriodStartDate - period finish date	
)
AS

SET NOCOUNT ON;

DECLARE @LocalSite BIGINT
	, @LocalCountry BIGINT
	, @LocalOffice BIGINT
	
SET @LocalSite= @my_SiteID
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

DECLARE @StatisticAreaType BIGINT = NULL
	, @StatisticPeriodType BIGINT = NULL
SELECT 
	@StatisticAreaType = idfsStatisticAreaType
	, @StatisticPeriodType = idfsStatisticPeriodType
FROM tstAggrSetting 
WHERE idfsAggrCaseType = 10102003/*Vet Aggregate Action*/ 
	AND intRowStatus = 0

DECLARE @i INT = 0

WHILE @i < @CaseCnt
BEGIN
	SET @i = @i + 1	
	
	DECLARE @AdministrativeUnitLocal BIGINT
	SET @AdministrativeUnitLocal = @AdministrativeUnit
	
	DECLARE @PeriodStartDateLocal DATETIME
	SET @PeriodStartDateLocal = @PeriodStartDate
	
	DECLARE @PeriodFinishDateLocal DATETIME
	SET @PeriodFinishDateLocal = @PeriodFinishDate
		
	IF @AdministrativeUnitLocal IS NULL
	SELECT TOP 1
		@AdministrativeUnitLocal = AdmUnit
	FROM (
		SELECT
			gr.idfsRegion AS AdmUnit
		FROM gisRegion gr
		WHERE gr.idfsCountry = @LocalCountry
			AND ISNULL(@StatisticAreaType, 10089003) = 10089003/*Region*/
		UNION ALL
		SELECT
			gr.idfsRayon
		FROM gisRayon gr
		WHERE gr.idfsCountry = @LocalCountry
			AND ISNULL(@StatisticAreaType, 10089002) = 10089002/*Rayon*/
		UNION ALL
		SELECT
			gr.idfsSettlement
		FROM gisSettlement gr
		WHERE gr.idfsCountry = @LocalCountry
			AND ISNULL(@StatisticAreaType, 10089004) = 10089004/*Settlement*/
	) x
	ORDER BY NEWID()


	IF @PeriodStartDateLocal IS NULL OR @PeriodFinishDateLocal IS NULL
	BEGIN 		
		IF @StatisticPeriodType IS NULL
		SET @StatisticPeriodType = (
										SELECT TOP 1
											tbr.idfsBaseReference
										FROM trtBaseReference tbr
										WHERE tbr.idfsReferenceType = 19000091
											AND tbr.intRowStatus = 0
											AND tbr.strDefault NOT IN ('Day')
										ORDER BY NEWID()
									)
		DECLARE @Date DATETIME 
		DECLARE @MonthNumber INT
		IF @StatisticPeriodType = 10091005 /*Year*/
		BEGIN 
			SET @PeriodStartDateLocal = CONVERT(DATETIME,'01.01.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
			SET @PeriodFinishDateLocal = CONVERT(DATETIME,'31.12.' + CAST(YEAR(@StartDate) AS NVARCHAR(4)),101)
		END
		ELSE IF @StatisticPeriodType = 10091003 /*Quarter*/
		BEGIN 
			SELECT TOP 1
				@MonthNumber = rn
			FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
			) x
			WHERE rn < 13
			ORDER BY NEWID()
			
			SET @Date = '01.' + CASE WHEN LEN(@MonthNumber) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

			SET @PeriodStartDateLocal = CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date)),101)
			SET @PeriodFinishDateLocal = DATEADD(MONTH,3,CONVERT(DATETIME,CONVERT(VARCHAR(2),(MONTH(@Date)-1)/3*3+1)+'/1/'+CONVERT(CHAR(4),YEAR(@Date)),101))-1
		END
		ELSE IF @StatisticPeriodType = 10091001 /*Month*/
		BEGIN
			SELECT TOP 1
				@MonthNumber = rn
			FROM (
				SELECT ROW_NUMBER() OVER (ORDER BY idfsBaseReference) rn FROM trtBaseReference
			) x
			WHERE rn < 13
			ORDER BY NEWID()
			
			SET @Date = '01.' + CASE WHEN LEN(@MonthNumber) = 1 THEN '0' ELSE '' END + CAST(@MonthNumber AS NVARCHAR(2)) + '.' + CAST(YEAR(@StartDate) AS NVARCHAR(4))

			SET @PeriodStartDateLocal = @Date
			SET @PeriodFinishDateLocal = DATEADD(MONTH, 1, DATEADD(DAY, 1 - DAY(@Date), @Date)) - 1
		END
		ELSE IF @StatisticPeriodType = 10091004 /*Week*/
		BEGIN
			DECLARE @FirstDayOfWeek INT
			SELECT @FirstDayOfWeek = ISNULL(tgso.strValue, 1) FROM tstGlobalSiteOptions tgso WHERE tgso.strName = 'FirstDayOfWeek'

			DECLARE @FromDate DATETIME = '01.01.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
			DECLARE @ToDate DATETIME = '31.12.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
			DECLARE @WeekRandomDate DATETIME = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @FromDate, @ToDate)), @FromDate)
			DECLARE @WeekDay INT = DATEPART(weekday, @WeekRandomDate) - 1
			SET @PeriodStartDateLocal = DATEADD(DAY, -1 * @WeekDay, @WeekRandomDate) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END
			SET @PeriodFinishDateLocal = DATEADD(DAY, 6, DATEADD(DAY, -1 * @WeekDay, @WeekRandomDate)) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END	
		END
	END
	
	IF NOT EXISTS (
				SELECT * FROM tlbAggrCase 
				WHERE idfsAggrCaseType = 10102003/*Vet Aggregate Action*/ 
					AND idfsAdministrativeUnit = @AdministrativeUnitLocal
					AND YEAR(datStartDate) = YEAR(@PeriodStartDateLocal)
					AND YEAR(datFinishDate) = YEAR(@PeriodFinishDateLocal)
					AND MONTH(datStartDate) = MONTH(@PeriodStartDateLocal)
					AND MONTH(datFinishDate) = MONTH(@PeriodFinishDateLocal)
					AND DAY(datStartDate) = DAY(@PeriodStartDateLocal)
					AND DAY(datFinishDate) = DAY(@PeriodFinishDateLocal)
				)	
	BEGIN		
		DECLARE @AggrCase BIGINT
		EXEC spsysGetNewID @ID = @AggrCase OUTPUT

		DECLARE @SentByOffice BIGINT = (SELECT tp.idfInstitution FROM tlbPerson tp WHERE tp.idfPerson = @SentByPerson)
		

		DECLARE @DiagnosticObservation BIGINT = NULL
		DECLARE @DiagnosticObservationFormTemplate BIGINT = NULL
		DECLARE @DiagnosticVersion BIGINT = (
									SELECT TOP 1
										tamvh.idfVersion 
									FROM tlbAggrMatrixVersionHeader tamvh 
									WHERE tamvh.idfsMatrixType = 71460000000/*Diagnostic investigations*/
										AND tamvh.intRowStatus = 0
										AND tamvh.blnIsActive = 1
		)
		IF @DiagnosticVersion IS NOT NULL 
		BEGIN 
			EXEC spsysGetNewID @ID=@DiagnosticObservation OUTPUT
			EXEC dbo.spFFGetActualTemplate 
				@idfsGISBaseReference=@LocalCountry
				,@idfsBaseReference=NULL
				,@idfsFormType=10034023 /*Diagnostic investigations*/
				,@blnReturnTable = 0
				,@idfsFormTemplateActual=@DiagnosticObservationFormTemplate OUTPUT
		END

		DECLARE @ProphylacticObservation BIGINT = NULL
		DECLARE @ProphylacticObservationFormTemplate BIGINT = NULL
		DECLARE @ProphylacticVersion BIGINT = (
									SELECT TOP 1
										tamvh.idfVersion 
									FROM tlbAggrMatrixVersionHeader tamvh 
									WHERE tamvh.idfsMatrixType = 71300000000/*Treatment-prophylactics and vaccination measures*/
										AND tamvh.intRowStatus = 0
										AND tamvh.blnIsActive = 1
		)
		IF @ProphylacticVersion IS NOT NULL 
		BEGIN 
			EXEC spsysGetNewID @ID=@ProphylacticObservation OUTPUT
			EXEC dbo.spFFGetActualTemplate 
				@idfsGISBaseReference=@LocalCountry
				,@idfsBaseReference=NULL
				,@idfsFormType=10034024 /*Treatment-prophylactics and vaccination measures*/
				,@blnReturnTable = 0
				,@idfsFormTemplateActual=@ProphylacticObservationFormTemplate OUTPUT
		END
		
		DECLARE @SanitaryObservation BIGINT = NULL
		DECLARE @SanitaryObservationFormTemplate BIGINT = NULL
		DECLARE @SanitaryVersion BIGINT = (
									SELECT TOP 1
										tamvh.idfVersion 
									FROM tlbAggrMatrixVersionHeader tamvh 
									WHERE tamvh.idfsMatrixType = 71260000000/*Veterinary-sanitary measures*/
										AND tamvh.intRowStatus = 0
										AND tamvh.blnIsActive = 1
		)
		IF @SanitaryVersion IS NOT NULL 
		BEGIN 
			EXEC spsysGetNewID @ID=@SanitaryObservation OUTPUT
			EXEC dbo.spFFGetActualTemplate 
				@idfsGISBaseReference=@LocalCountry
				,@idfsBaseReference=NULL
				,@idfsFormType=10034022 /*Veterinary-sanitary measures*/
				,@blnReturnTable = 0
				,@idfsFormTemplateActual=@SanitaryObservationFormTemplate OUTPUT
		END

		DECLARE @RandomDate AS DATETIME = DATEADD(DAY, CAST(RAND()*@DateRange AS INT), @StartDate)

		EXECUTE spAggregateCaseHeader_Post
			@idfAggrCase = @AggrCase
			,@idfsAggrCaseType = 10102003 /*VetAggregateAction*/
			,@idfsAdministrativeUnit = @AdministrativeUnit
			,@idfReceivedByOffice = @LocalOffice
			,@idfReceivedByPerson = @person
			,@idfSentByOffice = @SentByOffice
			,@idfSentByPerson = @SentByPerson
			,@idfEnteredByOffice = @LocalOffice
			,@idfEnteredByPerson = @person
			,@idfCaseObservation = NULL
			,@idfsCaseObservationFormTemplate = NULL
			,@idfDiagnosticObservation = @DiagnosticObservation
			,@idfsDiagnosticObservationFormTemplate = @DiagnosticObservationFormTemplate
			,@idfProphylacticObservation = @ProphylacticObservation
			,@idfsProphylacticObservationFormTemplate = @ProphylacticObservationFormTemplate
			,@idfSanitaryObservation = @SanitaryObservation
			,@idfVersion = NULL
			,@idfDiagnosticVersion = @DiagnosticVersion
			,@idfProphylacticVersion = @ProphylacticVersion
			,@idfSanitaryVersion = @SanitaryVersion
			,@idfsSanitaryObservationFormTemplate = @SanitaryObservationFormTemplate
			,@datReceivedByDate = @RandomDate
			,@datSentByDate = @RandomDate
			,@datEnteredByDate = @RandomDate
			,@datStartDate = @PeriodStartDate
			,@datFinishDate = @PeriodFinishDate
			,@strCaseID = NULL
	END
	ELSE 
		RAISERROR ('Aggrcase exists', 1, 1)	
END




EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;

