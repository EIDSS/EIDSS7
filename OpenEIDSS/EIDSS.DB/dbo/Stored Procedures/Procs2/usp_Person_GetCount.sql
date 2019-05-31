--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spPerson_SelectCount : rename for V7
--                          Input: N/A; Output: count
--                          05/02/2017: change name to: usp_Person_GetCount

-- Testing code:
/*
----testing code:
EXECUTE usp_Person_GetCount
*/

--=====================================================================================================
--##SUMMARY Selects count of Persons
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 31.10.2011
--##RETURNS Doesn't use


create procedure	[dbo].[usp_Person_GetCount]
as

select		COUNT(*) 
FROM		tlbPerson
INNER JOIN	tlbEmployee
ON			tlbEmployee.idfEmployee = tlbPerson.idfPerson
AND			tlbEmployee.intRowStatus = 0


