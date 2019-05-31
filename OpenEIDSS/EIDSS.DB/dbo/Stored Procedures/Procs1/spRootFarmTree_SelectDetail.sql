


 

--##SUMMARY Selects farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY These data are accessible only for actual (root) farm, not related to case

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Zhdanova A.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Gorodentseva T. all animals information associated with tlbFarmActual deleted
--##REMARKS Date: 24.07.2012

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfCase bigint

EXECUTE spRootFarmTree_SelectDetail 
	11000000001, 3

*/

create            Proc	[dbo].[spRootFarmTree_SelectDetail]
		@idfFarm	bigint--##PARAM @idfFarm - ID of farm
		,@HACode	int--##PARAM @HACode - HA Code of posted tree node (livetock or animal)
As

--0 The Farm tree structure
IF EXISTS (SELECT idfFarmActual FROM tlbFarmActual WHERE idfFarmActual = @idfFarm)
BEGIN
	Select		
		tlbFarmActual.idfFarmActual AS idfParty,
		CAST(10072005 as bigint) --FARM
			AS idfsPartyType,
		tlbFarmActual.strFarmCode As strName,
		CAST(NULL as bigint) as idfParentParty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarmActual.intAvianTotalAnimalQty ELSE tlbFarmActual.intLivestockTotalAnimalQty END AS intTotalAnimalQty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarmActual.intAvianSickAnimalQty ELSE tlbFarmActual.intLivestockSickAnimalQty END AS intSickAnimalQty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarmActual.intAvianDeadAnimalQty ELSE tlbFarmActual.intLivestockDeadAnimalQty END AS intDeadAnimalQty,
		CAST(NULL as int) AS  strAverageAge,
		CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
		strNote,
		@HACode as HACode,
		0 as intOrder
		
	From	tlbFarmActual 
	Where	    
		tlbFarmActual.idfFarmActual = @idfFarm
		AND tlbFarmActual.intRowStatus = 0

	--SELECT Herds info related with case/case farm
/*	UNION

	Select		
		tlbHerdActual.idfHerdActual AS idfParty,
		10072003 -- Herd
			AS idfsPartyType,
		tlbHerdActual.strHerdCode As strName,
		tlbHerdActual.idfFarmActual as idfParentParty,
		tlbHerdActual.intTotalAnimalQty,
		tlbHerdActual.intSickAnimalQty,
		tlbHerdActual.intDeadAnimalQty,
		CAST(NULL as int) AS  strAverageAge,
		CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
		tlbHerdActual.strNote,
		@HACode as HACode,
		1 as intOrder
	From	tlbHerdActual 
	INNER JOIN tlbFarmActual ON
		tlbHerdActual.idfFarmActual = tlbFarmActual.idfFarmActual
		AND tlbFarmActual.intRowStatus = 0
	INNER JOIN tlbSpeciesActual ON
		tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
		AND tlbSpeciesActual.intRowStatus = 0
	INNER JOIN trtBaseReference ON
		tlbSpeciesActual.idfsSpeciesType = trtBaseReference.idfsBaseReference
		--and trtBaseReference.intRowStatus = 0
		and (trtBaseReference.intHACode & @HACode)<>0
	Where	    
		tlbHerdActual.idfFarmActual = @idfFarm
		AND tlbHerdActual.intRowStatus = 0


	--SELECT Herds spieces info related with case/case herd
	UNION
	Select		
		tlbSpeciesActual.idfSpeciesActual AS idfParty,
		10072004 -- Species
			AS idfsPartyType,
		CAST(idfsSpeciesType AS NVARCHAR) As strName,
		tlbHerdActual.idfHerdActual as idfParentParty,
		tlbSpeciesActual.intTotalAnimalQty,
		tlbSpeciesActual.intSickAnimalQty,
		tlbSpeciesActual.intDeadAnimalQty,
		tlbSpeciesActual.strAverageAge,
		tlbSpeciesActual.datStartOfSignsDate,
		tlbSpeciesActual.strNote,
		@HACode as HACode,
		2 as intOrder
	From	tlbSpeciesActual
	INNER JOIN trtBaseReference ON
		tlbSpeciesActual.idfsSpeciesType = trtBaseReference.idfsBaseReference
		--and trtBaseReference.intRowStatus = 0
		and (trtBaseReference.intHACode & @HACode)<>0
	INNER JOIN tlbHerdActual ON
		tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
	Where	    
		tlbHerdActual.idfFarmActual = @idfFarm
		AND tlbSpeciesActual.intRowStatus = 0
	ORDER BY
		intOrder
*/
END
ELSE 
BEGIN

	Select		
		tlbFarm.idfFarm AS idfParty,
		CAST(10072005 as bigint) --FARM
			AS idfsPartyType,
		tlbFarm.strFarmCode As strName,
		CAST(NULL as bigint) as idfParentParty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarm.intAvianTotalAnimalQty ELSE tlbFarm.intLivestockTotalAnimalQty END AS intTotalAnimalQty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarm.intAvianSickAnimalQty ELSE tlbFarm.intLivestockSickAnimalQty END AS intSickAnimalQty,
		CASE WHEN (@HACode & 64)<>0/*avian*/ THEN tlbFarm.intAvianDeadAnimalQty ELSE tlbFarm.intLivestockDeadAnimalQty END AS intDeadAnimalQty,
		CAST(NULL as int) AS  strAverageAge,
		CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
		strNote,
		@HACode as HACode,
		0 as intOrder
	From	tlbFarm 
	Where	    
		tlbFarm.idfFarm = @idfFarm
		AND tlbFarm.intRowStatus = 0

	--SELECT Herds info related with case/case farm
	UNION

	Select		
		tlbHerd.idfHerd AS idfParty,
		CAST(10072003 as bigint) -- Herd
			AS idfsPartyType,
		tlbHerd.strHerdCode As strName,
		tlbHerd.idfFarm as idfParentParty,
		tlbHerd.intTotalAnimalQty,
		tlbHerd.intSickAnimalQty,
		tlbHerd.intDeadAnimalQty,
		CAST(NULL as int) AS  strAverageAge,
		CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
		tlbHerd.strNote,
		@HACode as HACode,
		1 as intOrder
	From	tlbHerd 
	INNER JOIN tlbFarm ON
		tlbHerd.idfFarm = tlbFarm.idfFarm
		AND tlbFarm.intRowStatus = 0
	--INNER JOIN tlbSpecies ON
	--	tlbHerd.idfHerd = tlbSpecies.idfHerd
	--	AND tlbSpecies.intRowStatus = 0
	--INNER JOIN trtBaseReference ON
	--	tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
	--	--and trtBaseReference.intRowStatus = 0
	--	and (trtBaseReference.intHACode & @HACode)<>0
	Where	    
		tlbHerd.idfFarm = @idfFarm
		AND tlbHerd.intRowStatus = 0


	--SELECT Herds spieces info related with case/case herd
	UNION
	Select		
		tlbSpecies.idfSpecies AS idfParty,
		CAST(10072004 as bigint) -- Species
			AS idfsPartyType,
		CAST(idfsSpeciesType AS NVARCHAR) As strName,
		tlbHerd.idfHerd as idfParentParty,
		tlbSpecies.intTotalAnimalQty,
		tlbSpecies.intSickAnimalQty,
		tlbSpecies.intDeadAnimalQty,
		tlbSpecies.strAverageAge,
		tlbSpecies.datStartOfSignsDate,
		tlbSpecies.strNote,
		@HACode as HACode,
		2 as intOrder
	From	tlbSpecies
	INNER JOIN trtBaseReference ON
		tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
		--and trtBaseReference.intRowStatus = 0
		and (trtBaseReference.intHACode & @HACode)<>0
	INNER JOIN tlbHerd ON
		tlbHerd.idfHerd = tlbSpecies.idfHerd
	Where	    
		tlbHerd.idfFarm = @idfFarm
		AND tlbSpecies.intRowStatus = 0
END

