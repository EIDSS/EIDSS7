
   
/************************************************************    
* spASCampaignDiagnosis_Post.proc    
************************************************************/    
    
--##SUMMARY Posts list of diagnosis related with specific AS campaign.    
--##SUMMARY Called by ASCampaignDetail form.    
    
--##REMARKS Author: Zurin M.    
--##REMARKS Create date: 10.06.2010  
    
--##REMARKS Updated: Zolotareva N.  
--##REMARKS Update date: 16.11.2011  
  
--##RETURNS Doesn't use    
    
/*    
--Example of procedure call:    
    
DECLARE @Action int    
DECLARE @idfCampaign bigint    
DECLARE @idfsDiagnosis bigint    
DECLARE @intOrder int    
    
-- TODO: Set parameter values here.    
    
EXECUTE spASCampaignDiagnosis_Post    
   @Action    
  ,@idfCampaign    
  ,@idfsDiagnosis    
  ,@intOrder    
*/    
    
    
    
    
CREATE         PROCEDURE dbo.spASCampaignDiagnosis_Post(    
   @Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record    
           ,@idfCampaignToDiagnosis bigint OUTPUT    
           ,@idfCampaign bigint    
           ,@idfsDiagnosis bigint    
           ,@intOrder int  
           ,@idfsSpeciesType bigint  
           ,@intPlannedNumber int    
           ,@idfsSampleType bigint
)    
AS    
IF @Action = 8    
BEGIN    
 DELETE FROM tlbCampaignToDiagnosis    
    WHERE     
 idfCampaignToDiagnosis = @idfCampaignToDiagnosis    
END    
    
ELSE IF @Action = 16    
BEGIN    
 UPDATE tlbCampaignToDiagnosis    
 SET     
   intOrder = @intOrder    
  ,idfsDiagnosis = @idfsDiagnosis    
  ,idfCampaign = @idfCampaign    
  ,idfsSpeciesType = @idfsSpeciesType  
  ,intPlannedNumber = @intPlannedNumber  
  ,idfsSampleType = @idfsSampleType
 WHERE     
  idfCampaignToDiagnosis = @idfCampaignToDiagnosis    
END    
ELSE IF @Action = 4    
BEGIN    
 if(ISNULL(@idfCampaignToDiagnosis,0)<=0)	
	EXEC spsysGetNewID @idfCampaignToDiagnosis OUTPUT    
 INSERT INTO tlbCampaignToDiagnosis    
     (    
   idfCampaignToDiagnosis    
   ,idfCampaign    
     ,idfsDiagnosis    
     ,intOrder   
     ,idfsSpeciesType  
     ,intPlannedNumber 
     ,idfsSampleType  
     )    
  VALUES    
     (    
   @idfCampaignToDiagnosis    
   ,@idfCampaign    
     ,@idfsDiagnosis    
     ,@intOrder    
     ,@idfsSpeciesType  
     ,@intPlannedNumber   
     ,@idfsSampleType
     )    
END    
    
RETURN 0
