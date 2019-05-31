
 
-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select Human case properties from different tables.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 14.07.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from dbo.fnRepGetVetCaseProperties ('ru')

*/


create Function [dbo].[fnRepGetVetCaseProperties]
(
	@LangID as nvarchar(50) = 'en'
)
Returns	 Table
AS
return
	select  
		tVetCase.idfVetCase AS idfCase,					
		tVetCase.strCaseID,
		
		tVetCase.strFieldAccessionID,	
		tVetCase.datInvestigationDate,	
		tVetCase.datEnteredDate,			
		tVetCase.datReportDate,			
		tVetCase.datAssignedDate,		
		dbo.fnSiteID()					as idfSiteID,
		dbo.fnConcatFullName(	tPersonEntered.strFamilyName, 
								tPersonEntered.strFirstName, 
								tPersonEntered.strSecondName)		as strEnteredName,
		dbo.fnConcatFullName(	tPersonInvestigated.strFamilyName, 
								tPersonInvestigated.strFirstName, 
								tPersonInvestigated.strSecondName)	as strInvestigationName,
		dbo.fnConcatFullName(	tPersonReported.strFamilyName, 
								tPersonReported.strFirstName, 
								tPersonReported.strSecondName)		as strReportedName,
		tFarm.idfFarm,					
		tFarm.strFarmCode,	
		tFarm.strNote,			
		tFarm.strNationalName,			
		dbo.fnConcatFullName(	tHuman.strLastName, 
								tHuman.strFirstName, 
								tHuman.strSecondName)			as strFarmerName,
		tFarm.strContactPhone,			
		tFarm.strFax,					
		tFarm.strEmail,		
		tFarmAddress.dblLongitude,
		tFarmAddress.dblLatitude,
		dbo.fnAddressString (@LangID,	tFarmAddress.idfGeoLocation)as strFarmLocation,
		rfFarmRegion.[name]				as strFarmRegion,
		rfFarmRayon.[name]				as strFarmRayon,
		rfFarmSettlement.[name]			as strSettlement,
		dbo.fnAddressString (@LangID,	tFarmAddress.idfGeoLocation) as strFarmAddress,
		tFarmAddress.idfGeoLocation		as idfFatmGeoLocation,
		tFarmAddress.idfsCountry		as idfsCountry,
		tFarmAddress.idfsRegion			as idfsRegion,
		tFarmAddress.idfsRayon			as idfsRayon,
		tFarmAddress.idfsSettlement		as idfsSettlement,
		tVetCase.idfOutbreak,
		tVetCase.idfsCaseClassification,
		tVetCase.idfsCaseType,
		tVetCase.idfsCaseProgressStatus,
		tVetCase.idfsCaseReportType,
		tVetCase.idfParentMonitoringSession
		
		
 

	from		dbo.tlbVetCase	as tVetCase

	-- Get Farm
	 left join	
	 (
		 dbo.tlbFarm		as tFarm
		-- Get Farm Owner
		left join	dbo.tlbHuman		as tHuman
				on	tHuman.idfHuman = tFarm.idfHuman
					AND tHuman.intRowStatus = 0
						   
		-- Get Farm Address
		 left join	
				(				dbo.tlbGeoLocation	as tFarmAddress
					inner join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfFarmRegion 
							on	rfFarmRegion.idfsReference = tFarmAddress.idfsRegion
					inner join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfFarmRayon 
							on	rfFarmRayon.idfsReference = tFarmAddress.idfsRayon
					 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfFarmSettlement
							on	rfFarmSettlement.idfsReference = tFarmAddress.idfsSettlement
				)
				on	tFarmAddress.idfGeoLocation = tFarm.idfFarmAddress
			   and  tFarmAddress.intRowStatus = 0
		)
		on	tVetCase.idfFarm = tFarm.idfFarm  and  
		    tFarm.intRowStatus = 0


			
	-- Get Person Entered By
	 left join	(
								dbo.tlbPerson	as tPersonEntered
					inner join	dbo.tlbEmployee as tEmployeeEntered
							on	tEmployeeEntered.idfEmployee = tPersonEntered.idfPerson
						   and  tEmployeeEntered.intRowStatus = 0
				)
			on	tPersonEntered.idfPerson = tVetCase.idfPersonEnteredBy
		   
	-- Get Person Reported By
	 left join	(
								dbo.tlbPerson as tPersonReported
					inner join	dbo.tlbEmployee as tEmployeeReported
							on	tEmployeeReported.idfEmployee = tPersonReported.idfPerson
						   and  tEmployeeReported.intRowStatus = 0
				)
			on	tPersonReported.idfPerson = tVetCase.idfPersonReportedBy
	-- Get Person Investigated By
	 left join	(
								dbo.tlbPerson as tPersonInvestigated
					inner join	dbo.tlbEmployee as tEmployeeInvestigated
							on	tEmployeeInvestigated.idfEmployee = tPersonInvestigated.idfPerson
						   and  tEmployeeInvestigated.intRowStatus = 0
				)
			on	tPersonInvestigated.idfPerson = tVetCase.idfPersonInvestigatedBy

	WHERE tVetCase.intRowStatus = 0
