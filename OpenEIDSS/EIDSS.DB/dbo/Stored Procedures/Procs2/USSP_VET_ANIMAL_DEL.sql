


-- ============================================================================
-- Name: USSP_VET_ANIMAL_DEL
-- Description:	Sets an animal record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/14/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VET_ANIMAL_DEL]
(	 
	@idfAnimal			   BIGINT
)
AS

DECLARE @returnCode INT = 0;
DECLARE @returnMsg  NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE				dbo.tlbAnimal
		SET					intRowStatus = 1
							--datModificationForArchiveDate = GETDATE()
		WHERE				idfAnimal = @idfAnimal; 

		SELECT @returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT @returnCode, @returnMsg;
		END

	END CATCH
END


