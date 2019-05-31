





--*************************************************************
-- Name 				: USP_GBL_ASSESSION_SET
-- Description			: Insert/Update for Campaign Monitoring Session
--          
-- Author: M.Jessee
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Michael Jessee	05/04/2018 Initial release.
-- ============================================================================

  
CREATE PROCEDURE [dbo].[USP_GBL_ASSESSION_SET]
(    
	@idfMonitoringSession			BIGINT ,
	@idfsMonitoringSessionStatus	BIGINT, 
	@idfsCountry					BIGINT,
	@idfsRegion						BIGINT,
	@idfsRayon						BIGINT,
	@idfsSettlement					BIGINT,
	@idfPersonEnteredBy				BIGINT,
	@idfCampaign					BIGINT,
	@idfsDiagnosis					BIGINT,
	@datEnteredDate					DATETIME,
	@strMonitoringSessionID			NVARCHAR(50) ,		--   = '(new)'
	@datStartDate					DATETIME,
	@datEndDate						DATETIME,
	@SessionCategoryID				BIGINT, -- 10169001 Human Active Surveillance Session, 10169002 Veterinary Active Surveillance Session
	@idfsSite						BIGINT
)     
AS    
DECLARE	@returnCode INT = 0
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS'


BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM dbo.tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession)
				BEGIN    
					 UPDATE dbo.tlbMonitoringSession   
					 SET    idfsMonitoringSessionStatus = @idfsMonitoringSessionStatus,
							idfsCountry = @idfsCountry,
							idfsRegion = @idfsRegion,
							idfsRayon = @idfsRayon,
							idfsSettlement = @idfsSettlement,
							idfPersonEnteredBy = @idfPersonEnteredBy,
							idfCampaign = @idfCampaign,
							idfsDiagnosis = @idfsDiagnosis,
							datEnteredDate = @datEnteredDate,
							datStartDate = @datStartDate,
							datEndDate = @datEndDate,
							SessionCategoryID = @SessionCategoryID,
							idfsSite = @idfsSite
					 WHERE  idfMonitoringSession = @idfMonitoringSession
				END    
			ELSE
				BEGIN    
					IF (ISNULL(@idfMonitoringSession,0)<=0)	
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSession', @idfMonitoringSession OUTPUT    

					IF LEFT(ISNULL(@strMonitoringSessionID, '(new'),4) = '(new'
						BEGIN
							EXEC dbo.USP_GBL_NextNumber_GET 'Active Surveillance Session', @strMonitoringSessionID OUTPUT , NULL
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
							intRowStatus,
							idfsSite
						)    
					VALUES    
						(    
							@idfMonitoringSession,
							@idfsMonitoringSessionStatus,
							@idfsCountry,
							@idfsRegion,
							@idfsRayon,
							@idfsSettlement,
							@idfPersonEnteredBy,
							@idfCampaign,
							@idfsDiagnosis,
							@datEnteredDate,
							@strMonitoringSessionID,
							@datStartDate,
							@datEndDate,
							@SessionCategoryID,
							0,
							@idfsSite
						)    
				END    
    
		IF @@TRANCOUNT > 0 
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfMonitoringSession 'idfMonitoringSession'
	END TRY

	BEGIN CATCH
		Throw;

	END CATCH

END


