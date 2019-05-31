
-- ============================================================================
-- Name: USSP_GBL_FARM_DEL
-- Description:	Sets a farm record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/24/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_FARM_DEL]
(	 
	@idfFarm				BIGINT
)
AS

DECLARE @returnCode			INT = 0;
DECLARE @returnMsg			NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE				dbo.tlbFarm
		SET					intRowStatus = 1
		WHERE				idfFarm = @idfFarm; 

		SELECT				@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT			@returnCode, @returnMsg;
		END

	END CATCH
END


