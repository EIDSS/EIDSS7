
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTemplate_DEL
-- Description: Delete the Parameter Template
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTemplate_DEL] 
(
	@idfsParameter BIGINT
	,@idfsFormTemplate BIGINT
	,@LangID NVARCHAR(50) = NULL
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
	
		DELETE FROM dbo.ffParameterDesignOption
			   WHERE idfsParameter = @idfsParameter 
					 AND idfsFormTemplate = @idfsFormTemplate
					 AND idfsLanguage = @langid_int
		
		IF (@LangID = 'en')
			BEGIN	                    	
	        
				DELETE FROM dbo.ffParameterDesignOption
					   WHERE idfsParameter = @idfsParameter 
							 AND idfsFormTemplate = @idfsFormTemplate
				--
				DELETE FROM dbo.ffParameterForTemplate
					   WHERE idfsParameter = @idfsParameter 
							 AND idfsFormTemplate = @idfsFormTemplate
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
