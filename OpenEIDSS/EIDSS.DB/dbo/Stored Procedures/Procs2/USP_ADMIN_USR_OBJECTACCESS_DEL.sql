
--*************************************************************
-- Name 				: USP_ADMIN_USR_OBJECTACCESS_DEL
-- Description			: Delete object access
--          
-- Author               : Maheshwar Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_ADMIN_USR_OBJECTACCESS_DEL]
(
	@idfObjectAccess		BIGINT ,
	@idfEmployee			BIGINT
)
AS 

DECLARE @returnCode		INT = 0 
DECLARE	@returnMsg		NVARCHAR(MAX) = 'SUCCESS' 
DECLARE @intPermission int
BEGIN

	IF (ISNULL(@idfEmployee,0)=0)
	BEGIN
	  RAISERROR('parameter @idfEmployee is required for delete',18,0)
	  RETURN
	END

	IF (ISNULL(@idfObjectAccess,0)=0)
	BEGIN
	  RAISERROR('parameter @idfObjectAccess is required for delete',18,0)
	  RETURN
	END

	BEGIN TRY
	BEGIN TRANSACTION

		-- Delete
		DELETE 
		FROM	dbo.tstObjectAccess 
		WHERE	idfActor = @idfEmployee
		AND		idfObjectAccess = @idfObjectAccess
	 

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
