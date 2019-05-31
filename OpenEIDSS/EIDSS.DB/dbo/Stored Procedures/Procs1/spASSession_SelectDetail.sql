
  
/************************************************************  
* spASSession_SelectDetail.proc  
************************************************************/  
  
  
--##SUMMARY Selects data for Active Surveillance Monitoring Session form  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 17.06.2010  

--##REMARKS Updated: Zolotareva N.  
--##REMARKS Update date: 21.11.2011  
--##REMARKS Added start and end dates
  
--##RETURNS Doesn't use  
  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=706800000000  
EXECUTE spASSession_SelectDetail   
 @idfMonitoringSession  
  
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spASSession_SelectDetail](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
 --,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  
-- 0- Session  
SELECT idfMonitoringSession  
      ,tlbMonitoringSession.idfsMonitoringSessionStatus  
      ,tlbMonitoringSession.idfsCountry  
      ,tlbMonitoringSession.idfsRegion  
      ,tlbMonitoringSession.idfsRayon  
      ,tlbMonitoringSession.idfsSettlement  
      ,tlbMonitoringSession.idfPersonEnteredBy  
      ,tlbMonitoringSession.idfCampaign  
      ,tlbMonitoringSession.idfsSite  
      ,tlbMonitoringSession.datEnteredDate  
      ,tlbMonitoringSession.strMonitoringSessionID  
      ,tlbMonitoringSession.datStartDate
      ,tlbMonitoringSession.datEndDate
	  ,convert(uniqueidentifier, tlbMonitoringSession.strReservedAttribute) as uidOfflineCaseID
      ,tlbCampaign.strCampaignID  
      ,tlbCampaign.strCampaignName  
      ,tlbCampaign.idfsCampaignType  
      ,tlbCampaign.datCampaignDateStart  
      ,tlbCampaign.datCampaignDateEnd  
	  ,tlbMonitoringSession.datModificationForArchiveDate
   
  FROM tlbMonitoringSession  
LEFT JOIN tlbCampaign  
 ON tlbCampaign.idfCampaign = tlbMonitoringSession.idfCampaign  
WHERE  
 tlbMonitoringSession.idfMonitoringSession = @idfMonitoringSession  
 and tlbMonitoringSession.intRowStatus = 0  
  
--1 Diagnosis  
EXEC spAsSession_SelectDiagnosis  @idfMonitoringSession    
  
--2 Farms  
SELECT idfFarm  
   ,tlbFarm.idfFarmActual as idfRootFarm  
    ,strFarmCode  
    ,strNationalName  
    ,dbo.fnConcatFullName(tlbHuman.strLastName ,tlbHuman.strFirstName ,tlbHuman.strSecondName) as strOwnerName  
    ,idfsOwnershipStructure  
    ,idfsLivestockProductionType  
   ,tlbFarm.idfMonitoringSession 
   ,CAST (0 AS bit) AS blnNewFarm  
FROM tlbFarm  
LEFT OUTER JOIN tlbHuman   
 on tlbHuman.idfHuman=tlbFarm.idfHuman and  
    tlbHuman.intRowStatus = 0  
WHERE  
 tlbFarm.idfMonitoringSession = @idfMonitoringSession  
 and tlbFarm.intRowStatus = 0  
   
--3 Farm Tree  
EXEC spASFarmTree_SelectDetail @idfMonitoringSession  
  
--4 Animals  
EXEC spASSessionAnimals_SelectDetail @idfMonitoringSession  
--5 Actions  
EXECUTE spAsSessionAction_SelectDetail @idfMonitoringSession  
  
  
