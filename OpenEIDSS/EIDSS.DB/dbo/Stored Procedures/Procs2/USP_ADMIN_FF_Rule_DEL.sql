
-- ================================================================================================
-- Name: USP_ADMIN_FF_Rule_DEL
-- Description: Deletes a Rule. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Rule_DEL] 
(
	@idfsRule BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;		
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'       
	
	BEGIN TRY
		DELETE FROM dbo.ffRuleConstant
			   WHERE [idfsRule] = @idfsRule
		DELETE FROM dbo.ffParameterForAction
			   WHERE [idfsRule] = @idfsRule
		DELETE FROM dbo.ffParameterForFunction
			   WHERE [idfsRule] = @idfsRule
		DELETE FROM dbo.ffRule 
			   WHERE [idfsRule] = @idfsRule

		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
