


--##SUMMARY Populates data related with specific campaign for associating Monitoring Session with campaign

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.06.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @idfCampaign bigint
SET @idfCampaign=4581160000000
EXECUTE spASSession_PopulateCampaignData 
	@idfCampaign

*/




CREATE         PROCEDURE dbo.spASSession_PopulateCampaignData(
	@idfCampaign AS bigint--##PARAM @idfCampaign - AS campaign ID
)
AS
-- 0- Campaign
SELECT 
       tlbCampaign.strCampaignID
      ,tlbCampaign.strCampaignName
      ,tlbCampaign.idfsCampaignType
      ,tlbCampaign.idfsCampaignStatus
	  ,tlbCampaign.datCampaignDateStart
	  ,tlbCampaign.datCampaignDateEnd
  FROM  tlbCampaign
WHERE
	tlbCampaign.idfCampaign = @idfCampaign
--1 Diagnosis

SELECT 
	   idfCampaignToDiagnosis
	  ,CAST(NULL as bigint) as idfMonitoringSession 
      ,idfCampaign
      ,idfsDiagnosis
      ,idfsSpeciesType
	  ,idfsSampleType
	  ,Cast (0 as BIT) as blnUsed
  FROM tlbCampaignToDiagnosis
WHERE
	idfCampaign = @idfCampaign
	and intRowStatus = 0
Order By intOrder



