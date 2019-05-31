

/*
 select *, len(strDiagnosis) from  dbo.fnASCampain_GetDiagnosisString('en')
 where idfCampaign = 12666940000000
*/

create function fnASCampain_GetDiagnosisString(
	@LangID as nvarchar(50) --##PARAM @LangID - language ID
)
returns  table
as
return
 SELECT   
	substring(STUFF((SELECT   ', ' + diagnosis.name AS [text()]
			FROM    tlbMonitoringSessionToDiagnosis sd
			INNER JOIN fnReference(@LangID, 19000019) diagnosis 
			ON	sd.idfsDiagnosis = diagnosis.idfsReference
			INNER JOIN tlbMonitoringSession  ms
			ON sd.idfMonitoringSession = ms.idfMonitoringSession  
				and ms.intRowStatus = 0 
			WHERE 
				sd.intRowStatus = 0  
				and ms.idfCampaign = c.idfCampaign
			order by sd.intOrder  
			for xml path ('')),1,2,''), 1, 500) as strDiagnosis,
	c.idfCampaign			
			
 FROM dbo.tlbCampaign c
 
	  
  
  
  
