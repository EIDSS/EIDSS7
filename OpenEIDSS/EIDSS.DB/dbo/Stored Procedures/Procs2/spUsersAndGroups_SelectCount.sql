
--##SUMMARY Selects count of User Groups
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.12.2011

--##RETURNS Doesn't use

/*
--Example of procedure call:
EXECUTE spUsersAndGroups_SelectCount 
	
*/

CREATE procedure	[dbo].[spUsersAndGroups_SelectCount]
as

	select		COUNT(*) 
	from		tlbEmployee
	--left join	
	--			tlbPerson
	--on			tlbEmployee.idfEmployee = tlbPerson.idfPerson
	--left join	tlbEmployeeGroup
	--on			tlbEmployee.idfEmployee = tlbEmployeeGroup.idfEmployeeGroup 
	where		tlbEmployee.intRowStatus=0 and 
	--			--tlbEmployee.idfEmployee<>-1 and
				tlbEmployee.idfsEmployeeType in (10023001,10023002) -- user or group
				--and	tlbEmployeeGroup.idfEmployeeGroup<>-1
