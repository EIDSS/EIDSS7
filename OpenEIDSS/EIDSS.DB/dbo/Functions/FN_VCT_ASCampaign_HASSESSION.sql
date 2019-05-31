
----------------------------------------------------------------------------
-- Name 				: FN_VCT_ASCampaign_HASSESSION
-- Description			: Checks if campaign has associated Open monitoring 
--							sessions same as Species and Samples as Campaign.
--						##RETURNS 0 if campaign has no monitoring sessions
--						##RETURNS 1 if campaign has at least one monitoring session
-- Author               : Mandar Kulkarni
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
-- SELECT * FROM dbo.FN_VCT_ASCampaign_HASSESSION(idfCampaign)
--*/
CREATE FUNCTION [dbo].[FN_VCT_ASCampaign_HASSESSION]
(
	@idfCampaign				AS BIGINT, --##PARAM @idfCampaign - campaign ID
	@CampaignToSampleTypeUID	AS BIGINT
)
RETURNS INT
AS
BEGIN
	
	DECLARE @hasSession INT = 0 

	IF EXISTS(	SELECT *  
				FROM  dbo.MonitoringSessionToSampleType msts
				INNER JOIN dbo.tlbMonitoringSession ms ON
							ms.idfMonitoringSession = msts.idfMonitoringSession
				LEFT JOIN dbo.CampaignToSampleType cts ON	
							ms.idfCampaign = cts.idfCampaign AND cts.intRowStatus = 0
				WHERE	ms.idfCampaign = @idfCampaign
				AND		cts.CampaignToSampleTypeUID = @CampaignToSampleTypeUID
				AND		ms.idfsMonitoringSessionStatus = 10160000
				AND		cts.idfsSpeciesType = msts.idfsSpeciesType
				AND		cts.idfsSampleType = msts.idfsSampleType
				AND		msts.intRowStatus = 0
			)
		SET @hasSession = 1
	ELSE
		SET @hasSession = 0

	RETURN @hasSession
END
