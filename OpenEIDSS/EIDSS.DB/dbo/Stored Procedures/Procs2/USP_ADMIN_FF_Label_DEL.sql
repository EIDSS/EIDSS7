
-- ================================================================================================
-- Name: USP_ADMIN_FF_Label_DEL
-- Description: Deletes the Label
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_Label_DEL] 
(
	@idfDecorElement BIGINT
)
AS
BEGIN
	SET NOCOUNT ON;	
	
	DECLARE
		@returnCode BIGINT = 0,
		@returnMsg  NVARCHAR(MAX) = 'Success'     
	
	BEGIN TRY
		DELETE FROM dbo.[ffDecorElementText]
			   WHERE [idfDecorElement] = @idfDecorElement
		
		DELETE FROM dbo.[ffDecorElement] 
			   WHERE [idfDecorElement] = @idfDecorElement

		SELECT @returnCode, @returnMsg

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
