
-- =============================================
-- Author:		Steven L. Verner
-- Create date: 05.07.2019
-- Description:	Retrieve a list of Roles and Permissions for the given user.
-- =============================================
CREATE PROCEDURE dbo.USP_ASPNetUser_GetRolesAndPermissions 
	-- Add the parameters for the stored procedure here
	@idfuserid bigint 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    select  
	 r.idfEmployeeGroup
	,r.strName Role
	,r1.strDefault Permission
	,r2.strDefault PermissionLevel
	from tstuserTable ut
	join tlbPerson p on p.idfPerson = ut.idfPerson
	join tlbEmployeeGroupMember gm on gm.idfEmployee = ut.idfPerson
	join tlbemployeegroup r on r.idfEmployeeGroup = gm.idfEmployeeGroup
	join LkupRoleSystemFunctionAccess fa on fa.RoleID = r.idfEmployeeGroup
	join trtBaseReference r1 on r1.idfsBaseReference = fa.SystemFunctionID
	join trtReferenceType r11 on r11.idfsReferenceType = r1.idfsReferenceType
	join trtBaseReference r2 on r2.idfsBaseReference = fa.SystemFunctionOperationID
	WHERE ut.idfUserID = @idfuserid

	order by strName, r1.strDefault  
	
END
GO
