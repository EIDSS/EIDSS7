

--##SUMMARY TThis procedure returns resultset for "Weekly situation on infectious diseases by age group and sex" report

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 14.01.2015

--##RETURNS Don't use 

/*
--Example of a call of procedure:

declare @UserId	 bigint
select @UserId = u.idfUserID
from tstUserTable u
join tstSite s
on s.idfsSite = u.idfsSite
and s.strSiteName = N'CDC' 

exec spRepHumWeeklyDiseasesByAgeGroupAndSex 
'en',
 N'2014-01-01T00:00:00',
  N'2015-01-01T00:00:00', 
  39520000000, --Baghdad,
  @UserId


*/ 
create  PROCEDURE [dbo].[spRepHumWeeklyDiseasesByAgeGroupAndSex]
(
	 @LangID		As nvarchar(50),
	 @SD			as nvarchar(20), 
	 @ED			as nvarchar(20),
	 @RegionID		as bigint = null,
	 @UserId		as bigint = null
)
AS	
begin

DECLARE	
		@idfsLanguage BIGINT
	,	@idfsCustomReportType BIGINT
	,	@strUserName nvarchar(200) 
	,	@SDDate DATETIME
	,	@EDDate DATETIME


  declare @ReportTable table
  (
    idfsBaseReference	bigint not null primary key,
	strDiagnosis		nvarchar (300) collate database_default not null,
    strUserName			nvarchar(300) null,
    int_0_Male			int, 
    int_0_Female		int, 
    int_1_4_Male		int, 
    int_1_4_Female		int, 
    int_5_14_Male		int, 
    int_5_14_Female		int, 
    int_15_45_Male		int, 
    int_15_45_Female	int, 
    int_45_Male			int, 
    int_45_Female		int, 
	intTotal_Male		int,
	intTotal_Female		int,
	intTotal			int,
	intOrder			int
  )

	SELECT 
		@strUserName = dbo.fnConcatFullName(tp.strFamilyName, tp.strFirstName, tp.strSecondName)
	FROM tstUserTable tut
		inner join tlbPerson tp
		on tp.idfPerson = tut.idfPerson
	WHERE tut.idfUserID = isnull(@UserId, dbo.fnUserID())


	SET @idfsCustomReportType = 10290023 /*IQ Weekly situation on infectious diseases by age group and sex*/
	
	SET @SDDate=dbo.fn_SetMinMaxTime(CAST(@SD AS DATETIME),0)
	SET @EDDate=dbo.fn_SetMinMaxTime(CAST(@ED AS DATETIME),1)
	
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
	
	
	DECLARE @ReportDiagnosisTable TABLE 
		(	
			idfsDiagnosis	bigint not null primary key
		)

	INSERT INTO @ReportDiagnosisTable 
	(
		idfsDiagnosis
	) 
	SELECT DISTINCT
		trtd.idfsDiagnosis		
	FROM dbo.trtDiagnosisToGroupForReportType fdt
		INNER JOIN trtDiagnosis trtd
		ON trtd.idfsDiagnosis = fdt.idfsDiagnosis 
		inner join trtReportRows trr
		on trr.idfsDiagnosisOrReportDiagnosisGroup = fdt.idfsReportDiagnosisGroup		
		and trr.idfsCustomReportType = fdt.idfsCustomReportType
	WHERE  fdt.idfsCustomReportType = @idfsCustomReportType    

	INSERT INTO @ReportDiagnosisTable (
		idfsDiagnosis
	) 
	SELECT distinct
	  trtd.idfsDiagnosis
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
		   SELECT * FROM @ReportDiagnosisTable
		   WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
		   )      

	insert into @ReportTable 
	(
		idfsBaseReference
		,strDiagnosis	
		,strUserName		
		,int_0_Male 
		,int_0_Female 
		,int_1_4_Male
		,int_1_4_Female 
		,int_5_14_Male
		,int_5_14_Female 
		,int_15_45_Male 
		,int_15_45_Female 
		,int_45_Male
		,int_45_Female 
		,intTotal_Male 
		,intTotal_Female 
		,intTotal 
		,intOrder 
	)
	SELECT 
		rr.idfsDiagnosisOrReportDiagnosisGroup
		, ISNULL(snt.strTextString, br.strDefault)
		, @strUserName
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, 0
		, rr.intRowOrder
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
	WHERE rr.idfsCustomReportType = @idfsCustomReportType
		AND rr.intRowStatus = 0
	ORDER BY rr.intRowOrder  
	
	
	DECLARE @ReportCaseTable table
	(	
		idfsDiagnosis BIGINT not null primary key,
		int_0_Male			int, 
		int_0_Female		int, 
		int_1_4_Male		int, 
		int_1_4_Female		int, 
		int_5_14_Male		int, 
		int_5_14_Female		int, 
		int_15_45_Male		int, 
		int_15_45_Female	int, 
		int_45_Male			int, 
		int_45_Female		int, 
		intTotal_Male		int,
		intTotal_Female		int,
		intTotal			int
	)
	
	DECLARE @ReportDiagnosisGroupTable table
	(	
		idfsReportDiagnosisGroup BIGINT not null  primary key,
		int_0_Male			int, 
		int_0_Female		int, 
		int_1_4_Male		int, 
		int_1_4_Female		int, 
		int_5_14_Male		int, 
		int_5_14_Female		int, 
		int_15_45_Male		int, 
		int_15_45_Female	int, 
		int_45_Male			int, 
		int_45_Female		int, 
		intTotal_Male		int,
		intTotal_Female		int,
		intTotal			int
	)
	
	;
	WITH DiagnosisTable
	AS
	(
		SELECT
			idfsDiagnosis
		FROM @ReportDiagnosisTable dt
	)
	
	, CaseTable
	AS
	(
		select
			  hc.idfHumanCase
			, COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis) AS idfsShowDiagnosis
			, h.idfsHumanGender AS Sex
			, CASE
				WHEN ISNULL(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						THEN hc.intPatientAge
				WHEN ISNULL(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						THEN CAST(hc.intPatientAge / 12 AS INT)
				WHEN ISNULL(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						THEN 0
				ELSE NULL
			END AS Age
		FROM tlbHumanCase hc
		JOIN tlbHuman h ON
			hc.idfHuman = h.idfHuman 
			AND h.intRowStatus = 0
		JOIN tlbGeoLocation gl ON
			h.idfCurrentResidenceAddress = gl.idfGeoLocation 
			AND gl.intRowStatus = 0  
			AND gl.idfsRegion = @RegionID
		WHERE @SDDate <= COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate)
			AND COALESCE(hc.datOnSetDate, hc.datFinalDiagnosisDate, hc.datTentativeDiagnosisDate, hc.datNotificationDate, hc.datEnteredDate) <= @EDDate
			AND hc.intRowStatus = 0 
			AND COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus) <> 370000000 /*casRefused*/ 
	)

	, ReportTable
	AS
	(
		select
			ct.idfHumanCase
			, dt.idfsDiagnosis
			, CASE 
				WHEN Sex = 10043002 /*Male*/
					THEN 1 ELSE 0 
			  END AS 'int_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/
					THEN 1 ELSE 0 
			  END AS 'int_Female'
			, CASE 
				WHEN Sex = 10043002 /*Male*/ AND Age < 1
					THEN 1 ELSE 0 
			  END AS 'int_0_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/ AND Age < 1
					THEN 1 ELSE 0 
			  END AS 'int_0_Female'
			  
			, CASE 
				WHEN Sex = 10043002 /*Male*/ AND Age BETWEEN 1 AND 4
					THEN 1 ELSE 0 
			  END AS 'int_1_4_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/ AND Age BETWEEN 1 AND 4
					THEN 1 ELSE 0 
			  END AS 'int_1_4_Female'
			  
			, CASE 
				WHEN Sex = 10043002 /*Male*/ AND Age BETWEEN 5 AND 14
					THEN 1 ELSE 0 
			  END AS 'int_5_14_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/ AND Age BETWEEN 5 AND 14
					THEN 1 ELSE 0 
			  END AS 'int_5_14_Female'
			  
			, CASE 
				WHEN Sex = 10043002 /*Male*/ AND Age BETWEEN 15 AND 45
					THEN 1 ELSE 0 
			  END AS 'int_15_45_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/ AND Age BETWEEN 15 AND 45
					THEN 1 ELSE 0 
			  END AS 'int_15_45_Female'
			  
			, CASE 
				WHEN Sex = 10043002 /*Male*/ AND Age > 45
					THEN 1 ELSE 0 
			  END AS 'int_45_Male'
			, CASE 
				WHEN Sex = 10043001 /*Female*/ AND Age > 45
					THEN 1 ELSE 0 
			  END AS 'int_45_Female'
		FROM DiagnosisTable dt
		LEFT JOIN CaseTable ct ON
			ct.idfsShowDiagnosis = dt.idfsDiagnosis
		where ct.idfsShowDiagnosis IS NOT NULL
	)


		
	INSERT INTO @ReportCaseTable
	(
		idfsDiagnosis
		, int_0_Male
		, int_0_Female
		, int_1_4_Male
		, int_1_4_Female
		, int_5_14_Male
		, int_5_14_Female
		, int_15_45_Male
		, int_15_45_Female
		, int_45_Male
		, int_45_Female
		, intTotal_Male
		, intTotal_Female
		, intTotal
	)
	SELECT 
		idfsDiagnosis
		, SUM(int_0_Male)			AS int_0_Male
		, SUM(int_0_Female)			AS int_0_Female
		, SUM(int_1_4_Male)			AS int_1_4_Male
		, SUM(int_1_4_Female)		AS int_1_4_Female
		, SUM(int_5_14_Male)		AS int_5_14_Male
		, SUM(int_5_14_Female)		AS int_5_14_Female
		, SUM(int_15_45_Male)		AS int_15_45_Male
		, SUM(int_15_45_Female)		AS int_15_45_Female
		, SUM(int_45_Male)			AS int_45_Male
		, SUM(int_45_Female)		AS int_45_Female
		, SUM(int_Male)				AS intTotal_Male
		, SUM(int_Female)			AS intTotal_Female
		, count(idfHumanCase)		AS intTotal
	FROM ReportTable
	GROUP BY idfsDiagnosis

	
	INSERT INTO @ReportDiagnosisGroupTable	
	(
		idfsReportDiagnosisGroup
		,int_0_Male
		,int_0_Female
		,int_1_4_Male
		,int_1_4_Female	
		,int_5_14_Male
		,int_5_14_Female
		,int_15_45_Male	
		,int_15_45_Female
		,int_45_Male
		,int_45_Female
		,intTotal_Male
		,intTotal_Female
		,intTotal
	)
	select
		 dtg.idfsReportDiagnosisGroup	
		,sum(rct.int_0_Male)
		,sum(rct.int_0_Female)
		,sum(rct.int_1_4_Male)
		,sum(rct.int_1_4_Female)	
		,sum(rct.int_5_14_Male)
		,sum(rct.int_5_14_Female)
		,sum(rct.int_15_45_Male)	
		,sum(rct.int_15_45_Female)
		,sum(rct.int_45_Male)
		,sum(rct.int_45_Female)
		,sum(rct.intTotal_Male)
		,sum(rct.intTotal_Female)
		,sum(rct.intTotal)
	from		@ReportCaseTable rct
		inner join	dbo.trtDiagnosisToGroupForReportType dtg
		on			dtg.idfsDiagnosis = rct.idfsDiagnosis
					and dtg.idfsCustomReportType = @idfsCustomReportType
	group by	dtg.idfsReportDiagnosisGroup		
	
	
	update		rt
	set	
		 rt.int_0_Male			= rct.int_0_Male
		,rt.int_0_Female		= rct.int_0_Female
		,rt.int_1_4_Male		= rct.int_1_4_Male
		,rt.int_1_4_Female		= rct.int_1_4_Female	
		,rt.int_5_14_Male		= rct.int_5_14_Male
		,rt.int_5_14_Female		= rct.int_5_14_Female
		,rt.int_15_45_Male		= rct.int_15_45_Male	
		,rt.int_15_45_Female	= rct.int_15_45_Female
		,rt.int_45_Male			= rct.int_45_Male
		,rt.int_45_Female		= rct.int_45_Female
		,rt.intTotal_Male		= rct.intTotal_Male	
		,rt.intTotal_Female		= rct.intTotal_Female
		,rt.intTotal			= rct.intTotal
	from		@ReportTable rt
	inner join	@ReportCaseTable rct
	on			rct.idfsDiagnosis = rt.idfsBaseReference	
		
	update		rt
	set	
		 rt.int_0_Male			= rdgt.int_0_Male
		,rt.int_0_Female		= rdgt.int_0_Female
		,rt.int_1_4_Male		= rdgt.int_1_4_Male
		,rt.int_1_4_Female		= rdgt.int_1_4_Female	
		,rt.int_5_14_Male		= rdgt.int_5_14_Male
		,rt.int_5_14_Female		= rdgt.int_5_14_Female
		,rt.int_15_45_Male		= rdgt.int_15_45_Male	
		,rt.int_15_45_Female	= rdgt.int_15_45_Female
		,rt.int_45_Male			= rdgt.int_45_Male
		,rt.int_45_Female		= rdgt.int_45_Female
		,rt.intTotal_Male		= rdgt.intTotal_Male	
		,rt.intTotal_Female		= rdgt.intTotal_Female
		,rt.intTotal			= rdgt.intTotal
	from		@ReportTable rt
	inner join	@ReportDiagnosisGroupTable rdgt
	on			rdgt.idfsReportDiagnosisGroup = rt.idfsBaseReference		
	
/*				
--=========================================================--					
	--- STUB results ---
	--- it should be deleted after proper implementation ---
--=========================================================--									



	insert into @ReportTable
	SELECT		disease.idfsReference,
				disease.name,
				'Some user',
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(4*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(3*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(2*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(10*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(10*RAND(BINARY_CHECKSUM(NEWID()))as int),
				cast(20*RAND(BINARY_CHECKSUM(NEWID()))as int),
				0	
				
	from		fnReference(@LangID, 19000019) disease
    where		idfsReference in    ( 7719020000000,    7720170000000,    7719580000000,    7718960000000,    7721480000000,    7720640000000,    7720070000000)

	update @ReportTable
	set intOrder = 1 where idfsDiagnosis = 7719020000000

	update @ReportTable
	set intOrder = 2 where idfsDiagnosis = 7720170000000

	update @ReportTable
	set intOrder = 3 where idfsDiagnosis = 7719580000000

	update @ReportTable
	set intOrder = 4 where idfsDiagnosis = 7718960000000

	update @ReportTable
	set intOrder = 5 where idfsDiagnosis = 7721480000000

	update @ReportTable
	set intOrder = 6 where idfsDiagnosis = 7720640000000
	
	update @ReportTable
	set intOrder = 7 where idfsDiagnosis = 7720070000000
*/

	select * from @ReportTable
	order by intOrder
end

