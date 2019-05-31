
-- ================================================================================================
-- Name: USP_ADMIN_FF_ParameterUsed_Check
-- Description: Checks if parameter is used. 
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_ParameterUsed_Check] 
(	
	@idfsParameter BIGINT	 	
)	
AS
BEGIN	
	SET NOCOUNT ON;

	DECLARE
		@Result BIT,
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX) 

	SET @Result = 0;

	BEGIN TRY
		IF (EXISTS(SELECT TOP 1 1 
				   FROM dbo.ffParameterForTemplate
				   WHERE [idfsParameter] = @idfsParameter
						 AND [intRowStatus] = 0))
			SET @Result = 1;
	
		SELECT @Result AS [idfsParameter]

		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END
