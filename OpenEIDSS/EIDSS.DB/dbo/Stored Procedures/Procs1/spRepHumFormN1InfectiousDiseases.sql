

--##SUMMARY This procedure returns Header (Page 1) for Form N1

--##REMARKS Author: 
--##REMARKS Create date: 

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##REMARKS Updated 30.05.2013 by Romasheva S.

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumFormN1InfectiousDiseases 'en', 2012, 1, 12
exec spRepHumFormN1InfectiousDiseases 'en', 2012, 1, 12, null, null, 868

*/ 
 
create PROCEDURE [dbo].[spRepHumFormN1InfectiousDiseases]
	@LangID				as varchar(36),
	@Year				as int, 
	@StartMonth			as int = null,
	@EndMonth			as int = null,
	@RegionID			as bigint = null,
	@RayonID			as bigint = null,
	@OrganizationID		as bigint = null
	
AS
BEGIN

	exec dbo.spSetFirstDay

	declare	@ReportTable	table
	(	idfsBaseReference	bigint not null primary key,
		intRowNumber		int null, --1
		strDiseaseName		nvarchar(300) collate database_default not null, --2
		strICD10			nvarchar(200) collate database_default null,	--3
		intTotal			int not null, --4
		intWomen			int not null, --5
		intAge_0_17			int not null, --6
		intAge_0_1			int not null, --7
		intAge_1_4			int not null, --8
		intAge_5_13			int not null, --9
		intAge_14_17		int not null, --10
		intAge_18_more		int not null, --11
		intRuralTotal		int not null, --12
		intRuralAge_0_17	int not null, --13
		intOrder			int not null
	)


  DECLARE 		
	@StartDate				datetime,	 
	@FinishDate				datetime,
	@idfsCustomReportType	bigint,
	@idfsLanguage			bigint,

	@FFP_Total			bigint,
	@FFP_Women			bigint,
	@FFP_Age_0_17		bigint,
	@FFP_Age_0_1		bigint,
	@FFP_Age_1_4		bigint,
	@FFP_Age_5_13		bigint,
	@FFP_Age_14_17		bigint,
	@FFP_Age_18_more	bigint,
	@FFP_RuralTotal		bigint,
	@FFP_RuralAge_0_17	bigint,
	
	@CountryID			bigint
	  
	  
	set	@CountryID = 170000000  
	SET @idfsCustomReportType = 10290000 /*Form number 1*/

	-- added 22.05.2012 by Romasheva S.
	select @FFP_Total = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Total'
	and intRowStatus = 0

	select @FFP_Women = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Women'
	and intRowStatus = 0
	
	select @FFP_Age_0_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_17'
	and intRowStatus = 0
	
	select @FFP_Age_0_1 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_0_1'
	and intRowStatus = 0

	select @FFP_Age_1_4 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_1_4'
	and intRowStatus = 0
	  
	select @FFP_Age_5_13 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_5_13'
	and intRowStatus = 0
	  
	select @FFP_Age_14_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_14_17'
	and intRowStatus = 0
	  
	select @FFP_Age_18_more = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Age_18_more'
	and intRowStatus = 0
	  
	select @FFP_RuralTotal = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RuralTotal'
	and intRowStatus = 0
	  
	select @FFP_RuralAge_0_17 = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_RuralAge_0_17'
	and intRowStatus = 0
	  
	  
	--Transport CHE
 	declare @TransportCHE bigint
 
 	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE
 			  
				
	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
			
	if @StartMonth IS null
	begin
		set @StartDate = (CAST(@Year AS VARCHAR(4)) + '01' + '01')
		set @FinishDate = dateADD(yyyy, 1, @StartDate)
	end
	else
	begin	
	  IF @StartMonth < 10	
			set @StartDate = (CAST(@Year AS VARCHAR(4)) + '0' +CAST(@StartMonth AS VARCHAR(2)) + '01')
	  ELSE				
			set @StartDate = (CAST(@Year AS VARCHAR(4)) + CAST(@StartMonth AS VARCHAR(2)) + '01')
			
	  IF (@EndMonth is null) or (@StartMonth = @EndMonth)
			set @FinishDate = dateADD(mm, 1, @StartDate)
	  ELSE	begin
			IF @EndMonth < 10	
				set @FinishDate = (CAST(@Year AS VARCHAR(4)) + '0' +CAST(@EndMonth AS VARCHAR(2)) + '01')
			ELSE				
				set @FinishDate = (CAST(@Year AS VARCHAR(4)) + CAST(@EndMonth AS VARCHAR(2)) + '01')
				
			set @FinishDate = dateADD(mm, 1, @FinishDate)
	  end
	end		

	INSERT INTO @ReportTable (
		idfsBaseReference,
		intRowNumber,
		strDiseaseName,
		strICD10,
		intTotal,
		intWomen,
		intAge_0_17,
		intAge_0_1,
		intAge_1_4,
		intAge_5_13,
		intAge_14_17,
		intAge_18_more,
		intRuralTotal,
		intRuralAge_0_17,
		intOrder
	) 
	SELECT 
	  rr.idfsDiagnosisOrReportDiagnosisGroup,
	  case
		when	IsNull(br.idfsReferenceType, -1) = 19000130	-- Diagnosis Group
				and IsNull(br.strDefault, N'') = N'Total'
			then	null
		else	rr.intRowOrder
	  end,
	  case
		when	IsNull(br.idfsReferenceType, -1) = 19000130	-- Diagnosis Group
				and IsNull(br.strDefault, N'') = N'Total'
			then	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault) + N'*'
		else	IsNull(IsNull(snt1.strTextString, br1.strDefault) +  N' ', N'') + IsNull(snt.strTextString, br.strDefault)
	  end,
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
	    

	WHERE rr.idfsCustomReportType = @idfsCustomReportType
			and rr.intRowStatus = 0
	ORDER BY rr.intRowOrder  



	DECLARE	@Form1DiagnosisTable	TABLE
	(	idfsDiagnosis		bigint NOT NULL PRIMARY KEY,
		blnIsAggregate		BIT,
		intTotal			INT NOT NULL,
		intWomen			INT NOT NULL,
		intAge_0_17			INT NOT NULL,
		intAge_0_1			INT NOT NULL,
		intAge_1_4			INT NOT NULL,
		intAge_5_13			INT NOT NULL,
		intAge_14_17		INT NOT NULL,
		intAge_18_more		INT NOT NULL,
		intRuralTotal		INT NOT NULL,
		intRuralAge_0_17	INT NOT NULL
	)

	INSERT INTO @Form1DiagnosisTable (
		idfsDiagnosis,
		blnIsAggregate,
		intTotal,
		intWomen,
		intAge_0_17,
		intAge_0_1,
		intAge_1_4,
		intAge_5_13,
		intAge_14_17,
		intAge_18_more,
		intRuralTotal,
		intRuralAge_0_17
	) 
	SELECT distinct
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
	  0

	FROM dbo.trtDiagnosisToGroupForReportType fdt
		INNER JOIN trtDiagnosis trtd
		ON trtd.idfsDiagnosis = fdt.idfsDiagnosis
	WHERE  fdt.idfsCustomReportType = @idfsCustomReportType 

	       
	INSERT INTO @Form1DiagnosisTable (
		idfsDiagnosis,
		blnIsAggregate,
		intTotal,
		intWomen,
		intAge_0_17,
		intAge_0_1,
		intAge_1_4,
		intAge_5_13,
		intAge_14_17,
		intAge_18_more,
		intRuralTotal,
		intRuralAge_0_17
	) 
	SELECT distinct
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
	  0

	FROM dbo.trtReportRows rr
		INNER JOIN trtBaseReference br
		on	br.idfsBaseReference = rr.idfsDiagnosisOrReportDiagnosisGroup
			AND br.idfsReferenceType = 19000019 --'rftDiagnosis'
			AND br.intRowStatus = 0
	    INNER JOIN   dbo.trtBaseReferenceToCP br_tc
			inner join tstCustomizationPackage cp
			on cp.idfCustomizationPackage = br_tc.idfCustomizationPackage
			and  cp.idfsCountry = @CountryID
	    ON br_tc.idfsBaseReference = br.idfsBaseReference
		INNER JOIN trtDiagnosis trtd
		ON trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
	WHERE  rr.idfsCustomReportType = @idfsCustomReportType 
		   AND  rr.intRowStatus = 0 
		   AND NOT EXISTS 
		   (
			   SELECT * FROM @Form1DiagnosisTable
			   WHERE idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
		   )      




DECLARE @MinAdminLevel bigint
DECLARE @MinTimeInterval bigint
DECLARE @AggrCaseType bigint


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

declare	@Form1HumanAggregateCase	table
(	idfAggrCase	bigint not null primary KEY,
	idfCaseObservation bigint,
	datStartDate datetime,
	idfVersion bigint
)


insert into	@Form1HumanAggregateCase
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
			    and c.idfsCountry = 170000000
    left join	gisRegion r
    on			r.idfsRegion = a.idfsAdministrativeUnit 
			    and r.idfsCountry = 170000000
    left join	gisRayon rr
    on			rr.idfsRayon = a.idfsAdministrativeUnit
			    and rr.idfsCountry = 170000000
    left join	gisSettlement s
    on			s.idfsSettlement = a.idfsAdministrativeUnit
			    and s.idfsCountry = 170000000
	left join tstSite ts
	on			ts.idfsSite = a.idfsAdministrativeUnit
				and ts.idfCustomizationPackage = 51577410000000 /*Azerbaijan*/
				and ts.intRowStatus = 0
				and ts.intFlags = 1	
WHERE 			
			a.idfsAggrCaseType = @AggrCaseType
			and (	@StartDate <= a.datStartDate
					and a.datFinishDate < @FinishDate
				)
			and (	(	@MinTimeInterval = 10091005 --'sptYear'
						and DateDiff(year, a.datStartDate, a.datFinishDate) = 0
						and DateDiff(quarter, a.datStartDate, a.datFinishDate) > 1
					)
					or	(	@MinTimeInterval = 10091003 --'sptQuarter'
							and DateDiff(quarter, a.datStartDate, a.datFinishDate) = 0
							and DateDiff(month, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091001 --'sptMonth'
							and DateDiff(month, a.datStartDate, a.datFinishDate) = 0
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091004 --'sptWeek'
							and dbo.fnWeekDatediff(a.datStartDate, a.datFinishDate) = 0
							and DateDiff(day, a.datStartDate, a.datFinishDate) > 1
						)
					or (	@MinTimeInterval = 10091002--'sptOnday'
						and DateDiff(day, a.datStartDate, a.datFinishDate) = 0)
				)    
			and (	
        			(	@MinAdminLevel = 10089001 --'satCountry' 
						and a.idfsAdministrativeUnit = c.idfsCountry
						and @OrganizationID is null
		      )
		    or	(	@MinAdminLevel = 10089003 --'satRegion' 
				    and a.idfsAdministrativeUnit = r.idfsRegion
				    AND (r.idfsRegion = @RegionID OR @RegionID IS NULL)
					and (@OrganizationID is null)
			    )
		    or	(	@MinAdminLevel = 10089002 --'satRayon' 
				    and a.idfsAdministrativeUnit = rr.idfsRayon
				    AND (rr.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (rr.idfsRegion = @RegionID OR @RegionID IS NULL)
					and (@OrganizationID is null)
			    )
		    or	(	@MinAdminLevel = 10089004 --'satSettlement' 
				    and a.idfsAdministrativeUnit = s.idfsSettlement
				    AND (s.idfsRayon = @RayonID OR @RayonID IS NULL) 
				    AND (s.idfsRegion = @RegionID OR @RegionID IS NULL)
					and (@OrganizationID is null)
			    )
				or	(
		    			a.idfsAdministrativeUnit = ts.idfsSite
						and (ts.idfsSite = @OrganizationID or @OrganizationID is null)
						and @RayonID IS NULL
						and @RegionID IS NULL
	      )
			 )

  and a.intRowStatus = 0


DECLARE	@Form1AggregateDiagnosisValuesTable	TABLE
(	idfsBaseReference	bigint NOT NULL PRIMARY KEY,
	intTotal			INT NOT NULL,
	intWomen			INT NOT NULL,
	intAge_0_17			INT NOT NULL,
	intAge_0_1			INT NOT NULL,
	intAge_1_4			INT NOT NULL,
	intAge_5_13			INT NOT NULL,
	intAge_14_17		INT NOT NULL,
	intAge_18_more		INT NOT NULL,
	intRuralTotal		INT NOT NULL,
	intRuralAge_0_17	INT NOT NULL)


 


insert into	@Form1AggregateDiagnosisValuesTable
(	idfsBaseReference,
	intTotal,
	intWomen,
	intAge_0_17,
	intAge_0_1,
	intAge_1_4,
	intAge_5_13,
	intAge_14_17,
	intAge_18_more,
	intRuralTotal,
	intRuralAge_0_17
)
select		
      fdt.idfsDiagnosis      ,
			sum(IsNull(CAST(agp_Total.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Women.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_0_17.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_0_1.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_1_4.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_5_13.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_14_17.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_Age_18_more.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_RuralTotal.varValue AS INT), 0)),
			sum(IsNull(CAST(agp_RuralAge_0_17.varValue AS INT), 0))

from		@Form1HumanAggregateCase fhac
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
inner join	@Form1DiagnosisTable fdt
on			fdt.idfsDiagnosis = mtx.idfsDiagnosis        

        
        
--	Total		
left join	dbo.tlbActivityParameters agp_Total
on			agp_Total.idfObservation= fhac.idfCaseObservation
			and	agp_Total.idfsParameter = @FFP_Total
			and agp_Total.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Total.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Total.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Women		
left join	dbo.tlbActivityParameters agp_Women
on			agp_Women.idfObservation= fhac.idfCaseObservation
			and	agp_Women.idfsParameter = @FFP_Women
			and agp_Women.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Women.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Women.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
			
--	Age_0_17		
left join	dbo.tlbActivityParameters agp_Age_0_17
on			agp_Age_0_17.idfObservation = fhac.idfCaseObservation
			and	agp_Age_0_17.idfsParameter = @FFP_Age_0_17
			and agp_Age_0_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_17.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

--	Age_0_1		
left join	dbo.tlbActivityParameters agp_Age_0_1
on			agp_Age_0_1.idfObservation = fhac.idfCaseObservation
			and	agp_Age_0_1.idfsParameter = @FFP_Age_0_1
			and agp_Age_0_1.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_0_1.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_0_1.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

			
--	Age_1_4		
left join	dbo.tlbActivityParameters agp_Age_1_4
on			agp_Age_1_4.idfObservation = fhac.idfCaseObservation
			and	agp_Age_1_4.idfsParameter = @FFP_Age_1_4
			and agp_Age_1_4.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_1_4.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_1_4.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

			
--	Age_5_13		
left join	dbo.tlbActivityParameters agp_Age_5_13
on			agp_Age_5_13.idfObservation = fhac.idfCaseObservation
			and	agp_Age_5_13.idfsParameter = @FFP_Age_5_13
			and agp_Age_5_13.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_5_13.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_5_13.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

			
--	Age_14_17		
left join	dbo.tlbActivityParameters agp_Age_14_17
on			agp_Age_14_17.idfObservation = fhac.idfCaseObservation
			and	agp_Age_14_17.idfsParameter = @FFP_Age_14_17
			and agp_Age_14_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_14_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_14_17.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	Age_18_more		
left join	dbo.tlbActivityParameters agp_Age_18_more
on			agp_Age_18_more.idfObservation = fhac.idfCaseObservation
			and	agp_Age_18_more.idfsParameter = @FFP_Age_18_more
			and agp_Age_18_more.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_Age_18_more.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_Age_18_more.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	RuralTotal		
left join	dbo.tlbActivityParameters agp_RuralTotal
on			agp_RuralTotal.idfObservation = fhac.idfCaseObservation
			and	agp_RuralTotal.idfsParameter = @FFP_RuralTotal
			and agp_RuralTotal.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_RuralTotal.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_RuralTotal.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')



--	RuralAge_0_17		
left join	dbo.tlbActivityParameters agp_RuralAge_0_17
on			agp_RuralAge_0_17.idfObservation = fhac.idfCaseObservation
			and	agp_RuralAge_0_17.idfsParameter = @FFP_RuralAge_0_17
			and agp_RuralAge_0_17.idfRow = mtx.idfAggrHumanCaseMTX
			and agp_RuralAge_0_17.intRowStatus = 0
			and SQL_VARIANT_PROPERTY(agp_RuralAge_0_17.varValue, 'BaseType') in  ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

group by	fdt.idfsDiagnosis

declare	@Form1CaseTable	table
(	idfsDiagnosis		bigint  not null,
	idfCase				bigint not null primary key,
	intYear				int NULL,
	idfsHumanGender		bigint,
	idfsRegion			bigint,
	idfsRayon			bigint,
	
	idfsRegionAdr			bigint,
	idfsRayonAdr			bigint
)


insert into	@Form1CaseTable
(	idfsDiagnosis,
	idfCase,
	intYear,
	idfsHumanGender,
	idfsRegion,
	idfsRayon,
	idfsRegionAdr, 
	idfsRayonAdr
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
			
			h.idfsHumanGender, /*gender*/
			case when ts.idfsSite is not null then @TransportCHE /*Transport CHE*/ else  gl.idfsRegion end,  /*region CR*/
			case when ts.idfsSite is not null then ts.idfsSite else gl.idfsRayon  end, /*rayon CR*/
			
			gl.idfsRegion,
			gl.idfsRayon
			
FROM tlbHumanCase hc     

    INNER JOIN	@Form1DiagnosisTable fdt
    ON			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

    INNER JOIN tlbHuman h
        LEFT OUTER JOIN tlbGeoLocation gl
        ON h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
      ON hc.idfHuman = h.idfHuman AND
         h.intRowStatus = 0
      
			
    left join tstSite ts
    on ts.idfsSite = hc.idfsSite
    and ts.intRowStatus = 0
    and ts.intFlags = 1
    			
WHERE		hc.datFinalCaseClassificationDate is not null and
			(	@StartDate <= hc.datFinalCaseClassificationDate
				and hc.datFinalCaseClassificationDate < @FinishDate				
			) and
			(gl.idfsRegion = @RegionID and ts.idfsSite is null or @RegionID is null) and
			(gl.idfsRayon = @RayonID and ts.idfsSite is null OR @RayonID is null)	and
			(ts.idfsSite = @OrganizationID or @OrganizationID is null)

			AND hc.intRowStatus = 0 
			-- Cases should only be seleced for the report Final Case Classification = Confirmed
			-- updated 22.05.2012 by Romasheva S.
			AND hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/

--Total
declare	@Form1CaseDiagnosisTotalValuesTable	table
(	idfsDiagnosis	bigint not null primary key,
	intTotal		INT not null
)

insert into	@Form1CaseDiagnosisTotalValuesTable
(	idfsDiagnosis,
	intTotal
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
group by	fct.idfsDiagnosis





--Total Women
declare	@Form1CaseDiagnosisWomenValuesTable	table
(	idfsDiagnosis	bigint not null primary key,
	intWomen		INT not null
)

insert into	@Form1CaseDiagnosisWomenValuesTable
(	idfsDiagnosis,
	intWomen
)
SELECT fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
WHERE fct.idfsHumanGender = 10043001
group by	fct.idfsDiagnosis



--Total Age_0_17
declare	@Form1CaseDiagnosis_Age_0_17_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_0_17				INT not null
)

insert into	@Form1CaseDiagnosis_Age_0_17_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 0 and fct.intYear <= 17)
group by	fct.idfsDiagnosis



--Total Age_0_1
declare	@Form1CaseDiagnosis_Age_0_1_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_0_1				INT not null
)

insert into	@Form1CaseDiagnosis_Age_0_1_TotalValuesTable
(	idfsDiagnosis,
	intAge_0_1
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 0 and fct.intYear < 1)
group by	fct.idfsDiagnosis




--Total Age_1_4
declare	@Form1CaseDiagnosis_Age_1_4_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_1_4				INT not null
)

insert into	@Form1CaseDiagnosis_Age_1_4_TotalValuesTable
(	idfsDiagnosis,
	intAge_1_4
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 1 and fct.intYear <= 4)
group by	fct.idfsDiagnosis




--Total Age_5_13
declare	@Form1CaseDiagnosis_Age_5_13_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_5_13				INT not null
)

insert into	@Form1CaseDiagnosis_Age_5_13_TotalValuesTable
(	idfsDiagnosis,
	intAge_5_13
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 5 and fct.intYear <= 13)
group by	fct.idfsDiagnosis



--Total Age_14_17
declare	@Form1CaseDiagnosis_Age_14_17_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_14_17				INT not null
)

insert into	@Form1CaseDiagnosis_Age_14_17_TotalValuesTable
(	idfsDiagnosis,
	intAge_14_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 14 and fct.intYear <= 17)
group by	fct.idfsDiagnosis




--Total Age_18_more
declare	@Form1CaseDiagnosis_Age_18_more_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intAge_18_more				INT not null
)

insert into	@Form1CaseDiagnosis_Age_18_more_TotalValuesTable
(	idfsDiagnosis,
	intAge_18_more
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		(fct.intYear >= 18 )
group by	fct.idfsDiagnosis



--Total RuralTotal
declare	@Form1CaseDiagnosis_RuralTotal_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intRuralTotal				INT not null
)

insert into	@Form1CaseDiagnosis_RuralTotal_TotalValuesTable
(	idfsDiagnosis,
	intRuralTotal
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		
/*EXCEPT:
 If Region=Baku, or 
 if (Region=Nakhichevan AR and Rayon=Nakhichevan) or 
 if (Region=Other rayons and Rayon= Genje or Mingechevir or Naftalan or Shirvan or Sumgayit)
*/
(fct.idfsRegionAdr <> 1344330000000/*Baku*/ ) AND
(fct.idfsRegionAdr <> 1344350000000 AND fct.idfsRayonAdr <> 1345180000000) AND
(fct.idfsRayonAdr NOT IN (1344920000000, 1344830000000, 1344890000000, 1344650000000, 1344470000000))
group by	fct.idfsDiagnosis



--Total RuralAge_0_17
declare	@Form1CaseDiagnosis_RuralAge_0_17_TotalValuesTable	table
(	idfsDiagnosis			bigint not null primary key,
	intRuralAge_0_17				INT not null
)

insert into	@Form1CaseDiagnosis_RuralAge_0_17_TotalValuesTable
(	idfsDiagnosis,
	intRuralAge_0_17
)
select		fct.idfsDiagnosis,
			count(fct.idfCase)
from		@Form1CaseTable fct
where		
/*EXCEPT:
 If Region=Baku, or 
 if (Region=Nakhichevan AR and Rayon=Nakhichevan) or 
 if (Region=Other rayons and Rayon= Genje or Mingechevir or Naftalan or Shirvan or Sumgayit)
*/
(fct.intYear >= 0 and fct.intYear <= 17) AND 
(fct.idfsRegionAdr <> 1344330000000/*Baku*/ ) AND
(fct.idfsRegionAdr <> 1344350000000 AND fct.idfsRayonAdr <> 1345180000000) AND
(fct.idfsRayonAdr NOT IN (1344920000000, 1344830000000, 1344890000000, 1344650000000, 1344470000000))
group by	fct.idfsDiagnosis
		
		
		

--aggregate cases
update		fdt
set				
	fdt.intAge_0_17 = fadvt.intAge_0_17,
	fdt.intAge_0_1 = fadvt.intAge_0_1,
	fdt.intAge_1_4 = fadvt.intAge_1_4,	
	fdt.intAge_5_13 = fadvt.intAge_5_13,	
	fdt.intAge_14_17 = fadvt.intAge_14_17,	
	fdt.intAge_18_more = fadvt.intAge_18_more,	
	fdt.intTotal = fadvt.intTotal,	
	fdt.intWomen = fadvt.intWomen,	
	fdt.intRuralTotal = fadvt.intRuralTotal,	
	fdt.intRuralAge_0_17 = fadvt.intRuralAge_0_17		
from		@Form1DiagnosisTable fdt
    inner join	@Form1AggregateDiagnosisValuesTable fadvt
    on			fadvt.idfsBaseReference = fdt.idfsDiagnosis
		
		
		
		

--standard cases
update		fdt
set			fdt.intTotal = isnull(fdt.intTotal, 0) + fcdvt.intTotal
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosisTotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
	
		

update		fdt
set			fdt.intWomen = isnull(fdt.intWomen, 0) + fcdvt.intWomen
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosisWomenValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
	


update		fdt
set			fdt.intAge_0_17 = isnull(fdt.intAge_0_17, 0) + fcdvt.intAge_0_17
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_0_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis



update		fdt
set			fdt.intAge_0_1 = isnull(fdt.intAge_0_1, 0) + fcdvt.intAge_0_1
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_0_1_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

		
		
update		fdt
set			fdt.intAge_1_4 = isnull(fdt.intAge_1_4, 0) + fcdvt.intAge_1_4
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_1_4_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
		


update		fdt
set			fdt.intAge_5_13 = isnull(fdt.intAge_5_13, 0) + fcdvt.intAge_5_13
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_5_13_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis



update		fdt
set			fdt.intAge_14_17 = isnull(fdt.intAge_14_17, 0) + fcdvt.intAge_14_17
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_14_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis



update		fdt
set			fdt.intAge_18_more = isnull(fdt.intAge_18_more, 0) + fcdvt.intAge_18_more
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_Age_18_more_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

		
		
update		fdt
set			fdt.intRuralTotal = isnull(fdt.intRuralTotal, 0) + fcdvt.intRuralTotal
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_RuralTotal_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
	
		
		
update		fdt
set			fdt.intRuralAge_0_17 = isnull(fdt.intRuralAge_0_17, 0) + fcdvt.intRuralAge_0_17
from		@Form1DiagnosisTable fdt
inner join	@Form1CaseDiagnosis_RuralAge_0_17_TotalValuesTable fcdvt
on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
		





DECLARE	@Form1DiagnosisGroupTable	TABLE
(	idfsDiagnosisGroup	bigint NOT NULL PRIMARY KEY,
	intTotal			INT NOT NULL,
	intWomen			INT NOT NULL,
	intAge_0_17			INT NOT NULL,
	intAge_0_1			INT NOT NULL,
	intAge_1_4			INT NOT NULL,
	intAge_5_13			INT NOT NULL,
	intAge_14_17			INT NOT NULL,
	intAge_18_more			INT NOT NULL,
	intRuralTotal			INT NOT NULL,
	intRuralAge_0_17			INT NOT NULL
)


insert into	@Form1DiagnosisGroupTable
(	idfsDiagnosisGroup,
	intTotal,
	intWomen,
	intAge_0_17,
	intAge_0_1,
	intAge_1_4,
	intAge_5_13,
	intAge_14_17,
	intAge_18_more,
	intRuralTotal,
	intRuralAge_0_17
)
select		dtg.idfsReportDiagnosisGroup,
	    sum(intTotal),	
	    sum(intWomen), 
	    sum(intAge_0_17), 
	    sum(intAge_0_1), 
	    sum(intAge_1_4), 
	    sum(intAge_5_13), 
	    sum(intAge_14_17), 
	    sum(intAge_18_more), 
	    sum(intRuralTotal),		
	    sum(intRuralAge_0_17)
from		@Form1DiagnosisTable fdt
inner join	dbo.trtDiagnosisToGroupForReportType dtg
on			dtg.idfsDiagnosis = fdt.idfsDiagnosis
			and dtg.idfsCustomReportType = @idfsCustomReportType

group by	dtg.idfsReportDiagnosisGroup	


update		ft
set	
  ft.intTotal = fdt.intTotal,	
	ft.intWomen = fdt.intWomen, 
	ft.intAge_0_17 = fdt.intAge_0_17, 
	ft.intAge_0_1 = fdt.intAge_0_1, 
	ft.intAge_1_4 = fdt.intAge_1_4, 
	ft.intAge_5_13 = fdt.intAge_5_13, 
	ft.intAge_14_17 = fdt.intAge_14_17, 
	ft.intAge_18_more = fdt.intAge_18_more, 
	ft.intRuralTotal = fdt.intRuralTotal, 
	ft.intRuralAge_0_17 = fdt.intRuralAge_0_17

from		@ReportTable ft
inner join	@Form1DiagnosisTable fdt
on			fdt.idfsDiagnosis = ft.idfsBaseReference	
		
		
update		ft
set	
  ft.intTotal = fdgt.intTotal,	
	ft.intWomen = fdgt.intWomen, 
	ft.intAge_0_17 = fdgt.intAge_0_17, 
	ft.intAge_0_1 = fdgt.intAge_0_1, 
	ft.intAge_1_4 = fdgt.intAge_1_4, 
	ft.intAge_5_13 = fdgt.intAge_5_13, 
	ft.intAge_14_17 = fdgt.intAge_14_17, 
	ft.intAge_18_more = fdgt.intAge_18_more, 
	ft.intRuralTotal = fdgt.intRuralTotal, 
	ft.intRuralAge_0_17 = fdgt.intRuralAge_0_17
from		@ReportTable ft
inner join	@Form1DiagnosisGroupTable fdgt
on			fdgt.idfsDiagnosisGroup = ft.idfsBaseReference			
		
		
		
	select * 
	from @ReportTable
	order by intOrder

END

