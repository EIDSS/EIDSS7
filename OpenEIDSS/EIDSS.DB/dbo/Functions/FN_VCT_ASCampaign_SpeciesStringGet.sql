----------------------------------------------------------------------------
-- Name 				: FN_VCT_ASCampaign_SpeciesStringGet
-- Description			: Get DiagnosisString for Active Surveillance Campaign
--          
-- Author               : Mandar Kulkarni
-- 
-- Revision History
-- Name				Date		Change Detail
--
-- Testing code:
/*
 select *, len(strDiagnosis) from  dbo.FN_VCT_ASCampaign_SpeciesStringGet('en')
 where idfCampaign = 12666940000000
*/
----------------------------------------------------------------------------
CREATE FUNCTION [dbo].[FN_VCT_ASCampaign_SpeciesStringGet]
(
	@LangID AS nvarchar(50) --##PARAM @LangID - language ID
)
RETURNS  TABLE
AS
RETURN
		SELECT	SUBSTRING(STUFF((SELECT   ', ' + tb.strDefault AS [text()]
		FROM	dbo.CampaignToSampleType tcd
		INNER JOIN dbo.trtBaseReference tb
		ON		tcd.idfsSpeciesType = tb.idfsBaseReference
		WHERE	tcd.intRowStatus = 0  
		AND		tcd.idfCampaign = c.idfCampaign
		ORDER BY tcd.intOrder  
		FOR XML PATH ('')),1,2,''), 1, 500) AS strSpecies,
				c.idfCampaign			
		FROM	dbo.tlbCampaign c
 
