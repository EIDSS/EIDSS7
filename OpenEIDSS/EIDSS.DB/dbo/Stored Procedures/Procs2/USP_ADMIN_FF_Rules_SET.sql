
-- ================================================================================================
-- Name: USP_ADMIN_FF_Rules_SET
-- Description: Save the Rules
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Rules_SET] 
(	
	@idfsFormTemplate BIGINT
	,@idfsCheckPoint BIGINT
    ,@idfsRuleFunction BIGINT = NULL
    ,@DefaultName VARCHAR(200)
    ,@NationalName NVARCHAR(300)
    ,@MessageText VARCHAR(200)
    ,@MessageNationalText VARCHAR(300)   
    ,@blnNot BIT
    ,@LangID NVARCHAR(50) = NULL
	,@idfsRule BIGINT OUTPUT	
	,@idfsRuleMessage BIGINT OUTPUT    
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
		IF (@idfsRuleFunction IS NULL)
			RETURN;
	
		IF (@LangID IS NULL)
			SET @LangID = 'en';
	
		IF (@idfsRule < 0) 
			EXEC dbo.[usp_sysGetNewID] @idfsRule OUTPUT
	
		IF (@idfsRuleMessage < 0) 
			EXEC dbo.[usp_sysGetNewID] @idfsRuleMessage OUTPUT	
	
		EXEC dbo.USP_GBL_BaseReference_SET @idfsRule,19000029 /*'rftFFRule'*/,@LangID, @DefaultName, @NationalName, 0

		EXEC dbo.USP_GBL_BaseReference_SET @idfsRuleMessage, 19000032 /*'rftFFRuleMessage'*/,@LangID, @MessageText, @MessageNationalText, 0
			
		IF NOT EXISTS (SELECT TOP 1 1 
					   FROM dbo.ffRule 
					   WHERE [idfsRule] = @idfsRule)
			BEGIN
				INSERT INTO [dbo].[ffRule]
					(
			   			[idfsRule]
						,[idfsRuleMessage]
						,[idfsFormTemplate]
						,[idfsCheckPoint]
						,[idfsRuleFunction]
						,[intRowStatus]
						,[blnNot]					
					)
				VALUES
					(
			   			@idfsRule
						,@idfsRuleMessage
						,@idfsFormTemplate
						,@idfsCheckPoint	
						,@idfsRuleFunction
						,0
						,@blnNot
					)
			END
		ELSE
			BEGIN
	         	UPDATE [dbo].[ffRule]
				SET [idfsRuleMessage] = @idfsRuleMessage			
					,[idfsFormTemplate] = @idfsFormTemplate 				
					,[idfsCheckPoint] = @idfsCheckPoint
					,[idfsRuleFunction] = @idfsRuleFunction
					,[blnNot] = @blnNot
					,[intRowStatus] = 0
				WHERE [idfsRule] = @idfsRule
			END
   
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
