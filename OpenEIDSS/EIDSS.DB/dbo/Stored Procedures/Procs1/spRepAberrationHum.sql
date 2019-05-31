

--##SUMMARY Select data for Human Aberration Analysis.
--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 18.09.2013 


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepAberrationHum 'en', '2014-04-01', '2014-05-23', 2, null, null, null, --37050000000, 3450000000, null, 
'<ItemList><Item key="7718050000000"/><Item key="7720340000000"/><Item key="784250000000"/></ItemList>',
null, null, null,
'<ItemList><Item key="0" /><Item key="360000000"/><Item key="350000000"/><Item key="380000000"/></ItemList>',
1, 0, 1, 0, 1


*/

create  PROCEDURE [dbo].[spRepAberrationHum]
	(
		@LangID		AS NVARCHAR(10), 
		@SD			AS NVARCHAR(20),
		@ED			AS NVARCHAR(20),
		@MinTimeInterval AS INT,
		@RegionID	AS BIGINT = NULL,
		@RayonID	AS BIGINT = NULL,
		@SettlementID	AS BIGINT = NULL,
	 	@Diagnosis	AS XML,
		@Gender		AS BIGINT = NULL,
		@StartAge	AS INT = NULL,
		@FinishAge	AS INT = NULL,
	 	@CaseClassif	AS XML,
	 	@DateField1	AS BIT = 0,
	 	@DateField2	AS BIT = 0,
	 	@DateField3	AS BIT = 0,
	 	@DateField4	AS BIT = 0,
	 	@DateField5	AS BIT = 0

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

    1		Date of Symptoms Onset
    2		Notification Date
    3		Diagnosis Date
    4		Date of Changed Diagnosis
    5		Date Entered

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
		select hc.idfHumanCase,
		--ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate))))
		coalesce(case @DateField1 when 0 then null else hc.datOnSetDate end,
		         case @DateField2 when 0 then null else hc.datNotificationDate end,
		         case @DateField3 when 0 then null else hc.datTentativeDiagnosisDate end,
		         case @DateField4 when 0 then null else hc.datFinalDiagnosisDate end,
		         case @DateField5 when 0 then null else hc.datEnteredDate end)
	from	tlbHumanCase hc
    		INNER JOIN	@Diagnosis.nodes('/ItemList/*') AS diag(n)  	ON   diag.n.value('@key[1]', 'bigint') = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
    		INNER JOIN	@CaseClassif.nodes('/ItemList/*') AS class(n)  ON   class.n.value('@key[1]', 'bigint') = COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus, 0)
    		INNER JOIN tlbHuman h   ON hc.idfHuman = h.idfHuman      and h.intRowStatus = 0
      		LEFT OUTER JOIN tlbGeoLocation gl    ON h.idfCurrentResidenceAddress = gl.idfGeoLocation   and gl.intRowStatus = 0

	WHERE 	--dates		
		(	@StartDate <= coalesce(case @DateField1 when 0 then null else hc.datOnSetDate end,
		                           case @DateField2 when 0 then null else hc.datNotificationDate end,
		                           case @DateField3 when 0 then null else hc.datTentativeDiagnosisDate end,
		                           case @DateField4 when 0 then null else hc.datFinalDiagnosisDate end,
		                           case @DateField5 when 0 then null else hc.datEnteredDate end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else hc.datOnSetDate end,
		                               case @DateField2 when 0 then null else hc.datNotificationDate end,
		                               case @DateField3 when 0 then null else hc.datTentativeDiagnosisDate end,
		                               case @DateField4 when 0 then null else hc.datFinalDiagnosisDate end,
		                               case @DateField5 when 0 then null else hc.datEnteredDate end)

		)

		-- region-rayon-settlement
		and (@RegionID is null or (gl.idfsRegion is not null and gl.idfsRegion = @RegionID))
		and (@RayonID is null or (gl.idfsRayon is not null and gl.idfsRayon = @RayonID)) 
		and (@SettlementID is null or (gl.idfsSettlement is not null and gl.idfsSettlement = @SettlementID))

		-- gender
		and (@Gender is null or @Gender=-1 or h.idfsHumanGender = @Gender)

		-- Age
		and (@StartAge is null or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						and IsNull(hc.intPatientAge, -1) >= @StartAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042004	-- Weeks
						and  cast(IsNull(hc.intPatientAge, -1) / 52 as int) >= @StartAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						and  cast(IsNull(hc.intPatientAge, -1) / 12 as int) >= @StartAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						and cast(IsNull(hc.intPatientAge, -1) / 365 as int) >= @StartAge)
			)
		and (@FinishAge is null or @FinishAge=0 or 
				(IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						and IsNull(hc.intPatientAge, -1) <= @FinishAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042004	-- Weeks
						and  cast(IsNull(hc.intPatientAge, -1) / 52 as int) <= @FinishAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						and  cast(IsNull(hc.intPatientAge, -1) / 12 as int) <= @FinishAge)
					or
				(IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						and cast(IsNull(hc.intPatientAge, -1) / 365 as int) <= @FinishAge)
			)
	      and hc.intRowStatus = 0


	select @sum=count(1) from @ReportTable


	select @fullsum=count(1)
	from	tlbHumanCase hc
    		INNER JOIN	@Diagnosis.nodes('/ItemList/*') AS diag(n)  	ON   diag.n.value('@key[1]', 'bigint') = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
    		INNER JOIN	@CaseClassif.nodes('/ItemList/*') AS class(n)  ON   class.n.value('@key[1]', 'bigint') = COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus, 0)

	WHERE 	--dates		
		(	@StartDate <= coalesce(case @DateField1 when 0 then null else hc.datOnSetDate end,
		                           case @DateField2 when 0 then null else hc.datNotificationDate end,
		                           case @DateField3 when 0 then null else hc.datTentativeDiagnosisDate end,
		                           case @DateField4 when 0 then null else hc.datFinalDiagnosisDate end,
		                           case @DateField5 when 0 then null else hc.datEnteredDate end)

		   and  @FinishDate > coalesce(case @DateField1 when 0 then null else hc.datOnSetDate end,
		                               case @DateField2 when 0 then null else hc.datNotificationDate end,
		                               case @DateField3 when 0 then null else hc.datTentativeDiagnosisDate end,
		                               case @DateField4 when 0 then null else hc.datFinalDiagnosisDate end,
		                               case @DateField5 when 0 then null else hc.datEnteredDate end)

		)
	      and hc.intRowStatus = 0




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
	else if @MinTimeInterval = 1 --'Onday'	      
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

