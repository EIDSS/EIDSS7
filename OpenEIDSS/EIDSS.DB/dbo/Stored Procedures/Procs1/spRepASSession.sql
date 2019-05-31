

--##SUMMARY Selects monitoring session details for report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 20.07.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
exec spRepASSession  5410000870, 'en'
*/



create  Procedure [dbo].[spRepASSession]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	


select   
			--- todo: implement
			 ms.idfMonitoringSession
			,ms.strMonitoringSessionID		as strSessionID
			,sstatus.name					as strSessionStatus
			,ms.datEnteredDate				as datEnteredDate

			,tc.strCampaignID				as strCampaignID
			,tc.strCampaignName				as strCampaignName
			,ctype.name						as strCampaignType

			,ts.strSiteName					as strSite
			,dbo.fnConcatFullName(tp.strFamilyName, tp.strFirstName, tp.strSecondName)								
											as strOfficer
			,ms.datStartDate				as datStartDate
			,ms.datEndDate					as datEndDate
			
			,reg.name						as strRegion
			,ms.idfsRegion					as idfsRegion
			,ray.name						as strRayon
			,ms.idfsRayon					as idfsRayon
			,town.name						as strSettlement
			,ms.idfsSettlement				as idfsSettlement
			
	
from		tlbMonitoringSession ms

left join tlbCampaign tc
	left join	dbo.fnReferenceRepair(@LangID,19000116) ctype --rftMonitoringSessionStatus
	on			ctype.idfsReference = tc.idfsCampaignType
on tc.idfCampaign = ms.idfCampaign
and tc.intRowStatus = 0

left join	fnGisReference(@LangID,19000003) reg
on			reg.idfsReference = ms.idfsRegion

left join	fnGisReference(@LangID,19000002) ray
on			ray.idfsReference = ms.idfsRayon

left join	fnGisReference(@LangID,19000004) town
on			town.idfsReference = ms.idfsSettlement

left join	fnReference(@LangID,19000117) sstatus --rftMonitoringSessionStatus
on			sstatus.idfsReference = ms.idfsMonitoringSessionStatus

left join tstSite ts
on ts.idfsSite = ms.idfsSite

left join tlbPerson tp
on tp.idfPerson = ms.idfPersonEnteredBy
	
where		ms.idfMonitoringSession = @idfCase
and			ms.intRowStatus = 0
	

