



-- ============================================================================
-- Name: USSP_VET_VACCINATION_DEL
-- Description:	Sets a vaccination record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/14/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VET_VACCINATION_DEL]
(	 
	@idfVaccination		   BIGINT
)
AS

DECLARE @returnCode			INT = 0;
DECLARE @returnMsg			NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE				dbo.tlbVaccination
		SET					intRowStatus = 1
		WHERE				idfVaccination = @idfVaccination; 

		SELECT @returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT @returnCode, @returnMsg;
		END

	END CATCH
END


