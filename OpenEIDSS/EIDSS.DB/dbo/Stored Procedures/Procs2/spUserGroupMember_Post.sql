
CREATE PROCEDURE [dbo].[spUserGroupMember_Post]
(
	@Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfEmployeeGroup bigint
	,@idfEmployee bigint
)
AS
Begin
-- Add and Delete only
IF @Action = 4
BEGIN
	if exists( select * from dbo.tlbEmployeeGroupMember where idfEmployeeGroup = @idfEmployeeGroup and idfEmployee = @idfEmployee)
		update tlbEmployeeGroupMember
		set intRowStatus = 0
		where 
			idfEmployeeGroup = @idfEmployeeGroup 
			and idfEmployee = @idfEmployee
	else

		INSERT INTO dbo.tlbEmployeeGroupMember
				   (idfEmployeeGroup 
					,idfEmployee			    
				   )
			 VALUES
				   (
					@idfEmployeeGroup 
					,@idfEmployee			    
				   )
	
END
Else If @Action = 8 Begin
	Exec [dbo].[spUserGroupMember_Delete] @idfEmployeeGroup,@idfEmployee	
END

End
