
  
/************************************************************  
* spASCampaign_SelectDetail.proc  
************************************************************/  
  
  
--##SUMMARY Selects data for Active Surveillance Campaign form  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 10.06.2010  
  
--##RETURNS Doesn't use  
  
--##REMARKS Updated: Zolotareva N.
--##REMARKS Update date: 16.11.2011


--##REMARKS Updated: Romasheva S.
--##REMARKS Update date: 05.08.2013 
  
/*  
--Example of procedure call:  
DECLARE @idfCampaign bigint  
set @idfCampaign = 12666940000000
EXECUTE spASCampaign_SelectDetail   
 @idfCampaign  
 ,'en'  
  
*/  
  
  

create         PROCEDURE dbo.spASCampaign_SelectDetail(  
 @idfCampaign AS bigint--##PARAM @idfCampaign - campaign ID  
 ,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  

declare @idfsSiteID bigint
declare @isWebAccess bit
select @idfsSiteID = dbo.fnSiteID()
select @isWebAccess = dbo.fnIsWebAccess()

select @isWebAccess = case
 when idfsSiteType <> 10085007 -- not TLVL
  then 0
 else @isWebAccess
end
from tstSite
where idfsSite = @idfsSiteID


-- 0- Campaign  
SELECT idfCampaign  
      ,idfsCampaignType  
      ,idfsCampaignStatus  
      ,datCampaignDateStart  
      ,datCampaignDateEnd  
      ,strCampaignID  
      ,strCampaignName  
      ,strCampaignAdministrator  
      ,strComments  
      ,strConclusion  
	  ,datModificationForArchiveDate
FROM tlbCampaign  
WHERE  
 idfCampaign = @idfCampaign  
 and intRowStatus = 0  
  
--1 Diagnosis  
  
SELECT idfCampaignToDiagnosis  
      ,idfCampaign  
      ,idfsDiagnosis -- this diagnosis can be changed during editing and we post is as changeable value  
      ,intOrder
      ,idfsSpeciesType
      ,intPlannedNumber 
      ,idfsSampleType
  FROM tlbCampaignToDiagnosis  
WHERE  
 idfCampaign = @idfCampaign  
 and intRowStatus = 0  
Order By intOrder  
  
--2 Sessions  
--Declare @strDisease nvarchar(max)  
--select @strDisease = ''  
--Declare @strDiseaseOne nvarchar(200)  
  
  
--DECLARE crDiagnosis Cursor FOR  
-- SELECT   
--  Diagnosis.[name]  
-- FROM tlbMonitoringSessionToDiagnosis  
-- INNER JOIN tlbMonitoringSession  
--  ON tlbMonitoringSession.idfMonitoringSession = tlbMonitoringSessionToDiagnosis.idfMonitoringSession  
-- LEFT JOIN fnReference(@LangID,19000019) [Diagnosis]  
--  ON [Diagnosis].idfsReference = tlbMonitoringSessionToDiagnosis.idfsDiagnosis  
-- WHERE  
--  idfCampaign = @idfCampaign  
--  and tlbMonitoringSession.intRowStatus = 0  
--  and tlbMonitoringSessionToDiagnosis.intRowStatus = 0  
-- Order By tlbMonitoringSessionToDiagnosis.intOrder  
  
--OPEN crDiagnosis  
--FETCH NEXT FROM crDiagnosis into @strDiseaseOne  
--WHILE @@FETCH_STATUS = 0   
--BEGIN  
-- select @strDisease = @strDisease + @strDiseaseOne + ', '  
-- FETCH NEXT FROM crDiagnosis INTO  @strDiseaseOne  
--END --crDiagnosis cursor end  
--CLOSE crDiagnosis  
--DEALLOCATE crDiagnosis  
  
--if @strDisease <> ''  
-- Select @strDisease = substring(@strDisease, 1, len(@strDisease)-2)  
  
  
SELECT ms.idfMonitoringSession  
      ,[Status].name as strStatus  
      ,Region.name as strRegion  
      ,Rayon.name as strRayon  
      ,Settlement.name as strSettlement  
      ,ms.datEnteredDate  
      ,ms.strMonitoringSessionID  
      ,ms.datStartDate
      ,ms.datEndDate
   --,@strDisease as strDisease
   ,[diagnosis].strDiagnosis as strDisease
   ,ms.idfCampaign  
FROM tlbMonitoringSession ms
left join tflMonitoringSessionFiltered tmsf
	join tflSiteToSiteGroup tstsg on tstsg.idfSiteGroup = tmsf.idfSiteGroup and tstsg.idfsSite = @idfsSiteID
on tmsf.idfMonitoringSession = ms.idfMonitoringSession
--and tmsf.idfsSite = @idfsSiteID
  
LEFT JOIN fnGisReference(@LangID,19000003) Region  
 ON Region.idfsReference = ms.idfsRegion  
LEFT JOIN fnGisReference(@LangID,19000002) Rayon  
 ON Rayon.idfsReference = ms.idfsRayon  
LEFT JOIN fnGisReference(@LangID,19000004) Settlement  
 ON Settlement.idfsReference = ms.idfsSettlement  
LEFT JOIN fnReference(@LangID,19000117) [Status]  
 ON [Status].idfsReference = ms.idfsMonitoringSessionStatus  
left join dbo.fnASCampain_GetDiagnosisString('en') [diagnosis]
on [diagnosis].idfCampaign = ms.idfCampaign
WHERE  
 ms.idfCampaign = @idfCampaign  
 and ms.intRowStatus = 0  
 and (@isWebAccess = 0 or NOT tmsf.idfMonitoringSession is NULL)
  
  
