

--##SUMMARY Select data for Reportable Infectious Diseases (Monthly Form IV03).
--##REMARKS Author: 
--##REMARKS Create date: 10.01.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepHumMonthlyInfectiousDisease 'en', '2010-01-01', '2015-02-01',  37020000000, 3260000000

exec spRepHumMonthlyInfectiousDisease 'en', '2010-01-01', '2015-02-01'
*/

create  Procedure [dbo].[spRepHumMonthlyInfectiousDisease]
	(
		@LangID		as nvarchar(10), 
		@StartDate	as datetime,	 
		@FinishDate	as datetime,
		@RegionID	as bigint = null,
		@RayonID	as bigint = null,
		@SiteID		as bigint = null
	)
AS	

exec dbo.spSetFirstDay

-- Field description may be found here
-- "https://repos.btrp.net/BTRP/Project_Documents/08x-Implementation/Customizations/GG/Reports/Specification for report development - Monthly Form 03 Human GG v1.0.doc"
-- by number marked red at screen form prototype 

declare	@ReportTable	table
(	idfsBaseReference	bigint not null primary key,
	strDiseaseName		nvarchar(300) collate database_default not null, --46
	strICD10			nvarchar(200) collate database_default null,	--47
	intAge_0_1			float not null,	--7
	intAge_1_4			float not null, --8
	intAge_5_14			float not null, --9
	intAge_15_19		float not null, --10
	intAge_20_29		float not null, --11
	intAge_30_59		float not null, --12
	intAge_60_more		float not null, --13
	intTotal			float not null, --14
	intLabTested		float null,		--15
	intLabConfirmed		float null,		--16
	intTotalConfirmed	float null,		--18
	strNameOfRespondent nvarchar(200) collate database_default null, --1
	strActualAddress	nvarchar(200) collate database_default null, --2
	strTelephone		nvarchar(200) collate database_default null, --3
	strMonth		nvarchar(200) collate database_default null, --3
	intOrder			int not null
)


DECLARE @idfsCustomReportType BIGINT
DECLARE @idfsLanguage BIGINT
DECLARE @strNameOfRespondent NVARCHAR(200)
DECLARE @strActualAddress NVARCHAR(200)
DECLARE @strTelephone  NVARCHAR(200)
DECLARE @strMonth AS NVARCHAR(200)
DECLARE @idfsSite BIGINT
DECLARE 
    @FFP_Age_0_1 BIGINT,--7
    @FFP_Age_1_4 BIGINT, --8
    @FFP_Age_5_14 BIGINT, --9
    @FFP_Age_15_19 BIGINT, --10
    @FFP_Age_20_29 BIGINT, --11
    @FFP_Age_30_59 BIGINT, --12
    @FFP_Age_60_more BIGINT, --13
    @FFP_Total BIGINT, --14
    @FFP_LabTested BIGINT,		--15
    @FFP_LabConfirmed BIGINT,		--18
    @FFP_TotalConfirmed BIGINT --21
    
declare @FatalCasesOfInfectiousDiseases bigint

--set @FatalCasesOfInfectiousDiseases = 10750760000000 /*Fatal cases of infectious diseases*/
    
select @FatalCasesOfInfectiousDiseases = dg.idfsReportDiagnosisGroup
from dbo.trtReportDiagnosisGroup dg
where dg.intRowStatus = 0 and
      dg.strDiagnosisGroupAlias = 'DG_FatalCasesOfInfectiousDiseases'

    
SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)

IF @RayonID IS NULL
BEGIN
  SET @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
  
END
ELSE
BEGIN
  SELECT @idfsSite = fnfl.idfsSite
  FROM dbo.fnReportingFacilitiesList(@idfsLanguage, @RayonID) fnfl
  
  IF @idfsSite IS NULL SET @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
END

SELECT 
    @strActualAddress = dbo.fnAddressSharedString(@LangID, tlbOffice.idfLocation),
    @strTelephone = tlbOffice.strContactPhone,
    @strNameOfRespondent = ISNULL(trtStringNameTranslation.strTextString, trtBaseReference.strDefault)
FROM tlbOffice
    INNER JOIN tstSite
    ON tlbOffice.idfOffice = tstSite.idfOffice
    AND tstSite.intRowStatus = 0

    INNER JOIN trtBaseReference
    ON tlbOffice.idfsOfficeName = trtBaseReference.idfsBaseReference --AND

    LEFT OUTER JOIN trtStringNameTranslation
    ON trtBaseReference.idfsBaseReference = trtStringNameTranslation.idfsBaseReference
    AND trtStringNameTranslation.idfsLanguage = @idfsLanguage 
    AND trtStringNameTranslation.intRowStatus = 0

WHERE tstSite.idfsSite = @idfsSite AND tlbOffice.intRowStatus = 0



select		
	@strMonth = IsNull(snt.strTextString, br.strDefault)
	from		trtBaseReference br
	left join	trtStringNameTranslation snt
	on			snt.idfsBaseReference = br.idfsBaseReference
				and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
				and snt.intRowStatus = 0
	where		br.idfsReferenceType = 19000132	-- Report Additional Text
				and br.intRowStatus = 0
				and br.intOrder = MONTH(@StartDate)

SET @idfsCustomReportType = 10290008 /*GG Report on Cases of Infectious Diseases (Monthly Form IV–03/1 Old Revision)*/

select @FFP_Age_0_1 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_1'
and intRowStatus = 0

select @FFP_Age_1_4 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_1_4'
and intRowStatus = 0

select @FFP_Age_5_14 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_5_14'
and intRowStatus = 0

select @FFP_Age_15_19 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_15_19'
and intRowStatus = 0

select @FFP_Age_20_29 = idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_20_29'
and intRowStatus = 0

select @FFP_Age_30_59= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_30_59'
and intRowStatus = 0

select @FFP_Age_60_more= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_60_more'
and intRowStatus = 0

select @FFP_Total= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
and intRowStatus = 0

select @FFP_LabTested= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_LabTested'
and intRowStatus = 0

select @FFP_LabConfirmed= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_LabConfirmed'
and intRowStatus = 0

select @FFP_TotalConfirmed= idfsFFObject from trtFFObjectForCustomReport
where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_TotalConfirmed'
and intRowStatus = 0


INSERT INTO @ReportTable (
	idfsBaseReference,
	strDiseaseName,
	strICD10,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
	intTotal,
	intLabTested,
	intLabConfirmed,
	intTotalConfirmed,
	strNameOfRespondent,
	strActualAddress,
	strTelephone,
	strMonth,
	intOrder
) 
SELECT 
  rr.idfsDiagnosisOrReportDiagnosisGroup,
  ISNULL(ISNULL(snt1.strTextString, br1.strDefault) +  ' ','')  +ISNULL(snt.strTextString, br.strDefault)  ,
  ISNULL(d.strIDC10, dg.strCode),
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  @strNameOfRespondent,
  @strActualAddress,
  @strTelephone,
  @strMonth,
  rr.intRowOrder

  
FROM   dbo.trtReportRows rr
    LEFT JOIN trtBaseReference br
        LEFT JOIN trtStringNameTranslation snt
        ON br.idfsBaseReference = snt.idfsBaseReference
        AND snt.idfsLanguage = @idfsLanguage

        LEFT OUTER JOIN trtDiagnosis d
        ON br.idfsBaseReference = d.idfsDiagnosis
        
        LEFT OUTER JOIN trtReportDiagnosisGroup dg
        ON br.idfsBaseReference = dg.idfsReportDiagnosisGroup
    ON rr.idfsDiagnosisOrReportDiagnosisGroup = br.idfsBaseReference
   
    LEFT OUTER JOIN trtBaseReference br1
        LEFT OUTER JOIN trtStringNameTranslation snt1
        ON br1.idfsBaseReference = snt1.idfsBaseReference
        AND snt1.idfsLanguage = @idfsLanguage
    ON rr.idfsReportAdditionalText = br1.idfsBaseReference
    

WHERE rr.idfsCustomReportType = @idfsCustomReportType AND
rr.idfsDiagnosisOrReportDiagnosisGroup <> @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/
ORDER BY rr.intRowOrder


DECLARE	@MonthlyReportDiagnosisTable	TABLE
(	idfsDiagnosis	BIGINT NOT NULL PRIMARY KEY,
  blnIsAggregate BIT,
	intAge_0_1			INT NOT NULL,	--7
	intAge_1_4			INT NOT NULL, --8
	intAge_5_14			INT NOT NULL, --9
	intAge_15_19		INT NOT NULL, --10
	intAge_20_29		INT NOT NULL, --11
	intAge_30_59		INT NOT NULL, --12
	intAge_60_more		INT NOT NULL, --13
	intTotal			INT NOT NULL, --14
	intLabTested		INT NULL,		--15
	intLabConfirmed		INT NULL,		--18
	intTotalConfirmed	INT NULL		--21
)

INSERT INTO @MonthlyReportDiagnosisTable (
	idfsDiagnosis,
  blnIsAggregate,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
	intTotal,
	intLabTested,
	intLabConfirmed,
	intTotalConfirmed
) 
SELECT DISTINCT
  fdt.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0

FROM dbo.trtDiagnosisToGroupForReportType fdt
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = fdt.idfsDiagnosis
    -- AND trtd.intRowStatus = 0
WHERE  fdt.idfsCustomReportType = @idfsCustomReportType 

     and  fdt.idfsReportDiagnosisGroup <> @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/
       
       
INSERT INTO @MonthlyReportDiagnosisTable (
	idfsDiagnosis,
  blnIsAggregate,
	intAge_0_1,
	intAge_1_4,
	intAge_5_14,
	intAge_15_19,
	intAge_20_29,
	intAge_30_59,
	intAge_60_more,
	intTotal,
	intLabTested,
	intLabConfirmed,
	intTotalConfirmed
) 
SELECT 
  trtd.idfsDiagnosis,
  CASE WHEN  trtd.idfsUsingType = 10020002  --dutAggregatedCase
    THEN 1
    ELSE 0
  END,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0,
  0

FROM dbo.trtReportRows rr
    INNER JOIN trtBaseReference br
    ON br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
        AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
    INNER JOIN trtDiagnosis trtd
    ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
        --AND trtd.intRowStatus = 0
WHERE  rr.idfsCustomReportType = @idfsCustomReportType 
       AND  rr.intRowStatus = 0 
       AND NOT EXISTS 
       (
       SELECT * FROM @MonthlyReportDiagnosisTable
       WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
       )      AND
       rr.idfsDiagnosisOrReportDiagnosisGroup <> @FatalCasesOfInfectiousDiseases /*Fatal cases of infectious diseases*/




       
       
       

DECLARE @MinAdminLevel BIGINT
DECLARE @MinTimeInterval BIGINT
DECLARE @AggrCaseType BIGINT


/*

19000091	rftStatisticPeriodType:
    10091001	sptMonth	Month
    10091002	sptOnday	Day
    10091003	sptQuarter	Quarter
    10091004	sptWeek	Week
    10091005	sptYear	Year

19000089	rftStatisticAreaType
    10089001	satCountry	Country
    10089002	satRayon	Rayon
    10089003	satRegion	Region
    10089004	satSettlement	Settlement


19000102	rftAggregateCaseType:
    10102001  Aggregate Case

*/

SET @AggrCaseType = 10102001

SELECT	@MinAdminLevel = idfsStatisticAreaType,
		@MinTimeInterval = idfsStatisticPeriodType
FROM fnAggregateSettings (@AggrCaseType)--@AggrCaseType



declare	@MonthlyReportHumanAggregateCase	table
(	idfAggrCase	BIGINT not null primary KEY,
  idfCaseObservation BIGINT,
  datStartDate datetime,
  idfVersion bigint
)


insert into	@MonthlyReportHumanAggregateCase
(	idfAggrCase,
  idfCaseObservation,
  datStartDate,
  idfVersion
)
select	  a.idfAggrCase,
          a.idfCaseObservation,
		  a.datStartDate,
		  a.idfVersion
from		tlbAggrCase a
    left join	gisCountry c
    on			c.idfsCountry = a.idfsAdministrativeUnit
			    and c.idfsCountry = 780000000
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = 780000000
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = 780000000
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = 780000000

WHERE 			
			a.idfsAggrCaseType = @AggrCaseType
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < DATEADD(day, 1, @FinishDate)
				)
			and (	(	@MinTimeInterval = 10091005 --'sptYear'
						and DateDiff(year, a.datStartDate, a.datFinishDate) = 0
						and DateDiff(quarter, a.datStartDate, a.datFinishDate) > 1
						and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
						and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
						and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
					)
					or	(	@MinTimeInterval = 10091003 --'sptQuarter'
							and DateDiff(quarter, a.datStartDate, a.datFinishDate) = 0
							and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091001 --'sptMonth'
							and DateDiff(month, a.datStartDate, a.datFinishDate) = 0
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091004 --'sptWeek'
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) = 0
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091002--'sptOnday'
						and DateDiff(day, a.datStartDate, a.datFinishDate) = 0)
				)    and		
        (	(	@MinAdminLevel = 10089001 --'satCountry' 
			    and a.idfsAdministrativeUnit = c.idfsCountry
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @RegionID OR @RegionID IS NULL)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)

			    )
	      )
  and a.intRowStatus = 0	      

DECLARE	@MonthlyReportAggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	BIGINT NOT NULL PRIMARY KEY,
	intAge_0_1			INT NOT NULL,	--7
	intAge_1_4			INT NOT NULL, --8
	intAge_5_14			INT NOT NULL, --9
	intAge_15_19		INT NOT NULL, --10
	intAge_20_29		INT NOT NULL, --11
	intAge_30_59		INT NOT NULL, --12
	intAge_60_more		INT NOT NULL, --13
	intTotal			INT NOT NULL, --14
	intLabTested		INT NULL,		--15
	intLabConfirmed		INT NULL,		--18
	intTotalConfirmed	INT NULL		--21
)








insert into	@MonthlyReportAggregateDiagnosisValuesTable
(	idfsBaseReference,
	intAge_0_1,	--7
	intAge_1_4, --8
	intAge_5_14, --9
	intAge_15_19, --10
	intAge_20_29, --11
	intAge_30_59, --12
	intAge_60_more, --13
	intTotal, --14
	intLabTested,		--15
	intLabConfirmed,		--18
	intTotalConfirmed--21
)
select		
      fdt.idfsDiagnosis      ,
			sum(CAST(IsNull(agp_Age_0_1.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_1_4.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_5_14.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_15_19.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_20_29.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_30_59.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Age_60_more.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_Total.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_LabTested.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_LabConfirmed.varValue, 0)AS INT)),
			sum(CAST(IsNull(agp_TotalConfirmed.varValue, 0)AS INT))

from		@MonthlyReportHumanAggregateCase fhac
-- Updated for version 6

-- Matrix version
inner join	tlbAggrMatrixVersionHeader h
on			h.idfsMatrixType = 71190000000	-- Human Aggregate Case
			and (	-- Get matrix version selected by the user in aggregate case
					h.idfVersion = fhac.idfVersion 
					-- If matrix version is not selected by the user in aggregate case, 
					-- then select active matrix with the latest date activation that is earlier than aggregate case start date
					or (	fhac.idfVersion is null 
							and	h.datStartDate <= fhac.datStartDate
							and	h.blnIsActive = 1
							and not exists	(
										select	*
										from	tlbAggrMatrixVersionHeader h_later
										where	h_later.idfsMatrixType = 71190000000	-- Human Aggregate Case
												and	h_later.datStartDate <= fhac.datStartDate
												and	h_later.blnIsActive = 1
												and h_later.intRowStatus = 0
												and	h_later.datStartDate > h.datStartDate
											)
						))
			and h.intRowStatus = 0

-- Matrix row
inner join	tlbAggrHumanCaseMTX mtx
on			mtx.idfVersion = h.idfVersion
			and mtx.intRowStatus = 0
inner join	@MonthlyReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis
        
        
        
--Age_0_1
left join	dbo.tlbActivityParameters agp_Age_0_1
on			agp_Age_0_1.idfObservation = fhac.idfCaseObservation
			and	agp_Age_0_1.idfsParameter = @FFP_Age_0_1
			and agp_Age_0_1.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_1.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_1.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Age_1_4
left join	dbo.tlbActivityParameters agp_Age_1_4
on			agp_Age_1_4.idfObservation= fhac.idfCaseObservation
			and	agp_Age_1_4.idfsParameter = @FFP_Age_1_4
			and agp_Age_1_4.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_1_4.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_1_4.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			

--	Age_5_14		
left join	dbo.tlbActivityParameters agp_Age_5_14
on			agp_Age_5_14.idfObservation= fhac.idfCaseObservation
			and	agp_Age_5_14.idfsParameter = @FFP_Age_5_14
			and agp_Age_5_14.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_5_14.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_5_14.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

--	Age_15_19		
left join	dbo.tlbActivityParameters agp_Age_15_19
on			agp_Age_15_19.idfObservation= fhac.idfCaseObservation
			and	agp_Age_15_19.idfsParameter = @FFP_Age_15_19
			and agp_Age_15_19.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_15_19.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_15_19.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	Age_20_29		
left join	dbo.tlbActivityParameters agp_Age_20_29
on			agp_Age_20_29.idfObservation= fhac.idfCaseObservation
			and	agp_Age_20_29.idfsParameter = @FFP_Age_20_29
			and agp_Age_20_29.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_20_29.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_20_29.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	Age_30_59		
left join	dbo.tlbActivityParameters agp_Age_30_59
on			agp_Age_30_59.idfObservation= fhac.idfCaseObservation
			and	agp_Age_30_59.idfsParameter = @FFP_Age_30_59
			and agp_Age_30_59.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_30_59.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_30_59.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

--	Age_60_more		
left join	dbo.tlbActivityParameters agp_Age_60_more
on			agp_Age_60_more.idfObservation= fhac.idfCaseObservation
			and	agp_Age_60_more.idfsParameter = @FFP_Age_60_more
			and agp_Age_60_more.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_60_more.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_60_more.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	LabTested		
left join	dbo.tlbActivityParameters agp_LabTested
on			agp_LabTested.idfObservation = fhac.idfCaseObservation
			and	agp_LabTested.idfsParameter = @FFP_LabTested
			and agp_LabTested.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_LabTested.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_LabTested.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')


--	LabConfirmed		
left join	dbo.tlbActivityParameters agp_LabConfirmed
on			agp_LabConfirmed.idfObservation = fhac.idfCaseObservation
			and	agp_LabConfirmed.idfsParameter = @FFP_LabConfirmed
			and agp_LabConfirmed.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_LabConfirmed.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_LabConfirmed.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	TotalConfirmed		
left join	dbo.tlbActivityParameters agp_TotalConfirmed
on			agp_TotalConfirmed.idfObservation = fhac.idfCaseObservation
			and	agp_TotalConfirmed.idfsParameter = @FFP_TotalConfirmed
			and agp_TotalConfirmed.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_TotalConfirmed.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_TotalConfirmed.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

group by	fdt.idfsDiagnosis



declare	@MonthlyReportCaseTable	table
(	idfsDiagnosis			BIGINT  not null,
	idfCase				BIGINT not null primary key,
	intYear					int NULL,
	blnLabTested  BIT,
	blnLabConfirmed   BIT,
	blnLabEpiConfirmed BIT
)

insert into	@MonthlyReportCaseTable
(	idfsDiagnosis,
	idfCase,
	intYear,
	blnLabTested,
	blnLabConfirmed,
	blnLabEpiConfirmed
)
select distinct
			fdt.idfsDiagnosis,
			hc.idfHumanCase AS idfCase,
			case
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 200)
					then	hc.intPatientAge
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
						and (IsNull(hc.intPatientAge, -1) >= 0 and IsNull(hc.intPatientAge, -1) <= 60)
					then	cast(hc.intPatientAge / 12 as int)
				when	IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
						and (IsNull(hc.intPatientAge, -1) >= 0)
					then	0
				else	null
			end,
			case when hc.idfsYNTestsConducted = 10100001 then 1 else 0 end,
			CASE 
			  WHEN  hc.blnLabDiagBasis = 1 and 
			        hc.idfsYNTestsConducted = 10100001 and 
			        (
			          hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/ or
			          (hc.idfsFinalCaseStatus is null and 
			          hc.idfsInitialCaseStatus = 350000000 /*Confirmed Case*/) 
			        )
			  THEN 1 ELSE 0 
			END,
			CASE 
			  WHEN ( (hc.blnLabDiagBasis = 1 and hc.idfsYNTestsConducted = 10100001)  or  
			          hc.blnEpiDiagBasis = 1) 
			       and
			       (
			          hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/ or
			          (hc.idfsFinalCaseStatus is null and 
			          hc.idfsInitialCaseStatus = 350000000 /*Confirmed Case*/) 
			       )			        
			  THEN 1 ELSE 0 
			END
			
FROM tlbHumanCase hc

    INNER JOIN	@MonthlyReportDiagnosisTable fdt
    ON			--fdt.blnIsAggregate = 0 AND
             fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    INNER JOIN tlbHuman h
      LEFT OUTER JOIN tlbGeoLocation gl
      ON h.idfCurrentResidenceAddress = gl.idfGeoLocation
    	AND gl.intRowStatus = 0
    ON hc.idfHuman = h.idfHuman
       and h.intRowStatus = 0
    			
    LEFT OUTER JOIN  tlbGeoLocation cgl
    ON hc.idfPointGeoLocation = cgl.idfGeoLocation
        AND cgl.intRowStatus = 0
			
WHERE	
	(	@StartDate <= ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate))))
		and ISNULL(hc.datOnSetDate, IsNull(hc.datFinalDiagnosisDate, ISNULL(hc.datTentativeDiagnosisDate, IsNull(hc.datNotificationDate, hc.datEnteredDate)))) <  DATEADD(day, 1, @FinishDate)
	) 
	AND
	(	
			(	cgl.idfsRegion is not null and @RegionID is not null
					and (cgl.idfsRegion = @RegionID)
					and (cgl.idfsRayon = @RayonID or @RayonID is null)
			)
			or	
			(	cgl.idfsRegion is null and gl.idfsRegion is not null and @RegionID is not null
					and (gl.idfsRegion = @RegionID)
					and (gl.idfsRayon = @RayonID or @RayonID is null)
			)
			or @RegionID is null
    )
    AND hc.intRowStatus = 0 
    AND COALESCE(hc.idfsFinalCaseStatus, hc.idfsInitialCaseStatus, 370000000) <> 370000000 --'casRefused'
    and (cgl.idfsCountry is null or cgl.idfsCountry = 780000000)
    

--Total
declare	@MonthlyReportCaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis		BIGINT not null primary key,
	intTotal				INT not null
)

insert into	@MonthlyReportCaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
group by	fct.idfsDiagnosis



--Total Age_0_1
declare	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_0_1				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_1
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 0 and fct.intYear < 1)
group by	fct.idfsDiagnosis


--Total Age_1_4
declare	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_1_4				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable
(	idfsDiagnosis,
	intAge_1_4
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 1 and fct.intYear <= 4)
group by	fct.idfsDiagnosis


--Total Age_5_14
declare	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_5_14				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable
(	idfsDiagnosis,
	intAge_5_14
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 5 and fct.intYear <= 14)
group by	fct.idfsDiagnosis


--Total Age_15_19
declare	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_15_19				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable
(	idfsDiagnosis,
	intAge_15_19
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 15 and fct.intYear <= 19)
group by	fct.idfsDiagnosis


--Total Age_20_29
declare	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_20_29				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable
(	idfsDiagnosis,
	intAge_20_29
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 20 and fct.intYear <= 29)
group by	fct.idfsDiagnosis


--Total Age_30_59
declare	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_30_59				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable
(	idfsDiagnosis,
	intAge_30_59
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 30 and fct.intYear <= 59)
group by	fct.idfsDiagnosis


--Total Age_60_more
declare	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intAge_60_more				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable
(	idfsDiagnosis,
	intAge_60_more
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		(fct.intYear >= 60)
group by	fct.idfsDiagnosis


--Total LabTested 
declare	@MonthlyReportCaseDiagnosis_LabTested_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intLabTested				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_LabTested_TotalValuesTable
(	idfsDiagnosis,
	intLabTested
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		fct.blnLabTested = 1
group by	fct.idfsDiagnosis



--Total LabConfirmed 
declare	@MonthlyReportCaseDiagnosis_LabConfirmed_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intLabConfirmed				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_LabConfirmed_TotalValuesTable
(	idfsDiagnosis,
	intLabConfirmed
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		fct.blnLabConfirmed = 1
group by	fct.idfsDiagnosis

--Total TotalConfirmed
declare	@MonthlyReportCaseDiagnosis_TotalConfirmed_TotalValuesTable	table
(	idfsDiagnosis			BIGINT not null primary key,
	intTotalConfirmed				INT not null
)

insert into	@MonthlyReportCaseDiagnosis_TotalConfirmed_TotalValuesTable
(	idfsDiagnosis,
	intTotalConfirmed
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@MonthlyReportCaseTable fct
where		fct.blnLabEpiConfirmed = 1
group by	fct.idfsDiagnosis

--aggregate cases
update		fdt
set				
	fdt.intAge_0_1 = fadvt.intAge_0_1,
	fdt.intAge_1_4 = fadvt.intAge_1_4,
	fdt.intAge_5_14 = fadvt.intAge_5_14,	
	fdt.intAge_15_19 = fadvt.intAge_15_19,	
	fdt.intAge_20_29 = fadvt.intAge_20_29,	
	fdt.intAge_30_59 = fadvt.intAge_30_59,
	fdt.intAge_60_more = fadvt.intAge_60_more,	
	fdt.intTotal = fadvt.intTotal,	
	fdt.intLabTested = fadvt.intLabTested,	
	fdt.intLabConfirmed = fadvt.intLabConfirmed,	
	fdt.intTotalConfirmed = fadvt.intTotalConfirmed		
from		@MonthlyReportDiagnosisTable fdt
    inner join	@MonthlyReportAggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 1


--standard cases
update		fdt
set			fdt.intTotal = isnull (fdt.intTotal, 0) + fcdvt.intTotal
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosisTotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0

update		fdt
set			fdt.intAge_0_1 =isnull (fdt.intAge_0_1, 0) +  fcdvt.intAge_0_1
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_0_1_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0

update		fdt
set			fdt.intAge_1_4 = isnull (fdt.intAge_1_4, 0) + fcdvt.intAge_1_4
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_1_4_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0

update		fdt
set			fdt.intAge_5_14 = isnull (fdt.intAge_5_14, 0) + fcdvt.intAge_5_14
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_5_14_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0
	
update		fdt
set			fdt.intAge_15_19 = isnull (fdt.intAge_15_19, 0) + fcdvt.intAge_15_19
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_15_19_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0	
	
update		fdt
set			fdt.intAge_20_29 = isnull (fdt.intAge_20_29, 0) + fcdvt.intAge_20_29
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_20_29_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
update		fdt
set			fdt.intAge_30_59 = isnull (fdt.intAge_30_59, 0) + fcdvt.intAge_30_59
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_30_59_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
update		fdt
set			fdt.intAge_60_more = isnull (fdt.intAge_60_more, 0) + fcdvt.intAge_60_more
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_Age_60_more_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
update		fdt
set			fdt.intLabTested = isnull (fdt.intLabTested, 0) + fcdvt.intLabTested
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_LabTested_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
update		fdt
set			fdt.intLabConfirmed = isnull (fdt.intLabConfirmed, 0) + fcdvt.intLabConfirmed
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_LabConfirmed_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
update		fdt
set			fdt.intTotalConfirmed = isnull (fdt.intTotalConfirmed, 0) + fcdvt.intTotalConfirmed
from		@MonthlyReportDiagnosisTable fdt
inner join	@MonthlyReportCaseDiagnosis_TotalConfirmed_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
--where		fdt.blnIsAggregate = 0		
	
	
	

	

DECLARE	@MonthlyReportDiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	BIGINT NOT NULL PRIMARY KEY,
	intAge_0_1			INT NOT NULL,	--7
	intAge_1_4			INT NOT NULL, --8
	intAge_5_14			INT NOT NULL, --9
	intAge_15_19		INT NOT NULL, --10
	intAge_20_29		INT NOT NULL, --11
	intAge_30_59		INT NOT NULL, --12
	intAge_60_more		INT NOT NULL, --13
	intTotal			INT NOT NULL, --14
	intLabTested		INT NULL,		--15
	intLabConfirmed		INT NULL,		--18
	intTotalConfirmed	INT NULL		--21
)
	
	
insert into	@MonthlyReportDiagnosisGroupTable
(	idfsDiagnosisGroup,
	intAge_0_1,	
	intAge_1_4, 
	intAge_5_14, 
	intAge_15_19, 
	intAge_20_29, 
	intAge_30_59, 
	intAge_60_more, 
	intTotal, 
	intLabTested,		
	intLabConfirmed,		
	intTotalConfirmed
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intAge_0_1),	
	    sum(intAge_1_4), 
	    sum(intAge_5_14), 
	    sum(intAge_15_19), 
	    sum(intAge_20_29), 
	    sum(intAge_30_59), 
	    sum(intAge_60_more), 
	    sum(intTotal), 
	    sum(intLabTested),		
	    sum(intLabConfirmed),		
	    sum(intTotalConfirmed)
from		@MonthlyReportDiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis AND
dtg.idfsCustomReportType = @idfsCustomReportType
group by	dtg.idfsReportDiagnosisGroup	
	
	
update		ft
set	
  ft.intAge_0_1 = fdt.intAge_0_1,	
	ft.intAge_1_4 = fdt.intAge_1_4, 
	ft.intAge_5_14 = fdt.intAge_5_14, 
	ft.intAge_15_19 = fdt.intAge_15_19, 
	ft.intAge_20_29 = fdt.intAge_20_29, 
	ft.intAge_30_59 = fdt.intAge_30_59, 
	ft.intAge_60_more = fdt.intAge_60_more, 
	ft.intTotal = fdt.intTotal, 
	ft.intLabTested = fdt.intLabTested,
	ft.intLabConfirmed = fdt.intLabConfirmed,
	ft.intTotalConfirmed = fdt.intTotalConfirmed

from		@ReportTable ft
inner join	@MonthlyReportDiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
	
	
update		ft
set	
  ft.intAge_0_1 = fdgt.intAge_0_1,	
	ft.intAge_1_4 = fdgt.intAge_1_4, 
	ft.intAge_5_14 = fdgt.intAge_5_14, 
	ft.intAge_15_19 = fdgt.intAge_15_19, 
	ft.intAge_20_29 = fdgt.intAge_20_29, 
	ft.intAge_30_59 = fdgt.intAge_30_59, 
	ft.intAge_60_more = fdgt.intAge_60_more, 
	ft.intTotal = fdgt.intTotal, 
	ft.intLabTested = fdgt.intLabTested,		
	ft.intLabConfirmed = fdgt.intLabConfirmed,		
	ft.intTotalConfirmed = fdgt.intTotalConfirmed 
from		@ReportTable ft
inner join	@MonthlyReportDiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference		
	
	
	

	
update		ft
set	
  ft.strICD10 = CASE WHEN rr.intNullValueInsteadZero & 1 > 0 THEN NULL else ft.strICD10 END,
	ft.intLabTested = CASE WHEN rr.intNullValueInsteadZero & 2 > 0 THEN NULL else ft.intLabTested END,		
	ft.intLabConfirmed = CASE WHEN rr.intNullValueInsteadZero & 4 > 0 THEN NULL else ft.intLabConfirmed END,		
  ft.intTotalConfirmed = CASE WHEN rr.intNullValueInsteadZero & 8 > 0  THEN NULL else ft.intTotalConfirmed END 
from		@ReportTable ft
  inner join 	dbo.trtReportRows rr
  on rr.idfsCustomReportType = @idfsCustomReportType
  and rr.idfsDiagnosisOrReportDiagnosisGroup = ft.idfsBaseReference	
  	
	
select * 
from @ReportTable
order by intOrder
	



