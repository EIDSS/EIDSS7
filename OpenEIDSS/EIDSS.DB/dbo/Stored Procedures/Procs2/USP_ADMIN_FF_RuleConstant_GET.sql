
-- ================================================================================================
-- Name: USP_ADMIN_FF_RuleConstant_GET
-- Description: Returns the list of Rule Constants
--          
-- Revision History:
-- Name            Date       Change
-- --------------- ---------- --------------------------------------------------------------------
-- Kishore Kodru    11/28/2018 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_FF_RuleConstant_GET]
(	
	@idfsRule BIGINT
)	
AS
BEGIN	
	SET NOCOUNT ON;	
	
	DECLARE
		@returnCode BIGINT,
		@returnMsg  NVARCHAR(MAX)       
	
	BEGIN TRY
		SELECT [idfRuleConstant]
			   ,[idfsRule]		
			   ,[varConstant]
		FROM [dbo].[ffRuleConstant] 
		WHERE [idfsRule] = @idfsRule
			  AND [intRowStatus] = 0
	
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;

		THROW;
	END CATCH
END

