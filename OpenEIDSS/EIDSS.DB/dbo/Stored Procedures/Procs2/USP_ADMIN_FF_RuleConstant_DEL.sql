
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleConstant_DEL
-- Description: Deletes the Rule Constant
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleConstant_DEL] 
(
	@idfRuleConstant BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'       
	
	BEGIN TRY
		DELETE FROM dbo.ffRuleConstant	
			   WHERE [idfRuleConstant] = @idfRuleConstant

		SELECT @returnCode, @returnMsg

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
