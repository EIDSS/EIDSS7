
  
  
  --##SUMMARY Select data for Armenian Form 85 custom reort
  
  --##REMARKS Author: 
  --##REMARKS Create date: 14.04.2012
  
  
  --##RETURNS Doesn't use
  
  /*
  --Example of a call of procedure:
  
  
  exec dbo.[spRepHumFormN85Fourth] @LangID=N'en',@Year=2015
  
  */ 
  
CREATE  Procedure [dbo].[spRepHumFormN85Fourth]
 (
	 @LangID		as nvarchar(50), 
	 @Year			as int,
	 @Month			as int = null,
	 @RegionID		as bigint = null,
	 @RayonID		as bigint = null 
 )
AS	 
begin
	exec dbo.spSetFirstDay  
  
  	declare	@ReportTable	table
  	(	idfsDiagnosis							bigint not null primary key,
  		strDiagnosis							nvarchar(300) collate database_default not null, 
  		strRowNumber							nvarchar(100) collate database_default null, 
  		strICD									nvarchar(200) collate database_default null,	
  		
  		blnShowTitle							bit not null default(0),
  		blnBold									bit not null default(0),
  		
  		intNumberOfCasesTotal					int not null default(0),
  		intNumberOfCasesUpTo18Age				int not null default(0),
  		intNumberOfHospitalizationTotal			int not null default(0),
  		intNumberOfHospitalizationUpTo18Age		int not null default(0),
  		intMaleTotal							int not null default(0),
  		intMaleUpTo18Age						int not null default(0),
  		intFemaleTotal							int not null default(0),
  		intFemaleUpTo18Age						int not null default(0),
  		intUrbanTotal							int not null default(0),
  		intUrbanUpTo18Age						int not null default(0),
  		intRuralTotal							int not null default(0),
  		intRuralUpTo18Age						int not null default(0),
  		intOrganizedTotal						int not null default(0),
  		intOrganizedUpTo18Age					int not null default(0),
  		intUnorganizedTotal						int not null default(0),
  		intUnorganizedUpTo18Age					int not null default(0),
  		intNumberOfFatalCasesTotal				int not null default(0),
  		intNumberOfFatalCasesUpTo18Age			int not null default(0),
  		
  		
  		intOrder								int not null default(0)
  	)
  	
  	declare	@Form85DiagnosisTable	table
	(	idfsDiagnosis					bigint not null primary key,

		intNumberOfCasesTotal					int not null default(0),
  		intNumberOfCasesUpTo18Age				int not null default(0),
  		intNumberOfHospitalizationTotal			int not null default(0),
  		intNumberOfHospitalizationUpTo18Age		int not null default(0),
  		intMaleTotal							int not null default(0),
  		intMaleUpTo18Age						int not null default(0),
  		intFemaleTotal							int not null default(0),
  		intFemaleUpTo18Age						int not null default(0),
  		intUrbanTotal							int not null default(0),
  		intUrbanUpTo18Age						int not null default(0),
  		intRuralTotal							int not null default(0),
  		intRuralUpTo18Age						int not null default(0),
  		intOrganizedTotal						int not null default(0),
  		intOrganizedUpTo18Age					int not null default(0),
  		intUnorganizedTotal						int not null default(0),
  		intUnorganizedUpTo18Age					int not null default(0),
  		intNumberOfFatalCasesTotal				int not null default(0),
  		intNumberOfFatalCasesUpTo18Age			int not null default(0)
	)
	
	declare	@Form85CaseTable	table
	(	idfsDiagnosis			bigint  not null,
		idfCase					bigint not null primary key,
		intYear					int	null,
		blnIsWomen				bit not null default(0),
		blnIsRural				bit not null default(0),
		blnIsUrban				bit not null default(0),
		blnIsLethalOutcome		bit not null default(0),
		blnIsHospitalization	bit not null default(0),
		blnIsOrganized			bit not null default(0)
	)
	  
  	declare
  		@StartDate								datetime,	 
		@FinishDate								datetime, 
  		@idfsCustomReportType					bigint,
  		@idfsLanguage							bigint,
  
  		@FFP_NumberOfCasesTotal					bigint,
  		@FFP_NumberOfCasesUpTo18Age				bigint,
  		@FFP_NumberOfHospitalizationTotal		bigint,
  		@FFP_NumberOfHospitalizationUpTo18Age	bigint,
  		@FFP_MaleTotal							bigint,
  		@FFP_MaleUpTo18Age						bigint,
  		@FFP_FemaleTotal						bigint,
  		@FFP_FemaleUpTo18Age					bigint,
  		@FFP_UrbanTotal							bigint,
  		@FFP_UrbanUpTo18Age						bigint,
  		@FFP_RuralTotal							bigint,
  		@FFP_RuralUpTo18Age						bigint,
  		@FFP_OrganizedTotal						bigint,
  		@FFP_OrganizedUpTo18Age					bigint,
  		@FFP_UnorganizedTotal					bigint,
  		@FFP_UnorganizedUpTo18Age				bigint,
  		@FFP_NumberOfFatalCasesTotal			bigint,
  		@FFP_NumberOfFatalCasesUpTo18Age		bigint,
	
		@outDied bigint,
		@outRecovered bigint,
		@outUnknown bigint,
		@outRemission bigint,
		
		@Unorganized bigint
		
	  
  
  
  
  	set @idfsCustomReportType = 10290048 --AM Form 85: Section IV. Diseases subject to list-based (aggregative) recording
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
  
  	select @FFP_NumberOfCasesTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_Total'
  	and intRowStatus = 0
  	
	
    select @FFP_NumberOfCasesUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfCase_18'
  	and intRowStatus = 0
	
	--
   	select @FFP_NumberOfHospitalizationTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfHospitalizationCases_Total'
  	and intRowStatus = 0
  
    select @FFP_NumberOfHospitalizationUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfHospitalizationCases_18'
  	and intRowStatus = 0  
  
	--
  	select @FFP_MaleTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFMale_Total'
  	and intRowStatus = 0
  
    select @FFP_MaleUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFMale_18'
  	and intRowStatus = 0    
  
	--
  	select @FFP_FemaleTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFFemale_Total'
  	and intRowStatus = 0
  
    select @FFP_FemaleUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFFemale_18'
  	and intRowStatus = 0  
  	
  	--
  	select @FFP_UrbanTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFUrban_Total'
  	and intRowStatus = 0
  
    select @FFP_UrbanUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFUrban_18'
  	and intRowStatus = 0
  	
  	--
  	select @FFP_RuralTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFRural_Total'
  	and intRowStatus = 0
  
    select @FFP_RuralUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFRural_18'
  	and intRowStatus = 0
  	
  	--
  	select @FFP_OrganizedTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFOrganized_Total'
  	and intRowStatus = 0
  
    select @FFP_OrganizedUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFOrganized_18'
  	and intRowStatus = 0
  	
  	--
  	select @FFP_UnorganizedTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFUnorganized_Total'
  	and intRowStatus = 0
  
    select @FFP_UnorganizedUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFUnorganized_18'
  	and intRowStatus = 0
  	
  	--
  	select @FFP_NumberOfFatalCasesTotal = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfFatalCases_Total'
  	and intRowStatus = 0
  
    select @FFP_NumberOfFatalCasesUpTo18Age = idfsFFObject from trtFFObjectForCustomReport
  	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFNumberOfFatalCases_18'
  	and intRowStatus = 0
  
  --
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
  	
  	
  	select @Unorganized = fr.idfsReference
  	from dbo.fnReference('en', 19000061) fr
  	where fr.name = N'Unorganized'
  	
	


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
	(	idfsBaseReference	bigint not null primary key,
		intNumberOfCasesTotal					int not null default(0),
  		intNumberOfCasesUpTo18Age				int not null default(0),
  		intNumberOfHospitalizationTotal			int not null default(0),
  		intNumberOfHospitalizationUpTo18Age		int not null default(0),
  		intMaleTotal							int not null default(0),
  		intMaleUpTo18Age						int not null default(0),
  		intFemaleTotal							int not null default(0),
  		intFemaleUpTo18Age						int not null default(0),
  		intUrbanTotal							int not null default(0),
  		intUrbanUpTo18Age						int not null default(0),
  		intRuralTotal							int not null default(0),
  		intRuralUpTo18Age						int not null default(0),
  		intOrganizedTotal						int not null default(0),
  		intOrganizedUpTo18Age					int not null default(0),
  		intUnorganizedTotal						int not null default(0),
  		intUnorganizedUpTo18Age					int not null default(0),
  		intNumberOfFatalCasesTotal				int not null default(0),
  		intNumberOfFatalCasesUpTo18Age			int not null default(0)	
	)


	insert into	@Form85AggregateDiagnosisValuesTable
	(	idfsBaseReference,
		intNumberOfCasesTotal,					
  		intNumberOfCasesUpTo18Age,				
  		intNumberOfHospitalizationTotal,		
  		intNumberOfHospitalizationUpTo18Age,	
  		intMaleTotal,							
  		intMaleUpTo18Age,						
  		intFemaleTotal,							
  		intFemaleUpTo18Age,						
  		intUrbanTotal,							
  		intUrbanUpTo18Age,						
  		intRuralTotal,							
  		intRuralUpTo18Age,						
  		intOrganizedTotal,						
  		intOrganizedUpTo18Age,					
  		intUnorganizedTotal,					
  		intUnorganizedUpTo18Age,				
  		intNumberOfFatalCasesTotal,				
  		intNumberOfFatalCasesUpTo18Age			
	)
	select		
		fdt.idfsDiagnosis,
		
		sum(CAST(IsNull(agp_NumberOfCase_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfCase_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_NumberOfHospitalizationCases_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfHospitalizationCases_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Male_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Male_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Female_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Female_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Urban_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Urban_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Rural_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Rural_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Organized_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Organized_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_Unorganized_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_Unorganized_18.varValue, 0)AS INT)),
		
		sum(CAST(IsNull(agp_NumberOfFatalCases_Total.varValue, 0)AS INT)),
		sum(CAST(IsNull(agp_NumberOfFatalCases_18.varValue, 0)AS INT))

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
				and	agp_NumberOfCase_Total.idfsParameter = @FFP_NumberOfCasesTotal
				and agp_NumberOfCase_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_NumberOfCase_18
	left join	dbo.tlbActivityParameters agp_NumberOfCase_18
	on			agp_NumberOfCase_18.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfCase_18.idfsParameter = @FFP_NumberOfCasesUpTo18Age
				and agp_NumberOfCase_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfCase_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfCase_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_NumberOfHospitalizationCases_Total		
	left join	dbo.tlbActivityParameters agp_NumberOfHospitalizationCases_Total
	on			agp_NumberOfHospitalizationCases_Total.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfHospitalizationCases_Total.idfsParameter = @FFP_NumberOfHospitalizationTotal
				and agp_NumberOfHospitalizationCases_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfHospitalizationCases_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfHospitalizationCases_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_NumberOfHospitalizationCases_18		
	left join	dbo.tlbActivityParameters agp_NumberOfHospitalizationCases_18
	on			agp_NumberOfHospitalizationCases_18.idfObservation= fhac.idfCaseObservation
				and	agp_NumberOfHospitalizationCases_18.idfsParameter = @FFP_NumberOfHospitalizationUpTo18Age
				and agp_NumberOfHospitalizationCases_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfHospitalizationCases_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfHospitalizationCases_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Male_Total		
	left join	dbo.tlbActivityParameters agp_Male_Total
	on			agp_Male_Total.idfObservation= fhac.idfCaseObservation
				and	agp_Male_Total.idfsParameter = @FFP_MaleTotal
				and agp_Male_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Male_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Male_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Male_18		
	left join	dbo.tlbActivityParameters agp_Male_18
	on			agp_Male_18.idfObservation= fhac.idfCaseObservation
				and	agp_Male_18.idfsParameter = @FFP_MaleUpTo18Age
				and agp_Male_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Male_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Male_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Female_Total		
	left join	dbo.tlbActivityParameters agp_Female_Total
	on			agp_Female_Total.idfObservation= fhac.idfCaseObservation
				and	agp_Female_Total.idfsParameter = @FFP_FemaleTotal
				and agp_Female_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Female_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Female_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Female_18		
	left join	dbo.tlbActivityParameters agp_Female_18
	on			agp_Female_18.idfObservation= fhac.idfCaseObservation
				and	agp_Female_18.idfsParameter = @FFP_FemaleUpTo18Age
				and agp_Female_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Female_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Female_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Urban_Total		
	left join	dbo.tlbActivityParameters agp_Urban_Total
	on			agp_Urban_Total.idfObservation = fhac.idfCaseObservation
				and	agp_Urban_Total.idfsParameter = @FFP_UrbanTotal
				and agp_Urban_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Urban_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Urban_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Urban_18		
	left join	dbo.tlbActivityParameters agp_Urban_18
	on			agp_Urban_18.idfObservation = fhac.idfCaseObservation
				and	agp_Urban_18.idfsParameter = @FFP_UrbanUpTo18Age
				and agp_Urban_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Urban_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Urban_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')

	--	agp_Rural_Total		
	left join	dbo.tlbActivityParameters agp_Rural_Total
	on			agp_Rural_Total.idfObservation = fhac.idfCaseObservation
				and	agp_Rural_Total.idfsParameter = @FFP_RuralTotal
				and agp_Rural_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Rural_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Rural_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_Rural_18		
	left join	dbo.tlbActivityParameters agp_Rural_18
	on			agp_Rural_18.idfObservation = fhac.idfCaseObservation
				and	agp_Rural_18.idfsParameter = @FFP_RuralUpTo18Age
				and agp_Rural_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Rural_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Rural_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
	
	--	agp_Organized_Total		
	left join	dbo.tlbActivityParameters agp_Organized_Total
	on			agp_Organized_Total.idfObservation = fhac.idfCaseObservation
				and	agp_Organized_Total.idfsParameter = @FFP_OrganizedTotal
				and agp_Organized_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Organized_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Organized_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_Organized_18		
	left join	dbo.tlbActivityParameters agp_Organized_18
	on			agp_Organized_18.idfObservation = fhac.idfCaseObservation
				and	agp_Organized_18.idfsParameter = @FFP_OrganizedUpTo18Age
				and agp_Organized_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Organized_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Organized_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_Unorganized_Total		
	left join	dbo.tlbActivityParameters agp_Unorganized_Total
	on			agp_Unorganized_Total.idfObservation = fhac.idfCaseObservation
				and	agp_Unorganized_Total.idfsParameter = @FFP_UnorganizedTotal
				and agp_Unorganized_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Unorganized_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Unorganized_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_Unorganized_18		
	left join	dbo.tlbActivityParameters agp_Unorganized_18
	on			agp_Unorganized_18.idfObservation = fhac.idfCaseObservation
				and	agp_Unorganized_18.idfsParameter = @FFP_UnorganizedUpTo18Age
				and agp_Unorganized_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_Unorganized_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_Unorganized_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				

	--	agp_NumberOfFatalCases_Total		
	left join	dbo.tlbActivityParameters agp_NumberOfFatalCases_Total
	on			agp_NumberOfFatalCases_Total.idfObservation = fhac.idfCaseObservation
				and	agp_NumberOfFatalCases_Total.idfsParameter = @FFP_NumberOfFatalCasesTotal
				and agp_NumberOfFatalCases_Total.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfFatalCases_Total.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfFatalCases_Total.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	--	agp_NumberOfFatalCases_18		
	left join	dbo.tlbActivityParameters agp_NumberOfFatalCases_18
	on			agp_NumberOfFatalCases_18.idfObservation = fhac.idfCaseObservation
				and	agp_NumberOfFatalCases_18.idfsParameter = @FFP_NumberOfFatalCasesUpTo18Age
				and agp_NumberOfFatalCases_18.idfRow = mtx.idfAggrHumanCaseMTX
				and agp_NumberOfFatalCases_18.intRowStatus = 0
				and SQL_VARIANT_PROPERTY(agp_NumberOfFatalCases_18.varValue, 'BaseType') in ('bigint','decimal','float','int','numeric','real','smallint','tinyint')
				
	group by	fdt.idfsDiagnosis
  
	
	--case-based
	insert into	@Form85CaseTable
	(	idfsDiagnosis,
		idfCase,
		intYear,
		blnIsWomen,
		blnIsRural,
		blnIsUrban,
		blnIsLethalOutcome,
		blnIsHospitalization,
		blnIsOrganized
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
				case when gs.idfsSettlementType = 730130000000 /*sttTown*/ then 1 else 0 end as blnIsUrban,				
				case when hc.idfsOutcome = @outDied /*outDied*/ then 1 else 0 end as blnIsLethalOutcome,
				case when hc.idfsYNHospitalization = 10100001 /*ynvYes*/ then 1 else 0 end as blnIsHospitalization,
				case when h.idfsOccupationType <> @Unorganized /*Unorganized*/ then 1 else 0 end as blnIsOrganized
				
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
	    			
	where		
				hc.idfsOutcome is not null
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
	
	--intNumberOfHospitalizationTotal		
	declare	@Form85Total_NumberOfHospitalization_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_NumberOfHospitalization_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsHospitalization = 1
	group by	fct.idfsDiagnosis
		
	--intNumberOfHospitalizationUpTo18Age
	declare	@Form85Total_NumberOfHospitalizationUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_NumberOfHospitalizationUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsHospitalization = 1
	and fct.intYear < 18
	group by	fct.idfsDiagnosis	
	
	--intMaleTotal		
	declare	@Form85Total_Male_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Male_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsWomen = 0
	group by	fct.idfsDiagnosis		
						
	--intMaleUpTo18Age	
	declare	@Form85Total_MaleUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_MaleUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsWomen = 0
	and fct.intYear < 18
	group by	fct.idfsDiagnosis		
	
	--intFemaleTotal	
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
							
	--intFemaleUpTo18Age		
	declare	@Form85Total_WomenUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_WomenUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsWomen = 1
	and fct.intYear < 18	
	group by	fct.idfsDiagnosis		
					
	--intUrbanTotal			
	declare	@Form85Total_Urban_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Urban_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsUrban = 1
	group by	fct.idfsDiagnosis	
						
	--intUrbanUpTo18Age		
	declare	@Form85Total_UrbanUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_UrbanUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsUrban = 1
	and fct.intYear < 18		
	group by	fct.idfsDiagnosis	
	
	--intRuralTotal			
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
					
	--intRuralUpTo18Age		
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
				
	--intOrganizedTotal		
	declare	@Form85Total_Organized_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_Organized_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsOrganized = 1
	group by	fct.idfsDiagnosis		
					
	--intOrganizedUpTo18Age		
	declare	@Form85Total_OrganizedUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_OrganizedUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsOrganized = 1
	and fct.intYear < 18
	group by	fct.idfsDiagnosis	
					
	--intUnorganizedTotal		
	declare	@Form85Total_UnOrganized_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_UnOrganized_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsOrganized = 0
	group by	fct.idfsDiagnosis	
				
	--intUnorganizedUpTo18Age		
	declare	@Form85Total_UnorganizedUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_UnorganizedUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsOrganized = 0
	and fct.intYear < 18
	group by	fct.idfsDiagnosis	
					
	--intNumberOfFatalCasesTotal	
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
					
	--intNumberOfFatalCasesUpTo18Age	
	declare	@Form85Total_LethalOutcomesUpTo18_ValuesTable	table
	(	idfsDiagnosis		bigint not null primary key,
		intTotal			int not null
	)

	insert into	@Form85Total_LethalOutcomesUpTo18_ValuesTable
	(	idfsDiagnosis,
		intTotal
	)
	select fct.idfsDiagnosis,
				count(fct.idfCase)
	from		@Form85CaseTable fct
	where fct.blnIsLethalOutcome = 1
	and fct.intYear < 18
	group by	fct.idfsDiagnosis		
		


	-- update @Form85DiagnosisTable
	update		fdt
	set			fdt.intNumberOfCasesTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis

	update		fdt
	set			fdt.intNumberOfCasesUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_UpTo18Age_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis
	
	update		fdt
	set			fdt.intNumberOfHospitalizationTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_NumberOfHospitalization_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
	
	update		fdt
	set			fdt.intNumberOfHospitalizationUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_NumberOfHospitalizationUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intMaleTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Male_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intMaleUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_MaleUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intFemaleTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Women_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intFemaleUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_WomenUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis			
	
	update		fdt
	set			fdt.intUrbanTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Urban_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		  
	update		fdt
	set			fdt.intUrbanUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_UrbanUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intRuralTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Rural_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		  
	update		fdt
	set			fdt.intRuralUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_RuralUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
	
	update		fdt
	set			fdt.intOrganizedTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Organized_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		  
	update		fdt
	set			fdt.intOrganizedUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_OrganizedUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
	
	update		fdt
	set			fdt.intUnorganizedTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_Unorganized_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		  
	update		fdt
	set			fdt.intUnorganizedUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_UnorganizedUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis			
		  
  	update		fdt
	set			fdt.intNumberOfFatalCasesTotal = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_LethalOutcomes_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis		
		  
	update		fdt
	set			fdt.intNumberOfFatalCasesUpTo18Age = isnull(fcdvt.intTotal, 0)
	from		@Form85DiagnosisTable fdt
	inner join	@Form85Total_LethalOutcomesUpTo18_ValuesTable fcdvt
	on			fcdvt.idfsDiagnosis = fdt.idfsDiagnosis	
	
	
	update		fdt
	set				
		fdt.intNumberOfCasesTotal = isnull(fdt.intNumberOfCasesTotal,0) + isnull(fadvt.intNumberOfCasesTotal, 0),
		fdt.intNumberOfCasesUpTo18Age = isnull(fdt.intNumberOfCasesUpTo18Age,0) + isnull(fadvt.intNumberOfCasesUpTo18Age, 0),
		
		fdt.intNumberOfHospitalizationTotal = isnull(fdt.intNumberOfHospitalizationTotal,0) + isnull(fadvt.intNumberOfHospitalizationTotal, 0),	
		fdt.intNumberOfHospitalizationUpTo18Age = isnull(fdt.intNumberOfHospitalizationUpTo18Age,0) + isnull(fadvt.intNumberOfHospitalizationUpTo18Age, 0),	
		
		fdt.intMaleTotal = isnull(fdt.intMaleTotal,0) + isnull(fadvt.intMaleTotal, 0),	
		fdt.intMaleUpTo18Age = isnull(fdt.intMaleUpTo18Age,0) + isnull(fadvt.intMaleUpTo18Age, 0),
		
		fdt.intFemaleTotal = isnull(fdt.intFemaleTotal,0) + isnull(fadvt.intFemaleTotal, 0),	
		fdt.intFemaleUpTo18Age = isnull(fdt.intFemaleUpTo18Age,0) + isnull(fadvt.intFemaleUpTo18Age, 0),	
		
		fdt.intUrbanTotal = isnull(fdt.intUrbanTotal,0) + isnull(fadvt.intUrbanTotal, 0),	
		fdt.intUrbanUpTo18Age = isnull(fdt.intUrbanUpTo18Age,0) + isnull(fadvt.intUrbanUpTo18Age, 0),	
		
		fdt.intRuralTotal = isnull(fdt.intRuralTotal,0) + isnull(fadvt.intRuralTotal, 0),
		fdt.intRuralUpTo18Age = isnull(fdt.intRuralUpTo18Age,0) + isnull(fadvt.intRuralUpTo18Age, 0),
		
		fdt.intOrganizedTotal = isnull(fdt.intOrganizedTotal,0) + isnull(fadvt.intOrganizedTotal, 0),
		fdt.intOrganizedUpTo18Age = isnull(fdt.intOrganizedUpTo18Age,0) + isnull(fadvt.intOrganizedUpTo18Age, 0),		
		
		fdt.intUnorganizedTotal = isnull(fdt.intUnorganizedTotal,0) + isnull(fadvt.intUnorganizedTotal, 0),
		fdt.intUnorganizedUpTo18Age = isnull(fdt.intUnorganizedUpTo18Age,0) + isnull(fadvt.intUnorganizedUpTo18Age, 0),

		fdt.intNumberOfFatalCasesTotal = isnull(fdt.intNumberOfFatalCasesTotal,0) + isnull(fadvt.intNumberOfFatalCasesTotal, 0),
		fdt.intNumberOfFatalCasesUpTo18Age = isnull(fdt.intNumberOfFatalCasesUpTo18Age,0) + isnull(fadvt.intNumberOfFatalCasesUpTo18Age, 0)
				
	from		@Form85DiagnosisTable fdt
		inner join	@Form85AggregateDiagnosisValuesTable fadvt
		on			fadvt.idfsBaseReference = fdt.idfsDiagnosis  
	  
	  
	

	declare	@Form85DiagnosisGroupTable	table
	(	idfsDiagnosisGroup						bigint not null primary key,
		intNumberOfCasesTotal					int not null default(0),
  		intNumberOfCasesUpTo18Age				int not null default(0),
  		intNumberOfHospitalizationTotal			int not null default(0),
  		intNumberOfHospitalizationUpTo18Age		int not null default(0),
  		intMaleTotal							int not null default(0),
  		intMaleUpTo18Age						int not null default(0),
  		intFemaleTotal							int not null default(0),
  		intFemaleUpTo18Age						int not null default(0),
  		intUrbanTotal							int not null default(0),
  		intUrbanUpTo18Age						int not null default(0),
  		intRuralTotal							int not null default(0),
  		intRuralUpTo18Age						int not null default(0),
  		intOrganizedTotal						int not null default(0),
  		intOrganizedUpTo18Age					int not null default(0),
  		intUnorganizedTotal						int not null default(0),
  		intUnorganizedUpTo18Age					int not null default(0),
  		intNumberOfFatalCasesTotal				int not null default(0),
  		intNumberOfFatalCasesUpTo18Age			int not null default(0)
	)
		
		
	insert into	@Form85DiagnosisGroupTable
	(	idfsDiagnosisGroup,
		intNumberOfCasesTotal,					
  		intNumberOfCasesUpTo18Age,				
  		intNumberOfHospitalizationTotal,		
  		intNumberOfHospitalizationUpTo18Age,	
  		intMaleTotal,							
  		intMaleUpTo18Age,						
  		intFemaleTotal,							
  		intFemaleUpTo18Age,						
  		intUrbanTotal,							
  		intUrbanUpTo18Age,						
  		intRuralTotal,							
  		intRuralUpTo18Age,						
  		intOrganizedTotal,						
  		intOrganizedUpTo18Age,					
  		intUnorganizedTotal,					
  		intUnorganizedUpTo18Age,				
  		intNumberOfFatalCasesTotal,				
  		intNumberOfFatalCasesUpTo18Age			
	)
	select		
		dtg.idfsReportDiagnosisGroup,
		sum(intNumberOfCasesTotal),					
		sum(intNumberOfCasesUpTo18Age),				
		sum(intNumberOfHospitalizationTotal),		
		sum(intNumberOfHospitalizationUpTo18Age),	
		sum(intMaleTotal),							
		sum(intMaleUpTo18Age),						
		sum(intFemaleTotal),							
		sum(intFemaleUpTo18Age),						
		sum(intUrbanTotal),							
		sum(intUrbanUpTo18Age),						
		sum(intRuralTotal),							
		sum(intRuralUpTo18Age),						
		sum(intOrganizedTotal),						
		sum(intOrganizedUpTo18Age),					
		sum(intUnorganizedTotal),					
		sum(intUnorganizedUpTo18Age),				
		sum(intNumberOfFatalCasesTotal),				
		sum(intNumberOfFatalCasesUpTo18Age)		
	from		@Form85DiagnosisTable fdt
		inner join	dbo.trtDiagnosisToGroupForReportType dtg
		on			dtg.idfsDiagnosis = fdt.idfsDiagnosis 
		and			dtg.idfsCustomReportType = @idfsCustomReportType
	group by	dtg.idfsReportDiagnosisGroup	  
		  
		  
	update		ft
	set	
		ft.intNumberOfCasesTotal = fdt.intNumberOfCasesTotal,
		ft.intNumberOfCasesUpTo18Age = fdt.intNumberOfCasesUpTo18Age,
		
		ft.intNumberOfHospitalizationTotal = fdt.intNumberOfHospitalizationTotal,	
		ft.intNumberOfHospitalizationUpTo18Age = fdt.intNumberOfHospitalizationUpTo18Age,	
		
		ft.intMaleTotal = fdt.intMaleTotal,	
		ft.intMaleUpTo18Age = fdt.intMaleUpTo18Age,
		
		ft.intFemaleTotal = fdt.intFemaleTotal,	
		ft.intFemaleUpTo18Age = fdt.intFemaleUpTo18Age,	
		
		ft.intUrbanTotal = fdt.intUrbanTotal,	
		ft.intUrbanUpTo18Age = fdt.intUrbanUpTo18Age,	
		
		ft.intRuralTotal = fdt.intRuralTotal,
		ft.intRuralUpTo18Age = fdt.intRuralUpTo18Age,
		
		ft.intOrganizedTotal = fdt.intOrganizedTotal,
		ft.intOrganizedUpTo18Age = fdt.intOrganizedUpTo18Age,		
		
		ft.intUnorganizedTotal = fdt.intUnorganizedTotal,
		ft.intUnorganizedUpTo18Age = fdt.intUnorganizedUpTo18Age,

		ft.intNumberOfFatalCasesTotal = fdt.intNumberOfFatalCasesTotal,
		ft.intNumberOfFatalCasesUpTo18Age = fdt.intNumberOfFatalCasesUpTo18Age
	from		@ReportTable ft
	inner join	@Form85DiagnosisTable fdt
	on			fdt.idfsDiagnosis = ft.idfsDiagnosis	
		
		
	update		ft
	set	
		ft.intNumberOfCasesTotal = fdgt.intNumberOfCasesTotal,
		ft.intNumberOfCasesUpTo18Age = fdgt.intNumberOfCasesUpTo18Age,
		
		ft.intNumberOfHospitalizationTotal = fdgt.intNumberOfHospitalizationTotal,	
		ft.intNumberOfHospitalizationUpTo18Age = fdgt.intNumberOfHospitalizationUpTo18Age,	
		
		ft.intMaleTotal = fdgt.intMaleTotal,	
		ft.intMaleUpTo18Age = fdgt.intMaleUpTo18Age,
		
		ft.intFemaleTotal = fdgt.intFemaleTotal,	
		ft.intFemaleUpTo18Age = fdgt.intFemaleUpTo18Age,	
		
		ft.intUrbanTotal = fdgt.intUrbanTotal,	
		ft.intUrbanUpTo18Age = fdgt.intUrbanUpTo18Age,	
		
		ft.intRuralTotal = fdgt.intRuralTotal,
		ft.intRuralUpTo18Age = fdgt.intRuralUpTo18Age,
		
		ft.intOrganizedTotal = fdgt.intOrganizedTotal,
		ft.intOrganizedUpTo18Age = fdgt.intOrganizedUpTo18Age,		
		
		ft.intUnorganizedTotal = fdgt.intUnorganizedTotal,
		ft.intUnorganizedUpTo18Age = fdgt.intUnorganizedUpTo18Age,

		ft.intNumberOfFatalCasesTotal = fdgt.intNumberOfFatalCasesTotal,
		ft.intNumberOfFatalCasesUpTo18Age = fdgt.intNumberOfFatalCasesUpTo18Age
	from		@ReportTable ft
	inner join	@Form85DiagnosisGroupTable fdgt
	on			fdgt.idfsDiagnosisGroup = ft.idfsDiagnosis		  
	  
	  
	  
	select * from @ReportTable
	order by intOrder	
end
