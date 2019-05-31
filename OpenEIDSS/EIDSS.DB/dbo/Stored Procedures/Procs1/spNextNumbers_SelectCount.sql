
--##SUMMARY Selects count of Numbering shhem,e
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spNextNumbers_SelectCount 
	
*/

create procedure	[dbo].[spNextNumbers_SelectCount]
as

select		COUNT(*) 
from		tstNextNumbers
