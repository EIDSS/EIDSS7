
--procedure connects AS Session to AS Campaign

CREATE PROCEDURE [dbo].[spAsSession_CampaignPost]  
@idfMonitoringSession bigint,  
@idfCampaign bigint  
AS  
UPDATE dbo.tlbMonitoringSession  
SET  
 idfCampaign = @idfCampaign  
WHERE   
 idfMonitoringSession = @idfMonitoringSession  

 
