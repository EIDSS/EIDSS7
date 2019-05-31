
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterFixedPresetValue_DEL
-- Description: Deletes the parameter Fixed Presetvalue from the table.
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterFixedPresetValue_DEL]
(
	@idfsParameterFixedPresetValue BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE
		@ErrorMessage NVARCHAR(400),
		@returnCode BIGINT = 0,
		@returnMsg NVARCHAR(MAX) = 'Success' 

	BEGIN TRY

		IF EXISTS(SELECT TOP 1 1 
			  FROM dbo.tlbActivityParameters
			  WHERE varValue = @idfsParameterFixedPresetValue
					AND intRowStatus = 0)
		SET  @ErrorMessage	= 'ParameterFixedPresetValueRemove_Has_tlbActivityParameters';
		
		IF (@ErrorMessage IS NOT NULL)
			THROW 52000, @ErrorMessage, 1

		DELETE FROM dbo.ffParameterFixedPresetValue
			   WHERE [idfsParameterFixedPresetValue] = @idfsParameterFixedPresetValue
		
		SELECT @returnCode, @returnMsg

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
