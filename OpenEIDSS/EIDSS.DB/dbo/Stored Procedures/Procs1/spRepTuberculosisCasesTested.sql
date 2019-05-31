
 
 --##SUMMARY 
 
 --##REMARKS Author: Romasheva S.
 --##REMARKS Create date: 25.10.2015
 
 --##RETURNS Don't use 
 
 /*
 --Example of a call of procedure:
 
 exec spRepTuberculosisCasesTested 'en',  N'<ItemList><Item key="2015" /><Item key="2014" /></ItemList>', 12, 12, 7721290000000
 
 exec spRepTuberculosisCasesTested 'en',  N'<ItemList><Item key="2015" /><Item key="2014" /></ItemList>', 1, 12, null
  

declare @p2 xml
set @p2=convert(xml,N'<ItemList><Item key="2014"/><Item key="2013"/><Item key="2012"/><Item key="2011"/><Item key="2010"/></ItemList>')
exec dbo.spRepTuberculosisCasesTested @LangID='en',@YearXml=@p2,@FromMonth=NULL,@ToMonth=NULL,@DiagnosisId=NULL,@SiteID=871


declare @p2 xml
set @p2=convert(xml,N'<ItemList><Item key="2014"/><Item key="2013"/><Item key="2012"/><Item key="2011"/><Item key="2010"/></ItemList>')
exec dbo.spRepTuberculosisCasesTested @LangID='en',@YearXml=@p2,@FromMonth=NULL,@ToMonth=NULL,@DiagnosisId=7721290000000,@SiteID=871  
  
  
  
 */ 
  
 create PROCEDURE [dbo].[spRepTuberculosisCasesTested]
 	@LangID				as varchar(36),
 	@YearXml		    as xml,
 	@FromMonth			as int = null,
 	@ToMonth			as int = null,
 	@DiagnosisId		as bigint = null,
 	@SiteID				as bigint = null
 AS
 BEGIN
 	set @FromMonth = isnull(@FromMonth,1)
	set @ToMonth = isnull(@ToMonth,12)
	
	declare	@ReportTable	table
	(	
		idfsRegion				bigint not null,
	
 		idfsRayon				bigint not null,
 		strRayonName			nvarchar(2000) not null,
 		
 		blnIsTransportCHE		bit not null default(0),
 		 		
 		strDiagnosisName		nvarchar(2000) null,
 		
 		intNumberOfCases_1		int default(0),
 		intTestedForHIV_1		int default(0),

 		intNumberOfCases_2		int default(0),
 		intTestedForHIV_2		int default(0),

 		intNumberOfCases_3		int default(0),
 		intTestedForHIV_3		int default(0),

 		intNumberOfCases_4		int default(0),
 		intTestedForHIV_4		int default(0),

 		intNumberOfCases_5		int default(0),
 		intTestedForHIV_5		int default(0),
 		
 		intRegionOrder			int,
 		primary key (idfsRayon)
	)
 	
 	declare @DiagnosisTable table (
 			idfsDiagnosis	bigint 	not null primary key	
 	)
 	
 	declare @Years table (
 		intOrder		int not null identity(1,1) primary key,
 		intYear			int not null,
 		datStartDate	datetime,
 		datEndDate		datetime
 	)
 	
	declare
		 @CountryID					bigint,
		 @idfsLanguage				bigint,
		 @idfsCustomReportType		bigint,
		 
		 @idfsRegionBaku			bigint,
		 @idfsRegionOtherRayons		bigint,
		 @idfsRegionNakhichevanAR	bigint,
		 @TransportCHE				bigint,
		 
		 @strDiagnosisName			nvarchar(2000),
		 @Tuberculosis				nvarchar(2000),
		 
		 @iYears					int,
		 
		 @intYear					int,
		 @datStartDate				datetime, 
		 @datEndDate				datetime,
		 
		 @idfsSample_Blood			bigint
 	
 	
	set @CountryID = 170000000

	SET @idfsLanguage = dbo.fnGetLanguageCode (@LangID)		  

	SET @idfsCustomReportType = 10290041 --Report on Tuberculosis cases tested for HIV
 	
 	
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
	
 	select @TransportCHE = frr.idfsReference
 	from dbo.fnGisReferenceRepair('en', 19000020) frr
 	where frr.name =  'Transport CHE'
 	print @TransportCHE		
	

	--7721530000000 --Blood
	select @idfsSample_Blood = tbra.idfsBaseReference
	from trtBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'Sample type'
		
		inner join trtBaseReferenceAttribute tbra2
			inner join trtAttributeType tat2
			on tat2.idfAttributeType = tbra2.idfAttributeType
			and tat2.strAttributeTypeName = 'attr_part_in_report'
		on tbra.idfsBaseReference = tbra2.idfsBaseReference
		and tbra2.varValue = @idfsCustomReportType 
	where cast(tbra.varValue as nvarchar(100)) = N'Blood'
 	
 	--Tuberculosis
 	select @Tuberculosis = tsnt.strTextString
 	from trtBaseReference tbr 
 		inner join trtStringNameTranslation tsnt
 		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 		and tsnt.idfsLanguage = @idfsLanguage
 	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 	and tbr.strDefault = 'Tuberculosis'
 	
 	select @strDiagnosisName = fr.name
 	from dbo.fnReference(@LangID, 19000019) fr
 	where fr.idfsReference = @DiagnosisId
 	
 	set @strDiagnosisName = isnull(@strDiagnosisName, @Tuberculosis)

 	insert into @DiagnosisTable (idfsDiagnosis)
 	select d.idfsDiagnosis
	from trtDiagnosis d
	  inner join dbo.trtDiagnosisToGroupForReportType dgrt
	  on dgrt.idfsDiagnosis = d.idfsDiagnosis
	  and dgrt.idfsCustomReportType = @idfsCustomReportType
	  
	  inner join dbo.trtReportDiagnosisGroup dg
	  on dgrt.idfsReportDiagnosisGroup = dg.idfsReportDiagnosisGroup
	  and dg.intRowStatus = 0 and dg.strDiagnosisGroupAlias = 'DG_Tuberculosis'
	where d.intRowStatus = 0
		and (d.idfsDiagnosis = @DiagnosisId or @DiagnosisId is null)
 	
 	
 	exec sp_xml_preparedocument @iYears output, @YearXml
	insert into @Years (
		intYear
	) 
	select 
		xmlYears.[key]
	from openxml (@iYears, '/ItemList/Item')  
	with (
			[key] int '@key'
		 ) as xmlYears
	order by xmlYears.[key]
	
	exec sp_xml_removedocument @iYears		
	
	--select @FromMonth as [@FromMonth], @ToMonth as [@ToMonth]
	update years
	set
		years.datStartDate	= dateadd(month, -1, dateadd(month, @FromMonth, cast(cast(years.intYear as varchar(4)) + '0101' as datetime))),
		years.datEndDate	= dateadd(month, @ToMonth, cast(cast(years.intYear as varchar(4)) + '0101' as datetime))
	from @Years years
	
	
	insert into @ReportTable
	(
		  strDiagnosisName
		, blnIsTransportCHE
		, idfsRegion
		, idfsRayon
		, strRayonName	

		, intNumberOfCases_1
 		, intTestedForHIV_1
 		
 		, intNumberOfCases_2
 		, intTestedForHIV_2

 		, intNumberOfCases_3
 		, intTestedForHIV_3

 		, intNumberOfCases_4
 		, intTestedForHIV_4

 		, intNumberOfCases_5
 		, intTestedForHIV_5
 		
 		,intRegionOrder
	)
	select
		@strDiagnosisName,
		0,
		ray.idfsRegion,
		ray.idfsRayon,

		isnull(gsnt_ray.strTextString, gbr_ray.strDefault),

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
							
		case ray.idfsRegion
		  when @idfsRegionBaku --Baku
		  then 1
		  
		  when @idfsRegionOtherRayons --Other rayons
		  then 2
		  
		  when @idfsRegionNakhichevanAR --Nakhichevan AR
		  then 3
		  
		  else 0
		 end 
  
	from gisRayon ray
      inner join gisRegion reg
      on ray.idfsRegion = reg.idfsRegion
      and reg.intRowStatus = 0
      and reg.idfsCountry = @CountryID
      
      inner join gisBaseReference gbr_ray
      on gbr_ray.idfsGISBaseReference = ray.idfsRayon
      and gbr_ray.intRowStatus = 0
      
      inner join dbo.gisStringNameTranslation gsnt_ray
      on gsnt_ray.idfsGISBaseReference = gbr_ray.idfsGISBaseReference
      and gsnt_ray.idfsLanguage = @idfsLanguage
      and gsnt_ray.intRowStatus = 0
	where ray.intRowStatus = 0 	
 	
 	
 	
	insert into @ReportTable
 	(
		  strDiagnosisName
		, blnIsTransportCHE
		, idfsRegion
		, idfsRayon
		, strRayonName	

		, intNumberOfCases_1
 		, intTestedForHIV_1
 		
 		, intNumberOfCases_2
 		, intTestedForHIV_2

 		, intNumberOfCases_3
 		, intTestedForHIV_3

 		, intNumberOfCases_4
 		, intTestedForHIV_4

 		, intNumberOfCases_5
 		, intTestedForHIV_5
 		
 		,intRegionOrder

	)
	select
		@strDiagnosisName,
		1,
		reg.idfsGISBaseReference,
		ray.idfsSite,
								
		i.[name],
    
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
    
		4
  
	from tstSite ray
		join gisBaseReference reg
		on reg.idfsGISBaseReference = @TransportCHE

		inner join dbo.gisStringNameTranslation gsnt_reg
		on gsnt_reg.idfsGISBaseReference = reg.idfsGISBaseReference
		and gsnt_reg.idfsLanguage = @idfsLanguage
		and gsnt_reg.intRowStatus = 0

		inner join	dbo.fnInstitution(@LangID) as i  
		on	ray.idfOffice = i.idfOffice  

	where ray.intRowStatus = 0		
	and ray.intFlags = 1				 	
 	
   

	declare	@ReportCaseTable	table
	(	idfCase					bigint not null primary key,
		intYear					int not null,
		blnTestedforHIV			int not null default(0),
		idfsRayon				bigint not null
	)

	declare cur cursor local forward_only for
	select years.intYear, years.datStartDate, years.datEndDate from @Years years
	
	open cur
	
	fetch next from cur into @intYear, @datStartDate, @datEndDate
	
	while @@FETCH_STATUS = 0
	begin
		
		insert into	@ReportCaseTable
		(	
			idfCase,
			intYear,
			blnTestedforHIV,
			idfsRayon
		)
		select
			hc.idfHumanCase AS idfCase,
			year(datFinalCaseClassificationDate) as intYear,
			0, --case when tested.idfTesting is not null then 1 else 0 end  as blnTestedforHIV,			
			case when ts.idfsSite is not null then ts.idfsSite else gl.idfsRayon  end /*rayon CR*/
		from tlbHumanCase hc
			left join @ReportCaseTable rct
			on hc.idfHumanCase = rct.idfCase
			
			inner join tlbHuman h
				left join tlbGeoLocation gl
				on h.idfCurrentResidenceAddress = gl.idfGeoLocation 
				and gl.intRowStatus = 0
			on hc.idfHuman = h.idfHuman 
			and	h.intRowStatus = 0
			
			--inner join @Years years
			--on years.intYear = year(hc.datFinalCaseClassificationDate)
				
			inner join @DiagnosisTable fdt
			on	fdt.idfsDiagnosis = COALESCE(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
					
			left join tstSite ts
			on ts.idfsSite = hc.idfsSite
			and ts.intRowStatus = 0
			and ts.intFlags = 1
			
			--outer apply (
			--	select top 1 t.idfTesting
			--	from tlbMaterial m
			--		inner join tlbTesting t
			--			inner join trtTestTypeForCustomReport ttcr --ifa for HIV
			--			on ttcr.idfsTestName = t.idfsTestName
			--			and ttcr.idfsCustomReportType = @idfsCustomReportType
			--		on t.idfMaterial = m.idfMaterial
			--		and t.intRowStatus = 0
			--		and t.idfsTestStatus in (10001001 /*Final*/, 10001006 /*Amended*/)
			--	where m.idfHuman = h.idfHuman
			--	and m.intRowStatus = 0	
			--	and m.idfsSampleType = @idfsSample_Blood
			--	order by t.idfTesting
			--) tested
		    			
		where		
			hc.datFinalCaseClassificationDate is not null and
			(	@datStartDate <= hc.datFinalCaseClassificationDate
							and hc.datFinalCaseClassificationDate < @datEndDate				
			) 
			and ((gl.idfsRegion is not null and gl.idfsRayon is not null) or (ts.idfsSite is not null))
			and hc.intRowStatus = 0 
			and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/		
			and rct.idfCase is null
		
		
		fetch next from cur into @intYear, @datStartDate, @datEndDate
	end
	
	close cur
	deallocate cur
	
	

	update rct set 
		rct.blnTestedforHIV = case when t.idfTesting is not null then 1 else 0 end	
	from @ReportCaseTable rct
		inner join tlbHumanCase hc
		on rct.idfCase = hc.idfHumanCase
		
		inner join tlbHuman h
		on h.idfHuman = hc.idfHuman
		
		inner join tlbMaterial m
			inner join tlbTesting t
				inner join trtTestTypeForCustomReport ttcr --ifa for HIV
				on ttcr.idfsTestName = t.idfsTestName
				and ttcr.idfsCustomReportType = @idfsCustomReportType
			on t.idfMaterial = m.idfMaterial
			and t.intRowStatus = 0
			and t.idfsTestStatus in (10001001 /*Final*/, 10001006 /*Amended*/)
		on m.idfHuman = h.idfHuman
		and m.intRowStatus = 0	
		and m.idfsSampleType = @idfsSample_Blood




	--Total
	declare	@ReportCaseTotalValuesTable	table
	(	intTotal				numeric(8,4) not null,
		intTotalTestedForHIV	numeric(8,4) not null,
		idfsRayon				bigint not null,
		intYear					int not null,
		primary key	(
		  idfsRayon asc,
		  intYear asc
		)
	)

	insert into	@ReportCaseTotalValuesTable
	(	
		intTotal,
		intTotalTestedForHIV,
		idfsRayon,
		intYear
	)
	select	
				count(fct.idfCase),
				sum(fct.blnTestedforHIV),
				idfsRayon,
				fct.intYear
	from		@ReportCaseTable fct
	group by	fct.idfsRayon, fct.intYear

	


	update rt set
		rt.intNumberOfCases_1			= isnull(rct1.intTotal, 0),
		rt.intTestedForHIV_1			= isnull(rct1.intTotalTestedForHIV, 0),
		
		rt.intNumberOfCases_2			= isnull(rct2.intTotal, 0),
		rt.intTestedForHIV_2			= isnull(rct2.intTotalTestedForHIV, 0),

		rt.intNumberOfCases_3			= isnull(rct3.intTotal, 0),
		rt.intTestedForHIV_3			= isnull(rct3.intTotalTestedForHIV, 0),

		rt.intNumberOfCases_4			= isnull(rct4.intTotal, 0),
		rt.intTestedForHIV_4			= isnull(rct4.intTotalTestedForHIV, 0),

		rt.intNumberOfCases_5			= isnull(rct5.intTotal, 0),
		rt.intTestedForHIV_5			= isnull(rct5.intTotalTestedForHIV, 0)
		
	from @ReportTable rt
		left join @ReportCaseTotalValuesTable rct1
			inner join @Years y1
			on y1.intYear = rct1.intYear
			and y1.intOrder = 1
		on rct1.idfsRayon = rt.idfsRayon
	
	
		left join @ReportCaseTotalValuesTable rct2
			inner join @Years y2
			on y2.intYear = rct2.intYear
			and y2.intOrder = 2
		on rct2.idfsRayon = rt.idfsRayon
	
		left join @ReportCaseTotalValuesTable rct3
			inner join @Years y3
			on y3.intYear = rct3.intYear
			and y3.intOrder = 3
		on rct3.idfsRayon = rt.idfsRayon	

		left join @ReportCaseTotalValuesTable rct4
			inner join @Years y4
			on y4.intYear = rct4.intYear
			and y4.intOrder = 4
		on rct4.idfsRayon = rt.idfsRayon	

		left join @ReportCaseTotalValuesTable rct5
			inner join @Years y5
			on y5.intYear = rct5.intYear
			and y5.intOrder = 5
		on rct5.idfsRayon = rt.idfsRayon	

	---- total
	
	--insert into @ReportTable
	--	(
	--		idfsRegion, 
	--		idfsRayon, 
	--		strRayonName, 
	--		strDiagnosisName, 
			
	--		intNumberOfCases_1,
	--		intTestedForHIV_1, 
	--		intPercentRegistered_1, 
			
	--		intNumberOfCases_2,
	--		intTestedForHIV_2, 
	--		intPercentRegistered_2, 
			
	--		intNumberOfCases_3,
	--		intTestedForHIV_3, 
	--		intPercentRegistered_3, 
			
	--		intNumberOfCases_4,
	--		intTestedForHIV_4, 
	--		intPercentRegistered_4, 
			
	--		intNumberOfCases_5,
	--		intTestedForHIV_5, 
	--		intPercentRegistered_5, 
			
	--		intRegionOrder
	--	)
	--select	
	--		-1,
	--		-1,
	--		'Total',
	--		rt.strDiagnosisName,
			
	--		sum(intNumberOfCases_1),
	--		sum(intTestedForHIV_1), 
	--		case when sum(intNumberOfCases_1) <> 0 then sum(intTestedForHIV_1)/sum(intNumberOfCases_1)*1.0000 else 0 end, 
			
	--		sum(intNumberOfCases_2),
	--		sum(intTestedForHIV_2), 
	--		case when sum(intNumberOfCases_2) <> 0 then sum(intTestedForHIV_2)/sum(intNumberOfCases_2)*1.0000 else 0 end, 
			
	--		sum(intNumberOfCases_3),
	--		sum(intTestedForHIV_3), 
	--		case when sum(intNumberOfCases_3) <> 0 then sum(intTestedForHIV_3)/sum(intNumberOfCases_3)*1.0000 else 0 end, 
			
	--		sum(intNumberOfCases_4),
	--		sum(intTestedForHIV_4), 
	--		case when sum(intNumberOfCases_4) <> 0 then sum(intTestedForHIV_4)/sum(intNumberOfCases_4)*1.0000 else 0 end, 
			
	--		sum(intNumberOfCases_5),
	--		sum(intTestedForHIV_5), 
	--		case when sum(intNumberOfCases_5) <> 0 then sum(intTestedForHIV_5)/sum(intNumberOfCases_5)*1.0000 else 0 end, 
			
	--		999
			
	--from		@ReportTable rt
	--group by rt.strDiagnosisName
	
		
	--================================================================================= 
 	select * from @ReportTable
 	order by intRegionOrder, strRayonName
 	
 
 END

	
