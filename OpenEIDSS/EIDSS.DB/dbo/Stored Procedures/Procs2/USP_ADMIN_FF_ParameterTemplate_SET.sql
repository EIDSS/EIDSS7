
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTemplate_SET
-- Description: Save the Parameter Template
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTemplate_SET] 
(
	@idfsParameter BIGINT
	,@idfsFormTemplate BIGINT
	,@LangID NVARCHAR(50) = NULL
	,@idfsEditMode BIGINT = NULL
	,@intLeft INT = NULL
	,@intTop INT = NULL
	,@intWidth INT = NULL
	,@intHeight INT = NULL
	,@intScheme INT = NULL
	,@intLabelSize INT = NULL
	,@intOrder INT = NULL
	,@blnFreeze BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
		IF (@idfsEditMode IS NULL)
			SET @idfsEditMode = 10068001;
		IF (@intLeft IS NULL)
			SET @intLeft = 0;
		IF (@intTop IS NULL)
			SET @IntTop = 0;
		IF (@intWidth IS NULL)
			SET @intWidth = 0;
		IF (@intHeight IS NULL)
			SET @intHeight = 0;	
		IF (@intScheme IS NULL)
			SET @intScheme = 0;	
		IF (@blnFreeze IS NULL)
			SET @blnFreeze = 0;
	
		IF (@intLabelSize IS NULL)
			BEGIN 
			IF (@intScheme = 0 OR @intScheme = 1)
				SET @intLabelSize = @intWidth / 2
			ELSE
				SET @intLabelSize = @intWidth;
		END;
		IF (@intOrder IS NULL)
			SET @intOrder = 0;	

		IF NOT EXISTS (SELECT TOP 1 1
					   FROM [dbo].[ffParameterForTemplate]
					   WHERE [idfsParameter] = @idfsParameter
							 AND [idfsFormTemplate] = @idfsFormTemplate)
			BEGIN
				INSERT INTO [dbo].[ffParameterForTemplate]
					(
           				[idfsParameter]
           				,[idfsFormTemplate]			  	   
						,[idfsEditMode]		
						,[blnFreeze]		
					)
				VALUES
					(
           				@idfsParameter
           				,@idfsFormTemplate
						,@idfsEditMode	
						,@blnFreeze			
					)          
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffParameterForTemplate]
				SET [idfsEditMode] = @idfsEditMode
					,[blnFreeze] = @blnFreeze
					,[intRowStatus] = 0
 				WHERE [idfsParameter] = @idfsParameter
					  AND [idfsFormTemplate] = @idfsFormTemplate 						
			END
	
		-----------------------------------
		EXEC dbo.[USP_ADMIN_FF_ParameterDesignOptions_SET] 
			 @idfsParameter
			 ,@idfsFormTemplate
			 ,@intLeft
			 ,@intTop
			 ,@intWidth
			 ,@intHeight			
			 ,@intScheme
			 ,@intLabelSize
			 ,@intOrder
			 ,@LangID
		
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
