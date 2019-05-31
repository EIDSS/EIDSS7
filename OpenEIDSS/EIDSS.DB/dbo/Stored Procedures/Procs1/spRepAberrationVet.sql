

--##SUMMARY Select data for Human Aberration Analysis.
--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 19.09.2013 


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepAberrationVet 'en', '2014-04-01', '2014-05-23', 2, null, null, null, --37050000000, 3450000000, null, 
'<ItemList><Item key="784580000000"/><Item key="7720340000000"/><Item key="784250000000"/></ItemList>',
10012003, 4578940000002,
'<ItemList><Item key="0" /><Item key="360000000"/><Item key="350000000"/><Item key="380000000"/></ItemList>',
1, 1, 1


*/

create  PROCEDURE [dbo].[spRepAberrationVet]
	(
		@LangID		AS NVARCHAR(10), 
		@SD			AS NVARCHAR(20),
		@ED			AS NVARCHAR(20),
		@MinTimeInterval AS INT,
		@RegionID	AS BIGINT = NULL,
		@RayonID	AS BIGINT = NULL,
		@SettlementID	AS BIGINT = NULL,
	 	@Diagnosis	AS XML,
		@VetCaseType	AS BIGINT,
		@ReportType	AS BIGINT,
	 	@CaseClassif	AS XML,
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

    1		Initial Report Date
    2		Data Entry Date
    3		Investigation Date

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
		select vc.idfVetCase,
		coalesce(case @DateField1 when 0 then null else vc.datReportDate end,
		         case @DateField2 when 0 then null else vc.datEnteredDate end,
		         case @DateField3 when 0 then null else vc.datInvestigationDate end)
		--ISNULL(vc.datReportDate, vc.datEnteredDate)
	from	tlbVetCase vc
    		INNER JOIN	@Diagnosis.nodes('/ItemList/*') AS diag(n)  	ON   diag.n.value('@key[1]', 'bigint') = vc.idfsShowDiagnosis
    		INNER JOIN	@CaseClassif.nodes('/ItemList/*') AS class(n)  ON   class.n.value('@key[1]', 'bigint') = isnull(vc.idfsCaseClassification, 0)

      		LEFT OUTER JOIN tlbFarm as tFarm	ON vc.idfFarm = tFarm.idfFarm AND tFarm.intRowStatus = 0
      		LEFT OUTER JOIN tlbHuman as tHuman	ON tHuman.idfHuman = tFarm.idfHuman AND tHuman.intRowStatus = 0
      		LEFT OUTER JOIN tlbGeoLocation gl	ON tFarm.idfFarmAddress = gl.idfGeoLocation AND gl.intRowStatus = 0

	WHERE 	--dates		
		(	@StartDate <= coalesce(case @DateField1 when 0 then null else vc.datReportDate end,
		                           case @DateField2 when 0 then null else vc.datEnteredDate end,
		                           case @DateField3 when 0 then null else vc.datInvestigationDate end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else vc.datReportDate end,
		                               case @DateField2 when 0 then null else vc.datEnteredDate end,
		                               case @DateField3 when 0 then null else vc.datInvestigationDate end)

		)

		-- Avian / Livestock
		and vc.idfsCaseType = @VetCaseType

		-- region-rayon-settlement
		and (@RegionID is null or (gl.idfsRegion is not null and gl.idfsRegion = @RegionID))
		and (@RayonID is null or (gl.idfsRayon is not null and gl.idfsRayon = @RayonID)) 
		and (@SettlementID is null or (gl.idfsSettlement is not null and gl.idfsSettlement = @SettlementID))

		-- report type
		and (vc.idfsCaseReportType = @ReportType 
				or @ReportType = 50815490000000	-- Both
			)


	      	and vc.intRowStatus = 0



select @sum=count(1) from @ReportTable

select @fullsum=count(1)
	from	tlbVetCase vc
    		INNER JOIN	@Diagnosis.nodes('/ItemList/*') AS diag(n)  	ON   diag.n.value('@key[1]', 'bigint') = vc.idfsShowDiagnosis
    		INNER JOIN	@CaseClassif.nodes('/ItemList/*') AS class(n)  ON   class.n.value('@key[1]', 'bigint') = isnull(vc.idfsCaseClassification, 0)

	WHERE 	--dates		
		(	@StartDate <= coalesce(case @DateField1 when 0 then null else vc.datReportDate end,
		                           case @DateField2 when 0 then null else vc.datEnteredDate end,
		                           case @DateField3 when 0 then null else vc.datInvestigationDate end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else vc.datReportDate end,
		                               case @DateField2 when 0 then null else vc.datEnteredDate end,
		                               case @DateField3 when 0 then null else vc.datInvestigationDate end)

		)
		and vc.idfsCaseType = @VetCaseType
		and (vc.idfsCaseReportType = @ReportType 
				or @ReportType = 50815490000000	-- Both
			)
	      	and vc.intRowStatus = 0


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
