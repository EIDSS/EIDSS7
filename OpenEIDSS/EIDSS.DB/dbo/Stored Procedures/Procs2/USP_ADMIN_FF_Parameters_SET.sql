
-- ================================================================================================
-- Name: USP_ADMIN_FF_Parameters_SET
-- Description: Save the Parameters
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Parameters_SET] 
(
	@idfsSection BIGINT   
    ,@idfsFormType BIGINT   
    ,@intScheme INT
    ,@idfsParameterType BIGINT
	,@idfsEditor BIGINT
	,@intHACode INT	
	,@intOrder INT = 0
	,@strNote NVARCHAR(1000)
    ,@DefaultName NVARCHAR(400)
    ,@NationalName NVARCHAR(600) = NULL
    ,@DefaultLongName NVARCHAR(400) = NULL
    ,@NationalLongName NVARCHAR(600) = NULL
    ,@LangID NVARCHAR(50) = NULL   
    ,@intLeft INT  
    ,@intTop INT
    ,@intWidth INT
	,@intHeight INT
	,@intLabelSize INT
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success', 
	    @idfsParameter BIGINT = 0,
	    @idfsParameterCaption BIGINT  = 0

	BEGIN TRY
		IF (@idfsParameter IS NULL)
			SET @idfsParameter = 0;
		IF (@idfsParameterCaption IS NULL)
			SET @idfsParameterCaption = 0;
		IF (@idfsParameter <= 0)
			EXEC dbo.[spsysGetNewID] @idfsParameter OUTPUT
		IF (@idfsParameterCaption <= 0)
			EXEC dbo.[spsysGetNewID] @idfsParameterCaption OUTPUT
	
		EXEC dbo.USP_GBL_BaseReference_SET @idfsParameter, 19000066/*'rftParameter'*/,@LangID, @DefaultLongName, @NationalLongName, 0
		EXEC dbo.USP_GBL_BaseReference_SET @idfsParameterCaption, 19000070 /*'rftParameterToolTip'*/,@LangID, @DefaultName, @NationalName, 0
		
		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.ffParameter
					   WHERE idfsParameter = @idfsParameter)
			BEGIN
				INSERT INTO [dbo].[ffParameter]
					(
			   			[idfsParameter]
						,[idfsSection]
						,[idfsFormType]						
						,[idfsParameterType]
						,[idfsEditor]
						,[idfsParameterCaption]
						,[intHACode]
						,[strNote]
						,[intOrder]					
					)
				VALUES
					(
						@idfsParameter
						,@idfsSection
						,@idfsFormType						
						,@idfsParameterType
						,@idfsEditor
						,@idfsParameterCaption
						,@intHACode
						,@strNote
						,@intOrder
					)
			END 
		ELSE 
			BEGIN
				UPDATE [dbo].[ffParameter]
				SET [idfsSection] = @idfsSection
					,[idfsFormType] = @idfsFormType
					,[idfsParameterType] = @idfsParameterType
					,[idfsEditor] = @idfsEditor
					,[idfsParameterCaption] = @idfsParameterCaption
					,[intHACode] = @intHACode
					,[strNote] = @strNote
					,[intOrder] = @intOrder
					,[intRowStatus] = 0
				WHERE [idfsParameter] = @idfsParameter
			END
	
		EXEC dbo.[spFFSaveParameterDesignOptions] 
			 @idfsParameter
			 ,NULL
			 ,@intLeft
			 ,@intTop
			 ,@intWidth
			 ,@intHeight			
			 ,@intScheme
			 ,@intLabelSize
			 ,@intOrder
			 ,@LangID		

		SELECT @returnCode as returnCode, @returnMsg as returnMsg, @idfsParameter as idfsParameter, @idfsParameterCaption as idfsParameterCaption 
		
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END