--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		05/02/2017
-- Last modified by:		Joan Li
-- Description:				05/02/2017: Created based on V6 spUserGroupDetail_Delete: rename for V7
--                          Input: N/A; Output: N/A
--                          05/02/2017: change name to: usp_UserGroupDetail_Delete

-- Testing code:
/*
----testing code:
EXECUTE usp_UserGroupDetail_Delete
*/

--=====================================================================================================
CREATE PROCEDURE [dbo].[usp_UserGroupDetail_Delete](@ID as bigint)
AS
	DELETE FROM tlbEmployeeGroup
	WHERE idfEmployeeGroup=@ID
	EXEC dbo.usp_sysBaseReference_Delete @ID
RETURN 0




