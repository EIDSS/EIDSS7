--*************************************************************
-- Name 				: [USP_VCT_ASCAMPAIGNTOSAMPLETYPE_SET]
-- Description			: Posts list of Samples related with specific AS campaign.    
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name       Date       Change Detail
--
-- Testing code:
--Example of procedure call:    
    
--DECLARE @Action int    
--DECLARE @idfCampaign BIGINT    
--DECLARE @idfsDiagnosis BIGINT    
--DECLARE @intOrder int    
    
---- TODO: Set parameter values here.    
--*/    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNTOSAMPLETYPE_SET]
(    
    @CampaignToSampleTypeUID	BIGINT = NULL,    
    @idfCampaign				BIGINT,    
    @intOrder					INT,  
    @idfsSpeciesType			BIGINT,  
    @intPlannedNumber			INT,    
    @idfsSampleType				BIGINT,
	@returnCode					INT = 0,
	@returnMsg					NVARCHAR(MAX) = 'SUCCESS'
)    
AS    
BEGIN    
	Declare @SupressSelect table
	( 
		returnCode int,
		returnMessage varchar(200)
	)
	BEGIN TRY
		BEGIN TRANSACTION
			IF EXISTS (SELECT * FROM dbo.CampaignToSampleType WHERE CampaignToSampleTypeUID = @CampaignToSampleTypeUID)
				BEGIN    
					 UPDATE dbo.CampaignToSampleType   
					 SET    intOrder = @intOrder,    
							idfCampaign = @idfCampaign,    
							idfsSpeciesType = @idfsSpeciesType, 
							intPlannedNumber = @intPlannedNumber,  
							idfsSampleType = @idfsSampleType
					 WHERE  CampaignToSampleTypeUID = @CampaignToSampleTypeUID
				END    
			ELSE
				BEGIN    
					IF (ISNULL(@CampaignToSampleTypeUID,0)<=0)
						INSERT INTO @SupressSelect	
						EXEC dbo.USP_GBL_NEXTKEYID_GET 'CampaignToSampleType', @CampaignToSampleTypeUID OUTPUT    

					INSERT INTO dbo.CampaignToSampleType    
						(    
							CampaignToSampleTypeUID,    
							idfCampaign,   
							intOrder,   
							idfsSpeciesType,  
							intPlannedNumber, 
							idfsSampleType,
							intRowStatus  
						)    
					VALUES    
						(    
							@CampaignToSampleTypeUID,    
							@idfCampaign,    
							@intOrder,    
							@idfsSpeciesType,  
							@intPlannedNumber,   
							@idfsSampleType,
							0
						)    
				END    
    
		IF @@TRANCOUNT > 0 AND @returnCode =0
			COMMIT

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' ,@CampaignToSampleTypeUID 'CampaignToSampleTypeUID'
	END TRY

	BEGIN CATCH
			IF @@Trancount = 1 
				ROLLBACK;
		THROW;

	END CATCH

END


