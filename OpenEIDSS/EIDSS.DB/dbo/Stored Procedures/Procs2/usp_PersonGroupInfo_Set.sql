
--------------------------------------------------------------------------------------
--
-- Mark Wilson 14-June-2017--
-- Updated to rename stored procs to usp_ _set
-- added to return new user id when  insert--
-- 15-June-2017 - MCW
-- Changed @Action from 4,8,16 to I, D, U--
-- 16-June-2017 - MCW
-- Changed added check to insure @Action meets I,U,D requirement
-- Revision History
--		Name       Date       Change Detail
--      JL         05/16/2018 change to valide Store Procedure USP_ADMIN_USR_GROUPMEMBER_SET
--
--------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_PersonGroupInfo_Set]
( 
	@Action AS VARCHAR(2),  -- I - insert record, D - delete record, U - update record
	@idfEmployeeGroup AS BIGINT,
	@idfEmployee AS BIGINT
)
	
AS 
BEGIN
DECLARE @msg NVARCHAR(200)

---------------------------------------------------------------------------------------
-- Check to make sure the Action is valid 
---------------------------------------------------------------------------------------
IF UPPER(@Action) NOT IN ('I', 'U', 'D')
BEGIN
  SET @msg = @Action + ' is not supported.  Use I for Insert, U for Update and D for Delete.'
  RAISERROR(@msg, 18,2)
  RETURN
END

EXEC USP_ADMIN_USR_GROUPMEMBER_SET @Action, @idfEmployeeGroup, @idfEmployee

END

