




CREATE  procedure dbo.spDepartment_SelectLookup
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





