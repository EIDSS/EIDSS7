
-- ================================================================================================
-- Name: USP_ADMIN_FF_Template_SET
-- Description: Save the template.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Template_SET] 
(
    @idfsFormType BIGINT
    ,@DefaultName NVARCHAR(400)
    ,@NationalName NVARCHAR(600) = NULL    
    ,@strNote NVARCHAR(200) = NULL 
    ,@LangID NVARCHAR(50) = NULL
    ,@blnUNI BIT = NULL
	,@idfsFormTemplate BIGINT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';	

	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
	
		IF (@idfsFormTemplate < 0)
			EXEC dbo.[usp_sysGetNewID] @idfsFormTemplate OUTPUT
		
		IF (@blnUNI IS NULL)
			SET @blnUNI = 0;	
		
		EXEC dbo.USP_GBL_BaseReference_SET @idfsFormTemplate, 19000033 /*'rftFFTemplate'*/,@LangID, @DefaultName, @NationalName, 0
			
		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.ffFormTemplate
					   WHERE [idfsFormTemplate] = @idfsFormTemplate)
			BEGIN
				INSERT INTO [dbo].[ffFormTemplate]
					(
	           			[idfsFormTemplate]
						,[idfsFormType]			   
						,[strNote]
						,[intRowStatus]
						,[blnUNI]
					)
				VALUES
					(
	           			@idfsFormTemplate
						,@idfsFormType
						,@strNote
						,0
						,@blnUNI
					)          
			END
		ELSE 
			BEGIN
				UPDATE [dbo].[ffFormTemplate]
				SET [idfsFormType] = @idfsFormType				  
					,[strNote] = @strNote
					,[blnUNI] = @blnUNI
					,[intRowStatus] = 0
	 			WHERE [idfsFormTemplate] = @idfsFormTemplate
			END
	
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	
		THROW;
	END CATCH;
END
