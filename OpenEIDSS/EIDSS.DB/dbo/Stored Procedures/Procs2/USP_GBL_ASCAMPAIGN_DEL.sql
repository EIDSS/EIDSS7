
--*************************************************************
-- Name 				: USP_GBL_ASCAMPAIGN_DEL
-- Description			: Deletes data for Active Surveillance Campaign 
--          
-- Author               : Mandar Kulkarni
-- Revision History
--		Name        Date        Change Detail
--		m.jessee	20180426	revised to GBL usage
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_GBL_ASCAMPAIGN_DEL]
(  
	@idfCampaign			AS	BIGINT--##PARAM @idfCampaign - campaign ID  
)  
AS  
DECLARE @returnMsg VARCHAR(MAX) = 'Success'
DECLARE @returnCode BIGINT = 0

BEGIN

	BEGIN TRY  	
		-- Delete Child records for Species and Sample Types
		UPDATE	dbo.CampaignToSampleType
		SET		intRowStatus = 1	
		WHERE	idfCampaign = @idfCampaign
		
		UPDATE	dbo.tlbCampaign
		SET		intRowStatus = 1	
		WHERE	idfCampaign = @idfCampaign

		IF @@TRANCOUNT > 0 
			COMMIT;

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


