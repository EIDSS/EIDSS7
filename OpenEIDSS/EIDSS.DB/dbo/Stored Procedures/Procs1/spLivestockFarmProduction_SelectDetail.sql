

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011


CREATE    Proc	[dbo].[spLivestockFarmProduction_SelectDetail]
		@idfFarm	bigint
As
Select		
	idfFarm,
	idfsOwnershipStructure,
	idfsLivestockProductionType,
	idfsGrazingPattern,
	idfsMovementPattern,
	tlbFarm.idfFarmActual as idfRootFarm
From		tlbFarm
WHERE idfFarm=@idfFarm
	AND intRowStatus = 0

UNION ALL
Select		
	idfFarmActual as idfFarm,
	idfsOwnershipStructure,
	idfsLivestockProductionType,
	idfsGrazingPattern,
	idfsMovementPattern,
	NULL as idfRootFarm
From		tlbFarmActual
WHERE idfFarmActual=@idfFarm
	AND intRowStatus = 0

