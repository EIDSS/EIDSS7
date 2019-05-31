--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spDepartment_SelectLookup : rename for V7
--                          Input: langID,org id, depatment id; Output: N/A
--                          05/02/2017: change name to: usp_Department_GetLookup

-- Testing code:
/*
----testing code:
exec usp_Department_GetLookup 'en', null, 2
*/

--=====================================================================================================

CREATE  procedure [dbo].[usp_Department_GetLookup]
	@LangID as nvarchar(50),
	@OrganizationID as bigint = null,
	@ID as bigint = NULL

as
select	idfDepartment, idfInstitution, [name], intRowStatus
from	dbo.fnDepartment(@LangID) 
where	(@OrganizationID is null 
		or idfInstitution = @OrganizationID)
		and (@ID IS NULL OR @ID = idfDepartment)

order by [name]






