
-- ============================================================================
-- Name: USSP_GBL_ASCAMPAIGNTOSAMPLETYPE_DEL
-- Description:	Sets a campaign to sample type record to "inactive".
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/30/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_ASCAMPAIGNTOSAMPLETYPE_DEL]
(	 
	@CampaignToSampleTypeUID			BIGINT
)
AS

DECLARE @returnCode						INT = 0;
DECLARE @returnMsg						NVARCHAR(max) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY
		UPDATE							dbo.CampaignToSampleType
		SET								intRowStatus = 1
		WHERE							CampaignToSampleTypeUID = @CampaignToSampleTypeUID; 

		SELECT							@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		BEGIN 
			THROW;

			SELECT						@returnCode, @returnMsg;
		END
	END CATCH
END

