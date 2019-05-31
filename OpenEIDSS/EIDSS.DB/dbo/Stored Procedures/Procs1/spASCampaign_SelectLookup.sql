


--##SUMMARY Selects data for Active Surveillance Campaign form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 10.06.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:
EXECUTE spASCampaign_SelectLookup 
	'en'

*/




CREATE         PROCEDURE dbo.spASCampaign_SelectLookup(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
AS
-- 0- Campaign
SELECT tlbCampaign.idfCampaign
      ,tlbCampaign.strCampaignID
      ,tlbCampaign.idfsCampaignType
      ,tlbCampaign.strCampaignName
      ,fnReferenceRepair.name as strCampaignType
	  ,tlbCampaign.intRowStatus
FROM tlbCampaign
Inner Join fnReferenceRepair(@LangID,19000116) --Campaign Type
	ON fnReferenceRepair.idfsReference=tlbCampaign.idfsCampaignType
WHERE
	--tlbCampaign.intRowStatus = 0 and
	tlbCampaign.idfsCampaignStatus = 10140001 --Open



