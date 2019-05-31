
-- ================================================================================================
-- Name: USP_ADMIN_FF_SectionTemplateRecursive_DEL
-- Description: Deletes the template recusrive.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru   11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_SectionTemplateRecursive_DEL] 
(
	@idfsSection BIGINT
	,@idfsFormTemplate BIGINT
	,@LangID  NVARCHAR(50) = NULL
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE
		@idfsParentSection BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg NVARCHAR(MAX) = 'Success'     

	BEGIN TRY
		SELECT @idfsParentSection = [idfsParentSection]
		FROM dbo.ffSection
		WHERE idfsSection = @idfsSection

		EXEC dbo.USP_ADMIN_FF_SectionTemplate_DEL @idfsSection,@idfsFormTemplate,@LangID
		
		IF (@idfsParentSection IS NOT NULL)
			EXEC dbo.USP_ADMIN_FF_SectionTemplate_DEL @idfsParentSection,@idfsFormTemplate,@LangID
	
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;  
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION

		THROW;
	END CATCH; 
END
