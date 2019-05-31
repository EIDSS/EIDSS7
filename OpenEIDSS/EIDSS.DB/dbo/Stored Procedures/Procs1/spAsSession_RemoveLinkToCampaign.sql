
--##SUMMARY Unlinks AS Session from Campaign

--##REMARKS Author: Zolotareva N.
--##REMARKS Create date: 20.07.2012

CREATE PROCEDURE [dbo].[spAsSession_RemoveLinkToCampaign]  
@idfMonitoringSession bigint  
AS  
  
UPDATE dbo.tlbMonitoringSession  
SET  
 idfCampaign =null  
WHERE   
 idfMonitoringSession = @idfMonitoringSession  
   
 
