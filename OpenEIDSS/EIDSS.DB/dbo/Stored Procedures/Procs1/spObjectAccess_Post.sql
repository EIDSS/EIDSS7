





CREATE PROCEDURE dbo.spObjectAccess_Post
(
	@Action 				int, -- 4 - Added, 8 - Deleted, 16 - Modified
	@idfObjectAccess		bigint output,
	@idfsObjectOperation	AS bigint = NULL,
	@idfsObjectType			bigint 	= NULL,
	@idfsObjectID			bigint	= NULL,	
	@idfEmployee			bigint,
	@isAllow				bit,
	@isDeny					bit
)
AS Begin

declare @intPermission int
if (@isDeny = 0) and (@isAllow = 0) Set @intPermission = 0;
if (@isDeny = 1) and (@isAllow = 0) Set @intPermission = 1;
if (@isDeny = 0) and (@isAllow = 1) Set @intPermission = 2;

-- Add or Modify
IF (@Action = 4 Or @Action = 16)
BEGIN	
		-- @idfObjectAccess > 0 for real records in tstObjectAccess for current actor and site.
		-- if @idfObjectAccess < 0 record is virtual (created from default access permission record) 
		-- and new record (with newly generated idfObjectAccess) shall be inserted.
		If @idfObjectAccess > 0 and Exists(Select Top 1 1 From dbo.tstObjectAccess Where idfObjectAccess = @idfObjectAccess and intRowStatus = 0)
		Begin
			UPDATE	tstObjectAccess
			SET		intPermission = @intPermission
			WHERE	 idfObjectAccess = @idfObjectAccess and intRowStatus = 0
		End Else Begin
			-- нужно выдать новый ID
			EXEC spsysGetNewID @idfObjectAccess Output
			
			INSERT INTO	tstObjectAccess
			(
				idfObjectAccess,
				idfsObjectType,
				idfsObjectID,
				idfsObjectOperation,
				idfActor,
				intPermission,
				idfsOnSite
			)
			VALUES
			(
				@idfObjectAccess,
				@idfsObjectType,
				@idfsObjectID,
				@idfsObjectOperation,
				@idfEmployee,
				@intPermission,			
				dbo.fnPermissionSite()
			)
	 end
End
-- Delete
IF @Action = 8
BEGIN
	DELETE FROM tstObjectAccess 
	WHERE idfObjectAccess = @idfObjectAccess
	and idfActor = @idfEmployee
	--
	--AND intRowStatus = 0 
	--AND idfsOnSite=@idfsSite
END
End
