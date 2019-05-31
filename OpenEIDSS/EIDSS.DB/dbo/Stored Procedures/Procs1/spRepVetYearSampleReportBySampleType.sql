

--##SUMMARY Select data for Samples Report by Sample Type Report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 17.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use 

/*
--Example of a call of procedure:

exec spRepVetYearSampleReportBySampleType  'en', '2010'

*/

CREATE  Procedure [dbo].[spRepVetYearSampleReportBySampleType]
    (
		@LangID as nvarchar(10),
        @Year   as int
    )
as

	SELECT			
			tDiagnosis.name					AS Disease,
			rfFarmRegion.[name]				AS Region,
            SpecimenType.name			AS SampleType,
            COUNT(Material.idfMaterial)	AS Total,
            COUNT(tPositiv.idfMaterial)		AS TotalPR,

            COUNT(case when month(tVetCase.datReportDate) = 1 THEN Material.idfMaterial	ELSE NULL END)  AS Jan,
            COUNT(case when month(tVetCase.datReportDate) = 1 THEN tPositiv.idfMaterial ELSE NULL END)	AS JanPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 2 THEN Material.idfMaterial	ELSE NULL END)  AS Feb,
            COUNT(case when month(tVetCase.datReportDate) = 2 THEN tPositiv.idfMaterial ELSE NULL END)	AS FebPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 3 THEN Material.idfMaterial	ELSE NULL END)	AS Mar,  
            COUNT(case when month(tVetCase.datReportDate) = 3 THEN tPositiv.idfMaterial ELSE NULL END)	AS MarPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 4 THEN Material.idfMaterial	ELSE NULL END)  AS Apr, 
            COUNT(case when month(tVetCase.datReportDate) = 4 THEN tPositiv.idfMaterial ELSE NULL END)	AS AprPR, 
            
            COUNT(case when month(tVetCase.datReportDate) = 5 THEN Material.idfMaterial	ELSE NULL END)	AS May,  
            COUNT(case when month(tVetCase.datReportDate) = 5 THEN tPositiv.idfMaterial ELSE NULL END)	AS MayPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 6 THEN Material.idfMaterial	ELSE NULL END)  AS Jun, 
            COUNT(case when month(tVetCase.datReportDate) = 6 THEN tPositiv.idfMaterial ELSE NULL END)	AS JunPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 7 THEN Material.idfMaterial	ELSE NULL END)  AS Jul, 
            COUNT(case when month(tVetCase.datReportDate) = 7 THEN tPositiv.idfMaterial ELSE NULL END)	AS JulPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 8 THEN Material.idfMaterial	ELSE NULL END)	AS Aug,  
            COUNT(case when month(tVetCase.datReportDate) = 8 THEN tPositiv.idfMaterial ELSE NULL END)	AS AugPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 9 THEN Material.idfMaterial	ELSE NULL END)	AS Sep,   
            COUNT(case when month(tVetCase.datReportDate) = 9 THEN tPositiv.idfMaterial ELSE NULL END)	AS SepPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 10 THEN Material.idfMaterial  ELSE NULL END) AS Oct, 
            COUNT(case when month(tVetCase.datReportDate) = 10 THEN tPositiv.idfMaterial ELSE NULL END) AS OctPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 11 THEN Material.idfMaterial  ELSE NULL END) AS Nov,  
            COUNT(case when month(tVetCase.datReportDate) = 11 THEN tPositiv.idfMaterial ELSE NULL END) AS NovPR,
            
            COUNT(case when month(tVetCase.datReportDate) = 12 THEN Material.idfMaterial  ELSE NULL END) AS Dec,  
            COUNT(case when month(tVetCase.datReportDate) = 12 THEN tPositiv.idfMaterial ELSE NULL END) AS DecPR

	from		dbo.tlbVetCase					as tVetCase
	inner join	tlbMaterial as Material 
			on	tVetCase.idfVetCase = Material.idfVetCase
			and Material.intRowStatus = 0
	left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
	on			SpecimenType.idfsReference = Material.idfsSampleType
			
	inner join	fnAnimalList(@LangID)		as fnAnimalList
			on	fnAnimalList.idfParty = Material.idfAnimal
	-- Get Farm
	 left join	(		
						dbo.tlbFarm			as tFarm
				   
			 left join	dbo.tlbGeoLocation	as tFarmLocation
					on	tFarmLocation.idfGeoLocation = tFarm.idfFarmAddress
				   and  tFarmLocation.intRowStatus = 0
			 left join	dbo.fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfFarmRegion 
					on	rfFarmRegion.idfsReference = tFarmLocation.idfsRegion
				)
			on	tVetCase.idfFarm = tFarm.idfFarm and
			    tFarm.intRowStatus = 0
			
	 left join	(	
				select	distinct tTesting.idfMaterial
					  from	dbo.tlbTesting			as tTesting
				inner join	dbo.tlbTestValidation	as tTestValidation
						on	tTestValidation.idfTesting = tTesting.idfTesting
					   and  tTestValidation.idfsInterpretedStatus = 10104001 /*Rule In*/
					   and  tTestValidation.intRowStatus = 0
					   and  tTesting.intRowStatus = 0
				) as tPositiv
			on	tPositiv.idfMaterial = Material.idfMaterial
	 left join	dbo.fnReferenceRepair(@LangID, 19000019 ) tDiagnosis --rftDiagnosis
			on	tVetCase.idfsShowDiagnosis = tDiagnosis.idfsReference
		 where  year(tVetCase.datReportDate) = @Year
			AND tVetCase.intRowStatus = 0
	  group by  tDiagnosis.name , rfFarmRegion.[name], SpecimenType.name
	  
	  


