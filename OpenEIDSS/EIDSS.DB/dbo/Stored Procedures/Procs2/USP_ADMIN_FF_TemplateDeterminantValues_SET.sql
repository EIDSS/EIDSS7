
-- ================================================================================================
-- Name: USP_ADMIN_FF_TemplateDeterminantValues_SET
-- Description:Save the Template Determinant Values 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
-- Description:	
-- Revision History
--		Name		   Date		      Change Detail
-- ================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_TemplateDeterminantValues_SET] 
(
    @idfsFormTemplate BIGINT
    ,@idfsBaseReference BIGINT = NULL
    ,@idfsGISBaseReference BIGINT = NULL
	,@idfDeterminantValue BIGINT OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	
	DECLARE 
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success' 

	BEGIN TRY
	
		IF (@idfDeterminantValue < 0)
			EXEC dbo.[usp_sysGetNewID] @idfDeterminantValue OUTPUT
	
		IF NOT EXISTS (SELECT TOP 1 1
					   FROM dbo.ffDeterminantValue
					   WHERE [idfDeterminantValue] = @idfDeterminantValue)
			BEGIN
				INSERT INTO [dbo].[ffDeterminantValue]
					(
           				[idfDeterminantValue]
						,[idfsFormTemplate]
						,[idfsBaseReference]
						,[idfsGISBaseReference]
					)
				VALUES
					(
           				@idfDeterminantValue
						,@idfsFormTemplate
						,@idfsBaseReference
						,@idfsGISBaseReference
					)           
			END
		ELSE
			BEGIN
				UPDATE [dbo].[ffDeterminantValue]
				SET [idfsFormTemplate] =@idfsFormTemplate 
					,[idfsBaseReference] = @idfsBaseReference
					,[idfsGISBaseReference] = @idfsGISBaseReference
					,[intRowStatus] = 0
				WHERE [idfDeterminantValue] = @idfDeterminantValue
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
