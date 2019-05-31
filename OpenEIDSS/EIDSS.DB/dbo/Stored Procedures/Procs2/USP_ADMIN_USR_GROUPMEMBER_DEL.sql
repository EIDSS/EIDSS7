
--*************************************************************
-- Name 				: USP_ADMIN_USR_GROUPMEMBER_DEL
-- Description			: Delete user from member group
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ADMIN_USR_GROUPMEMBER_DEL]
(
	@idfEmployeeGroup bigint,
	@idfEmployee bigint
)
AS
DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(MAX) = 'SUCCESS' 
BEGIN

	BEGIN TRY
	BEGIN TRANSACTION

		DELETE 
		FROM	dbo.tlbEmployeeGroupMember 
		WHERE	idfEmployeeGroup = @idfEmployeeGroup and idfEmployee = @idfEmployee

		IF @@TRANCOUNT > 0 
		  COMMIT

		SELECT @returnCode, @returnMsg

	END TRY  

	BEGIN CATCH 

		SET @returnMsg = 
			'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
			+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
			+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
			+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
			+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
			+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SET @returnCode = ERROR_NUMBER()

		SELECT @returnCode, @returnMsg

	END CATCH
END


