
--*************************************************************
-- Name 				: [USP_GBL_ASSESSIONTOSAMPLETYPE_SET]
-- Description			: Insert/Update for Monitoring Session sample type details
--                      
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Michael Jessee	05/04/2018 Initial release.
--*************************************************************
  
CREATE PROCEDURE [dbo].[USP_GBL_ASSESSIONTOSAMPLETYPE_SET]
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

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY

	BEGIN CATCH
		Throw;

	END CATCH

END


