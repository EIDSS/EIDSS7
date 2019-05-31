


CREATE            Proc	[dbo].[spFarmTree_SelectDetail]
		@idfFarm	bigint--##PARAM @idfFarm - ID of farm
As

--0 The Farm tree structure
Select		
	tlbFarm.idfFarm,
	tlbFarm.idfFarm AS idfParty,
	tlbFarm.idfMonitoringSession,
	tvc.idfVetCase AS idfCase,
	CAST(10072005 as bigint) --FARM
		AS idfsPartyType,
	tlbFarm.strFarmCode As strName,
	CAST(NULL as bigint) as idfParentParty,
	tlbFarm.idfObservation,
	tlbObservation.idfsFormTemplate,
	isnull(tlbFarm.intAvianTotalAnimalQty, tlbFarm.intLivestockTotalAnimalQty) AS intTotalAnimalQty,
	isnull(tlbFarm.intAvianSickAnimalQty, tlbFarm.intLivestockSickAnimalQty) AS intSickAnimalQty,
	isnull(tlbFarm.intAvianDeadAnimalQty, tlbFarm.intLivestockDeadAnimalQty) AS intDeadAnimalQty,
	CAST(NULL as int) AS  strAverageAge,
	CAST(NULL AS DATETIME) AS  datStartOfSignsDate,
	strNote
From	tlbFarm 
LEFT OUTER JOIN tlbVetCase tvc ON
	tvc.idfFarm = tlbFarm.idfFarm
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbFarm.idfObservation
	AND tlbObservation.intRowStatus = 0
Where	    
	tlbFarm.idfFarm = @idfFarm
	AND tlbFarm.intRowStatus = 0

--SELECT Herds info related with case/case farm
UNION

Select		
	tlbFarm.idfFarm,
	tlbHerd.idfHerd AS idfParty,
	tlbFarm.idfMonitoringSession,
	tvc.idfVetCase AS idfCase,
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
LEFT OUTER JOIN tlbVetCase tvc ON
	tvc.idfFarm = tlbFarm.idfFarm
Where	    
	tlbFarm.idfFarm = @idfFarm
	AND tlbHerd.intRowStatus = 0


--SELECT Herds spieces info related with case/case herd
UNION
Select		
	tlbFarm.idfFarm,
	tlbSpecies.idfSpecies AS idfParty,
	tlbFarm.idfMonitoringSession,
	tvc.idfVetCase AS idfCase,
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
LEFT OUTER JOIN tlbVetCase tvc ON
	tvc.idfFarm = tlbFarm.idfFarm
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbSpecies.idfObservation
	AND tlbObservation.intRowStatus = 0
Where	    
	tlbFarm.idfFarm = @idfFarm
	AND tlbSpecies.intRowStatus = 0









