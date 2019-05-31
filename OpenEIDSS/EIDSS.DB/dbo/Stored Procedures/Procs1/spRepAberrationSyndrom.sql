

--##SUMMARY Select data for Syndromic Aberration Analysis.
--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 01.10.2013 


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepAberrationSyndrom 'en', '2014-04-01', '2014-05-23', 2, null, null, null, --37050000000, 3450000000, null, 
1101, 1,
null, null, 1,
333, 
1,1,1

*/

create  PROCEDURE [dbo].[spRepAberrationSyndrom]
	(
		@LangID		AS NVARCHAR(10), 
		@SD			AS NVARCHAR(20),
		@ED			AS NVARCHAR(20),
		@MinTimeInterval AS INT,
		@RegionID	AS BIGINT = NULL,
		@RayonID	AS BIGINT = NULL,
		@SettlementID	AS BIGINT = NULL,
	 	@Site		AS BIGINT,
		@Gender		AS BIGINT = NULL,
		@StartAge	AS INT = NULL,
		@FinishAge	AS INT = NULL,
	 	@NotificationType AS BIGINT,
	 	@Hospital	AS BIGINT = NULL,
	 	@DateField1	AS BIT = 0,
	 	@DateField2	AS BIT = 0,
	 	@DateField3	AS BIT = 0

	)
AS	

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/10x-Business Analysis/21 Reports and Paper Forms/21.6.002 Aberration Analysis Standard Reports.doc"


/*

    1		Day
    2		Week
    3		Month

*/
/*

    1		Report Date
    2		Date of Symptoms Onset
    3		Date of Care

*/


	declare @ReportTable	table
	(
		 [ident] BIGINT
		,[date]	DATETIME
	)

	declare 
	  @StartDate as datetime,
	  @FinishDate as datetime
	set @StartDate=dbo.fn_SetMinMaxTime(CAST(@SD as datetime),0)
	set @FinishDate=dbo.fn_SetMinMaxTime(CAST(@ED as datetime),1)


	declare @sum int, @fullsum int


	declare @idfsLanguage bigint
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)

	SET @FinishDate=DATEADD(day, 1, @FinishDate)

	if @MinTimeInterval = 3 --'Month'
	BEGIN
		if @StartDate > DATEADD(month, DATEDIFF(month, 0, @StartDate), 0)
			SELECT @StartDate = DATEADD(month, DATEDIFF(month, 0, @StartDate)+1, 0)
		if @FinishDate = DATEADD(month, DATEDIFF(month, 0, @FinishDate)+1, 0)
			SELECT @FinishDate = DATEADD(month, DATEDIFF(month, 0, @FinishDate), 0)
		else
			SELECT @FinishDate = DATEADD(month, DATEDIFF(month, 0, @FinishDate)-1, 0)
	END
	else if @MinTimeInterval = 2 --'Week'
	BEGIN
		SELECT @StartDate = case DATEPART(WEEKDAY, @StartDate) when 1 then DATEADD(DAY, 1-DATEPART(WEEKDAY, @StartDate), @StartDate) else DATEADD(DAY, 8-DATEPART(WEEKDAY, @StartDate), @StartDate) end
		SELECT @FinishDate = DATEADD(DAY, 1-DATEPART(WEEKDAY, @FinishDate), @FinishDate)
	END
	
	if (@StartDate >= @FinishDate Or @StartDate > '20990101' Or @FinishDate > '20990101')
		SELECT CONVERT(NVARCHAR(20), [date], 120) as date, 0 as observed, 0 as sum, 0 as fullsum, [ident] as id
		FROM @ReportTable
	else
	begin
	
	insert into @ReportTable([ident],[date])
		select sc.idfBasicSyndromicSurveillance,
		coalesce(case @DateField1 when 0 then null else sc.datReportDate end,
		         case @DateField2 when 0 then null else sc.datDateOfSymptomsOnset end,
		         case @DateField3 when 0 then null else sc.datDateOfCare end)
		--case when @DateField=1 then sc.datReportDate when @DateField=2 then sc.datDateOfSymptomsOnset when @DateField=3 then sc.datDateOfCare end
	from	tlbBasicSyndromicSurveillance sc
    		INNER JOIN tlbHuman h   ON sc.idfHuman = h.idfHuman      and h.intRowStatus = 0
      		LEFT OUTER JOIN tlbGeoLocation gl    ON h.idfCurrentResidenceAddress = gl.idfGeoLocation   and gl.intRowStatus = 0

	WHERE 	--dates
			@StartDate <= coalesce(case @DateField1 when 0 then null else sc.datReportDate end,
		                           case @DateField2 when 0 then null else sc.datDateOfSymptomsOnset end,
		                           case @DateField3 when 0 then null else sc.datDateOfCare end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else sc.datReportDate end,
		                               case @DateField2 when 0 then null else sc.datDateOfSymptomsOnset end,
		                               case @DateField3 when 0 then null else sc.datDateOfCare end)

		--site
		and sc.idfsSite = @Site

		--notification type
		and sc.idfsBasicSyndromicSurveillanceType = @NotificationType

		--hospital
		and (@Hospital is null or  sc.idfHospital = @Hospital)

		-- region-rayon-settlement
		and (@RegionID is null or (gl.idfsRegion is not null and gl.idfsRegion = @RegionID))
		and (@RayonID is null or (gl.idfsRayon is not null and gl.idfsRayon = @RayonID)) 
		and (@SettlementID is null or (gl.idfsSettlement is not null and gl.idfsSettlement = @SettlementID))

		-- gender
		and (@Gender is null or h.idfsHumanGender = @Gender)

		-- Age
		and (@StartAge is null or IsNull(sc.intAgeFullYear, -1) >= @StartAge)
		and (@FinishAge is null or IsNull(sc.intAgeFullYear, -1) <= @FinishAge)

		and sc.intRowStatus = 0


select @sum=count(1) from @ReportTable

select @fullsum=count(1)
	from	tlbBasicSyndromicSurveillance sc

	WHERE 	--dates		
			@StartDate <= coalesce(case @DateField1 when 0 then null else sc.datReportDate end,
		                           case @DateField2 when 0 then null else sc.datDateOfSymptomsOnset end,
		                           case @DateField3 when 0 then null else sc.datDateOfCare end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else sc.datReportDate end,
		                               case @DateField2 when 0 then null else sc.datDateOfSymptomsOnset end,
		                               case @DateField3 when 0 then null else sc.datDateOfCare end)

		--site
		and sc.idfsSite = @Site

		--notification type
		and sc.idfsBasicSyndromicSurveillanceType = @NotificationType

		and sc.intRowStatus = 0

if @MinTimeInterval = 3 --'Month'
BEGIN

	;WITH nm AS 
	(
  		SELECT TOP (DATEDIFF(MONTH, @StartDate, @FinishDate) + 1) 
    		nm = ROW_NUMBER() OVER (ORDER BY [object_id])
  		FROM sys.all_objects
	)
	SELECT CONVERT(NVARCHAR(20), DATEADD(MONTH, nm-1, @StartDate), 120) as date, count(r.ident) as observed, @sum as sum, @fullsum as fullsum, nm-1 as id
	FROM nm
	LEFT OUTER JOIN @ReportTable r ON DATEADD(MONTH, nm-1, @StartDate) <= [date] AND DATEADD(MONTH, nm, @StartDate) > [date]
	GROUP BY DATEADD(MONTH, nm-1, @StartDate), nm;

END
else if @MinTimeInterval = 2 --'Week'
BEGIN

	;WITH nw AS 
	(
  		SELECT TOP (DATEDIFF(WEEK, @StartDate, @FinishDate)) 
    		nw = ROW_NUMBER() OVER (ORDER BY [object_id])
  		FROM sys.all_objects
	)
	SELECT CONVERT(NVARCHAR(20), DATEADD(WEEK, nw-1, @StartDate), 120) as date, count(r.ident) as observed, @sum as sum, @fullsum as fullsum, nw-1 as id
	FROM nw
	LEFT OUTER JOIN @ReportTable r ON DATEADD(WEEK, nw-1, @StartDate) <= [date] AND DATEADD(WEEK, nw, @StartDate) > [date]
	GROUP BY DATEADD(WEEK, nw-1, @StartDate), nw;

END
else if @MinTimeInterval = 1--'Onday'	      
BEGIN

	;WITH nd AS 
	(
  		SELECT TOP (DATEDIFF(DAY, @StartDate, @FinishDate) + 1) 
    		nd = ROW_NUMBER() OVER (ORDER BY [object_id])
  		FROM sys.all_objects
	)
	SELECT CONVERT(NVARCHAR(20), DATEADD(DAY, nd-1, @StartDate), 120) as date, count(r.ident) as observed, @sum as sum, @fullsum as fullsum, nd-1 as id
	FROM nd
	LEFT OUTER JOIN @ReportTable r ON DATEADD(DAY, nd-1, @StartDate) = DATEADD(DAY, DATEDIFF(DAY, 0, [date]), 0)
	GROUP BY DATEADD(DAY, nd-1, @StartDate), nd;

END

end
