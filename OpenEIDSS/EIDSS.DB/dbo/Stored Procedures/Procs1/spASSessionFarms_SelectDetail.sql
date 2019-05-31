
  
/************************************************************  
* spASSessionFarms_SelectDetail.proc  
************************************************************/  
  
  
--##SUMMARY Selects data for Active Surveillance Monitoring Session form  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 17.06.2010  

--##RETURNS Doesn't use  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=706800000000  
EXECUTE spASSessionFarms_SelectDetail   
 @idfMonitoringSession  
  
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spASSessionFarms_SelectDetail](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
 --,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  

--0 Farms  
SELECT idfFarm  
   ,tlbFarm.idfFarmActual as idfRootFarm  
    ,strFarmCode  
    ,strNationalName  
    ,dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName ,tlbHuman.strSecondName) as strOwnerName  
    ,idfsOwnershipStructure  
    ,idfsLivestockProductionType  
   ,@idfMonitoringSession as idfMonitoringSession 
   ,CAST (0 AS bit) AS blnNewFarm  
   ,isnull(CAST ((select COUNT(*) from tlbFarm i where i.idfFarm = tlbFarm.idfFarm and i.idfMonitoringSession = @idfMonitoringSession and i.intRowStatus = 0) AS bit),0) AS blnIsDetailsFarm
   ,isnull(CAST ((select COUNT(*) from tlbMonitoringSessionSummary i where i.idfFarm = tlbFarm.idfFarm and i.idfMonitoringSession = @idfMonitoringSession and i.intRowStatus = 0) AS bit),0) AS blnIsSummaryFarm
   ,tlbFarm.idfHuman AS idfOwner
FROM tlbFarm  
LEFT OUTER JOIN tlbHuman   
 on tlbHuman.idfHuman=tlbFarm.idfHuman and  
    tlbHuman.intRowStatus = 0  
WHERE  
 tlbFarm.idfFarm in (
	select distinct idfFarm from 
		(
			select idfFarm 
			from tlbFarm 
			where tlbFarm.idfMonitoringSession = @idfMonitoringSession
			and tlbFarm.intRowStatus = 0
			union all 
			select idfFarm 
			from  tlbMonitoringSessionSummary
			where tlbMonitoringSessionSummary.idfMonitoringSession = @idfMonitoringSession
			and tlbMonitoringSessionSummary.intRowStatus = 0
		) f
	)
 and tlbFarm.intRowStatus = 0  
   
  
