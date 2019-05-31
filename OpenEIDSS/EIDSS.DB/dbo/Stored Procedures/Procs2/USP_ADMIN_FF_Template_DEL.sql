
-- ================================================================================================
-- Name: USP_ADMIN_FF_Template_DEL
-- Description: Deletes the Template
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Template_DEL] 
(
	@idfsFormTemplate BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	SET XACT_ABORT ON;
	
	DECLARE
		@ID BIGINT,
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 	

	BEGIN TRY
		
--		Declare cursLang Cursor For 
--			Select Distinct idfsLanguage From dbo.ffSectionDesignOption
--			Union
--			Select Distinct idfsLanguage From dbo.ffParameterDesignOption
--			Union
--			Select Distinct idfsLanguage From dbo.ffDecorElement
--		---
--		Declare @idfsLanguage Bigint
--		Open cursLang;
--			Fetch Next From cursLang Into @idfsLanguage
--			While (@@FETCH_STATUS = 0) BEGIN
		EXEC dbo.USP_ADMIN_FF_TemplateDesignOptions_DEL @idfsFormTemplate--, @idfsLanguage		                           
--					 Fetch Next From cursLang Into @idfsLanguage                  	
--			 End   
--	   Close cursLang;
--	   Deallocate cursLang;

		DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT [idfsRule]
				FROM dbo.ffRule
				WHERE idfsFormTemplate = @idfsFormTemplate  --And [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_Rule_DEL @ID
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs 
	   
		DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT [idfsParameter]
				FROM dbo.ffParameterForTemplate
				WHERE idfsFormTemplate = @idfsFormTemplate  --And [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs into @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_ParameterTemplate_DEL @ID, @idfsFormTemplate, 'en' 
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs	
	 
	   DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT [idfsSection]
				FROM dbo.ffSectionForTemplate
				WHERE idfsFormTemplate = @idfsFormTemplate -- And [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_SectionTemplate_DEL @ID, @idfsFormTemplate, 'en'
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs
	   
	   DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT DET.[idfDecorElement]
				FROM dbo.ffDecorElementText DET
				INNER JOIN dbo.ffDecorElement DE
				ON DE.idfDecorElement = DET.idfDecorElement
				WHERE idfsFormTemplate = @idfsFormTemplate
--				And DET.[intRowStatus] = 0
--				And DE.[intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_Label_DEL @ID
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs
	  
		DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT DEL.[idfDecorElement]
				FROM dbo.ffDecorElementLine DEL
				INNER JOIN dbo.ffDecorElement DE
				ON DE.idfDecorElement = DEL.idfDecorElement
				WHERE idfsFormTemplate = @idfsFormTemplate
--				And DEL.[intRowStatus] = 0
--				And DE.[intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_Line_DEL @ID
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs
	
		DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
			FOR SELECT DISTINCT idfDeterminantValue FROM dbo.ffDeterminantValue						
				WHERE idfsFormTemplate = @idfsFormTemplate --And [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @ID

		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC dbo.USP_ADMIN_FF_TemplateDeterminantValues_DEL @ID
				FETCH NEXT FROM curs INTO @ID
			END

		CLOSE curs
		DEALLOCATE curs
		
		DELETE FROM dbo.ffFormTemplate
			   WHERE idfsFormTemplate = @idfsFormTemplate

		EXEC dbo.usp_sysBaseReference_Delete @idfsFormTemplate

		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END


