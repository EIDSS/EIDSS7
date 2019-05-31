

CREATE FUNCTION [dbo].[fn070SearchQuery__55734620000000]
(
@LangID	as nvarchar(50)
)
returns table
as
return
select		
v.[sflASCampaign_CampaignType_ID], 
			[ref_sflASCampaign_CampaignType].[name] as [sflASCampaign_CampaignType], 
			v.[sflASCampaign_CampaignStatus_ID], 
			[ref_sflASCampaign_CampaignStatus].[name] as [sflASCampaign_CampaignStatus], 
			v.[sflASCampaign_StartDate], 
			v.[sflASCampaign_CampaignName], 
			v.[sflASCampaign_EndDate], 
			cast((
	select		distinct ASCampaignDiagnosis.[name] + '; ' 
	from		tlbCampaignToDiagnosis CampaignToDiagnosesString
	inner join	fnReferenceRepair(@LangID, 19000019)	ASCampaignDiagnosis	-- rftDiagnosis
	on			ASCampaignDiagnosis.idfsReference = CampaignToDiagnosesString.idfsDiagnosis
	where		CampaignToDiagnosesString.idfCampaign = v.[sflASCampaign_DiagnosesString]
				and CampaignToDiagnosesString.intRowStatus = 0
	order by	ASCampaignDiagnosis.[name] + '; ' 
	for xml path('')		
	) as nvarchar(max)) as [sflASCampaign_DiagnosesString] , 
			v.[sflASCampaign_CampaignID], 
			v.[sflASCampaign_Administrator] 
from		vw070SearchQuery__55734620000000 v

left join	fnReferenceRepair(@LangID, 19000116) [ref_sflASCampaign_CampaignType] 
on			[ref_sflASCampaign_CampaignType].idfsReference = v.[sflASCampaign_CampaignType_ID] 
left join	fnReferenceRepair(@LangID, 19000115) [ref_sflASCampaign_CampaignStatus] 
on			[ref_sflASCampaign_CampaignStatus].idfsReference = v.[sflASCampaign_CampaignStatus_ID] 



--Not needed--left join	fnReference(@LangID, 19000044) ref_None	-- Information String
--Not needed--on			ref_None.idfsReference = 0		-- Workaround. We dont need (none) anymore

 


