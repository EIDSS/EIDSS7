--*************************************************************
-- Name 				: [USP_VCT_ASCAMPAIGNTOSAMPLETYPE_DEL]
-- Description			: Delete Samples related with specific AS campaign.    
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
CREATE PROCEDURE [dbo].[USP_VCT_ASCAMPAIGNTOSAMPLETYPE_DEL]
(    
    @CampaignToSampleTypeUID	BIGINT,    
	@returnCode					INT = 0 OUTPUT,
	@returnMsg					NVARCHAR(MAX) = 'SUCCESS' OUTPUT
)    
AS    
BEGIN    
	BEGIN TRY
		BEGIN TRANSACTION
			BEGIN    
				DELETE dbo.CampaignToSampleType    
				WHERE  CampaignToSampleTypeUID = @CampaignToSampleTypeUID
			END    
    
			IF @@TRANCOUNT > 0 
				COMMIT

			SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY

	BEGIN CATCH
			IF @@Trancount > 0 
				ROLLBACK;
		Throw;

	END CATCH

END


