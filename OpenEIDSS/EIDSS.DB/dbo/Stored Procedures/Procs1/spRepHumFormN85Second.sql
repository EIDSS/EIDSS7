


--##SUMMARY Select data for Armenian Form 85 custom reort

--##REMARKS Author: 
--##REMARKS Create date: 14.04.2012
 
--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec dbo.[spRepHumFormN85Second] @LangID=N'en',@Year=2015

*/ 

CREATE  Procedure [dbo].[spRepHumFormN85Second]
	(
		 @LangID		as nvarchar(50), 
		 @Year			as int,
		 @Month			as int = null,
		 @RegionID		as bigint = null,
		 @RayonID		as bigint = null
	 )
AS	 
begin
	
	
	declare	@ReportTable	table
	(	idfsDiagnosis					bigint not null primary key,
		strDiagnosis					nvarchar(300) collate database_default not null, 
		strRowNumber					nvarchar(100) collate database_default null, 
		strICD							nvarchar(200) collate database_default null,	
		
		blnShowTitle					bit not null default(0),
		blnBold							bit not null default(0),
		
		intDiseasesRecordedTotal		int not null default(0),
		intAgeUpTo14					int not null default(0),
		intAgeOlder14					int not null default(0),
		intRecordedLethalOutcomes		int not null default(0),
		
		intOrder						int not null default(0)
	)
	
		
	declare	@Form85DiagnosisTable	table
	(	idfsDiagnosis					bigint not null primary key,

		intDiseasesRecordedTotal		int not null default(0),
		intAgeUpTo14					int not null default(0),
		intAgeOlder14					int not null default(0),
		intRecordedLethalOutcomes		int not null default(0)
	)	
	
	declare	@Form85CaseTable	table
	(	idfsDiagnosis		bigint  not null,
		idfCase				bigint not null primary key,
		intYear				int	null,
		blnIsLethalOutcome	bit not null default(0)
	)
	
  declare 		
	@StartDate				datetime,	 
	@FinishDate				datetime,
	@idfsLanguage			bigint,
	@idfsCustomReportType	bigint ,
	
 	@FFNumberOfCase_Total		bigint,
	@FFNumberOfCase_14			bigint,
	@FFNumberOfCase_Older14		bigint,
	@FFNumberOfFatalCases_Total	bigint,
	
	@outDied bigint,
	@outRecovered bigint,
	@outUnknown bigint,
	@outRemission bigint


	set @idfsCustomReportType = 10290046 --AM Form 85: Section II. Healthcare-associated infections
	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
	
	set @StartDate = cast(@Year AS VARCHAR(4)) + '01' + '01'
	if @Month is null
	begin
		set @FinishDate = dateadd(yyyy, 1, @StartDate)
	end
	else
	begin	
		set @StartDate = dateadd(m, @Month-1, @StartDate)
		set @FinishDate = dateadd(m, 1, @StartDate)
	end		

	select @outDied = fr.idfsReference
  	from dbo.fnReference('en', 19000064) fr
  	where fr.name = N'Died'
  	
  	select @outRecovered = fr.idfsReference
  	from dbo.fnReference('en', 19000064) fr
  	where fr.name = N'Recovered'
  	
  	select @outUnknown = fr.idfsReference
  	from dbo.fnReference('en', 19000064) fr
  	where fr.name = N'Unknown'
  	
  	select @outRemission = fr.idfsReference
  	from dbo.fnReference('en', 19000064) fr
  	where fr.name = N'Remission'
  	
  	
  	select @FFNumberOfCase_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_Total'
  	and intRowStatus = 0

  	select @FFNumberOfCase_14 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_14'
  	and intRowStatus = 0
  	
  	select @FFNumberOfCase_Older14 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_Older14'
  	and intRowStatus = 0

  	select @FFNumberOfFatalCases_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfFatalCases_Total'
  	and intRowStatus = 0


	insert into @ReportTable (
		idfsDiagnosis,
		strDiagnosis,
		strRowNumber,
		strICD,
		
		blnShowTitle,
		blnBold,
		
		intOrder
	) 
	select 
		rr.idfsDiagnosisOrReportDiagnosisGroup,
		case when rr.intNullValueInsteadZero & 2 > 0 then UPPER(isnull(diag.name, diag_group.name) + IsNull(rep_add_text.name, '')) else isnull(diag.name, diag_group.name) + IsNull(rep_add_text.name, '') end as strDiagnosis,
		isnull(cast(tbra_d.varValue as nvarchar(10)), cast(tbra_dg.varValue as nvarchar(10))),
		ISNULL(d.strIDC10, dg.strCode),
		case when rr.intNullValueInsteadZero & 2 > 0 then 1 else 0 end as  blnShowTitle,
		case when rep_add_text.name is not null then 1 else 0 end as blnBold,
		rr.intRowOrder
	from   dbo.trtReportRows rr
		left join dbo.fnReferenceRepair(@LangID, 19000019) diag
			inner join trtDiagnosis d
			on diag.idfsReference = d.idfsDiagnosis
		on diag.idfsReference =  rr.idfsDiagnosisOrReportDiagnosisGroup
	
		left join dbo.fnReferenceRepair(@LangID, 19000130) diag_group
			inner join trtReportDiagnosisGroup dg
			on diag_group.idfsReference = dg.idfsReportDiagnosisGroup
		on diag_group.idfsReference =  rr.idfsDiagnosisOrReportDiagnosisGroup
		
		left join dbo.fnReferenceRepair(@LangID, 19000132) rep_add_text
		on rep_add_text.idfsReference =  rr.idfsReportAdditionalText
	
		left join trtBaseReferenceAttribute tbra_d
			inner join trtBaseReference tbr_repName
			on tbr_repName.idfsBaseReference = @idfsCustomReportType
			and tbr_repName.strDefault = tbra_d.strAttributeItem
		on d.idfsDiagnosis = tbra_d.idfsBaseReference
		
		left join trtBaseReferenceAttribute tbra_dg
			inner join trtBaseReference tbr_repName1
			on tbr_repName1.idfsBaseReference = @idfsCustomReportType
			and tbr_repName1.strDefault = tbra_dg.strAttributeItem
		on dg.idfsReportDiagnosisGroup = tbra_dg.idfsBaseReference
	where rr.idfsCustomReportType = @idfsCustomReportType
			and rr.intRowStatus = 0
	order by rr.intRowOrder  


	insert into @Form85DiagnosisTable (
		idfsDiagnosis
	) 
	select distinct
	  fdt.idfsDiagnosis
	from dbo.trtReportRows rr 
		inner join dbo.trtDiagnosisToGroupForReportType fdt
		on rr.idfsDiagnosisOrReportDiagnosisGroup = fdt.idfsReportDiagnosisGroup
		inner join trtDiagnosis trtd
		on trtd.idfsDiagnosis = fdt.idfsDiagnosis
	where  fdt.idfsCustomReportType = @idfsCustomReportType 

	       
	insert into @Form85DiagnosisTable (
		idfsDiagnosis
	) 
	select distinct
	  trtd.idfsDiagnosis
	from dbo.trtReportRows rr
		inner join trtDiagnosis trtd
		on trtd.idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup 
	where  rr.idfsCustomReportType = @idfsCustomReportType 
		   AND  rr.intRowStatus = 0 
		   and not exists 
		   (
			   select * from @Form85DiagnosisTable
			   where idfsDiagnosis = rr.idfsDiagnosisOrReportDiagnosisGroup
		   )      


	--aggregate
	declare @MinAdminLevel		bigint
	declare @MinTimeInterval	bigint
	declare @AggrCaseType		bigint


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

	set @AggrCaseType = 10102001

	select	@MinAdminLevel = idfsStatisticAreaType,
			@MinTimeInterval = idfsStatisticPeriodType
	from fnAggregateSettings (@AggrCaseType)--@AggrCaseType

	declare	@Form85HumanAggregateCase	table
	(	
		idfAggrCase				bigint not null primary KEY,
		idfCaseObservation		bigint,
		datStartDate			datetime,
		idfVersion				bigint
	)


	insert into	@Form85HumanAggregateCase
	(	
		idfAggrCase,
		idfCaseObservation,
		datStartDate,
		idfVersion
	)
	select		
		a.idfAggrCase,
		a.idfCaseObservation,
		a.datStartDate,
		a.idfVersion
	from		tlbAggrCase a
		left join	gisCountry c
		on			c.idfsCountry = a.idfsAdministrativeUnit
					and c.idfsCountry = 80000000
		left join	gisRegion r
		on			r.idfsRegion = a.idfsAdministrativeUnit 
					and r.idfsCountry = 80000000
		left join	gisRayon rr
		on			rr.idfsRayon = a.idfsAdministrativeUnit
					and rr.idfsCountry = 80000000
		left join	gisSettlement s
		on			s.idfsSettlement = a.idfsAdministrativeUnit
					and s.idfsCountry = 80000000

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
		      

	declare	@Form85AggregateDiagnosisValuesTable	table
	(	idfsBaseReference				bigint not null primary key,
		intFFNumberOfCase_Total			bigint,
		intFFNumberOfCase_14			bigint,
		intFFNumberOfCase_Older14		bigint,
		intFFNumberOfFatalCases_Total	bigint
	)


	insert into	@Form85AggregateDiagnosisValuesTable
	(	idfsBaseReference,
		intFFNumberOfCase_Total,
		intFFNumberOfCase_14,
		intFFNumberOfCase_Older14,
		intFFNumberOfFatalCases_Total
	)
	select		
		fdt.idfsDiagnosis,
		
		sum(CAST(IsNull(agp_NumberOfCase_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_14.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_Older14.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfFatalCases_Total.varValue, 0)AS INT))

	from		@Form85HumanAggregateCase fhac
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
	inner join	@Form85DiagnosisTable fdt
	on			fdt.idfsDiagnosis = mtx.idfsDiagnosis

	--agp_NumberOfCase_Total
	left join	dbo.tlbActivityParameters agp_NumberOfCase_Total
	on			agp_NumberOfCase_Total.idfObservation = fhac.idfCaseObservation
				and	agp_NumberOfCase_Total.idfsParameter = @FFNumberOfCase_Total
				and agp_NumberOfCase_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfCase_14
	left join	dbo.tlbActivityParameters agp_NumberOfCase_14
	on			agp_NumberOfCase_14.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_14.idfsParameter = @FFNumberOfCase_14
				and agp_NumberOfCase_14.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_14.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_14.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfCase_Older14
	left join	dbo.tlbActivityParameters agp_NumberOfCase_Older14
	on			agp_NumberOfCase_Older14.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_Older14.idfsParameter = @FFNumberOfCase_Older14
				and agp_NumberOfCase_Older14.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_Older14.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_Older14.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfFatalCases_Total		
	left join	dbo.tlbActivityParameters agp_NumberOfFatalCases_Total
	on			agp_NumberOfFatalCases_Total.idfObservation = fhac.idfCaseObservation
				and	agp_NumberOfFatalCases_Total.idfsParameter = @FFNumberOfFatalCases_Total
				and agp_NumberOfFatalCases_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfFatalCases_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfFatalCases_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	group by	fdt.idfsDiagnosis


	-- case-based
	insert into	@Form85CaseTable
	(	idfsDiagnosis,
		idfCase,
		intYear,
		blnIsLethalOutcome
	)
	select distinct
				fdt.idfsDiagnosis,
				hc.idfHumanCase AS idfCase,
				case
					when	IsNull(hc.idfsHumanAgeType, -1) = 10042003	-- Years 
							and IsNull(hc.intPatientAge, -1) >= 0 
						then	hc.intPatientAge
					when	IsNull(hc.idfsHumanAgeType, -1) = 10042002	-- Months
							and IsNull(hc.intPatientAge, -1) >= 0 
						then	cast(hc.intPatientAge / 12 as int)
					when	IsNull(hc.idfsHumanAgeType, -1) = 10042001	-- Days
							and IsNull(hc.intPatientAge, -1) >= 0
						then	0
					else	null
				end,			
				
				case when hc.idfsOutcome = @outDied /*outDied*/ then 1 else 0 end as blnIsLethalOutcome
				
	from tlbHumanCase hc     
		inner join	@Form85DiagnosisTable fdt
		on			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

		inner join tlbHuman h
			left join tlbGeoLocation gl
			on	h.idfCurrentResidenceAddress = gl.idfGeoLocation 
			and	gl.intRowStatus = 0
		on	hc.idfHuman = h.idfHuman and
			h.intRowStatus = 0
	    			
	where		hc.idfsOutcome is not null
				and (@StartDate <=
						case
							when hc.idfsOutcome = @outDied /*outDied*/ then isnull(h.datDateOfDeath, isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate)) 
							when hc.idfsOutcome = @outRecovered/*outRecovered*/ then isnull(hc.datDischargeDate, isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate)) 
							when hc.idfsOutcome = @outUnknown or hc.idfsOutcome = @outRemission /*outUnknown, remission*/  then isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate) 
							else null
						end
			
					and case
							when hc.idfsOutcome = @outDied/*outDied*/ then isnull(h.datDateOfDeath, isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate)) 
							when hc.idfsOutcome = @outRecovered/*outRecovered*/  then isnull(hc.datDischargeDate, isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate)) 
							when hc.idfsOutcome = @outUnknown or hc.idfsOutcome = @outRemission /*outUnknown, remission*/  then isnull(hc.datFinalCaseClassificationDate, hc.datEnteredDate) 
							else null
						end  < @FinishDate) 
				and	(gl.idfsRegion = @RegionID or @RegionID is null) 
				and	(gl.idfsRayon = @RayonID OR @RayonID is null)	
				and hc.intRowStatus = 0 

				
				
				
	--intDiseasesRecordedTotal
	declare	@Form85Total_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	group by	fct.idfsDiagnosis

	
	--intAgeUpTo14		
	declare	@Form85Total_UpTo14Age_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_UpTo14Age_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.intYear < 14
	group by	fct.idfsDiagnosis
	
	
	--intAgeOlder14	
	declare	@Form85Total_Older14Age_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Older14Age_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.intYear >=14
	group by	fct.idfsDiagnosis	
				
			
	--intRecordedLethalOutcomes				
	declare	@Form85Total_LethalOutcomes_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_LethalOutcomes_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsLethalOutcome = 1
	group by	fct.idfsDiagnosis					

	-- update @Form85DiagnosisTable
	update		fdt
	set			fdt.intDiseasesRecordedTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intAgeUpTo14 = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_UpTo14Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intAgeOlder14 = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Older14Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intRecordedLethalOutcomes = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_LethalOutcomes_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
		
	--aggr cases
	update		fdt
	set				
		fdt.intDiseasesRecordedTotal = isnull(fdt.intDiseasesRecordedTotal, 0) + isnull(fadvt.intFFNumberOfCase_Total, 0),
		fdt.intAgeUpTo14 =  isnull(fdt.intAgeUpTo14 ,0) + isnull(fadvt.intFFNumberOfCase_14, 0), 
		fdt.intAgeOlder14 =  isnull(fdt.intAgeOlder14 ,0) + isnull(fadvt.intFFNumberOfCase_Older14, 0), 
		fdt.intRecordedLethalOutcomes =  isnull(fdt.intRecordedLethalOutcomes ,0) + isnull(fadvt.intFFNumberOfFatalCases_Total, 0) 
	from		@Form85DiagnosisTable fdt
		inner join	@Form85AggregateDiagnosisValuesTable fadvt
		on			fadvt.idfsBaseReference = fdt.idfsDiagnosis  	
				

	declare	@Form85DiagnosisGroupTable	table
	(	idfsDiagnosisGroup				bigint not null primary key,

		intDiseasesRecordedTotal		int not null default(0),
		intAgeUpTo14					int not null default(0),
		intAgeOlder14					int not null default(0),
		intRecordedLethalOutcomes		int not null default(0)
	)		
		
	insert into	@Form85DiagnosisGroupTable
	(	idfsDiagnosisGroup,
		intDiseasesRecordedTotal,
		intAgeUpTo14,
		intAgeOlder14,
		intRecordedLethalOutcomes
	)
	select	dtg.idfsReportDiagnosisGroup,
			sum(fdt.intDiseasesRecordedTotal),	
			sum(fdt.intAgeUpTo14), 
			sum(fdt.intAgeOlder14), 
			sum(fdt.intRecordedLethalOutcomes)
	from		@Form85DiagnosisTable fdt
	inner join	dbo.trtDiagnosisToGroupForReportType dtg
	on			dtg.idfsDiagnosis = fdt.idfsDiagnosis and
				dtg.idfsCustomReportType = @idfsCustomReportType
	group by	dtg.idfsReportDiagnosisGroup			
		
		
	update		ft
	set	
		ft.intDiseasesRecordedTotal = fdt.intDiseasesRecordedTotal,	
		ft.intAgeUpTo14 = fdt.intAgeUpTo14, 
		ft.intAgeOlder14 = fdt.intAgeOlder14, 
		ft.intRecordedLethalOutcomes = fdt.intRecordedLethalOutcomes
	from		@ReportTable ft
	inner join	@Form85DiagnosisTable fdt
	on			fdt.idfsDiagnosis = ft.idfsDiagnosis	
		
		
	update		ft
	set	
		ft.intDiseasesRecordedTotal = fdgt.intDiseasesRecordedTotal,	
		ft.intAgeUpTo14 = fdgt.intAgeUpTo14, 
		ft.intAgeOlder14 = fdgt.intAgeOlder14, 
		ft.intRecordedLethalOutcomes = fdgt.intRecordedLethalOutcomes
	from		@ReportTable ft
	inner join	@Form85DiagnosisGroupTable fdgt
	on			fdgt.idfsDiagnosisGroup = ft.idfsDiagnosis				
		
		
		
	select * from @ReportTable
	order by intOrder

end
