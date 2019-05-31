

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

/*
exec spAvianFarmProduction_SelectDetail 53320000000
*/


CREATE     Proc	[dbo].[spAvianFarmProduction_SelectDetail]
		@idfFarm	bigint
As
Select		
	idfFarm,
	idfsAvianFarmType,
	idfsAvianProductionType,
	idfsIntendedUse,
	idfFarmActual as idfRootFarm
From		tlbFarm
WHERE
	idfFarm=@idfFarm
	AND intRowStatus = 0

UNION ALL 
Select		
	idfFarmActual as idfFarm,
	idfsAvianFarmType,
	idfsAvianProductionType,
	idfsIntendedUse,
	NULL as idfRootFarm
From		tlbFarmActual
WHERE
	idfFarmActual=@idfFarm
	AND intRowStatus = 0


