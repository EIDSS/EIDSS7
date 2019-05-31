
--*************************************************************
-- Name 				: [USP_GBL_ASSESSIONTOSAMPLETYPE_DEL]
-- Description			: Delete for Monitoring Session sample type details
--                      
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Mandar Kulkarni	05/21/2018 Initial release.
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_GBL_ASSESSIONTOSAMPLETYPE_DEL]
(    
	@MonitoringSessionToSampleType	BIGINT
)    
AS    
DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'
BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
		BEGIN    
				DELETE
				FROM	dbo.MonitoringSessionToSampleType   
				WHERE  MonitoringSessionToSampleType = @MonitoringSessionToSampleType
		END    
    
		IF @@TRANCOUNT > 0 
			COMMIT

		SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK
				SET @returnCode = ERROR_NUMBER()
				SET @returnMsg = 
			   'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
			   + ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   + ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   + ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   + ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   + ' ErrorMessage: '+ ERROR_MESSAGE()
			   ----select @LogErrMsg

			  SELECT @returnCode, @returnMsg

	END CATCH

END


