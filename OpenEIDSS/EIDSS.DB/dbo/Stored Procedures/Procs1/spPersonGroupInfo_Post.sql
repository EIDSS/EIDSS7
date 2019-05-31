
CREATE PROCEDURE dbo.spPersonGroupInfo_Post
( 
		 @Action as int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
		,@idfEmployeeGroup as bigint
		,@idfEmployee as bigint
)
	
AS Begin
exec spUserGroupMember_Post @Action,@idfEmployeeGroup, @idfEmployee
--IF @Action = 4 --insert
--BEGIN
--	Insert into dbo.tlbEmployeeGroupMember
--	(
--		idfEmployeeGroup
--		,idfEmployee
--	)
--	Values
--	(
--		@idfEmployeeGroup
--		,@idfEmployee
--	)
--END	
--ELSE IF @Action=8 --DELETE
--Begin
--	Delete from dbo.tlbEmployeeGroupMember where idfEmployeeGroup=@idfEmployeeGroup and idfEmployee=@idfEmployee
--End

End
