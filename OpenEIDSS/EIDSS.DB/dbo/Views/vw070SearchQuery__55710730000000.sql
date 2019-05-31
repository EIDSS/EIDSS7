

CREATE VIEW [dbo].[vw070SearchQuery__55710730000000]
as

select		as_cam.idfCampaign as [PKField], 
			as_cam.idfCampaign as [PKField_4582550000000], 
			as_cam.strCampaignID as [sflASCampaign_CampaignID], 
			as_cam.strCampaignName as [sflASCampaign_CampaignName], 
			as_cam.strCampaignAdministrator as [sflASCampaign_Administrator], 
			as_cam.idfsCampaignType as [sflASCampaign_CampaignType_ID], 
			as_cam.idfsCampaignStatus as [sflASCampaign_CampaignStatus_ID], 
			as_cam.datCampaignDateStart as [sflASCampaign_StartDate], 
			as_cam.datCampaignDateEnd as [sflASCampaign_EndDate], 
			as_cam.idfCampaign as [sflASCampaign_DiagnosesString]

from 

 
	tlbCampaign AS as_cam
 



where		as_cam.intRowStatus = 0


