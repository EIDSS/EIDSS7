
--##SUMMARY Selects farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY These data are accessible only for case related farms

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use
/*
--Example of a call of procedure:
DECLARE @idfCase bigint

EXECUTE spVetFarmTree_SelectDetail 
	@idfCase = 710130000000

*/

CREATE            Proc	[dbo].[spVetFarmTree_SelectDetail]
		@idfCase	bigint--##PARAM @idfCase - ID of case to which farm belongs
As

DECLARE @CaseType AS BIGINT 
Select 
	@CaseType = idfsCaseType
FROM tlbVetCase
Where 
	idfVetCase=@idfCase
	and intRowStatus=0

--0 The Farm tree structure

Select		
	tlbFarm.idfFarm AS idfParty,
	tlbVetCase.idfVetCase AS idfCase,  
	CAST(10072005 as bigint) --FARM
		AS idfsPartyType,
	tlbFarm.strFarmCode As strName,
	CAST(NULL as bigint) as idfParentParty,
	tlbFarm.idfObservation,
	tlbObservation.idfsFormTemplate,
	CASE WHEN @CaseType = 10012004/*avian*/ THEN tlbFarm.intAvianTotalAnimalQty ELSE tlbFarm.intLivestockTotalAnimalQty END AS intTotalAnimalQty,
	CASE WHEN @CaseType = 10012004/*avian*/ THEN tlbFarm.intAvianSickAnimalQty ELSE tlbFarm.intLivestockSickAnimalQty END AS intSickAnimalQty,
	CASE WHEN @CaseType = 10012004/*avian*/ THEN tlbFarm.intAvianDeadAnimalQty ELSE tlbFarm.intLivestockDeadAnimalQty END AS intDeadAnimalQty,
	CAST(NULL as int) AS  strAverageAge,
	CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
	strNote
From	tlbFarm 
INNER JOIN dbo.tlbVetCase ON
	tlbVetCase.idfFarm = tlbFarm.idfFarm
	AND tlbVetCase.intRowStatus = 0
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbFarm.idfObservation
	AND tlbObservation.intRowStatus = 0
Where	    
	tlbVetCase.idfVetCase = @idfCase
	AND tlbFarm.intRowStatus = 0

--SELECT Herds info related with case/case farm
UNION

Select		
	tlbHerd.idfHerd AS idfParty,
	tlbVetCase.idfVetCase AS idfCase,  
	CAST(10072003 as bigint) -- Herd
		AS idfsPartyType,
	tlbHerd.strHerdCode As strName,
	tlbHerd.idfFarm as idfParentParty,
	CAST(NULL AS bigint) as idfObservation,
	CAST(NULL AS bigint) as idfsFormTemplate,
	tlbHerd.intTotalAnimalQty,
	tlbHerd.intSickAnimalQty,
	tlbHerd.intDeadAnimalQty,
	CAST(NULL as int) AS  strAverageAge,
	CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
	tlbHerd.strNote
From	tlbHerd 
INNER JOIN tlbFarm ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbFarm.intRowStatus = 0
INNER JOIN dbo.tlbVetCase ON
	tlbVetCase.idfFarm = tlbFarm.idfFarm
	AND tlbVetCase.intRowStatus = 0
Where	    
	tlbVetCase.idfVetCase = @idfCase
	AND tlbHerd.intRowStatus = 0


--SELECT Herds spieces info related with case/case herd
UNION
Select		
	tlbSpecies.idfSpecies AS idfParty,
	tlbVetCase.idfVetCase AS idfCase,  
	CAST(10072004 as bigint) -- Species
		AS idfsPartyType,
	CAST(idfsSpeciesType AS NVARCHAR) As strName,
	tlbHerd.idfHerd as idfParentParty,
	tlbSpecies.idfObservation,
	tlbObservation.idfsFormTemplate,
	tlbSpecies.intTotalAnimalQty,
	tlbSpecies.intSickAnimalQty,
	tlbSpecies.intDeadAnimalQty,
	tlbSpecies.strAverageAge,
	tlbSpecies.datStartOfSignsDate,
	tlbSpecies.strNote
From	tlbSpecies 
INNER JOIN tlbHerd ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	AND tlbHerd.intRowStatus = 0
INNER JOIN tlbFarm ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbFarm.intRowStatus = 0
INNER JOIN dbo.tlbVetCase ON
	tlbVetCase.idfFarm = tlbFarm.idfFarm
	AND tlbVetCase.intRowStatus = 0
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbSpecies.idfObservation
	AND tlbObservation.intRowStatus = 0
Where	    
	tlbVetCase.idfVetCase = @idfCase
	AND tlbSpecies.intRowStatus = 0



--EXEC dbo.spVetFarmTree_SelectDetail 'C6BF9591-E727-42C8-807B-179097EE60CA', 'en'







