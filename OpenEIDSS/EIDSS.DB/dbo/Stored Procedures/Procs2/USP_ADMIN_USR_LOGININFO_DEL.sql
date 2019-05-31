--*************************************************************
-- Name 				: USP_ADMIN_USR_LOGININFO_DEL
-- Description			: Delete user login info
--          
-- Author               : Maheshwar D Deo
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************

CREATE PROCEDURE [dbo].[USP_ADMIN_USR_LOGININFO_DEL]
(
	@idfUserID bigint
)
AS
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0 

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			DELETE 
			FROM	dbo.tstUserTable 
			WHERE	idfUserID=@idfUserID

		IF @@TRANCOUNT > 0 
			COMMIT  

		SELECT @returnCode, @returnMsg
	END TRY  

	BEGIN CATCH  

		IF @@TRANCOUNT > 0
			BEGIN
				ROLLBACK

				SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()
				SELECT @returnCode, @returnMsg
			END

	END CATCH; 
END

