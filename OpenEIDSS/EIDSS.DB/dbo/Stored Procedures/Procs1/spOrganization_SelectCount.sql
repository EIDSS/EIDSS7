
--##SUMMARY Selects count of Organizations
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spOrganization_SelectCount 
	
*/

create procedure	[dbo].[spOrganization_SelectCount]
as

select		COUNT(*) 
from		tlbOffice
where		tlbOffice.intRowStatus = 0
