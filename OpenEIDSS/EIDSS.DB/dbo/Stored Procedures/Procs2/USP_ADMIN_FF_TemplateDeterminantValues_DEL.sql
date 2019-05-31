
-- ================================================================================================
-- Name: USP_ADMIN_FF_TemplateDeterminantValues_DEL
-- Description: Delete the Template Determinant Values 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_TemplateDeterminantValues_DEL] 
(
	@idfDeterminantValue BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'       
	
	BEGIN TRY
		DELETE FROM dbo.[ffDeterminantValue]
			   WHERE [idfDeterminantValue] = @idfDeterminantValue
	
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH; 	
END
