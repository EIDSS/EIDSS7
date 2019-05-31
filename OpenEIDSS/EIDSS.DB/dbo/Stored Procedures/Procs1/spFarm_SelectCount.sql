
--##SUMMARY Selects count of Farms

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spFarm_SelectCount 
	
*/

create procedure	[dbo].[spFarm_SelectCount]
as

select		COUNT(*) 
FROM		tlbFarmActual
WHERE		tlbFarmActual.intRowStatus = 0

