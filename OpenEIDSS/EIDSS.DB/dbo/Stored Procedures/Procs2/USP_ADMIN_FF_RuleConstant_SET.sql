
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleConstant_SET
-- Description: Save the Rule Constant
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleConstant_SET] 
(	
	@idfsRule BIGINT	
	,@varConstant SQL_VARIANT
)	
AS
BEGIN	
	SET NOCOUNT ON;		
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success',
		@idfRuleConstant BIGINT = 0

	BEGIN TRY

		IF (@idfRuleConstant < 0)
			EXEC dbo.[usp_sysGetNewID] @idfRuleConstant OUTPUT

		IF NOT EXISTS (SELECT TOP 1 1 
					   FROM dbo.ffRuleConstant
					   WHERE [idfRuleConstant] = @idfRuleConstant)
			BEGIN
				INSERT INTO [dbo].[ffRuleConstant]
					(
			   			[idfRuleConstant]
		   				,[idfsRule]					
						,[varConstant]
					)
				VALUES
				   (
			   			@idfRuleConstant
			   			,@idfsRule					
						,@varConstant		   
				   )
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffRuleConstant]
				SET [varConstant] = @varConstant
					,[intRowStatus] = 0
				WHERE [idfRuleConstant] = @idfRuleConstant
		END

		SELECT @returnCode as returnCode, @returnMsg as returnMsg, @idfRuleConstant as idfRuleConstant 
   
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
