
/*
 exec [spRepThaiCaseClassificationSelectLookup] 'ru'
*/


create procedure [dbo].[spRepThaiCaseClassificationSelectLookup]
(
	@LangID nvarchar(50)
)
as
begin
	select 
		 CC.[idfsCaseClassification] 
		,ISNULL(CCName.name, CCName.strDefault) as [name]
		,CCName.strDefault as strDefault
		,CCName.intHACode
		,case CCName.intHACode & 2 when  2 then CAST(1 as bit) else CAST(0 as bit) end as blnIsHuman
		,case CCName.intHACode & 32 when  32 then CAST(1 as bit) else CAST(0 as bit) end as blnIsLivestock
		,case CCName.intHACode & 64 when  64 then CAST(1 as bit) else CAST(0 as bit) end as blnIsAvian
		,ISNULL(CC.[blnInitialHumanCaseClassification], CAST(0 as bit)) as blnInitialHumanCaseClassification
		,ISNULL(CC.[blnFinalHumanCaseClassification], CAST(0 as bit)) as blnFinalHumanCaseClassification

	
	from [dbo].[trtCaseClassification] CC
	inner join dbo.fnReference(@LangID, 19000011) CCName On CC.[idfsCaseClassification] = CCName.idfsReference
	left join dbo.trtHACodeList HACodeList on CCName.intHACode = HACodeList.intHACode
	where CC.intRowStatus = 0 
end
