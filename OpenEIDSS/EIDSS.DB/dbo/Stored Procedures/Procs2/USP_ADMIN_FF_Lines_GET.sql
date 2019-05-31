
-- ================================================================================================
-- Name: USP_ADMIN_FF_Lines_GET
-- Description:	Retrieves the Lines for UI FF fields
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Lines_GET]
(
	@LangID NVARCHAR(50) = NULL
	,@idfsFormTemplate BIGINT = NULL	 	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	IF (@LangID IS NULL)
		SET @LangID = 'en';

	DECLARE
		@langid_int BIGINT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY

		SET @langid_int = dbo.FN_GBL_LanguageCode_GET(@LangID);

		SELECT DE.[idfDecorElement]
			   ,DE.[idfsDecorElementType]
			   ,@LangID AS [langid]
			   ,DE.[idfsFormTemplate]
			   ,DE.[idfsSection]
			   ,DEL.[intLeft]
			   ,DEL.[intTop]
			   ,DEL.[intWidth]
			   ,DEL.[intHeight]		
			   ,DEL.[intColor]
			   ,DEL.[blnOrientation]
		FROM [dbo].[ffDecorElement] DE   
		INNER JOIN [dbo].[ffDecorElementLine] DEL
		ON DE.[idfDecorElement] = DEL.[idfDecorElement]
		   AND DEL.[intRowStatus] = 0
		WHERE (DE.[idfsFormTemplate] = @idfsFormTemplate OR @idfsFormTemplate IS NULL)
			  AND (DE.[idfsLanguage] = @langid_int OR @langid_int IS NULL)
			  AND DE.[intRowStatus] = 0

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END


