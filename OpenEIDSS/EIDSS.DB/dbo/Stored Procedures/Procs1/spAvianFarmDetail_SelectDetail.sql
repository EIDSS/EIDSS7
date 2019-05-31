







--##SUMMARY Selects data for AvianFarmDetail control data.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @idfFarm bigint
EXECUTE spAvianFarmDetail_SelectDetail 
	@idfFarm

*/


CREATE           PROCEDURE [dbo].[spAvianFarmDetail_SelectDetail]
	@idfFarm AS bigint --##PARAM @idfFarm - farm ID
AS

Select  
	idfFarm, 
	intBuidings,
	intBirdsPerBuilding
FROM tlbFarm
Where 
	idfFarm=@idfFarm
	AND intRowStatus = 0
UNION ALL
Select  
	idfFarmActual as idfFarm, 
	intBuidings,
	intBirdsPerBuilding
FROM tlbFarmActual
Where 
	idfFarmActual=@idfFarm
	AND intRowStatus = 0









