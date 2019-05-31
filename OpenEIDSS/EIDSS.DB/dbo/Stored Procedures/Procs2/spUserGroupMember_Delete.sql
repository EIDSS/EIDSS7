
CREATE PROCEDURE [dbo].[spUserGroupMember_Delete]
(
	@idfEmployeeGroup bigint
	,@idfEmployee bigint
)
AS
Begin
	Delete from dbo.tlbEmployeeGroupMember where idfEmployeeGroup = @idfEmployeeGroup and idfEmployee = @idfEmployee
End
