--*************************************************************
-- Name 				: [USP_VCT_ASCAMPAIGNMONITORINGSESSIONTOSAMPLETYPE_SET]
-- Description			: Insert/Update for Monitoring Session sample type details
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--*/    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNMONITORINGSESSIONTOSAMPLETYPE_SET]
(    
	@MonitoringSessionToSampleType	BIGINT OUTPUT,
	@idfMonitoringSession			BIGINT,
	@idfsSpeciesType				BIGINT,
	@idfsSampleType					BIGINT,
	@intOrder						INT
)    
AS    
DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'
BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM dbo.MonitoringSessionToSampleType WHERE MonitoringSessionToSampleType = @MonitoringSessionToSampleType)
				BEGIN    
					 UPDATE dbo.MonitoringSessionToSampleType   
					 SET    MonitoringSessionToSampleType = @MonitoringSessionToSampleType,
							idfMonitoringSession = @idfMonitoringSession,
							idfsSpeciesType = @idfsSpeciesType,
							idfsSampleType = @idfsSampleType,
							intOrder = @intOrder
					 WHERE  MonitoringSessionToSampleType = @MonitoringSessionToSampleType
				END    
			ELSE
				BEGIN    
					IF (ISNULL(@MonitoringSessionToSampleType,0)<=0)	
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'MonitoringSessionToSampleType', @MonitoringSessionToSampleType OUTPUT    

					INSERT INTO dbo.MonitoringSessionToSampleType   
						(    
							MonitoringSessionToSampleType,
							idfMonitoringSession,
							idfsSpeciesType,
							idfsSampleType, 
							intOrder,
							intRowStatus
						)    
					VALUES    
						(    
							@MonitoringSessionToSampleType,
							@idfMonitoringSession,
							@idfsSpeciesType,
							@idfsSampleType, 
							@intOrder,
							0
						)    
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


