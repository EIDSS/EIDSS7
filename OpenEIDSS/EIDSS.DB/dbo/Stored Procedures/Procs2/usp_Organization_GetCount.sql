



--##SUMMARY Selects count of Organizations
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

-- renamed to usp_Organization_GetCount from usp_Organization_SelectCount by MCW 5/2/2017

/*
--Example of procedure call:
EXECUTE spOrganization_SelectCount 
	
*/

create procedure	[dbo].[usp_Organization_GetCount]
as

select		COUNT(*) 
from		tlbOffice
where		tlbOffice.intRowStatus = 0



