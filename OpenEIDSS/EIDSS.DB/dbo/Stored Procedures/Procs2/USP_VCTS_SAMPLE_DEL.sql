

--*************************************************************
-- Name 				: USP_VCTS_SAMPLE_DEL
-- Description			: 
--          
-- Author               : Harold Pryor
-- Revision History
--		Name       Date       Change Detail
--  Harold Pryor  5/21/2018  Initial Creation
--
-- Testing code:
--*************************************************************

 
CREATE PROCEDURE [dbo].[USP_VCTS_SAMPLE_DEL]
(	 
	@idfMaterial		   BIGINT
)
AS

DECLARE @returnCode INT = 0;
DECLARE @returnMsg  NVARCHAR(max) = 'SUCCESS'

BEGIN
	BEGIN TRY
		BEGIN TRANSACTION			
			
			BEGIN
				EXEC dbo.USSP_GBL_MATERIAL_DEL  @idfMaterial
		   END
  				
			IF @@TRANCOUNT > 0 
			COMMIT;

		  SELECT @returnCode, @returnMsg
	END TRY

	BEGIN CATCH
		BEGIN 
			IF @@TRANCOUNT  > 0 
				ROLLBACK

			SET @returnCode = ERROR_NUMBER()
			SET @returnMsg = 
				'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER() ) 
				+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY() )
				+ ' ErrorState: ' + CONVERT(VARCHAR,ERROR_STATE())
				+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE() ,'')
				+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE() ,''))
				+ ' ErrorMessage: '+ ERROR_MESSAGE()

			SELECT @returnCode, @returnMsg
		END

	END CATCH
END -- Stored Proc END


