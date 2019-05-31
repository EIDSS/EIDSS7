


--##SUMMARY Select data for Armenian Form 85 custom reort

--##REMARKS Author: Romasheva R.
--##REMARKS Create date: 21.01.2016


--##RETURNS Doesn't use

/*
--Example of a call of procedure:


exec dbo.[spRepHumFormN85FirstAndThird] @LangID=N'en',@Year=2015, @Month = null, @RegionID = null, @RayonID = null, @idfsCustomReportType = 10290045
exec dbo.[spRepHumFormN85FirstAndThird] @LangID=N'en',@Year=2015, @Month = null, @RegionID = null, @RayonID = null, @idfsCustomReportType = 10290047

*/ 

CREATE  Procedure [dbo].[spRepHumFormN85FirstAndThird]
	 (
		 @LangID				as nvarchar(50), 
		 @Year					as int,
		 @Month					as int = null,
		 @RegionID				as bigint = null,
		 @RayonID				as bigint = null,
		 @idfsCustomReportType	as bigint 
		 --10290045 -- AM Form 85: Section I. Infectious diseases, foodborne, chemical intoxications and radiation poisonings in the reporting month/year
		 --10290047 -- AM Form 85: Section III. Additional List of Notifiable Diseases
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
		
		intCasesOfRecordedDiseasesTotal	int not null default(0),
		intIncludingWomen				int not null default(0),
		intIncludingUpTo18Age			int not null default(0),
		intIncluding0_2Age				int not null default(0),
		intIncluding3_6Age				int not null default(0),
		intIncludingRuralTotal			int not null default(0),
		intIncludingRuralUpTo18Age		int not null default(0),
		intRecordedLethalOutcomes		int not null default(0),
		
		intOrder						int not null default(0)
	)
		
	declare	@Form85DiagnosisTable	table
	(	idfsDiagnosis					bigint not null primary key,

		intCasesOfRecordedDiseasesTotal	int not null default(0),
		intIncludingWomen				int not null default(0),
		intIncludingUpTo18Age			int not null default(0),
		intIncluding0_2Age				int not null default(0),
		intIncluding3_6Age				int not null default(0),
		intIncludingRuralTotal			int not null default(0),
		intIncludingRuralUpTo18Age		int not null default(0),
		intRecordedLethalOutcomes		int not null default(0)
	)	
	
	declare	@Form85CaseTable	table
	(	idfsDiagnosis		bigint  not null,
		idfCase				bigint not null primary key,
		intYear				int	null,
		blnIsWomen			bit not null default(0),
		blnIsRural			bit not null default(0),
		blnIsLethalOutcome	bit not null default(0)
	)
	
  declare 		
	@StartDate					datetime,	 
	@FinishDate					datetime,
	@idfsLanguage				bigint,
	
	@FFNumberOfCase_Total		bigint,
	@FFFemale_Total				bigint,
	@FFNumberOfCase_18			bigint,
	@FFNumberOfCase_0_2			bigint,
	@FFNumberOfCase_3_6			bigint,
	@FFRural_Total				bigint,
	@FFRural_18					bigint,
	@FFNumberOfFatalCases_Total	bigint,
	
	@outDied bigint,
	@outRecovered bigint,
	@outUnknown bigint,
	@outRemission bigint


							

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


  	select @FFNumberOfCase_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_Total'
  	and intRowStatus = 0

  	select @FFFemale_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFFemale_Total'
  	and intRowStatus = 0

  	select @FFNumberOfCase_18 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_18'
  	and intRowStatus = 0
  	
  	select @FFNumberOfCase_0_2 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_0_2'
  	and intRowStatus = 0
  	
  	select @FFNumberOfCase_3_6 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_3_6'
  	and intRowStatus = 0
  	
  	select @FFRural_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFRural_Total'
  	and intRowStatus = 0
  	
  	select @FFRural_18 = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFRural_18'
  	and intRowStatus = 0
  	
  	select @FFNumberOfFatalCases_Total = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfFatalCases_Total'
  	and intRowStatus = 0
  	
  	
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
		intFFFemale_Total				bigint,
		intFFNumberOfCase_18			bigint,
		intFFNumberOfCase_0_2			bigint,
		intFFNumberOfCase_3_6			bigint,
		intFFRural_Total				bigint,
		intFFRural_18					bigint,
		intFFNumberOfFatalCases_Total	bigint
	)


	insert into	@Form85AggregateDiagnosisValuesTable
	(	idfsBaseReference,
		intFFNumberOfCase_Total,
		intFFFemale_Total,
		intFFNumberOfCase_18,
		intFFNumberOfCase_0_2,
		intFFNumberOfCase_3_6,
		intFFRural_Total,
		intFFRural_18,
		intFFNumberOfFatalCases_Total
	)
	select		
		fdt.idfsDiagnosis,
		
		sum(CAST(IsNull(agp_NumberOfCase_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Female_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_18.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_0_2.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_3_6.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Rural_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Rural_18.varValue, 0)AS INT)),
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

	--	agp_Female_Total		
	left join	dbo.tlbActivityParameters agp_Female_Total
	on			agp_Female_Total.idfObservation= fhac.idfCaseObservation
				and	agp_Female_Total.idfsParameter = @FFFemale_Total
				and agp_Female_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Female_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Female_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfCase_18
	left join	dbo.tlbActivityParameters agp_NumberOfCase_18
	on			agp_NumberOfCase_18.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_18.idfsParameter = @FFNumberOfCase_18
				and agp_NumberOfCase_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfCase_0_2
	left join	dbo.tlbActivityParameters agp_NumberOfCase_0_2
	on			agp_NumberOfCase_0_2.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_0_2.idfsParameter = @FFNumberOfCase_0_2
				and agp_NumberOfCase_0_2.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_0_2.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_0_2.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfCase_3_6
	left join	dbo.tlbActivityParameters agp_NumberOfCase_3_6
	on			agp_NumberOfCase_3_6.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_3_6.idfsParameter = @FFNumberOfCase_3_6
				and agp_NumberOfCase_3_6.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_3_6.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_3_6.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Rural_Total		
	left join	dbo.tlbActivityParameters agp_Rural_Total
	on			agp_Rural_Total.idfObservation = fhac.idfCaseObservation
				and	agp_Rural_Total.idfsParameter = @FFRural_Total
				and agp_Rural_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Rural_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Rural_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Rural_18		
	left join	dbo.tlbActivityParameters agp_Rural_18
	on			agp_Rural_18.idfObservation = fhac.idfCaseObservation
				and	agp_Rural_18.idfsParameter = @FFRural_18
				and agp_Rural_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Rural_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Rural_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfFatalCases_Total		
	left join	dbo.tlbActivityParameters agp_NumberOfFatalCases_Total
	on			agp_NumberOfFatalCases_Total.idfObservation = fhac.idfCaseObservation
				and	agp_NumberOfFatalCases_Total.idfsParameter = @FFNumberOfFatalCases_Total
				and agp_NumberOfFatalCases_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfFatalCases_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfFatalCases_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	group by	fdt.idfsDiagnosis
  
  	

	-- Case-based
	insert into	@Form85CaseTable
	(	idfsDiagnosis,
		idfCase,
		intYear,
		blnIsWomen,
		blnIsRural,
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
				
				case when h.idfsHumanGender = 10043001 then 1 else 0 end as blnIsWomen, 
				case when gs.idfsSettlementType = 730140000000 /*sttVillage*/ then 1 else 0 end as blnIsRural,
				case when hc.idfsOutcome = 10770000000/*outDied*/ then 1 else 0 end as blnIsLethalOutcome
				
	from tlbHumanCase hc     
		inner join	@Form85DiagnosisTable fdt
		on			fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

		inner join tlbHuman h
			left join tlbGeoLocation gl
				left join gisSettlement gs
				on gs.idfsSettlement = gl.idfsSettlement
				and gs.intRowStatus = 0
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

				
				
				
	--CasesOfRecordedDiseasesTotal
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

	
	--IncludingWomen	
	declare	@Form85Total_Women_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Women_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsWomen = 1
	group by	fct.idfsDiagnosis
			
	--intIncludingUpTo18Age		
	declare	@Form85Total_UpTo18Age_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_UpTo18Age_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.intYear < 18
	group by	fct.idfsDiagnosis
	
	
	--intIncluding0_2Age	
	declare	@Form85Total_0_2Age_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_0_2Age_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.intYear <= 2
	group by	fct.idfsDiagnosis	
				
	--intIncluding3_6Age	
	declare	@Form85Total_3_6Age_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_3_6Age_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.intYear >= 3 and fct.intYear <= 6  
	group by	fct.idfsDiagnosis	
	
					
	--intIncludingRuralTotal	
	declare	@Form85Total_Rural_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Rural_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsRural = 1
	group by	fct.idfsDiagnosis	
	
	--intIncludingRuralUpTo18Age	
	declare	@Form85Total_RuralUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_RuralUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsRural = 1
	and fct.intYear < 18
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
	set			fdt.intCasesOfRecordedDiseasesTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intIncludingWomen = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Women_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intIncludingUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_UpTo18Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intIncluding0_2Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_0_2Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intIncluding3_6Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_3_6Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
	
	update		fdt
	set			fdt.intIncludingRuralTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Rural_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
	
	update		fdt
	set			fdt.intIncludingRuralUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_RuralUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		
	update		fdt
	set			fdt.intRecordedLethalOutcomes = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_LethalOutcomes_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
		

	--aggr cases
	update		fdt
	set				
		fdt.intCasesOfRecordedDiseasesTotal = isnull(fdt.intCasesOfRecordedDiseasesTotal, 0) + isnull(fadvt.intFFNumberOfCase_Total, 0),
		fdt.intIncludingWomen =  isnull(fdt.intIncludingWomen, 0) + isnull(fadvt.intFFFemale_Total, 0),	
		fdt.intIncludingUpTo18Age =  isnull(fdt.intIncludingUpTo18Age ,0) + isnull(fadvt.intFFNumberOfCase_18, 0), 
		fdt.intIncluding0_2Age =  isnull(fdt.intIncluding0_2Age ,0) + isnull(fadvt.intFFNumberOfCase_0_2, 0), 
		fdt.intIncluding3_6Age =  isnull(fdt.intIncluding3_6Age ,0) + isnull(fadvt.intFFNumberOfCase_3_6, 0), 
		fdt.intIncludingRuralTotal =  isnull(fdt.intIncludingRuralTotal ,0) + isnull(fadvt.intFFRural_Total, 0), 
		fdt.intIncludingRuralUpTo18Age =  isnull(fdt.intIncludingRuralUpTo18Age ,0) + isnull(fadvt.intFFRural_18, 0), 
		fdt.intRecordedLethalOutcomes =  isnull(fdt.intRecordedLethalOutcomes ,0) + isnull(fadvt.intFFNumberOfFatalCases_Total, 0) 
	from		@Form85DiagnosisTable fdt
		inner join	@Form85AggregateDiagnosisValuesTable fadvt
		on			fadvt.idfsBaseReference = fdt.idfsDiagnosis  	

		

	declare	@Form85DiagnosisGroupTable	table
	(	idfsDiagnosisGroup				bigint not null primary key,
		intCasesOfRecordedDiseasesTotal	int not null default(0),
		intIncludingWomen				int not null default(0),
		intIncludingUpTo18Age			int not null default(0),
		intIncluding0_2Age				int not null default(0),
		intIncluding3_6Age				int not null default(0),
		intIncludingRuralTotal			int not null default(0),
		intIncludingRuralUpTo18Age		int not null default(0),
		intRecordedLethalOutcomes		int not null default(0)
	)		
		
	insert into	@Form85DiagnosisGroupTable
	(	idfsDiagnosisGroup,
		intCasesOfRecordedDiseasesTotal,
		intIncludingWomen,
		intIncludingUpTo18Age,
		intIncluding0_2Age,
		intIncluding3_6Age,
		intIncludingRuralTotal,
		intIncludingRuralUpTo18Age,
		intRecordedLethalOutcomes
	)
	select	dtg.idfsReportDiagnosisGroup,
			sum(fdt.intCasesOfRecordedDiseasesTotal),	
			sum(fdt.intIncludingWomen), 
			sum(fdt.intIncludingUpTo18Age), 
			sum(fdt.intIncluding0_2Age), 
			sum(fdt.intIncluding3_6Age), 
			sum(fdt.intIncludingRuralTotal), 
			sum(fdt.intIncludingRuralUpTo18Age), 
			sum(fdt.intRecordedLethalOutcomes)
	from		@Form85DiagnosisTable fdt
	inner join	dbo.trtDiagnosisToGroupForReportType dtg
	on			dtg.idfsDiagnosis = fdt.idfsDiagnosis and
				dtg.idfsCustomReportType = @idfsCustomReportType
	group by	dtg.idfsReportDiagnosisGroup			

		
	update		ft
	set	
		ft.intCasesOfRecordedDiseasesTotal = fdt.intCasesOfRecordedDiseasesTotal,	
		ft.intIncludingWomen = fdt.intIncludingWomen, 
		ft.intIncludingUpTo18Age = fdt.intIncludingUpTo18Age, 
		ft.intIncluding0_2Age = fdt.intIncluding0_2Age, 
		ft.intIncluding3_6Age = fdt.intIncluding3_6Age, 
		ft.intIncludingRuralTotal = fdt.intIncludingRuralTotal, 
		ft.intIncludingRuralUpTo18Age = fdt.intIncludingRuralUpTo18Age, 
		ft.intRecordedLethalOutcomes = fdt.intRecordedLethalOutcomes
	from		@ReportTable ft
	inner join	@Form85DiagnosisTable fdt
	on			fdt.idfsDiagnosis = ft.idfsDiagnosis	
		
		
	update		ft
	set	
		ft.intCasesOfRecordedDiseasesTotal = fdgt.intCasesOfRecordedDiseasesTotal,	
		ft.intIncludingWomen = fdgt.intIncludingWomen, 
		ft.intIncludingUpTo18Age = fdgt.intIncludingUpTo18Age, 
		ft.intIncluding0_2Age = fdgt.intIncluding0_2Age, 
		ft.intIncluding3_6Age = fdgt.intIncluding3_6Age, 
		ft.intIncludingRuralTotal = fdgt.intIncludingRuralTotal, 
		ft.intIncludingRuralUpTo18Age = fdgt.intIncludingRuralUpTo18Age, 
		ft.intRecordedLethalOutcomes = fdgt.intRecordedLethalOutcomes
	from		@ReportTable ft
	inner join	@Form85DiagnosisGroupTable fdgt
	on			fdgt.idfsDiagnosisGroup = ft.idfsDiagnosis				
		
		
		
	select * from @ReportTable
	order by intOrder
end
