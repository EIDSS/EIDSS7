

--##SUMMARY Select data for Syndromic ILI Aberration Analysis.
--##REMARKS Author: Gorodentseva
--##REMARKS Create date: 05.06.2014 


--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepAberrationILISyndrom 'en', '2014-05-01', '2014-07-01', 2, null, null,  --37050000000, 3450000000, 
null

*/

create  PROCEDURE [dbo].[spRepAberrationILISyndrom]
	(
		@LangID		AS NVARCHAR(10), 
		@SD			AS NVARCHAR(20),
		@ED			AS NVARCHAR(20),
		@GroupAge	AS INT,
		@RegionID	AS BIGINT = NULL,
		@RayonID	AS BIGINT = NULL,
	 	@Hospital	AS BIGINT = NULL

	)
AS	

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/10x-Business Analysis/21 Reports and Paper Forms/21.6.002 Aberration Analysis Standard Reports.doc"

/*

    1		0-4
    2		5-14
    3		15-29
    4		30-64
    5		>=65
    6		Total

*/


	declare @ReportTable	table
	(
		 [ident] BIGINT
		,[date]	DATETIME
		,[cnt]	INT
	)

	declare 
	  @StartDate as datetime,
	  @FinishDate as datetime
	set @StartDate=dbo.fn_SetMinMaxTime(CAST(@SD as datetime),0)
	set @FinishDate=dbo.fn_SetMinMaxTime(CAST(@ED as datetime),1)


	declare @idfsLanguage bigint
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)

	SET @FinishDate=DATEADD(day, 1, @FinishDate)

	SELECT @StartDate = case DATEPART(WEEKDAY, @StartDate) when 1 then DATEADD(DAY, 1-DATEPART(WEEKDAY, @StartDate), @StartDate) else DATEADD(DAY, 8-DATEPART(WEEKDAY, @StartDate), @StartDate) end
	SELECT @FinishDate = DATEADD(DAY, 1-DATEPART(WEEKDAY, @FinishDate), @FinishDate)
	
	if (@StartDate >= @FinishDate Or @StartDate > '20990101' Or @FinishDate > '20990101')
		SELECT CONVERT(NVARCHAR(20), [date], 120) as date, 0 as observed, 0 as sum, 0 as fullsum, [ident] as id
		FROM @ReportTable
	else
	begin
	------------------------------------------------------------------------------------
	
	insert into @ReportTable([ident],[date],[cnt])
		select ad.idfAggregateDetail,
		ah.datStartDate,
		case
			when @GroupAge = 1 then ad.intAge0_4
			when @GroupAge = 2 then ad.intAge5_14
			when @GroupAge = 3 then ad.intAge15_29
			when @GroupAge = 4 then ad.intAge30_64
			when @GroupAge = 5 then ad.intAge65
			when @GroupAge = 6 then ad.inTotalILI
		end
	from	tlbBasicSyndromicSurveillanceAggregateHeader ah
    		INNER JOIN tlbBasicSyndromicSurveillanceAggregateDetail ad   ON ah.idfAggregateHeader = ad.idfAggregateHeader      and ad.intRowStatus = 0
      		INNER JOIN tlbOffice o	ON o.idfOffice = ad.idfHospital	and o.intRowStatus = 0
      		LEFT OUTER JOIN tlbGeoLocationShared gl    ON o.idfLocation = gl.idfGeoLocationShared   and gl.intRowStatus = 0

	WHERE 	--dates
			@StartDate <= ah.datStartDate

		   and  @FinishDate > ah.datFinishDate

		--hospital
		and (@Hospital is null or  ad.idfHospital = @Hospital)

		-- region-rayon
		and (@RegionID is null or (@Hospital is null and gl.idfsRegion is not null and gl.idfsRegion = @RegionID))
		and (@RayonID is null or (@Hospital is null and gl.idfsRayon is not null and gl.idfsRayon = @RayonID)) 

		and ah.intRowStatus = 0


	;WITH nw AS 
	(
  		SELECT TOP (DATEDIFF(WEEK, @StartDate, @FinishDate)) 
    		nw = ROW_NUMBER() OVER (ORDER BY [object_id])
  		FROM sys.all_objects
	)
	SELECT CONVERT(NVARCHAR(20), DATEADD(WEEK, nw-1, @StartDate), 120) as date, sum(isnull(r.cnt,0)) as observed, -1 as sum, -1 as fullsum, nw-1 as id
	FROM nw
	LEFT OUTER JOIN @ReportTable r ON DATEADD(WEEK, nw-1, @StartDate) <= [date] AND DATEADD(WEEK, nw, @StartDate) > [date]
	GROUP BY DATEADD(WEEK, nw-1, @StartDate), nw;


end
