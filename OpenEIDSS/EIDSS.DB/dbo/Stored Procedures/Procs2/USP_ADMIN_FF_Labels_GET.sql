
-- ================================================================================================
-- Name: USP_ADMIN_FF_Labels_GET
-- Description: Retrieves the List of Determinant Types
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Labels_GET]
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
			   ,DEL.idfsBaseReference
			   ,DE.[idfsDecorElementType]
			   ,@LangID AS [langid]
			   ,DE.[idfsFormTemplate]
			   ,DE.[idfsSection]
			   ,DEL.[intLeft]
			   ,DEL.[intTop]
			   ,DEL.[intWidth]
			   ,DEL.[intHeight]
			   ,DEL.[intFontStyle]
			   ,DEL.[intFontSize]
			   ,DEL.[intColor]
			   ,BR.strDefault AS [DefaultText]
			   ,ISNULL(SNT.strTextString, BR.strDefault) AS [NationalText]
		FROM [dbo].[ffDecorElement] DE   
		INNER JOIN [dbo].[ffDecorElementText] DEL
		ON DE.[idfDecorElement] = DEL.[idfDecorElement] 
		   AND DEL.[intRowStatus] = 0
	    INNER JOIN dbo.trtBaseReference BR
		ON DEL.idfsBaseReference = BR.idfsBaseReference
	    LEFT JOIN dbo.trtStringNameTranslation SNT
		ON DEL.idfsBaseReference = SNT.idfsBaseReference
		   AND SNT.idfsLanguage = @langid_int
	    WHERE (DE.[idfsFormTemplate] = @idfsFormTemplate
			   OR @idfsFormTemplate IS NULL)
			  AND (DE.[idfsLanguage] = dbo.FN_ADMIN_FF_DesignLanguageForLabel_GET(@LangID, DE.[idfDecorElement])
				   OR @langid_int IS NULL)
			  AND DE.[intRowStatus] = 0

		--COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		--IF @@TRANCOUNT > 0 
		--	ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

