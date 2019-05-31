
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleParameterForFunction_SET
-- Description: Saves the Rule Paramter For Functions
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleParameterForFunction_SET] 
(	
     @idfsParameter BIGINT
     ,@idfsFormTemplate BIGINT
     ,@idfsRule BIGINT
     ,@intOrder INT 
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success', 
		@idfParameterForFunction BIGINT = 0

	BEGIN TRY
		IF (@idfParameterForFunction < 0)
			EXEC dbo.[usp_sysGetNewID] @idfParameterForFunction OUTPUT
	
		IF NOT EXISTS (SELECT TOP 1 1 
					   FROM dbo.ffParameterForFunction
					   WHERE [idfParameterForFunction] = @idfParameterForFunction)
			BEGIN
		 
				INSERT INTO [dbo].[ffParameterForFunction]
					(
		   				[idfParameterForFunction]
						,[idfsParameter]
						,[idfsFormTemplate]
						,[idfsRule]
						,[intOrder]
					)
				VALUES
					(
			   			@idfParameterForFunction
						,@idfsParameter
						,@idfsFormTemplate
						,@idfsRule
						,@intOrder		   
					)
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffParameterForFunction]
				SET [intOrder] = @intOrder
					,[intRowStatus] = 0
				WHERE [idfParameterForFunction] = @idfParameterForFunction
			END

		SELECT @returnCode as returnCode, @returnMsg as returnMsg, @idfParameterForFunction as idfParameterForFunction 
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END