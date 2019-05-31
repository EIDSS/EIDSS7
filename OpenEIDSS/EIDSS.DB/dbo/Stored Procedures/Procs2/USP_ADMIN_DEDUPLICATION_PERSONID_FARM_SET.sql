
-- ================================================================================================
-- Name: USP_ADMIN_DEDUPLICATION_PERSONID_FARM_SET
--
-- Description: Update column idfHumanActual in tlbFarmActual.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Ann Xiong    4/16/2019 Initial release for new API.
--
--
-- ================================================================================================

Alter PROCEDURE [dbo].[USP_ADMIN_DEDUPLICATION_PERSONID_FARM_SET]
 	@SurvivorHumanMasterID		BIGINT = NULL,
	@SupersededHumanMasterID	BIGINT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0 
	DECLARE	@ReturnMsg NVARCHAR(max) = 'SUCCESS' 

	BEGIN TRY

		BEGIN TRANSACTION

			UPDATE 	dbo.tlbFarmActual
			SET 	idfHumanActual = @SurvivorHumanMasterID					
			WHERE	idfHumanActual = @SupersededHumanMasterID
			
			IF @@TRANCOUNT > 0 
				COMMIT TRANSACTION;
			
			SELECT @ReturnCode 'ReturnCode', @ReturnMsg 'ReturnMsg'
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER()
		SET @ReturnMsg = 'ErrorNumber: ' + convert(varchar, ERROR_NUMBER() ) 
							+ ' ErrorSeverity: ' + convert(varchar, ERROR_SEVERITY() )
			   				+ ' ErrorState: ' + convert(varchar,ERROR_STATE())
			   				+ ' ErrorProcedure: ' + isnull(ERROR_PROCEDURE() ,'')
			   				+ ' ErrorLine: ' +  convert(varchar,isnull(ERROR_LINE() ,''))
			   				+ ' ErrorMessage: '+ ERROR_MESSAGE()

		SELECT @ReturnCode 'ReturnCode', @ReturnMsg 'ReturnMsg'

	END CATCH
END

