

--##SUMMARY Select Date and admin unit list for aggregate report.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 03.12.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

exec spRepGetAggSumParamAdmUnit 
'<?xml version="1.0" encoding="UTF-16"?><ROOT><AdminLevel AreaType="satCountry"><AdminUnit AdminUnitID="170000000" /></AdminLevel><TimeInterval PeriodType="sptYear"><TimeIntervalUnit StartDate="2009-01-01" FinishDate="2009-12-31" /><TimeIntervalUnit StartDate="2008-01-01" FinishDate="2008-12-31" /></TimeInterval></ROOT>', 
'ru'

*/

create  Procedure [dbo].[spRepGetAggSumParamAdmUnit]
	(
	    @AggrXml nvarchar(4000),
	    @LangID NVARCHAR(36)
	)
AS	
	declare @idoc int
	exec sp_xml_preparedocument @idoc OUTPUT, @AggrXml

	 SELECT
	 (	
		ISNULL(rfCountry.[name],'') + ISNULL(rfRegion.[name],'') +
		ISNULL(rfRayon.[name],'') + ISNULL(rfSettlement.[name],'')
	 )	AS AdmUnitName,
	 
	rfAdmUnitType.name as AdmUnitType
	
	 
	 FROM		OPENXML (@idoc, '/ROOT/AdminLevel/AdminUnit', 1)
				WITH	(AdminUnitID  bigint)
 	 left join	fnGisReference(@LangID, 19000001 /*'rftCountry'*/) rfCountry 
			on	rfCountry.idfsReference = AdminUnitID
	 left join	fnGisReference(@LangID, 19000003 /*'rftRegion'*/)  rfRegion 
			on	rfRegion.idfsReference = AdminUnitID
	 left join	fnGisReference(@LangID, 19000002 /*'rftRayon'*/)   rfRayon 
			on	rfRayon.idfsReference = AdminUnitID
	 left join	fnGisReference(@LangID, 19000004 /*'rftSettlement'*/) rfSettlement
			on	rfSettlement.idfsReference = AdminUnitID
			
	 left join  fnReferenceRepair(@LangID, 19000089) rfAdmUnitType
	 on rfAdmUnitType.idfsReference =
	
				case
					   when rfCountry.idfsReference is not null  then 10089001
					   when rfRegion.idfsReference is not null  then 10089003
					   when rfRayon.idfsReference is not null  then 10089002
					   when rfSettlement.idfsReference is not null  then 10089004
					   else -1
				end 

	exec sp_xml_removedocument @idoc



