
/************************************************************    
* spASCampaignSession_Post.proc    
************************************************************/    
    
--##SUMMARY Clears and sets links to specific AS campaign.    
--##SUMMARY Called by ASCampaignDetail form.    
    
--##REMARKS Author: Gorodentrseva T.    
--##REMARKS Create date: 18.07.2012  
  
--##RETURNS Doesn't use    
    
/*    
--Example of procedure call:    
    
DECLARE @Action int    
DECLARE @idfMonitoringSession bigint    
    
-- TODO: Set parameter values here.    
    
EXECUTE spASCampaignSession_Post    
   @Action    
  ,@idfMonitoringSession    
*/    
    
    
    
    
CREATE         PROCEDURE dbo.spASCampaignSession_Post(    
   @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record    
           ,@idfMonitoringSession bigint	--##PARAM @idfMonitoringSession - sesson ID
		   ,@idfCampaign bigint				--##PARAM @idfCampaign - campaign ID to link to
)    
AS    
IF @Action = 8    
BEGIN    
 UPDATE tlbMonitoringSession    
 SET     
   idfCampaign = NULL    
 WHERE     
  idfMonitoringSession = @idfMonitoringSession  
END    
ELSE IF @Action = 4    
BEGIN    
 UPDATE tlbMonitoringSession    
 SET     
   idfCampaign = @idfCampaign    
 WHERE     
  idfMonitoringSession = @idfMonitoringSession  
END    
  
    
RETURN 0
