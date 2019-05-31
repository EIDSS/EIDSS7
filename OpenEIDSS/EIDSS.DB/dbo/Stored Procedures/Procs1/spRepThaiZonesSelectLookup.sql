
/*
 exec [spRepThaiZonesSelectLookup] 'ru'
*/


create procedure [dbo].[spRepThaiZonesSelectLookup]
(
	@LangID nvarchar(50)
)
as
begin
	select distinct
		 tbr.idfsBaseReference 
		,ISNULL(ZoneName.name, ZoneName.strDefault) as [name]
		,ZoneName.strDefault as strDefault
		,case when isnumeric(tbr.strBaseReferenceCode) = 1 then cast(tbr.strBaseReferenceCode as int) else 0 end as intOrder
	
	from [dbo].[trtBaseReference] tbr
		inner join dbo.fnReference(@LangID, 19000132) ZoneName 
		on tbr.idfsBaseReference = ZoneName.idfsReference
		
		inner join trtGISBaseReferenceAttribute tgra
			inner join trtAttributeType tat
			on tat.idfAttributeType = tgra.idfAttributeType
			and tat.strAttributeTypeName = 'ThaiZones'
		on cast(tgra.varValue as bigint) = tbr.idfsBaseReference
	
	where tbr.intRowStatus = 0
	order by case when isnumeric(tbr.strBaseReferenceCode) = 1 then cast(tbr.strBaseReferenceCode as int) else 0 end
	
end
