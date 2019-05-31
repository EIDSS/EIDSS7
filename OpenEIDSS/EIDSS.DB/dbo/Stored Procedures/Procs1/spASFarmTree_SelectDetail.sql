


 

--##SUMMARY Selects farm tree data. These data includes info about farm and its child herds/species
--##SUMMARY These data are accessible only for farms related with monitoring session  

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 08.07.2010

--##RETURNS Doesn't use
/*
--Example of a call of procedure:
DECLARE @idfMonitoringSession bigint

EXECUTE spASFarmTree_SelectDetail 
	@idfMonitoringSession

*/

CREATE            Proc	[dbo].[spASFarmTree_SelectDetail]
		@idfMonitoringSession	bigint--##PARAM @idfMonitoringSession - ID of monitoring session to which farm belongs
As

--0 The Farm tree structure

Select		
	tlbFarm.idfFarm as idfParty,
	tlbFarm.idfMonitoringSession,  
	CAST(10072005 AS bigint) as idfsPartyType, 
	tlbFarm.strFarmCode As strName,
	CAST(NULL as bigint) as idfParentParty,
	tlbFarm.intLivestockTotalAnimalQty as intTotalAnimalQty,
	tlbFarm.strNote, 
	idfFarm AS idfFarm
from tlbFarm 
where  
	tlbFarm.idfMonitoringSession = @idfMonitoringSession
	AND tlbFarm.intRowStatus = 0
	AND NOT @idfMonitoringSession IS NULL
--SELECT Herds info related with case/case farm
UNION

Select		
	tlbHerd.idfHerd as idfParty,
	tlbFarm.idfMonitoringSession,  
	CAST(10072003 AS bigint) as idfsPartyType, 
	tlbHerd.strHerdCode As strName,
	tlbHerd.idfFarm as idfParentParty,
	tlbHerd.intTotalAnimalQty,
	tlbHerd.strNote,
	tlbHerd.idfFarm AS idfFarm

From		tlbFarm
  INNER JOIN tlbHerd ON
	  tlbHerd.idfFarm = tlbFarm.idfFarm and
	  tlbHerd.intRowStatus = 0	
	INNER JOIN tlbSpecies ON
		tlbHerd.idfHerd = tlbSpecies.idfHerd
		AND tlbSpecies.intRowStatus = 0
	INNER JOIN trtBaseReference ON
		tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
		and (ISNULL(trtBaseReference.intHACode,32) & 32)<>0
Where	    
	tlbFarm.idfMonitoringSession = @idfMonitoringSession
	AND tlbFarm.intRowStatus = 0
	AND NOT @idfMonitoringSession IS NULL


--SELECT Herds spieces info related with case/case herd
UNION
Select		
	tlbSpecies.idfSpecies as idfParty,
	tlbFarm.idfMonitoringSession,  
	CAST(10072004 AS bigint) as idfsPartyType,
	CAST(tlbSpecies.idfsSpeciesType AS NVARCHAR) As strName,
	tlbHerd.idfHerd as idfParentParty,
	tlbSpecies.intTotalAnimalQty,
	tlbSpecies.strNote,
	tlbHerd.idfFarm AS idfFarm
From		tlbFarm
INNER JOIN tlbHerd ON
	tlbHerd.idfFarm = tlbFarm.idfFarm and
	tlbHerd.intRowStatus = 0	
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd and 
	tlbSpecies.intRowStatus = 0
INNER JOIN trtBaseReference ON
	tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
	and (ISNULL(trtBaseReference.intHACode,32) & 32)<>0
Where	    
	tlbFarm.idfMonitoringSession = @idfMonitoringSession
	AND tlbFarm.intRowStatus = 0
	AND NOT @idfMonitoringSession IS NULL





