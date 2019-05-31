
--##SUMMARY Selects count of Persons

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spPerson_SelectCount 
	
*/


create procedure	[dbo].[spPerson_SelectCount]
as

select		COUNT(*) 
FROM		tlbPerson
INNER JOIN	tlbEmployee
ON			tlbEmployee.idfEmployee = tlbPerson.idfPerson
AND			tlbEmployee.intRowStatus = 0

