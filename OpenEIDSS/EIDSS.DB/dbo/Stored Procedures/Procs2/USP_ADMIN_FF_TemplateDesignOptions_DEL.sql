
-- ================================================================================================
-- Name: USP_ADMIN_FF_TemplateDesignOptions_DEL
-- Description: Delete the Template Design Options
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_TemplateDesignOptions_DEL] 
(
	@idfsFormTemplate BIGINT
    ,@LangID BIGINT = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE 
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	BEGIN TRY

		DELETE FROM dbo.ffDecorElementText
			   FROM dbo.ffDecorElementText DET
			   INNER JOIN dbo.ffDecorElement FDE
			   ON DET.idfDecorElement = FDE.idfDecorElement
			   WHERE FDE.idfsFormTemplate = @idfsFormTemplate
					 AND (FDE.idfsLanguage = @LangID
						  OR @LangID IS NULL)
		---
		DELETE FROM dbo.ffDecorElementLine
			   FROM dbo.ffDecorElementLine DEL
			   INNER JOIN dbo.ffDecorElement FDE
			   ON DEL.idfDecorElement = FDE.idfDecorElement
			   WHERE FDE.idfsFormTemplate = @idfsFormTemplate
					 AND (FDE.idfsLanguage = @LangID
						  OR @LangID IS NULL)
		---
		DELETE FROM dbo.ffDecorElement
			   WHERE idfsFormTemplate = @idfsFormTemplate
					 AND (idfsLanguage = @LangID
						  OR @LangID IS NULL)	
		---
		DELETE FROM dbo.ffSectionDesignOption
			   WHERE idfsFormTemplate = @idfsFormTemplate
					 AND (idfsLanguage = @LangID
					      OR @LangID IS NULL)
		---
		DELETE FROM dbo.ffParameterDesignOption
			   WHERE idfsFormTemplate = @idfsFormTemplate
					 AND (idfsLanguage = @LangID
						  OR @LangID IS NULL)
		---
		DELETE FROM dbo.trtStringNameTranslation
			   WHERE idfsBaseReference = @idfsFormTemplate
					 AND (idfsLanguage = @LangID
						  OR @LangID IS NULL)

		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	
		THROW;
	END CATCH;
END
