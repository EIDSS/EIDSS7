

--=====================================================================
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				checking and testing for EIDSS7 usp50
--                          Selects list of statistic records for StatisticList form from tlbStatistic
--                          delete block code from V6
-- Testing code:
/*
SELECT * FROM fn_Statistic_SelectList('ru')
*/
--=====================================================================

CREATE                      Function	[dbo].[fn_Statistic_SelectList](
		@LangID as nvarchar(50)--##PARAM @LangID - language ID
)
returns table
as
return
select			tlbStatistic.idfStatistic,
				tlbStatistic.idfsStatisticDataType,
				tlbStatistic.[idfsStatisticAreaType],
				tlbStatistic.[idfsStatisticalAgeGroup],
				StatisticalAgeGroup.name as strStatisticalAgeGroup,
				DataType.[strDefault] as defDataTypeName,
				Cast(tlbStatistic.[varValue] as float) as [varValue],
				tlbStatistic.[idfsMainBaseReference],
				tlbStatistic.[idfsStatisticPeriodType],
				tlbStatistic.[idfsArea],
				tlbStatistic.datStatisticStartDate,
				DataType.[name] as setnDataTypeName,
				ParamType.[name] as ParameterType,
				ParamType.[idfsReference] AS idfsParameterType, 
				Main.[strDefault] as defParameterName,
				IsNull(cMain.strTextString, Main.strDefault) as setnParameterName,
				Main.idfsBaseReference AS idfsParameterName,
				AreaType.[strDefault] as defAreaTypeName,
				AreaType.[name] as setnAreaTypeName,
				PeriodType.[strDefault] as defPeriodTypeName,
				PeriodType.[name] as setnPeriodTypeName,
				Area.idfsCountry,
				Area.idfsRegion,
				Area.idfsRayon,
				Area.idfsSettlement,
				Area.strAreaName  as setnArea

from			tlbStatistic

left outer join	fnReferenceRepair(@LangID, 19000090/*'rftStatisticDataType'*/) DataType
on				DataType.[idfsReference] = tlbStatistic.[idfsStatisticDataType]
left outer join	fnReferenceRepair(@LangID, 19000089/*'rftStatisticAreaType'*/) AreaType
on				AreaType.[idfsReference] = tlbStatistic.[idfsStatisticAreaType]
left outer join	fnReferenceRepair(@LangID, 19000091/*'rftStatisticPeriodType'*/) PeriodType
on				PeriodType.[idfsReference] = tlbStatistic.[idfsStatisticPeriodType]
left outer join	trtStatisticDataType sdt
on				sdt.[idfsStatisticDataType] = tlbStatistic.[idfsStatisticDataType]
left outer join	trtReferenceType rt
on				rt.idfsReferenceType = sdt.idfsReferenceType
left outer join	fnReferenceRepair(@LangID, 19000076/*'rftReferenceTypeName'*/) ParamType
on				ParamType.[idfsReference] = rt.idfsReferenceType
left outer join	fnReferenceRepair(@LangID, 19000145/*'rftStatisticalAgeGroup'*/) StatisticalAgeGroup
on				StatisticalAgeGroup.[idfsReference] = tlbStatistic.[idfsStatisticalAgeGroup]
left outer join	(
	dbo.trtBaseReference as Main 
	left join	dbo.trtStringNameTranslation as cMain 
	on			Main.idfsBaseReference = cMain.idfsBaseReference
				and cMain.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
				)
on				Main.idfsBaseReference = tlbStatistic.[idfsMainBaseReference]
				and IsNull(Main.intRowStatus, 0) = 0
left outer join vwAreaInfo Area 
on				Area.idfsArea = tlbStatistic.[idfsArea]
				and Area.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

WHERE 
	tlbStatistic.intRowStatus = 0

