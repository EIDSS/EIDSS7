

-- =============================================
-- Author:		Vasilyev I.
-- Create date: 
-- Description:
-- =============================================


--##SUMMARY Select Date and administrative uniot for aggregate case report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 08.12.2009

--##RETURNS Doesn't use

/*
--Example of a call of function:
select * from dbo.fnRepGetAggParams (51646510000000, 'ru') 
*/

create Function dbo.fnRepGetAggParams
(
	@idfActivity	as bigint,
	@LangID			as nvarchar(50) = 'en'
)
Returns Table
as
return
	
	select 
	(	
		ISNULL(rfCountry.[name],'') + ISNULL(rfRegion.[name],'') +
		ISNULL(rfRayon.[name],'') + ISNULL(rfSettlement.[name],'')
	)	as AdmUnitName,
	tAggr.datStartDate, 
	tAggr.datFinishDate,
	tAggr.idfAggrCase		as idfActivity,
	
	tAggr.strCaseID,
	tAggr.idfsAdministrativeUnit,
	
	CASE 
         WHEN rfCountry.idfsReference IS not null THEN 19000001
         WHEN rfRegion.idfsReference IS not null THEN 19000003
         WHEN rfRayon.idfsReference IS not null THEN 19000002
         WHEN rfSettlement.idfsReference IS not null THEN 19000004
         ELSE 0
    END		as idfsAdmUnitType
	
	from		dbo.tlbAggrCase as tAggr
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfCountry 
			on	rfCountry.idfsReference = tAggr.idfsAdministrativeUnit
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfRegion 
			on	rfRegion.idfsReference = tAggr.idfsAdministrativeUnit
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfRayon 
			on	rfRayon.idfsReference = tAggr.idfsAdministrativeUnit
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfSettlement
			on	rfSettlement.idfsReference = tAggr.idfsAdministrativeUnit
		 where	tAggr.idfAggrCase = @idfActivity
		   and	tAggr.intRowStatus = 0

