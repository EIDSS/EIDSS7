
  
/************************************************************  
* spAsSession_SelectDiagnosis
************************************************************/  
  
  
--##SUMMARY Selects diagnosis for Active Surveillance Monitoring Session form  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 27.05.2013 
  
--##RETURNS Doesn't use  
  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=706800000000  
EXECUTE spAsSession_SelectDiagnosis   
 @idfMonitoringSession  
  
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spAsSession_SelectDiagnosis](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
)  
AS  
  
--0 Diagnosis  
  
SELECT   
       idfMonitoringSessionToDiagnosis   
   ,idfMonitoringSession  
      ,idfsDiagnosis   
	  ,idfsSpeciesType
      ,intOrder  
      ,idfsSampleType
  FROM tlbMonitoringSessionToDiagnosis  
WHERE  
 idfMonitoringSession = @idfMonitoringSession  
 and intRowStatus = 0  
Order By intOrder  

