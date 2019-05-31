

CREATE   Proc [dbo].[USP_GBL_Person_Delete]
@idfPerson  BIGINT
As
-- StaffPosition
BEGIN
	DECLARE @returnMsg				VARCHAR(MAX) = 'Success';
	DECLARE @returnCode				BIGINT = 0;
BEGIN TRY
	DELETE FROM tstObjectAccess WHERE idfActor = @idfPerson
	DELETE FROM tlbEmployeeGroupMember WHERE idfEmployee = @idfPerson
	DELETE FROM tlbPerson WHERE idfPerson = @idfPerson
	DELETE FROM tlbEmployee WHERE idfEmployee = @idfPerson

	SELECT @returnMsg 'ReturnMessage', @returnCode 'ReturnCode'
END TRY
BEGIN CATCH
	THROW;
END CATCH

END








