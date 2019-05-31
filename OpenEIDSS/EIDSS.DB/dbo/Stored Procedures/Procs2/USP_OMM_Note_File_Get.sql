
--*************************************************************
-- Name: [USP_OMM_Session_Note_GetDetail]
-- Description: Insert/Update for Outbreak Session Note
--          
-- Author: Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--    
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_Note_File_Get]
(    
	@idfOutbreakNote	BIGINT
)
AS

BEGIN    

	DECLARE	@returnCode								INT = 0;
	DECLARE @returnMsg								NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		
		SELECT
			UploadFileName,
			UploadFileObject
		FROM		
			tlbOutbreakNote 
		where 
			idfOutbreakNote =	@idfOutbreakNote

	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;
		
		SET		@returnCode = ERROR_NUMBER();
		SET		@returnMsg = 
					'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
					+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
					+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
					+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
					+ ' ErrorLine: ' +  CONVERT(VARCHAR, ISNULL(ERROR_LINE(), ''))
					+ ' ErrorMessage: '+ ERROR_MESSAGE();

		
	END CATCH

	SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg
END