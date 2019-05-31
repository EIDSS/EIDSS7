--*************************************************************
-- Name 				: [USP_VCT_ASCAMPAIGNMONITORINGSESSIONANDSAMPLES_SET]
-- Description			: Insert/Update for Campaign Monitoring Session
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
--*/    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNMONITORINGSESSIONANDSAMPLES_SET]
(    
	@SetMonitoringidfSession				BIGINT OUTPUT,
	@SetMonitoringidfsSessionStatus			BIGINT, 
	@SetMonitoringSessionidfsCountry		BIGINT,
	@SetMonitoringSessionidfsRegion			BIGINT,
	@SetMonitoringSessionidfsRayon			BIGINT,
	@SetMonitoringSessionidfsSettlement		BIGINT,
	@SetMonitoringSessionidfPersonEnteredBy	BIGINT,
	@idfCampaign							BIGINT,
	@idfsDiagnosis							BIGINT,
	@SetMonitoringSessiondatEnteredDate		DATETIME,
	@SetMonitoringSessionstrSessionID		NVARCHAR (50) OUTPUT,
	@SetMonitoringSessiondatStartDate		DATETIME,
	@SetMonitoringSessiondatEndDate			DATETIME,
	@MonitoringSessionidfsCategoryID		BIGINT -- 10169001 Human Active Surveillance Session, 10169002 Veterinary Active Surveillance Session
)     
AS    
DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'
BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM dbo.tlbMonitoringSession WHERE idfMonitoringSession = @SetMonitoringidfSession)
				BEGIN    
					 UPDATE dbo.tlbMonitoringSession   
					 SET    idfsMonitoringSessionStatus = @SetMonitoringidfsSessionStatus,
							idfsCountry = @SetMonitoringSessionidfsCountry,
							idfsRegion = @SetMonitoringSessionidfsRegion,
							idfsRayon = @SetMonitoringSessionidfsRayon,
							idfsSettlement = @SetMonitoringSessionidfsSettlement,
							idfPersonEnteredBy = @SetMonitoringSessionidfPersonEnteredBy,
							idfCampaign = @idfCampaign,
							idfsDiagnosis = @idfsDiagnosis,
							datEnteredDate = @SetMonitoringSessiondatEnteredDate,
							datStartDate = @SetMonitoringSessiondatStartDate,
							datEndDate = @SetMonitoringSessiondatEndDate,
							SessionCategoryID = @MonitoringSessionidfsCategoryID
					 WHERE  idfMonitoringSession = @SetMonitoringidfSession
				END    
			ELSE
				BEGIN    
					IF (ISNULL(@SetMonitoringidfSession,0)<=0)	
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSession', @SetMonitoringidfSession OUTPUT    

					IF LEFT(ISNULL(@SetMonitoringSessionstrSessionID, '(new'),4) = '(new'
						BEGIN
							EXEC dbo.USP_GBL_NextNumber_GET 'Active Surveillance Session', @SetMonitoringSessionstrSessionID OUTPUT , NULL
						END


					INSERT INTO dbo.tlbMonitoringSession   
						(    
							idfMonitoringSession,
							idfsMonitoringSessionStatus,
							idfsCountry,
							idfsRegion,
							idfsRayon,
							idfsSettlement,
							idfPersonEnteredBy,
							idfCampaign,
							idfsDiagnosis,
							datEnteredDate,
							strMonitoringSessionID,
							datStartDate,
							datEndDate,
							SessionCategoryID,
							intRowStatus
						)    
					VALUES    
						(    
							@SetMonitoringidfSession,
							@SetMonitoringidfsSessionStatus,
							@SetMonitoringSessionidfsCountry,
							@SetMonitoringSessionidfsRegion,
							@SetMonitoringSessionidfsRayon,
							@SetMonitoringSessionidfsSettlement,
							@SetMonitoringSessionidfPersonEnteredBy,
							@idfCampaign,
							@idfsDiagnosis,
							@SetMonitoringSessiondatEnteredDate,
							@SetMonitoringSessionstrSessionID,
							@SetMonitoringSessiondatStartDate,
							@SetMonitoringSessiondatEndDate,
							@MonitoringSessionidfsCategoryID,
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


