



--##SUMMARY Deletes department Record. Called from OrganizationDetail form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use

/*
--Example of procedure call:

DECLARE @ID as bigint
EXEC spDepartment_Delete @ID

*/

CREATE      procedure dbo.spDepartment_Delete( 
	@ID as bigint
)
as
DECLARE @NameID bigint

SELECT 
	@NameID = idfsDepartmentName
FROM 
	tlbDepartment 
WHERE 
	idfDepartment=@ID

delete from tlbDepartment
where idfDepartment = @ID
exec dbo.spsysBaseReference_Delete @NameID






