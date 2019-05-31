-- ================================================================================================
-- Name: USSP_VET_FARM_DEL
--
-- Description:	Sets a farm record to "inactive".
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/02/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_FARM_DEL] (@FarmID BIGINT)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0,
		@ReturnMessage NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		UPDATE dbo.tlbFarm
		SET intRowStatus = 1
		WHERE idfFarm = @FarmID;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;
	END TRY

	BEGIN CATCH
		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
