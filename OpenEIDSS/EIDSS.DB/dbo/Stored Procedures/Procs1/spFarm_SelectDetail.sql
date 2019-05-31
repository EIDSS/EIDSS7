

--##SUMMARY Returns data for FarmDetail form.
--##SUMMARY The form itself contains only LiveStock/Avian checkboxes, all other data are loaded through the child panels
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.08.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:

exec spFarm_SelectDetail 51422990000000
exec spFarm_SelectDetail NULL

*/


CREATE           PROCEDURE [dbo].[spFarm_SelectDetail]
	@idfFarm AS bigint			--##PARAM @idfFarm - farm ID
AS


Select  
	idfFarm, 
	intHACode,
	datModificationDate
FROM tlbFarm
Where 
	idfFarm=@idfFarm
	AND intRowStatus = 0
UNION ALL
Select  
	idfFarmActual AS idfFarm, 
	intHACode,
	datModificationDate
FROM tlbFarmActual
Where 
	idfFarmActual=@idfFarm
	AND intRowStatus = 0










