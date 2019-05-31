
-- ================================================================================================
-- Name: USP_ADMIN_FF_Label_SET
-- Description: Save the label
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Label_SET] 
(
	@LangID NVARCHAR(50) = NULL
   ,@idfsFormTemplate BIGINT
   ,@idfsSection BIGINT
   ,@intLeft INT
   ,@intTop INT
   ,@intWidth INT
   ,@intHeight INT
   ,@intFontStyle INT
   ,@intFontSize INT	
   ,@intColor INT
   ,@DefaultText VARCHAR(200)
   ,@NationalText NVARCHAR(400)

)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';
Declare @SupressSelect table
	( retrunCode int,
		returnMessage varchar(200)
	)
	DECLARE
		@langid_int BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' ,
		@idfDecorElement BIGINT,
		@idfsBaseReference BIGINT 

	BEGIN TRY
		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);

		IF (@idfDecorElement < 0)
			BEGIN
			    INSERT INTO @SupressSelect
				EXEC dbo.[usp_sysGetNewID] @idfDecorElement OUTPUT
				INSERT INTO @SupressSelect
				EXEC dbo.[usp_sysGetNewID] @idfsBaseReference OUTPUT
			END --Else Begin
				--Select @idfsBaseReference = [idfsBaseReference] From dbo.[ffDecorElementText] Where idfDecorElement = @idfDecorElement
		--End
	
		EXEC dbo.USP_GBL_BaseReference_SET @idfsBaseReference, 19000131, @LangID, @DefaultText, @NationalText, 0
	
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
					   ,10106001
					   ,@langid_int
					   ,@idfsFormTemplate
					   ,@idfsSection
					)
           
			   INSERT INTO [dbo].[ffDecorElementText]
				   (
           				[idfDecorElement]
           				,[idfsBaseReference]
						,[intFontSize]
						,[intFontStyle]
						,[intColor]
						,[intLeft]
						,[intTop]
						,[intWidth]
						,[intHeight]
					)
			   VALUES
					(
           				@idfDecorElement
           				,@idfsBaseReference
           				,@intFontSize
						,@intFontStyle
						,@intColor
           				,@intLeft
						,@intTop
						,@intWidth
						,@intHeight
					)              
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffDecorElementText]
				SET [intFontSize] = @intFontSize
					,[intFontStyle] = @intFontStyle
					,[intColor] = @intColor
					,[intLeft] = @intLeft
					,[intTop] = @intTop
					,[intWidth] = @intWidth
					,[intHeight] = @intHeight
					,[intRowStatus] = 0
				WHERE [idfDecorElement] = @idfDecorElement            
			END
		
		SELECT @returnCode 'ReturnCode' , @returnMsg 'ReturnMessage',@idfDecorElement 'idfDecorElement', @idfsBaseReference 'idfsBaseReference'
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
