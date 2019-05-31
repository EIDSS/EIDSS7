--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spUserGroup_SelectCount: rename for V7
--                          Input: N/A; Output: N/A
--                          05/02/2017: change name to: usp_UserGroup_GetCount

-- Testing code:
/*
----testing code:
EXECUTE usp_UserGroup_GetCount
*/

--=====================================================================================================
--##SUMMARY Selects count of User Groups
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011
--##RETURNS Doesn't use


create procedure	[dbo].[usp_UserGroup_GetCount]
as

	select		COUNT(*) 
	from		tlbEmployeeGroup
	inner join	tlbEmployee
	on			tlbEmployee.idfEmployee=tlbEmployeeGroup.idfEmployeeGroup
	and			tlbEmployee.intRowStatus=0 
	and			tlbEmployeeGroup.idfEmployeeGroup<>-1

