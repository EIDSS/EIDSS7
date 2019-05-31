
-- ================================================================================================
-- Name: USP_ADMIN_FF_Parameter_DEL
-- Description: Delete the Parameter.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Parameter_DEL] 
(
	@idfsParameter BIGINT	
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE 
		@ErrorMessage NVARCHAR(400),
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
				
		--If Exists(Select Top 1 1 From dbo.ffParameterDesignOption Where idfsParameter = @idfsParameter) Exec dbo.spThrowException 'ParameterRemove_Has_ffParameterDesignOption_Rows';
		IF EXISTS(SELECT TOP 1 1
					FROM dbo.tasQuerySearchField
					WHERE idfsParameter = @idfsParameter)
			SET @ErrorMessage = 'ParameterRemove_Has_tasQuerySearchField_Rows';

		IF EXISTS(SELECT TOP 1 1
					FROM dbo.ffParameterForTemplate
					WHERE idfsParameter = @idfsParameter
						AND intRowStatus = 0)
			SET @ErrorMessage = 'ParameterRemove_Has_ffParameterForTemplate_Rows';

		IF EXISTS(SELECT TOP 1 1
					FROM dbo.tlbActivityParameters
					WHERE idfsParameter = @idfsParameter
						AND intRowStatus = 0)
			SET @ErrorMessage = 'ParameterRemove_Has_tlbActivityParameters_Rows';

		--IF EXISTS(SELECT TOP 1 1 FROM dbo.tlbAggrMatrixVersion Where idfsParameter = @idfsParameter AND intRowStatus = 0) SET  @ErrorMessage	= 'ParameterRemove_Has_tlbAggrMatrixVersion_Rows';
		IF EXISTS(SELECT TOP 1 1
					FROM dbo.ffParameterForFunction
					WHERE idfsParameter = @idfsParameter
						AND intRowStatus = 0)
			SET @ErrorMessage = 'ParameterRemove_ParameterForFunction';
	
		IF (@ErrorMessage IS NOT NULL)
			THROW 52000, @ErrorMessage, 1;  

		IF EXISTS(SELECT TOP 1 1
				  FROM dbo.ffParameterForTemplate
				  WHERE idfsParameter = @idfsParameter)
			BEGIN
				DECLARE
					@st_id BIGINT
				DECLARE curs CURSOR LOCAL FORWARD_ONLY STATIC
				FOR SELECT DISTINCT idfsFormTemplate
					FROM dbo.ffParameterForTemplate
					WHERE idfsParameter = @idfsParameter
						  AND [intRowStatus] = 0
					OPEN curs
				FETCH NEXT FROM curs INTO @st_id
			
				WHILE @@FETCH_STATUS = 0
					BEGIN
						EXEC dbo.USP_ADMIN_FF_ParameterTemplate_DEL @idfsParameter, @st_id		
						FETCH NEXT FROM curs INTO @st_id
					END
			
				CLOSE curs
				DEALLOCATE curs
			END
		
		DELETE FROM dbo.ffParameterDesignOption
			   WHERE idfsParameter = @idfsParameter
					  AND idfsFormTemplate IS NULL
		
		DELETE FROM dbo.ffParameter
			   WHERE idfsParameter = @idfsParameter

		EXEC dbo.usp_sysBaseReference_Delete @idfsParameter

		SELECT @returnCode, @returnMsg
		COMMIT TRANSACTION;
	END TRY 
	BEGIN CATCH   
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH;
END
