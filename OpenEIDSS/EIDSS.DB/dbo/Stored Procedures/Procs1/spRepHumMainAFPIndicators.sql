

--##SUMMARY This procedure returns resultset for Main indicators of AFP surveillance report

--##REMARKS Author: 
--##REMARKS Create date: 

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepHumMainAFPIndicators 'en', N'20140101', N'20141231'

*/ 
 
create PROCEDURE [dbo].[spRepHumMainAFPIndicators]
(
	 @LangID		As nvarchar(50),
	 @SD			as datetime, 
	 @ED			as datetime
)
AS	

	declare 
		@CountryID bigint,
		@idfsLanguage bigint,
		@Year int,
		@idfsStatType bigint,
		@idfsCustomReportType bigint,

		@idfsRegionBaku bigint,
		@idfsRegionOtherRayons bigint,
		@idfsRegionNakhichevanAR bigint,
		@FFP_Date_of_onset_of_paralysis bigint
	
	declare @ReportTable table
	(
		idfsRegion bigint not null,
		idfsRayon bigint not null,
		strRegion nvarchar(200) not null,
		strRayon nvarchar(200) not null,
		intChildren int, 
		intRegisteredAFP int,
		intRegisteredAFPWithSamples int,
		intRegionOrder int not null,
		intMaxYearForStatistics int,
		intLastParalisysOnsetYear int
	)

	set @idfsCustomReportType =  10290006
	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		
	set @CountryID = 170000000
	set @Year = Year(@SD)
	
	--Flexible Form Type = “Human Clinical Signs” and Tooltip = “Acute Flaccid Paralysis-Date of onset of paralysis” 
	select @FFP_Date_of_onset_of_paralysis = idfsFFObject from trtFFObjectForCustomReport
	where idfsCustomReportType = @idfsCustomReportType and strFFObjectAlias = 'FFP_Date_of_onset_of_paralysis'
	and intRowStatus = 0

	--set @idfsStatType = 8425310000000 -- Population under 15
	select @idfsStatType = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Statistical Data Type'
		
		inner join trtBaseReferenceAttribute tbra2
			inner join trtAttributeType tat2
			on tat2.idfAttributeType = tbra2.idfAttributeType
			and tat2.strAttributeTypeName = 'attr_part_in_report'
		on tbra.idfsBaseReference = tbra2.idfsBaseReference
		and tbra2.varValue = @idfsCustomReportType 
	where cast(tbra.varValue as nvarchar(100)) = N'Population under 15'
  
	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'

	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'


	--1344350000000 --Nakhichevan AR
	select @idfsRegionNakhichevanAR = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Nakhichevan AR'
  
	insert into @ReportTable
	(
		idfsRegion,
		idfsRayon,
		strRegion,
		strRayon,
		intRegionOrder
	)
	select
		ray.idfsRegion,
		ray.idfsRayon,

		isnull(gsnt_reg.strTextString, gbr_reg.strDefault),
		isnull(gsnt_ray.strTextString, gbr_ray.strDefault),

		case ray.idfsRegion
		  when @idfsRegionBaku			--Baku
		  then 1
	      
		  when @idfsRegionOtherRayons	--Other rayons
		  then 2
	      
		  when @idfsRegionNakhichevanAR --Nakhichevan AR
		  then 3
	      
		  else 0
		end as intRegionOrder
	  
	from gisRayon ray
	  inner join gisRegion reg
	  on ray.idfsRegion = reg.idfsRegion
	  and reg.intRowStatus = 0
	  and reg.idfsCountry = @CountryID
	  
	  inner join gisBaseReference gbr_reg
	  on gbr_reg.idfsGISBaseReference = reg.idfsRegion
	  and gbr_reg.intRowStatus = 0
	  
	  inner join dbo.gisStringNameTranslation gsnt_reg
	  on gsnt_reg.idfsGISBaseReference = gbr_reg.idfsGISBaseReference
	  and gsnt_reg.idfsLanguage = @idfsLanguage
	  and gsnt_reg.intRowStatus = 0
	  
	  inner join gisBaseReference gbr_ray
	  on gbr_ray.idfsGISBaseReference = ray.idfsRayon
	  and gbr_ray.intRowStatus = 0
	  
	  inner join dbo.gisStringNameTranslation gsnt_ray
	  on gsnt_ray.idfsGISBaseReference = gbr_ray.idfsGISBaseReference
	  and gsnt_ray.idfsLanguage = @idfsLanguage
	  and gsnt_ray.intRowStatus = 0
	  
	where ray.intRowStatus = 0



	update rfstat set
		rfstat.intMaxYearForStatistics = maxYear
	from @ReportTable rfstat
	inner join (
		select MAX(year(stat.datStatisticStartDate)) as maxYear, rfs.idfsRayon
		from @ReportTable  rfs    
			inner join dbo.tlbStatistic stat
			on stat.idfsArea = rfs.idfsRayon 
				and stat.intRowStatus = 0
				and stat.idfsStatisticDataType = @idfsStatType  -- Population under 15
				and year(stat.datStatisticStartDate) <= @Year
		group by  idfsRayon
	  ) as mrfs
	on rfstat.idfsRayon = mrfs.idfsRayon
                                      	

	update rt set
		rt.intChildren = cast(s.varValue as int)
	from @ReportTable rt
	inner join dbo.tlbStatistic s
	on	rt.idfsRayon = s.idfsArea and
		s.intRowStatus = 0 and
		s.idfsStatisticDataType = @idfsStatType and
		s.datStatisticStartDate = cast(rt.intMaxYearForStatistics as varchar(4)) + '-01-01' 


   
	declare @DiagnosisTable table
	(
	idfsDiagnosis bigint not null primary key
	)

	insert into @DiagnosisTable
	(
		idfsDiagnosis
	)
	select 
		fdt.idfsDiagnosisOrReportDiagnosisGroup
	from  dbo.trtReportRows fdt
		inner join trtDiagnosis trtd
		on trtd.idfsDiagnosis = fdt.idfsDiagnosisOrReportDiagnosisGroup AND
		trtd.intRowStatus = 0
	where  fdt.idfsCustomReportType = @idfsCustomReportType 


	declare	@ReportCaseTable	table
	(	
		idfCase			bigint not null primary key,
		idfsRegion		bigint not null,
		idfsRayon		bigint not null,
		datOnSetDate	datetime,
		IsSampleExists	bit not null default(0)
	)


	insert into	@ReportCaseTable
	(	
		idfCase,
		idfsRegion,
		idfsRayon,
		datOnSetDate
	)
	select distinct
		hc.idfHumanCase as idfCase,
		gl.idfsRegion,  /*region CR*/
		gl.idfsRayon,  /*rayon CR*/
  		CAST(tap.varValue as datetime) as datOnSetDate
	from tlbHumanCase hc
	inner join tlbHuman h
		inner  join tlbGeoLocation gl
		on h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
	on hc.idfHuman = h.idfHuman AND
	   h.intRowStatus = 0

	inner join	@ReportTable fdt
	on	fdt.idfsRegion = gl.idfsRegion
		and fdt.idfsRayon = gl.idfsRayon
			
	inner join @DiagnosisTable dt
	on dt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

	inner join tlbObservation obs
		inner join tlbActivityParameters tap
		on tap.idfObservation = obs.idfObservation
		and tap.intRowStatus = 0
		and tap.idfsParameter = @FFP_Date_of_onset_of_paralysis
		and (
				cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%date%' or
				(cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap.varValue as nvarchar)) = 1 )	
			)  
	on	obs.idfObservation = hc.idfCSObservation
		and obs.intRowStatus = 0			
			
			
	left join tstSite ts
	on	ts.idfsSite = hc.idfsSite
		and ts.intRowStatus = 0
		and ts.intFlags = 1
  			
	where	hc.datTentativeDiagnosisDate is not null and
			(@SD <= CAST(tap.varValue as datetime) and CAST(tap.varValue as datetime) < DATEADD(day, 1, @ED)) 
			and gl.idfsRegion is not null 
			and gl.idfsRayon is not null
			and ts.idfsSite is null
			and hc.intRowStatus = 0 
			and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/

	update rct set
		rct.IsSampleExists = 1
	from @ReportCaseTable rct
	where exists
	(
		select  *
		from @ReportCaseTable  rct1
			inner join tlbMaterial m
			on m.idfHumanCase = rct1.idfCase
			and m.intRowStatus = 0
		where	m.datFieldCollectionDate - rct1.datOnSetDate <=  14 
				and rct.idfCase = rct1.idfCase
	)


	declare	@ReportCaseTableWithLastOnsetDate	table
	(	
		idfCase				bigint not null primary key,
		idfsRegion			bigint not null,
		idfsRayon			bigint not null,
		datLastOnSetDate	datetime
	)


	insert into	@ReportCaseTableWithLastOnsetDate
	(	
		idfCase,
		idfsRegion,
		idfsRayon,
		datLastOnSetDate
	)
	select distinct
		hc.idfHumanCase as idfCase,
		gl.idfsRegion,  /*region CR*/
		gl.idfsRayon,  /*rayon CR*/
  		CAST(tap.varValue as datetime) as datOnSetDate
	from tlbHumanCase hc
	inner join tlbHuman h
		inner  join tlbGeoLocation gl
		on h.idfCurrentResidenceAddress = gl.idfGeoLocation AND gl.intRowStatus = 0
	on hc.idfHuman = h.idfHuman AND
	   h.intRowStatus = 0

	inner join	@ReportTable fdt
	on	fdt.idfsRegion = gl.idfsRegion
		and fdt.idfsRayon = gl.idfsRayon
			
	inner join @DiagnosisTable dt
	on dt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)

	inner join tlbObservation obs
		inner join tlbActivityParameters tap
		on tap.idfObservation = obs.idfObservation
		and tap.intRowStatus = 0		
		and tap.idfsParameter = @FFP_Date_of_onset_of_paralysis
		and (
				cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%date%' or
				(cast(SQL_VARIANT_PROPERTY(tap.varValue, 'BaseType') as nvarchar) like N'%char%' and ISDATE(cast(tap.varValue as nvarchar)) = 1 )	
			)  
	on	obs.idfObservation = hc.idfCSObservation
		and obs.intRowStatus = 0			
			
	left join tstSite ts
	on	ts.idfsSite = hc.idfsSite
		and ts.intRowStatus = 0
		and ts.intFlags = 1
  			
	where	hc.datTentativeDiagnosisDate is not null and
			CAST(tap.varValue as datetime) < @SD
			and gl.idfsRegion is not null 
			and gl.idfsRayon is not null
			and ts.idfsSite is null
			and hc.intRowStatus = 0 
			and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
			

	--Total
	declare	@ReportCaseDiagnosisTotalValuesTable	table
	(	
		intTotal		int not null,
		idfsRegion		bigint not null,
		idfsRayon		bigint not null
	)

	insert into	@ReportCaseDiagnosisTotalValuesTable
	(	
		intTotal,
		idfsRegion,
		idfsRayon
	)
	select 
		count(fct.idfCase),
		idfsRegion,
		idfsRayon
	from		@ReportCaseTable fct
	group by	fct.idfsRegion, fct.idfsRayon

	--Total cases with samples
	declare	@ReportCaseDiagnosisTotalValuesTableWithSamples	table
	(	
		intTotal		int not null,
		idfsRegion		bigint not null,
		idfsRayon		bigint not null
	)

	insert into	@ReportCaseDiagnosisTotalValuesTableWithSamples
	(	
		intTotal,
		idfsRegion,
		idfsRayon
	)
	select 
		count(rct.idfCase),
		idfsRegion,
		idfsRayon
	from		@ReportCaseTable rct
	where		rct.IsSampleExists = 1
	group by	rct.idfsRegion, rct.idfsRayon


	--Last paralisys onset year
	declare	@ReportCaseLastParalisysOnsetYearTable	table
	(	
		intLastParalisysOnsetYear		int not null,
		idfsRegion						bigint not null,
		idfsRayon						bigint not null
	)

	insert into	@ReportCaseLastParalisysOnsetYearTable
	(	
		intLastParalisysOnsetYear,
		idfsRegion,
		idfsRayon
	)
	select 
		isnull(year(max(fct.datLastOnSetDate)), 0),
		idfsRegion,
		idfsRayon
	from		@ReportCaseTableWithLastOnsetDate fct
	group by	fct.idfsRegion, fct.idfsRayon
	


	-- calculated fields
	update		rt
	set			rt.intRegisteredAFP = fcdvt.intTotal
	from		@ReportTable rt
	inner join	@ReportCaseDiagnosisTotalValuesTable fcdvt
	on			fcdvt.idfsRegion = rt.idfsRegion
				and fcdvt.idfsRayon = rt.idfsRayon
  	   

	update		rt
	set			rt.intRegisteredAFPWithSamples = fcdvts.intTotal
	from		@ReportTable rt
	inner join	@ReportCaseDiagnosisTotalValuesTableWithSamples fcdvts
	on			fcdvts.idfsRegion = rt.idfsRegion
				and fcdvts.idfsRayon = rt.idfsRayon
	where rt.intRegisteredAFP > 0


	update		rt
	set			rt.intLastParalisysOnsetYear = fcdvt.intLastParalisysOnsetYear
	from		@ReportTable rt
	inner join	@ReportCaseLastParalisysOnsetYearTable fcdvt
	on			fcdvt.idfsRegion = rt.idfsRegion
				and fcdvt.idfsRayon = rt.idfsRayon


	select   
		strRegion,
		strRayon,
		intChildren,
		intRegisteredAFP,
		intRegisteredAFPWithSamples,
		intLastParalisysOnsetYear

	from @ReportTable
	order by intRegionOrder, strRayon 
				

