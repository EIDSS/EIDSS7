

CREATE PROCEDURE dbo.spUserGroupDetail_Delete(@ID as bigint)
AS
	DELETE FROM tlbEmployeeGroup
	WHERE idfEmployeeGroup=@ID
	EXEC dbo.spsysBaseReference_Delete @ID
RETURN 0



