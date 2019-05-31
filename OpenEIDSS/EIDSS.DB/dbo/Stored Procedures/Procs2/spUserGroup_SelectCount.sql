
--##SUMMARY Selects count of User Groups
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spUserGroup_SelectCount 
	
*/

create procedure	[dbo].[spUserGroup_SelectCount]
as

	select		COUNT(*) 
	from		tlbEmployeeGroup
	inner join	tlbEmployee
	on			tlbEmployee.idfEmployee=tlbEmployeeGroup.idfEmployeeGroup
	and			tlbEmployee.intRowStatus=0 
	and			tlbEmployeeGroup.idfEmployeeGroup<>-1
