
-- ================================================================================================
-- Name: USP_ADMIN_FF_ActivityParameters_DEL
-- Description: Deletes the Activity Parameter
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ActivityParameters_DEL]
(
	@idfsParameter BIGINT
	,@idfObservation BIGINT
	,@idfRow BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'       
	
	BEGIN TRY
		DELETE FROM dbo.tlbActivityParameters
			   WHERE idfsParameter = @idfsParameter 
					 AND idfObservation = @idfObservation 
					 AND idfRow = @idfRow
		COMMIT TRANSACTION;
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
