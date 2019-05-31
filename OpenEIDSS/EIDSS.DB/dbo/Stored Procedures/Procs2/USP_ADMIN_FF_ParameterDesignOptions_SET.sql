
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterDesignOptions_SET
-- Description:	Save the ParameterDesignOptions
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterDesignOptions_SET] 
(	
	@idfsParameter BIGINT
	,@idfsFormTemplate BIGINT
	,@intLeft INT
	,@intTop INT
    ,@intWidth INT
    ,@intHeight INT    
    ,@intScheme INT
    ,@intLabelSize INT
    ,@intOrder INT
    ,@LangID NVARCHAR(50)   
)	
AS
BEGIN	
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';
	Declare
		@langid_int BIGINT,
		@LangID_intEN BIGINT,
		@idfParameterDesignOption BIGINT,
		@idfParameterDesignOptionEN BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
		SET @LangID_intEN = dbo.FN_GBL_LanguageCode_GET('en'); 
	
		IF (@idfsFormTemplate IS NULL)
			BEGIN
				SELECT @idfParameterDesignOption = [idfParameterDesignOption]
				FROM dbo.ffParameterDesignOption
				WHERE [idfsParameter] = @idfsParameter
					  AND idfsFormTemplate IS NULL
					  AND [idfsLanguage] = @langid_int
					  AND [intRowStatus] = 0
			END
		ELSE
			BEGIN	         	
				SELECT @idfParameterDesignOption = [idfParameterDesignOption]
				FROM dbo.ffParameterDesignOption
				WHERE [idfsParameter] = @idfsParameter
					  AND [idfsFormTemplate] = @idfsFormTemplate
					  AND [idfsLanguage] = @langid_int
					  AND [intRowStatus] = 0    	
			END
		 
		If (@idfParameterDesignOption IS NULL)
			BEGIN
				EXEC dbo.[usp_sysGetNewID] @idfParameterDesignOption OUTPUT
				INSERT [dbo].[ffParameterDesignOption]
					(
				   		[idfParameterDesignOption]
					    ,[intLeft]
					    ,[intTop]
					    ,[intWidth]
					    ,[intHeight]					   
					    ,[intScheme]
					    ,[intLabelSize]					 
					    ,[idfsParameter]
					    ,[idfsLanguage]
					    ,[idfsFormTemplate]
					    ,[intOrder]
				   )
				VALUES
				   (
				   		@idfParameterDesignOption
						,@intLeft
						,@intTop
					    ,@intWidth
					    ,@intHeight					   
					    ,@intScheme
					    ,@intLabelSize					  
					    ,@idfsParameter
					    ,@langid_int
					    ,@idfsFormTemplate
					    ,@intOrder
				   )
	
				IF (@LangID <> 'en')
					BEGIN
				
						IF (@idfsFormTemplate IS NULL)
							BEGIN
								SELECT @idfParameterDesignOptionEN = [idfParameterDesignOption]
								FROM dbo.ffParameterDesignOption
								WHERE [idfsParameter] = @idfsParameter
									  AND idfsFormTemplate IS NULL
									  AND [idfsLanguage] = @LangID_intEN 
									  AND intRowStatus = 0
							END
						ELSE
							BEGIN	         	
								SELECT @idfParameterDesignOptionEN = [idfParameterDesignOption]
								FROM dbo.ffParameterDesignOption
								WHERE [idfsParameter] = @idfsParameter
									  AND [idfsFormTemplate] = @idfsFormTemplate
									  AND [idfsLanguage] = @LangID_intEN 
									  AND intRowStatus = 0  	
							END
							
				
						IF (@idfParameterDesignOptionEN IS NULL)
							BEGIN
								EXEC dbo.[usp_sysGetNewID] @idfParameterDesignOptionEN OUTPUT
								Insert [dbo].[ffParameterDesignOption]
									(
				   						[idfParameterDesignOption]
										,[intLeft]
										,[intTop]
										,[intWidth]
										,[intHeight]					  
										,[intScheme]
										,[intLabelSize]						 
										,[idfsParameter]
										,[idfsLanguage]
										,[idfsFormTemplate]
										,[intOrder]
									)
								VALUES
									(
				   						@idfParameterDesignOptionEN
										,@intLeft
										,@intTop
										,@intWidth
										,@intHeight					   
										,@intScheme
										,@intLabelSize					 
										,@idfsParameter
										,@LangID_intEN
										,@idfsFormTemplate
										,@intOrder
									)			                     	
							END
					END
			END
		ELSE
			BEGIN
	         	UPDATE [dbo].[ffParameterDesignOption]
				SET [intLeft] = @intLeft				
					,[intTop] = @intTop
					,[intWidth] = @intWidth
					,[intHeight] = @intHeight						  
					,[intScheme] = @intScheme
					,[intLabelSize] = @intLabelSize
					,[intOrder] = @intOrder
					,[intRowStatus] = 0							
				WHERE [idfParameterDesignOption] = @idfParameterDesignOption
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

