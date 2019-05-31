
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterTypes_DEL
-- Description: Deletes the Parameter Type
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
--	Lamont Mitchell	12/29/2018 Modified Output paramaters
-- =================/===============================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterTypes_DEL]
(
	@idfsParameterType BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE
		@ErrorMessage NVARCHAR(400),
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'   

	BEGIN TRY
		/*
		SELECT @ErrorMessage = [ErrorMessage]
		FROM dbo.FN_ADMIN_FF_ParameterTypes_DeleteCheck(@ErrorMessage);

		IF EXISTS(SELECT TOP 1 1
					  FROM dbo.ffParameter
					  WHERE idfsParameterType = @idfsParameterType
							AND intRowStatus = 0)
		SET  @ErrorMessage	=  'ParameterTypeRemove_Has_ffParameter';

		IF EXISTS(SELECT TOP 1 1
			  FROM dbo.tlbActivityParameters
			  WHERE varValue IN (SELECT idfsParameterFixedPresetValue 
								 FROM dbo.ffParameterFixedPresetValue
								 WHERE idfsParameterType = @idfsParameterType 
								       AND intRowStatus = 0)
			        AND intRowStatus = 0)
		SET  @ErrorMessage	= 'ParameterTypeRemove_Has_tlbActivityParameters';	

	IF (@ErrorMessage IS NOT NULL)
			THROW 52000, @ErrorMessage, 1
	*/
		DELETE FROM dbo.ffParameterFixedPresetValue
			   WHERE idfsParameterType= @idfsParameterType
	
		DELETE FROM dbo.ffParameterType
			   WHERE [idfsParameterType] = @idfsParameterType
		COMMIT TRANSACTION;
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage' 

		
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
