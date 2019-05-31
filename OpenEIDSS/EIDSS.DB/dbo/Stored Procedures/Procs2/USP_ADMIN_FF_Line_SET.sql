
-- ================================================================================================
-- Name: USP_ADMIN_FF_Line_SET
-- Description: Save the line.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Line_SET] 
(
   @idfsDecorElementType BIGINT 
   ,@LangID NVARCHAR(50) = NULL
   ,@idfsFormTemplate BIGINT
   ,@idfsSection BIGINT
   ,@intLeft INT
   ,@intTop INT
   ,@intWidth INT
   ,@intHeight INT
   ,@intColor INT
   ,@blnOrientation BIT = NULL
   ,@idfDecorElement BIGINT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';
	
	DECLARE 
		@langid_int BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
	
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		IF (@idfDecorElement < 0)
			EXEC dbo.[usp_sysGetNewID] @idfDecorElement OUTPUT

		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.ffDecorElement
					   WHERE [idfDecorElement] = @idfDecorElement)
			BEGIN
				INSERT INTO [dbo].[ffDecorElement]
					(
           				[idfDecorElement]
						,[idfsDecorElementType]
						,[idfsLanguage]
						,[idfsFormTemplate]
						,[idfsSection]
					)
				VALUES
					(
           				@idfDecorElement
						,@idfsDecorElementType 
						,@langid_int
						,@idfsFormTemplate
						,@idfsSection
					)   
				       
				INSERT INTO [dbo].[ffDecorElementLine]
					(
           				[idfDecorElement]
           				,[intLeft]
						,[intTop]
						,[intWidth]
						,[intHeight]			
						,[intColor]
						,[blnOrientation]	
					)
			   VALUES
					(
           				@idfDecorElement
           				,@intLeft
						,@intTop
						,@intWidth
						,@intHeight			 
						,@intColor
						,@blnOrientation
					)          
           
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffDecorElement]
				SET [idfsDecorElementType] = @idfsDecorElementType
					,[idfsLanguage] = @langid_int
					,[idfsFormTemplate] = @idfsFormTemplate
					,[idfsSection] = @idfsSection
					,[intRowStatus] = 0
				WHERE [idfDecorElement] = @idfDecorElement
				
				UPDATE [dbo].[ffDecorElementLine]
				SET [intLeft] = @intLeft
					,[intTop] = @intTop
					,[intWidth] = @intWidth
					,[intHeight] = @intHeight			
					,[intColor] = @intColor
					,[blnOrientation]	 = @blnOrientation
					,[intRowStatus] = 0
				WHERE [idfDecorElement] = @idfDecorElement            
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
