----------------------------------------------------------------------------
-- Name 				: FN_VCT_ASCampaign_SampleTypeStringGet
-- Description			: Get DiagnosisString for Active Surveillance Campaign
--          
-- Author               : Mandar Kulkarni
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
/*
 select *, len(strDiagnosis) from  dbo.FN_VCT_ASCampaign_SampleTypeStringGet('en')
 where idfCampaign = 12666940000000
*/
----------------------------------------------------------------------------
CREATE FUNCTION [dbo].[FN_VCT_ASCampaign_SampleTypeStringGet]
(
	@LangID AS nvarchar(50) --##PARAM @LangID - language ID
)
RETURNS  TABLE
AS
RETURN
		SELECT	SUBSTRING(STUFF((SELECT   ', ' + SampleType.name AS [text()]
		FROM	dbo.CampaignToSampleType tcd
		INNER JOIN dbo.FN_GBL_ReferenceRepair(@LangID, 19000087) SampleType 
		ON		tcd.idfsSampleType= SampleType.idfsReference
		WHERE	tcd.intRowStatus = 0  
		AND		tcd.idfCampaign = c.idfCampaign
		ORDER BY tcd.intOrder  
		FOR XML PATH ('')),1,2,''), 1, 500) AS strSampleType,
				c.idfCampaign			
		FROM	dbo.tlbCampaign c
 
