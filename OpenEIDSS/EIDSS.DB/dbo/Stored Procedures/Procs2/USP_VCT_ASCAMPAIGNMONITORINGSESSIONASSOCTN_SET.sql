--*************************************************************
-- Name 				: [USP_VCT_ASCAMPAIGNMONITORINGSESSIONASSOCTN_SET]
-- Description			: Associate/DisAssociate Campaign to Monitoring Session
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--*/    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNMONITORINGSESSIONASSOCTN_SET]
(    
	@idfMonitoringSession	BIGINT,
	@idfCampaign			BIGINT -- Pass in as 'NULL' when to disassociate
)
AS    
DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'
BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			BEGIN
				-- Logic to associate camapign to monitoring session
				UPDATE dbo.tlbMonitoringSession   
				SET    idfCampaign = @idfCampaign
				WHERE  idfMonitoringSession = @idfMonitoringSession
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


