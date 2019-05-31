

--##SUMMARY Select data for Penside Tests for Vet report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 23.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetPensideTestsList 1849460000822 , 'en' 
 
*/ 

create  Procedure [dbo].[spRepVetPensideTestsList] 
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
	select		rfTestType.[name]				as strTestName,
				tMaterial.strFieldBarcode		as strFieldSampleID,
				rfSpecimenType.[name]			as strSampleType,
				coalesce(SpeciesType.name, SpeciesType.strDefault, '') +' ' +coalesce(tAnimal.strAnimalCode, tHerd.strHerdCode,'') 
												as strSpecies,
				rfTestResult.[name]				as strTestResult 	
	 
	from		dbo.tlbVetCase		as tVetCase
		   
	 left join	dbo.tlbMaterial	as tMaterial
	     left join	dbo.fnReferenceRepair(@LangID, 19000087 /*rftSpecimenType*/)		as rfSpecimenType
			    on	tMaterial.idfsSampleType = rfSpecimenType.idfsReference
 		on	tMaterial.idfVetCase = tVetCase.idfVetCase and
 		    tMaterial.intRowStatus = 0
		   
   inner join	dbo.tlbPensideTest	as tTest
	     left join	dbo.fnReferenceRepair(@LangID, 19000105 /*rftPensideTestResult*/)	as rfTestResult
			    on	rfTestResult.idfsReference = tTest.idfsPensideTestResult
	     left join	dbo.fnReferenceRepair(@LangID, 19000104 /*rftPensideTestType*/)	as rfTestType
			    on	rfTestType.idfsReference = tTest.idfsPensideTestName
	 on	tTest.idfMaterial = tMaterial.idfMaterial	and 
      tTest.intRowStatus = 0
			

	 left join	dbo.tlbSpecies		as tSpecies
	       inner join	dbo.tlbHerd			as tHerd
			      on	tSpecies.idfHerd = tHerd.idfHerd
			on	tMaterial.idfSpecies = tSpecies.idfSpecies and
			    tSpecies.intRowStatus = 0

	 left join  dbo.fnReferenceRepair(@LangID,19000086) SpeciesType 
			on  SpeciesType.idfsReference = tSpecies.idfsSpeciesType
			
	 left join	dbo.tlbAnimal		as tAnimal
			on	tMaterial.idfAnimal = tAnimal.idfAnimal and
			    tAnimal.intRowStatus = 0
			
			
	 where  tVetCase.idfVetCase = @ObjID
		AND tVetCase.intRowStatus = 0
			

