

--##SUMMARY 
--##REMARKS Author: 
--##REMARKS Create date:
--##RETURNS Doesn't use

/*
--Example of a call of procedure:
exec [spRepASSessionActions]  88200000241, 'ru'
*/

create  Procedure [dbo].[spRepASSessionActions]
	(
		@idfCase bigint,
		@LangID nvarchar(20)
	)
AS	


select  idfMonitoringSessionAction	as	idfsKey,
		msat.name					as	strAction,
		datActionDate				as	datDate,
		dbo.fnConcatFullName(p.strFamilyName,p.strFirstName, p.strSecondName)  as	strEnteredBy,
		strComments					as	strComment,
		msas.name					as	strStatus
		 
from tlbMonitoringSessionAction  a 
	inner join tlbPerson p
	on a.idfPersonEnteredBy = p.idfPerson
	
	inner join	dbo.fnReferenceRepair(@LangID,19000127) as msat --rftMonitoringSessionActionType
	on			msat.idfsReference = a.idfsMonitoringSessionActionType
		
	inner join	dbo.fnReferenceRepair(@LangID,19000128) as msas --rftMonitoringSessionActionStatus
	on			msas.idfsReference = a.idfsMonitoringSessionActionStatus
	
WHERE  
 idfMonitoringSession = @idfCase  
 and a.intRowStatus = 0  		 
		 
		 
		 
