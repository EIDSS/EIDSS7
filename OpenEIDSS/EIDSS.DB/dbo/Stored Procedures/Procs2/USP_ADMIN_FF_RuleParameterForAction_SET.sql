
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleParameterForAction_SET
-- Description: Save theRule Parameter for Action
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleParameterForAction_SET] 
(		
	@idfsRule BIGINT
    ,@idfsFormTemplate BIGINT
	,@idfsParameter BIGINT
    ,@idfsRuleAction BIGINT
)	
AS
BEGIN	
	SET NOCOUNT ON;	

	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success', 
		@idfParameterForAction BIGINT = 0

	BEGIN TRY

		IF (@idfParameterForAction < 0)
			EXEC dbo.[usp_sysGetNewID] @idfParameterForAction OUTPUT
	
		IF NOT EXISTS (SELECT TOP 1 1 
					   FROM dbo.ffParameterForAction
					   WHERE [idfParameterForAction] = @idfParameterForAction)
			BEGIN
		 
				INSERT INTO [dbo].[ffParameterForAction]
					(
		   				[idfParameterForAction]
						,[idfsRule]
						,[idfsFormTemplate]
						,[idfsParameter]
						,[idfsRuleAction]
					)
				VALUES
					(
			   			@idfParameterForAction
						,@idfsRule
						,@idfsFormTemplate
						,@idfsParameter
						,@idfsRuleAction
					)
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffParameterForAction]
				SET [idfsRuleAction] = @idfsRuleAction
					,[intRowStatus] = 0
				WHERE [idfParameterForAction] = @idfParameterForAction
			END

		SELECT @returnCode as returnCode, @returnMsg as returnMsg, @idfParameterForAction as idfParameterForAction
   		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
