--*************************************************************
-- Name 				: USP_OMM_SESSION_Note_Delete
-- Description			: Deletes file objects, or the entire record for the specified note 
--          
-- Author               : Doug Albanese
-- Revision History
--		Name       Date       Change Detail
--
--
-- Testing code:
--*************************************************************
CREATE PROCEDURE [dbo].[USP_OMM_SESSION_Note_Delete]
(  
	@idfOutbreakNote			AS BIGINT,
	@deleteFileObjectOnly		AS BIT = NULL
)  

AS  
	DECLARE	@returnCode					INT = 0;
	DECLARE @returnMsg					NVARCHAR(MAX) = 'SUCCESS';

	BEGIN

		BEGIN TRY  	
			IF @deleteFileObjectOnly = 1
				BEGIN
					UPDATE			tlbOutbreakNote

					SET				UploadFileName = null, 
									UploadFileObject = NULL

					WHERE			idfOutbreakNote = @idfOutbreakNote

				END
			ELSE
				BEGIN

					DELETE 
					FROM			tlbOutbreakNote

					WHERE			idfOutbreakNote = @idfOutbreakNote

				END

			IF @@TRANCOUNT > 0 
				COMMIT;

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
		END CATCH

		SELECT @returnCode as ReturnCode, @returnMsg as ReturnMsg

	END


