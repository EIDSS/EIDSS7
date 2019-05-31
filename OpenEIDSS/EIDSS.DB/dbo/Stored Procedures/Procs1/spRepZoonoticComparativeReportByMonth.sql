
 
 --##SUMMARY Zoonotic Comparative Report (by months)
 /*
Implement rules for retrieving data into the Zoonotic Comparative Report (by months) according to the specification:
https://95.167.107.114/BTRP/Project_Documents/08x-Implementation/Customizations/AJ/AJ%20Customization%20EIDSS%20v6/Reports/Zoonotic%20Comparative%20Report%20by%20months/Specification%20for%20report%20development%20-%20Zoonotic%20Comparative%20Report%20by%20months.doc
*/
 
 --##REMARKS Author: Romasheva S.
 --##REMARKS Create date: 01.10.2015
 
 --##RETURNS Don't use 
 
 /*
 --Example of a call of procedure:
 7718570000000	Botulism
7718730000000	Brucellosis
7719840000000	Influenza - Avian (HPAI; H5N1)
7720660000000	Rabies
 
--baku
 exec [spRepZoonoticComparativeReportByMonth] 'en', 2014, 1344330000000, 1344360000000, 7718730000000
 exec [spRepZoonoticComparativeReportByMonth] 'en', 2014, 1344330000000, null, 7718730000000
 exec [spRepZoonoticComparativeReportByMonth] 'en', 2014, 1344330000000, null, null
  
  exec [spRepZoonoticComparativeReportByMonth] 'en', 2014, 1344330000000, 1344360000000, 7720660000000
  
--other regions
  exec [spRepZoonoticComparativeReportByMonth] 'en', 2015, 1344340000000, 1344800000000, 7718730000000
  exec [spRepZoonoticComparativeReportByMonth] 'en', 2015, 1344340000000, null, 7718730000000
  
--republic 
   exec [spRepZoonoticComparativeReportByMonth] 'en', 2015, null, null, 7718730000000
   exec [spRepZoonoticComparativeReportByMonth] 'ru', 2015, null, null, 7718730000000
   exec [spRepZoonoticComparativeReportByMonth] 'az-l', 2015, null, null, 7718730000000   
   
   exec [spRepZoonoticComparativeReportByMonth] 'az-l', 2015, null, null, 7720660000000 --  Rabies
   exec [spRepZoonoticComparativeReportByMonth] 'az-l', 2015, null, null, null
   
   
   
   
exec [spRepZoonoticComparativeReportByMonth] 'en', 2015, 1344330000000, 1344360000000,  7718570000000 /*Botulism*/
exec [spRepZoonoticComparativeReportByMonth] 'en', 2015, 1344330000000, 1344360000000,  56409380000000 /*Group {Intestinal disease} with only one diagnosis {Botulism}*/
  
exec spZoonoticDiagnosesAndGroups_SelectLookup 'en'  
 */ 
  
 create PROCEDURE [dbo].[spRepZoonoticComparativeReportByMonth]
 	@LangID				as varchar(36),
 	@Year				as int, 
	@idfsRegion			as bigint,
 	@idfsRayon			as bigint,
 	@idfsDiagnosis		as bigint,
 	@SiteID				as bigint = null
 AS
 BEGIN
	 declare @ReportTable	table	(	
			intDataType				int not null primary key, -- 1 - human, 2 - animal		
			
			strAdministrativeUnit	nvarchar(2000),
			strDataType				nvarchar(200),
			
 			idfsRegion				bigint,
 			strRegionName			nvarchar(2000), 		
	 		
 			idfsRayon				bigint, 
 			strRayonName			nvarchar(2000),
	 		
 			idfsDiagnosis			bigint,
 			strDiagnosis			nvarchar(2000),
	 		
 			intJan					int not null,
 			intFeb					int not null,
			intMar					int not null,
 			intApr					int not null,
 			intMay					int not null,
			intJun					int not null,
 			intJul					int not null,
 			intAug					int not null,
 			intSep					int not null,
 			intOct					int not null,
 			intNov					int not null,
 			intDec					int not null,
	 		
 			intTotal				int not null
		 )
 	
 	declare @HumanCases table (
		intMonth		int not null primary key,
		intTotal		int not null	
 		)

	declare @VetCases table (
		intMonth		int not null primary key,
		intTotal		int not null	
 		) 	
 		
 	declare @ASSessions table (
 		intMonth		int not null primary key,
		intTotal		int not null	
 	)
 			
 	declare
 		@idfsLanguage bigint,
 		@CountryID bigint,
 		@idfsSite bigint,

 		@StartDate	datetime,	 
 		@FinishDate datetime,
 		@strRepublic nvarchar(200),
 		@idfsRegionBaku bigint,
 		@idfsRegionOtherRayons bigint,
 		@strAdministrativeUnit nvarchar(2000),
 		@strDataType_human nvarchar(200),
 		@strDataType_animal nvarchar(200)
 		

 	set @idfsLanguage = dbo.fnGetLanguageCode (@LangID)	
 		
 	set	@CountryID = 170000000
	
	set @idfsSite = ISNULL(@SiteID, dbo.fnSiteID())
	
	set @StartDate = cast(@Year as varchar) + '0101'	 
 	set @FinishDate = dateadd(year, 1, @StartDate)
 		

	--1344340000000 --Other rayons
	select @idfsRegionOtherRayons = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Other rayons'			
	
	--1344330000000 --Baku
	select @idfsRegionBaku = tbra.idfsGISBaseReference
	from trtGISBaseReferenceAttribute tbra
		inner join	trtAttributeType at
		on			at.strAttributeTypeName = N'AZ Region'
	where cast(tbra.varValue as nvarchar(100)) = N'Baku'
	
	--@strRepublic
	select @strRepublic = tsnt.strTextString
 	from trtBaseReference tbr 
 		inner join trtStringNameTranslation tsnt
 		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 		and tsnt.idfsLanguage = @idfsLanguage
 	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 	and tbr.strDefault = 'Republic'
 	
 	select @strDataType_human = tsnt.strTextString
 	from trtBaseReference tbr 
 		inner join trtStringNameTranslation tsnt
 		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 		and tsnt.idfsLanguage = @idfsLanguage
 	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 	and tbr.strDefault = 'Among humans'
 	
 	select @strDataType_animal = tsnt.strTextString
 	from trtBaseReference tbr 
 		inner join trtStringNameTranslation tsnt
 		on tsnt.idfsBaseReference = tbr.idfsBaseReference
 		and tsnt.idfsLanguage = @idfsLanguage
 	where tbr.idfsReferenceType = 19000132 /*additional report text*/
 	and tbr.strDefault = 'Among animals' 	
 	
	set @strRepublic = isnull(@strRepublic, 'Republic') 	
	
	--select @idfsRegionBaku as [@idfsRegionBaku], @idfsRegionOtherRayons as [@idfsRegionOtherRayons], @strRepublic as [@strRepublic]
 			


	SET @strAdministrativeUnit = 
						case
							when @idfsRegion is null and @idfsRayon is null 
								then  @strRepublic
							when @idfsRayon is null and @idfsRegion is not null 
								then	(select [name] from fnGisReference(@LangID, 19000003 /*rftRegion*/) where idfsReference = @idfsRegion)
							when @idfsRayon is not null and @idfsRegion = @idfsRegionOtherRayons
								then	(select [name] from fnGisReference(@LangID, 19000002 /*rftRayon*/) where idfsReference = @idfsRayon)
							when @idfsRayon is not null and @idfsRegion = @idfsRegionBaku
								then	(select [name] from fnGisReference(@LangID, 19000003 /*rftRegion*/) where idfsReference = @idfsRegion) + ', ' +
										(select [name] from fnGisReference(@LangID, 19000002 /*rftRayon*/) where idfsReference = @idfsRayon)
							else
								(select [name] from fnGisReference(@LangID, 19000002 /*rftRayon*/) where idfsReference = @idfsRayon)+ ', ' +
								(select [name] from fnGisReference(@LangID, 19000003 /*rftRegion*/) where idfsReference = @idfsRegion)
						end				
		
                       
	insert into @ReportTable 
	(
		intDataType,
		strDataType,
		strAdministrativeUnit,
		idfsRegion,
		idfsRayon, 
		idfsDiagnosis,
 		intJan,
 		intFeb,
		intMar,
 		intApr,
 		intMay,
		intJun,
 		intJul,
 		intAug,
 		intSep,
 		intOct,
 		intNov,
 		intDec,
 		intTotal
	)
	values
		(1, @strDataType_human, @strAdministrativeUnit, @idfsRegion, @idfsRayon, @idfsDiagnosis, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
		(2, @strDataType_animal, @strAdministrativeUnit, @idfsRegion, @idfsRayon, @idfsDiagnosis, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
	

	update rt set 
		rt.strRegionName = ref_region.name,
		rt.strRayonName = ref_rayon.name,
		rt.strDiagnosis =  isnull(ref_diagnosis.name, ref_diagnosis_group.name) 
	from @ReportTable rt
		left join dbo.fnGisReference(@LangID, 19000003) ref_region
		on ref_region.idfsReference = rt.idfsRegion
		
		left join dbo.fnGisReference(@LangID, 19000002) ref_rayon
		on ref_rayon.idfsReference = rt.idfsRayon
		
		left join dbo.fnReference(@LangID, 19000019) ref_diagnosis
		on rt.idfsDiagnosis = ref_diagnosis.idfsReference
		
		left join dbo.fnReference(@LangID, 19000156) ref_diagnosis_group
		on rt.idfsDiagnosis = ref_diagnosis_group.idfsReference
		

	
	insert into @HumanCases 
		(
			intMonth,
			intTotal
		)
		
	select
		month(hc.datFinalCaseClassificationDate),
		count(hc.idfHumanCase)
	from tlbHumanCase hc
		inner join tlbHuman h
			left outer join tlbGeoLocation gl
			on h.idfCurrentResidenceAddress = gl.idfGeoLocation 
				and gl.intRowStatus = 0
		 on hc.idfHuman = h.idfHuman 
			and	h.intRowStatus = 0
		
		inner join trtDiagnosis td
			left join trtDiagnosisToDiagnosisGroup tdtdg
			on tdtdg.idfsDiagnosis = td.idfsDiagnosis
			and tdtdg.intRowStatus = 0
		on	td.idfsDiagnosis = isnull(hc.idfsFinalDiagnosis, hc.idfsTentativeDiagnosis)
		and td.intRowStatus = 0
		and td.blnZoonotic = 1
		and td.idfsUsingType = 10020001
		and (td.idfsDiagnosis = @idfsDiagnosis or tdtdg.idfsDiagnosisGroup = @idfsDiagnosis or @idfsDiagnosis is null)
	         
		left join tstSite ts
		on ts.idfsSite = hc.idfsSite
			and ts.intRowStatus = 0
			and ts.intFlags = 1
				
	where	hc.datFinalCaseClassificationDate is not null 
			and
				(		@StartDate <= hc.datFinalCaseClassificationDate
						and hc.datFinalCaseClassificationDate < @FinishDate				
				) 
			and(gl.idfsRegion = @idfsRegion or @idfsRegion is null)
			and (gl.idfsRayon = @idfsRayon or @idfsRayon is null)
			and hc.intRowStatus = 0
			and hc.idfsFinalCaseStatus = 350000000 /*Confirmed Case*/
			and ts.idfsSite is null		
			
		
	group by month(hc.datFinalCaseClassificationDate)



	insert into @VetCases
		(
			intMonth, 
			intTotal
		)
	select
		month(vc.datFinalDiagnosisDate),
		sum(case when vc.idfsCaseType = 10012003 then isnull(f.intLivestockSickAnimalQty, 0) else 0 end) + 
			sum(case when vc.idfsCaseType = 10012003 then isnull(f.intLivestockDeadAnimalQty, 0) else 0 end) +
		sum(case when vc.idfsCaseType = 10012004 then isnull(f.intAvianSickAnimalQty, 0) else 0 end) + 
			sum(case when vc.idfsCaseType = 10012004 then isnull(f.intAvianDeadAnimalQty, 0) else 0 end) 	
			
	from tlbVetCase vc
		inner join tlbFarm f
			left join tlbGeoLocation gl
			on gl.idfGeoLocation = f.idfFarmAddress
			and gl.intRowStatus = 0
		on f.idfFarm = vc.idfFarm
		
		inner join trtDiagnosis td
			left join trtDiagnosisToDiagnosisGroup tdtdg
				on tdtdg.idfsDiagnosis = td.idfsDiagnosis
				and tdtdg.intRowStatus = 0
		on	td.idfsDiagnosis = vc.idfsFinalDiagnosis
		and td.intRowStatus = 0
		and td.blnZoonotic = 1
		and td.idfsUsingType = 10020001
		and (td.idfsDiagnosis = @idfsDiagnosis or tdtdg.idfsDiagnosisGroup = @idfsDiagnosis or @idfsDiagnosis is null)
	

	where vc.idfsCaseClassification = 350000000 /*Confirmed Case*/
		and (		@StartDate <= vc.datFinalDiagnosisDate
						and vc.datFinalDiagnosisDate < @FinishDate				
			) 
		and(gl.idfsRegion = @idfsRegion or @idfsRegion is null)
		and (gl.idfsRayon = @idfsRayon or @idfsRayon is null)
		and vc.intRowStatus = 0
		and (vc.idfsCaseReportType = 4578940000002 /*passive*/ or
				vc.idfParentMonitoringSession is null 
				and vc.idfsCaseReportType = 4578940000001 /* active*/
		)
		and (vc.idfsFinalDiagnosis = @idfsDiagnosis or tdtdg.idfsDiagnosisGroup = @idfsDiagnosis or @idfsDiagnosis is null)
	group by month(vc.datFinalDiagnosisDate)


	insert into @ASSessions
		(
			intMonth, 
			intTotal
		)
	select
		month(tt.datConcludedDate),
		count(animal.idfAnimal)
	
	from tlbMonitoringSession tms
		inner join tlbFarm farm
		on farm.idfMonitoringSession = tms.idfMonitoringSession
		and farm.intRowStatus = 0
		
		inner join tlbHerd herd
		on herd.idfFarm = farm.idfFarm
		and herd.intRowStatus = 0
		
		inner join tlbSpecies species
		on species.idfHerd = herd.idfHerd
		and species.intRowStatus = 0
		
		inner join tlbAnimal animal
		on animal.idfSpecies = species.idfSpecies
		and animal.intRowStatus = 0
		
		outer apply (
						select top 1 test.datConcludedDate 
						from  tlbMaterial material
							inner join tlbTesting test
									inner join trtDiagnosis td
										left join trtDiagnosisToDiagnosisGroup tdtdg
										on tdtdg.idfsDiagnosis = td.idfsDiagnosis
										and tdtdg.intRowStatus = 0
									on	td.idfsDiagnosis = test.idfsDiagnosis
									and td.intRowStatus = 0
									and td.blnZoonotic = 1
									and td.idfsUsingType = 10020001
									and (td.idfsDiagnosis = @idfsDiagnosis or tdtdg.idfsDiagnosisGroup = @idfsDiagnosis or @idfsDiagnosis is null)
							on	test.idfMaterial = material.idfMaterial
								and test.intRowStatus = 0
								and test.idfsTestStatus in (10001001 /*Final*/, 10001006 /*Amended*/)
							
							inner join trtTestTypeToTestResult tttr
							on	tttr.idfsTestName = test.idfsTestName
								and tttr.idfsTestResult = test.idfsTestResult
								and tttr.blnIndicative = 1
						where	material.idfAnimal = animal.idfAnimal
								and material.intRowStatus = 0
								and test.datConcludedDate is not null
						order by test.datConcludedDate asc
		) tt
		
	where 
			(tms.idfsRegion = @idfsRegion or @idfsRegion is null)
		and (tms.idfsRayon = @idfsRayon or @idfsRayon is null)		
		and tt.datConcludedDate is not null
		and (	@StartDate <= tt.datConcludedDate 
				and tt.datConcludedDate  < @FinishDate				
			) 
	group by month(tt.datConcludedDate)
 
 

 	-- Human Cases
 	update rt set
 		rt.intJan = isnull(hc.intJan, 0),
 		rt.intFeb = isnull(hc.intFeb, 0),
 		rt.intMar = isnull(hc.intMar, 0),
 		rt.intApr = isnull(hc.intApr, 0),
 		rt.intMay = isnull(hc.intMay, 0),
 		rt.intJun = isnull(hc.intJun, 0),
 		rt.intJul = isnull(hc.intJul, 0),
 		rt.intAug = isnull(hc.intAug, 0),
 		rt.intSep = isnull(hc.intSep, 0),
 		rt.intOct = isnull(hc.intOct, 0),
 		rt.intNov = isnull(hc.intNov, 0),
 		rt.intDec = isnull(hc.intDec, 0),
 		rt.intTotal =  
 			isnull(hc.intJan, 0) +
 			isnull(hc.intFeb, 0) +
 			isnull(hc.intMar, 0) +
 			isnull(hc.intApr, 0) +
 			isnull(hc.intMay, 0) +
 			isnull(hc.intJun, 0) +
 			isnull(hc.intJul, 0) +
 			isnull(hc.intAug, 0) +
 			isnull(hc.intSep, 0) +
 			isnull(hc.intOct, 0) +
 			isnull(hc.intNov, 0) +
 			isnull(hc.intDec, 0)

	from @ReportTable rt
 		cross join (
					select 
					  [1] as intJan 
					, [2] as intFeb 
					, [3] as intMar
					, [4] as intApr 
					, [5] as intMay
					, [6] as intJun 
					, [7] as intJul
					, [8] as intAug
					, [9] as intSep
					, [10] as intOct
					, [11] as intNov
					, [12] as intDec
					

					from 
						(	
							select intMonth, intTotal
							from @HumanCases rt
						) as p
						pivot
						(	
							sum(intTotal)
							for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
						) as pvt
		
 		) as hc
 	where rt.intDataType = 1
 		
 		
 	-- Vet Cases
 	update rt set
 		rt.intJan = isnull(vc.intJan, 0),
 		rt.intFeb = isnull(vc.intFeb, 0),
 		rt.intMar = isnull(vc.intMar, 0),
 		rt.intApr = isnull(vc.intApr, 0),
 		rt.intMay = isnull(vc.intMay, 0),
 		rt.intJun = isnull(vc.intJun, 0),
 		rt.intJul = isnull(vc.intJul, 0),
 		rt.intAug = isnull(vc.intAug, 0),
 		rt.intSep = isnull(vc.intSep, 0),
 		rt.intOct = isnull(vc.intOct, 0),
 		rt.intNov = isnull(vc.intNov, 0),
 		rt.intDec = isnull(vc.intDec, 0),
 		rt.intTotal =  
 			isnull(vc.intJan, 0) +
 			isnull(vc.intFeb, 0) +
 			isnull(vc.intMar, 0) +
 			isnull(vc.intApr, 0) +
 			isnull(vc.intMay, 0) +
 			isnull(vc.intJun, 0) +
 			isnull(vc.intJul, 0) +
 			isnull(vc.intAug, 0) +
 			isnull(vc.intSep, 0) +
 			isnull(vc.intOct, 0) +
 			isnull(vc.intNov, 0) +
 			isnull(vc.intDec, 0)

	from @ReportTable rt
 		cross join (
					select 
					  [1] as intJan 
					, [2] as intFeb 
					, [3] as intMar
					, [4] as intApr 
					, [5] as intMay
					, [6] as intJun 
					, [7] as intJul
					, [8] as intAug
					, [9] as intSep
					, [10] as intOct
					, [11] as intNov
					, [12] as intDec
					

					from 
						(	
							select intMonth, intTotal
							from @VetCases rt
						) as p
						pivot
						(	
							sum(intTotal)
							for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
						) as pvt
		
 		) as vc
 	where rt.intDataType = 2 		

 	-- ASSessions
 	update rt set
 		rt.intJan = rt.intJan + isnull(ms.intJan, 0),
 		rt.intFeb = rt.intFeb + isnull(ms.intFeb, 0),
 		rt.intMar = rt.intMar + isnull(ms.intMar, 0),
 		rt.intApr = rt.intApr + isnull(ms.intApr, 0),
 		rt.intMay = rt.intMay + isnull(ms.intMay, 0),
 		rt.intJun = rt.intJun + isnull(ms.intJun, 0),
 		rt.intJul = rt.intJul + isnull(ms.intJul, 0),
 		rt.intAug = rt.intAug + isnull(ms.intAug, 0),
 		rt.intSep = rt.intSep + isnull(ms.intSep, 0),
 		rt.intOct = rt.intOct + isnull(ms.intOct, 0),
 		rt.intNov = rt.intNov + isnull(ms.intNov, 0),
 		rt.intDec = rt.intDec + isnull(ms.intDec, 0),
 		rt.intTotal =   rt.intTotal +
 			isnull(ms.intJan, 0) +
 			isnull(ms.intFeb, 0) +
 			isnull(ms.intMar, 0) +
 			isnull(ms.intApr, 0) +
 			isnull(ms.intMay, 0) +
 			isnull(ms.intJun, 0) +
 			isnull(ms.intJul, 0) +
 			isnull(ms.intAug, 0) +
 			isnull(ms.intSep, 0) +
 			isnull(ms.intOct, 0) +
 			isnull(ms.intNov, 0) +
 			isnull(ms.intDec, 0)

	from @ReportTable rt
 		cross join (
					select 
					  [1] as intJan 
					, [2] as intFeb 
					, [3] as intMar
					, [4] as intApr 
					, [5] as intMay
					, [6] as intJun 
					, [7] as intJul
					, [8] as intAug
					, [9] as intSep
					, [10] as intOct
					, [11] as intNov
					, [12] as intDec
					

					from 
						(	
							select intMonth, intTotal
							from @ASSessions rt
						) as ms
						pivot
						(	
							sum(intTotal)
							for intMonth in ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])
						) as pvt
		
 		) as ms
 	where rt.intDataType = 2
 	 
	---------------------------------------------------------------------------
 	select * from @ReportTable
 	order by intDataType
 END

	
