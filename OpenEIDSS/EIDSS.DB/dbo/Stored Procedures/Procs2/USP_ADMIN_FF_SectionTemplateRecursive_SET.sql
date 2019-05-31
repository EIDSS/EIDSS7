
-- ================================================================================================
-- Name: USP_ADMIN_FF_SectionTemplateRecursive_SET
-- Description: Save the section template recursive.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_SectionTemplateRecursive_SET] 
(
	@idfsSection BIGINT
	,@idfsFormTemplate BIGINT
	,@blnFreeze BIT = NULL
	,@LangID NVARCHAR(50) = NULL
	,@intLeft INT = NULL
	,@intTop INT = NULL
	,@intWidth INT = NULL
	,@intHeight INT = NULL
	,@intOrder INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	IF (@LangID IS NULL)
		SET @LangID = 'en';
	
	DECLARE 
		@langid_int BIGINT,
		@idfsParentSection BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'  
	
	BEGIN TRY

		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);
	
		EXEC dbo.USP_ADMIN_FF_SectionTemplate_SET @idfsSection,@idfsFormTemplate,@blnFreeze,@LangID,@intLeft,@intTop,@intWidth,@intHeight,@intOrder
							
		SELECT @idfsParentSection = [idfsParentSection]
		FROM dbo.ffSection
		WHERE idfsSection =@idfsSection	
	
		IF (@idfsParentSection IS NOT NULL)
			BEGIN
				EXEC dbo.USP_ADMIN_FF_SectionTemplateRecursive_SET @idfsParentSection, @idfsFormTemplate, @blnFreeze, @LangID, @intLeft, @intTop, @intWidth, @intHeight, @intOrder    
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
