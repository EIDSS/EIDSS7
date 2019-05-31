
-- ================================================================================================
-- Name: USP_ADMIN_FF_Section_DEL
-- Description: Delete the section.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Section_DEL] 
(
	@idfsSection BIGINT	
)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	DECLARE
		@ErrorMessage NVARCHAR(400),
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 
	
	BEGIN TRY	
			
		IF EXISTS(SELECT TOP 1 1 
				  FROM dbo.ffDecorElement
				  WHERE idfsSection = @idfsSection
						AND intRowStatus = 0)
			SET @ErrorMessage = 'SectionRemove_Has_ffDecorElement_Rows';

		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffParameter
				  WHERE idfsSection = @idfsSection
						AND intRowStatus = 0)
			SET @ErrorMessage = 'SectionRemove_Has_ffParameter_Rows';
	
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffSection
				  WHERE idfsParentSection = @idfsSection
						AND intRowStatus = 0)
			SET @ErrorMessage = 'SectionRemove_Has_ffSection_ParentSection_Rows';

		--If Exists(Select Top 1 1 From dbo.ffSectionDesignOption Where idfsSection = @idfsSection) Exec dbo.spThrowException 'SectionRemove_Has_ffSectionDesignOption_Rows';
	
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffSectionForTemplate
				  WHERE idfsSection = @idfsSection
						AND intRowStatus = 0)
			SET @ErrorMessage = 'SectionRemove_Has_ffSectionForTemplate_Rows';
	
		IF (@ErrorMessage IS NOT NULL)
			THROW 52000, @ErrorMessage, 1 
	
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffSection
				  WHERE idfsParentSection = @idfsSection)
			BEGIN
				DECLARE @sect_id BIGINT
				DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
				FOR SELECT DISTINCT [idfsSection]
					FROM dbo.ffSection
					WHERE idfsParentSection = @idfsSection
						  AND [intRowStatus] = 0
					OPEN curs
				FETCH NEXT FROM curs INTO @sect_id
			
				WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC dbo.USP_ADMIN_FF_Section_DEL @sect_id
						FETCH NEXT FROM curs INTO @sect_id
					END
			
				CLOSE curs
				DEALLOCATE curs
			END
		
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffParameter
				  WHERE idfsSection = @idfsSection)
			BEGIN
				DECLARE @param_id BIGINT
				DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
				FOR SELECT DISTINCT [idfsParameter]
					FROM dbo.ffParameter
					WHERE idfsSection = @idfsSection
						  AND [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @param_id
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					EXEC dbo.USP_ADMIN_FF_Section_DEL @param_id
					FETCH NEXT FROM curs INTO @param_id
				END
			
			CLOSE curs
			DEALLOCATE curs
		END
		
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffParameter
				  WHERE idfsSection = @idfsSection)
			BEGIN
				DECLARE @de_id BIGINT
				DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
				FOR SELECT DISTINCT idfDecorElement
					FROM dbo.ffDecorElement
					WHERE idfsSection = @idfsSection
						  AND [intRowStatus] = 0
				OPEN curs
			FETCH NEXT FROM curs INTO @de_id
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					EXEC dbo.USP_ADMIN_FF_Label_DEL @de_id
					EXEC dbo.USP_ADMIN_FF_Line_DEL @de_id
					FETCH NEXT FROM curs INTO @de_id
				END
			
			CLOSE curs
			DEALLOCATE curs
		END
	
		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffSectionForTemplate
				  WHERE idfsSection = @idfsSection)
			BEGIN
				DECLARE @st_id BIGINT
				DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
					FOR SELECT DISTINCT idfsFormTemplate
						FROM dbo.ffSectionForTemplate
						WHERE idfsSection = @idfsSection
							  AND [intRowStatus] = 0
					OPEN curs
				FETCH NEXT FROM curs INTO @st_id
			
				WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC dbo.USP_ADMIN_FF_SectionTemplate_DEL @idfsSection, @st_id		
						FETCH NEXT FROM curs INTO @st_id
					END
			
				CLOSE curs
				DEALLOCATE curs
			END
	
		DELETE FROM dbo.ffSection
			   WHERE idfsSection = @idfsSection

		EXEC dbo.usp_sysBaseReference_Delete @idfsSection
		
		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END
