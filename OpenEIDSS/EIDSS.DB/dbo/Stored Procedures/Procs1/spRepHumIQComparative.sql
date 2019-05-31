

--##SUMMARY 

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 13.01.2015

--##RETURNS Don't use 

/*
--Example of a call of procedure:

declare @UserId	 bigint
select @UserId = u.idfUserID
from tstUserTable u
join tstSite s
on s.idfsSite = u.idfsSite
and s.strSiteName = N'CDC' 

exec spRepHumIQComparative 'en', 2014, 2014, 1, 12, null, null, null, null, null, @UserId 

exec spRepHumIQComparative 'ar', 2014, 2014, 1, 12, null, null, null, null, null,

*/ 
 
create PROCEDURE [dbo].[spRepHumIQComparative]
	@LangID				as varchar(36),
	@FirstYear			as int, 
	@SecondYear			as int, 
	@StartMonth			as int = null,
	@EndMonth			as int = null,
	@FirstRegionID		as bigint = null,
	@FirstRayonID		as bigint = null,
	@SecondRegionID		as bigint = null,
	@SecondRayonID		as bigint = null,
	@SiteID				as bigint = null,
	@UserId				as bigint = null

AS
BEGIN


	declare	@ReportTable	table
	(	  
		idfsBaseReference	bigint not null primary key
		, intRowNumber		int null
		, strDisease		nvarchar(300) collate database_default not null 
		, strICD10			nvarchar(200) collate database_default null	
		, strUserName		nvarchar(200) collate database_default null	
		
		, strAdministrativeUnit1 nvarchar(2000) collate database_default not null 
		, intUnit1Y1 float not null
		, intUnit1Y2 float not null
		, intUnit1Percent decimal(8,2)  null
		, strAdministrativeUnit2 nvarchar(2000) collate database_default not null 
		, intUnit2Y1 float not null
		, intUnit2Y2 float not null
		, intUnit2Percent decimal(8,2)  null
	)


declare
	@strUserName nvarchar(200), 		
	@StartDate1 DATETIME,	 
	@FinishDate1 DATETIME,		
	@StartDate2 DATETIME,	 
	@FinishDate2 DATETIME,

	@idfsLanguage BIGINT,
		
	@idfsCustomReportType BIGINT,	
	  
	@strAdministrativeUnit1 NVARCHAR(2000),
	@strAdministrativeUnit2 NVARCHAR(2000),
	  
	@CountryID BIGINT,
	@idfsSite BIGINT
	  
 

SELECT 
	@strUserName = dbo.fnConcatFullName(tp.strFamilyName, tp.strFirstName, tp.strSecondName)
FROM tstUserTable tut
	inner join tlbPerson tp
	on tp.idfPerson = tut.idfPerson
WHERE tut.idfUserID = isnull(@UserId, dbo.fnUserID())

print @strUserName

SET @idfsCustomReportType = 10290024 /*IQ Comparative Report*/
SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	


IF @StartMonth IS NULL
BEGIN
	SET @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '01' + '01')
	SET @FinishDate1 = DATEADD(yyyy, 1, @StartDate1) 
  	
	SET @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '01' + '01')
	SET @FinishDate2 = DATEADD(yyyy, 1, @StartDate2) 
END
ELSE
BEGIN	
	IF @StartMonth < 10	
	BEGIN
		SET @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '0' +CAST(@StartMonth AS VARCHAR(2)) + '01')
		SET @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '0' +CAST(@StartMonth AS VARCHAR(2)) + '01')
	END	
	ELSE 
		BEGIN				
			SET @StartDate1 = (CAST(@FirstYear AS VARCHAR(4)) + CAST(@StartMonth AS VARCHAR(2)) + '01')
			SET @StartDate2 = (CAST(@SecondYear AS VARCHAR(4)) + CAST(@StartMonth AS VARCHAR(2)) + '01')
		END
		
		
	IF (@EndMonth IS NULL) OR (@StartMonth = @EndMonth) 
	BEGIN 
		SET @FinishDate1 = DATEADD(mm, 1, @StartDate1)
		SET @FinishDate2 = DATEADD(mm, 1, @StartDate2)
	END 	
	ELSE	
		BEGIN
			IF @EndMonth < 10	
			BEGIN
				SET @FinishDate1 = (CAST(@FirstYear AS VARCHAR(4)) + '0' +CAST(@EndMonth AS VARCHAR(2)) + '01')
				SET @FinishDate2 = (CAST(@SecondYear AS VARCHAR(4)) + '0' +CAST(@EndMonth AS VARCHAR(2)) + '01')
			END
			ELSE 
				BEGIN
					SET @FinishDate1 = (CAST(@FirstYear AS VARCHAR(4)) + CAST(@EndMonth AS VARCHAR(2)) + '01')
					SET @FinishDate2 = (CAST(@SecondYear AS VARCHAR(4)) + CAST(@EndMonth AS VARCHAR(2)) + '01')
				END  
				
			SET @FinishDate1 = DATEADD(mm, 1, @FinishDate1)
			SET @FinishDate2 = DATEADD(mm, 1, @FinishDate2)
		END 
END	

print @StartDate1
print @FinishDate1

set @CountryID = 1050000000	--Iraq
set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
	
	
SET @strAdministrativeUnit1 = ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000002 /*rftRayon*/) WHERE idfsReference = @FirstRayonID),'') 
						+
						CASE 
							WHEN @FirstRayonID IS NOT NULL AND @FirstRegionID IS NOT NULL 
								THEN ', '
							ELSE ''
						END
						+
						CASE 
							WHEN @FirstRegionID IS NOT NULL 
								THEN ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000003 /*rftRegion*/) WHERE idfsReference = @FirstRegionID),'') 
							ELSE ''
						END
            			+
						CASE 
							WHEN @FirstRayonID IS NULL AND @FirstRegionID IS NULL
								THEN case when @LangID = 'ar' then N'البلد' else N'Country' end
							ELSE ''
						END		

SET @strAdministrativeUnit2 = ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000002 /*rftRayon*/) WHERE idfsReference = @SecondRayonID),'') 
						+
						CASE 
							WHEN @SecondRayonID IS NOT NULL AND @SecondRegionID IS NOT NULL AND @SecondRegionID <> 1344340000000 -- Other rayons
								THEN ', '
							ELSE ''
						END
						+
						CASE 
							WHEN @SecondRegionID IS NOT NULL 
								THEN ISNULL((SELECT [name] FROM fnGisReference(@LangID, 19000003 /*rftRegion*/) WHERE idfsReference = @SecondRegionID),'') 
							ELSE ''
						END
            			+
						CASE 
							WHEN @SecondRayonID IS NULL AND @SecondRegionID IS NULL
								THEN case when @LangID = 'ar' then N'البلد' else N'Country' end
							ELSE ''
						END


	INSERT INTO @ReportTable 
		(
			idfsBaseReference
			, intRowNumber
			, strUserName
			, strDisease
			, strICD10
			
			, strAdministrativeUnit1
			, intUnit1Y1
			, intUnit1Y2
			, intUnit1Percent
			
			, strAdministrativeUnit2
			, intUnit2Y1
			, intUnit2Y2
			, intUnit2Percent
		) 
	SELECT 
		rr.idfsDiagnosisOrReportDiagnosisGroup
		, rr.intRowOrder
		, @strUserName
	
		, ISNULL(ISNULL(snt1.strTextString, br1.strDefault) +  N' ', N'') + ISNULL(snt.strTextString, br.strDefault)
		, ISNULL(d.strIDC10, dg.strCode)
	  
		, @strAdministrativeUnit1
		, 0
		, 0
		, 0.00
	  
		, @strAdministrativeUnit2
		, 0
		, 0
		, 0.00
	FROM dbo.trtReportRows rr
	LEFT JOIN trtBaseReference br
		LEFT JOIN trtStringNameTranslation snt ON 
			br.idfsBaseReference = snt.idfsBaseReference
			AND snt.idfsLanguage = @idfsLanguage
		LEFT OUTER JOIN trtDiagnosis d ON
			br.idfsBaseReference = d.idfsDiagnosis
		LEFT OUTER JOIN trtReportDiagnosisGroup dg
        ON br.idfsBaseReference = dg.idfsReportDiagnosisGroup
	ON rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference

	LEFT OUTER JOIN trtBaseReference br1
		LEFT OUTER JOIN trtStringNameTranslation snt1 ON 
			br1.idfsBaseReference = snt1.idfsBaseReference
			AND snt1.idfsLanguage = @idfsLanguage
	ON rr.idfsReportAdditionalText = br1.idfsBaseReference   

	WHERE rr.idfsCustomReportType = @idfsCustomReportType
		AND rr.intRowStatus = 0
	ORDER BY rr.intRowOrder  


	IF OBJECT_ID('tempdb.dbo.#ReportDiagnosisTable') is not null 
	DROP TABLE #ReportDiagnosisTable

	CREATE TABLE #ReportDiagnosisTable
	(	
		idfsDiagnosis		BIGINT NOT NULL PRIMARY KEY,
		intTotal			INT not NULL,
	)

	INSERT INTO #ReportDiagnosisTable 
	(
		idfsDiagnosis,
		intTotal
	) 
	SELECT DISTINCT
		trtd.idfsDiagnosis
		, 0
	FROM dbo.trtDiagnosisToGroupForReportType fdt
		INNER JOIN trtDiagnosis trtd
		ON trtd.idfsDiagnosis = fdt.idfsDiagnosis 
		inner join trtReportRows trr
		on trr.idfsDiagnosisOrReportDiagnosisGroup = fdt.idfsReportDiagnosisGroup		
		and trr.idfsCustomReportType = fdt.idfsCustomReportType
	WHERE  fdt.idfsCustomReportType = @idfsCustomReportType    



	INSERT INTO #ReportDiagnosisTable (
		idfsDiagnosis,
		intTotal
	) 
	SELECT distinct
	  trtd.idfsDiagnosis,
	  0
	FROM dbo.trtReportRows rr
		INNER JOIN trtBaseReference br
		ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
			AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
		INNER JOIN trtDiagnosis trtd
		ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
	WHERE  rr.idfsCustomReportType = @idfsCustomReportType 
		   AND  rr.intRowStatus = 0 
		   AND NOT EXISTS 
		   (
		   SELECT * FROM #ReportDiagnosisTable
		   WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
		   )      


	DECLARE	@ReportDiagnosisGroupTable	TABLE
	(	idfsDiagnosisGroup	BIGINT NOT NULL PRIMARY KEY,
		intTotal			INT NOT NULL
	)  

----------------------------------------------------------------------------------------
-- @StartDate1 - @FinishDate1
-- @FirstRegionID, @FirstRayonID 
----------------------------------------------------------------------------------------
EXEC dbo.spRepHumIQComparative_Calculations  @StartDate1, @FinishDate1, @FirstRegionID, @FirstRayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intUnit1Y1 = fdgt.intTotal
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
		
		
update		ft
set	
    ft.intUnit1Y1 = fdt.intTotal
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	


----------------------------------------------------------------------------------------
-- @StartDate2 - @FinishDate2
-- @FirstRegionID, @FirstRayonID 
----------------------------------------------------------------------------------------
UPDATE #ReportDiagnosisTable
SET intTotal = 0

exec dbo.spRepHumIQComparative_Calculations  @StartDate2, @FinishDate2, @FirstRegionID, @FirstRayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intUnit1Y2 = fdgt.intTotal
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
		
		
update		ft
set	
    ft.intUnit1Y2 = fdt.intTotal
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	


	
----------------------------------------------------------------------------------------
-- @StartDate1 - @FinishDate1
-- @SecondRegionID, @SecondRayonID 
----------------------------------------------------------------------------------------
UPDATE #ReportDiagnosisTable
SET intTotal = 0

exec dbo.spRepHumIQComparative_Calculations  @StartDate1, @FinishDate1, @SecondRegionID, @SecondRayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intUnit2Y1 = fdgt.intTotal
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
		
		
update		ft
set	
    ft.intUnit2Y1 = fdt.intTotal
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	




----------------------------------------------------------------------------------------
-- @StartDate2 - @FinishDate2
-- @SecondRegionID, @SecondRayonID 
----------------------------------------------------------------------------------------
UPDATE #ReportDiagnosisTable
SET intTotal = 0

exec dbo.spRepHumIQComparative_Calculations  @StartDate2, @FinishDate2, @SecondRegionID, @SecondRayonID 

delete from @ReportDiagnosisGroupTable

insert into	@ReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal)
from		#ReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup

update		ft
set	
  ft.intUnit2Y2 = fdgt.intTotal
from		@ReportTable ft
inner join	@ReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference	
		
		
update		ft
set	
    ft.intUnit2Y2 = fdt.intTotal
from		@ReportTable ft
inner join	#ReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	




	


--- calculate %
UPDATE @ReportTable 
SET intUnit1Percent = CASE WHEN intUnit1Y1 = 0 THEN null ELSE (intUnit1Y2 - intUnit1Y1) / intUnit1Y1 END
	, intUnit2Percent = CASE WHEN intUnit2Y1 = 0 THEN null ELSE (intUnit2Y2 - intUnit2Y1) / intUnit2Y1 END


/*
	----=========================================================--					
	--	--- STUB results---	
	--	--- it should be deleted after proper implementation ---
	----=========================================================--				
	insert into @ReportTable
	
	
	select	top 60 
			  fnReferenceRepair.idfsReference 
			, null
			, 'USER name'
			, fnReferenceRepair.name
			, trtDiagnosis.strIDC10
			, 'Nizami, Baku' as strAdministrativeUnit1
			, cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int)	
			, cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int)	
			, (100*RAND(BINARY_CHECKSUM(NEWID()))	- 80*RAND(BINARY_CHECKSUM(NEWID())))/100		
			, 'Republic' 
			, cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int)	
			, cast (10*RAND(BINARY_CHECKSUM(NEWID())) as int)	
			, (100*RAND(BINARY_CHECKSUM(NEWID()))	- 80*RAND(BINARY_CHECKSUM(NEWID())))/100	
	from	dbo.fnReferenceRepair(@LangID, 19000019) --rftDiagnosis
	inner join trtDiagnosis
	on			trtDiagnosis.idfsDiagnosis = fnReferenceRepair.idfsReference
	where		fnReferenceRepair.intHACode&2 = 2
	order by	fnReferenceRepair.intOrder, fnReferenceRepair.name  
*/

SELECT
* 
from @ReportTable
order by intRowNumber


END
	
