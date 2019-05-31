
--##SUMMARY Procedure produces a set of Vet aggr Action with the specified parameters

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 15.01.2016

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXEC sptemp_CreateILIAggr 
	@ILICnt = 1
	, @my_SiteID = 1100
	, @LocalUserName = NULL
	, @StartDate = '2010-01-01 12:00:00:00'
*/

CREATE PROC [dbo].[sptemp_CreateILIAggr](
	@ILICnt INT,						--##PARAM @CaseCnt - the number of cases to generate
	@my_SiteID INT,						--##PARAM @my_SiteID - site id for case generation
	@LocalUserName NVARCHAR(200) = NULL,--##PARAM @LocalUserName - user name for case generation
	@StartDate DATETIME					--##PARAM @StartDate - min date for calculation dates
)
AS

SET NOCOUNT ON;
SET DATEFORMAT dmy
SET DATEFIRST 1

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


DECLARE @i INT = 0

WHILE @i < @ILICnt
BEGIN
	SET @i = @i + 1
	
	DECLARE @Year INT = YEAR(@StartDate) - 1
	
	DECLARE @FirstDayOfWeek INT
	SELECT @FirstDayOfWeek = ISNULL(tgso.strValue, 1) FROM tstGlobalSiteOptions tgso WHERE tgso.strName = 'FirstDayOfWeek'
	
	DECLARE @FromDate DATETIME = '01.01.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
	DECLARE @ToDate DATETIME = '31.12.' + CAST(YEAR(DATEADD(YEAR, -1, @StartDate)) AS NVARCHAR(4))
	
	DECLARE @WeekRandomDate DATETIME = DATEADD(DAY, RAND(CHECKSUM(NEWID())) * (1 + DATEDIFF(DAY, @FromDate, @ToDate)), @FromDate)
	DECLARE @WeekNumber INT = DATEPART(week, @WeekRandomDate)
	
	DECLARE @WeekDay INT = DATEPART(weekday, @WeekRandomDate) - 1
	DECLARE @PeriodStartDate DATETIME = DATEADD(DAY, -1 * @WeekDay, @WeekRandomDate) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END
	DECLARE @PeriodFinishDate DATETIME = DATEADD(DAY, 6, DATEADD(DAY, -1 * @WeekDay, @WeekRandomDate)) - CASE WHEN @FirstDayOfWeek = 0 THEN 1 ELSE 0 END

	DECLARE @AggrILI BIGINT
	EXEC spsysGetNewID @ID = @AggrILI OUTPUT

	EXECUTE spBasicSyndromicSurveillanceAggregateHeader_Post
		@Action=4
		,@idfAggregateHeader=@AggrILI
		,@datDateEntered =@StartDate
		,@idfEnteredBy=@person
		,@idfsSite=@LocalSite
		,@intYear=@Year
		,@intWeek=@WeekNumber
		,@datStartDate=@PeriodStartDate
		,@datFinishDate=@PeriodFinishDate
		
	DECLARE @j INT = 0

	WHILE @j < 3
	BEGIN
		SET @j = @j + 1
		
		DECLARE @Hospital BIGINT
		DECLARE @HospitalTable AS TABLE (id BIGINT)
		
		SELECT TOP 1
			@Hospital = to1.idfOffice
		FROM tlbOffice to1
		JOIN tstSite ts ON
			ts.idfOffice = to1.idfOffice
			AND ts.intRowStatus = 0
			AND ts.blnIsWEB = 0
		WHERE to1.intRowStatus = 0
			AND to1.idfOffice NOT IN (SELECT id FROM @HospitalTable)
		ORDER BY NEWID()
		
		INSERT INTO @HospitalTable
		VALUES (@Hospital)	
		
		DECLARE @Age0_4 INT = CAST(RAND(CAST(NEWID() AS VARBINARY))*10 AS BIGINT)
			, @Age5_14 INT = CAST(RAND(CAST(NEWID() AS VARBINARY))*10 AS BIGINT)
			, @Age15_29 INT = CAST(RAND(CAST(NEWID() AS VARBINARY))*10 AS BIGINT)
			, @Age30_64 INT = CAST(RAND(CAST(NEWID() AS VARBINARY))*10 AS BIGINT)
			, @Age65 INT = CAST(RAND(CAST(NEWID() AS VARBINARY))*10 AS BIGINT)
			, @TotalILI INT
			, @TotalAdmissions INT
			, @ILISamples INT
		SET @TotalILI = @Age0_4 + @Age5_14 + @Age15_29 + @Age30_64 + @Age65
		SET @TotalAdmissions = @TotalILI + 21
		SET @ILISamples = @TotalAdmissions + (@TotalAdmissions / 2)
		
		DECLARE @AggrILIDetail BIGINT
		EXEC spsysGetNewID @ID = @AggrILIDetail OUTPUT
		
		EXEC spBasicSyndromicSurveillanceAggregateDetail_Post
			@Action=4
			,@idfAggregateDetail=@AggrILIDetail
			,@idfAggregateHeader=@AggrILI
			,@idfHospital=@Hospital
			,@intAge0_4=@Age0_4
			,@intAge5_14=@Age5_14
			,@intAge15_29=@Age15_29
			,@intAge30_64=@Age30_64
			,@intAge65=@Age65
			,@inTotalILI=@TotalILI
			,@intTotalAdmissions=@TotalAdmissions
			,@intILISamples=@ILISamples
	END
		
END




EXEC dbo.spSetContext @ContextString=''

SET NOCOUNT OFF;

