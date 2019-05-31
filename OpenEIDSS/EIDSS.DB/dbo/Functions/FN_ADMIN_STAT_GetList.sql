
--=====================================================================
-- LASt modified date:		06/13/2017
-- LASt modified by:		Joan Li
-- Description:				checking and testing for EIDSS7 usp50
--                          Selects list of statistic records for StatisticList form from tlbStatistic
--                          delete block code from V6
-- Last modified date:		06/11/2018
-- Last modified by:		Maheshwar Deo
-- Description:				Added date formatting
-- Testing code:
/*
SELECT * FROM fn_Statistic_SelectList('ru')
*/
--=====================================================================

CREATE Function	[dbo].[FN_ADMIN_STAT_GetList]
(
	@LangID AS nvarchar(50)--##PARAM @LangID - language ID
)
RETURNS TABLE
AS
	RETURN
	SELECT	tlbStatistic.idfStatistic,
			tlbStatistic.idfsStatisticDataType,
			tlbStatistic.[idfsStatisticAreaType],
			tlbStatistic.[idfsStatisticalAgeGroup],
			StatisticalAgeGroup.NAME AS strStatisticalAgeGroup,
			DataType.[strDefault] AS defDataTypeName,
			CAST(tlbStatistic.[varValue] AS FLOAT) AS [varValue],
			tlbStatistic.[idfsMainBASeReference],
			tlbStatistic.[idfsStatisticPeriodType],
			tlbStatistic.[idfsArea],
			dbo.FN_GBL_FormatDate(tlbStatistic.datStatisticStartDate, 'mm/dd/yyyy') As datStatisticStartDate,
			DataType.[name] AS setnDataTypeName,
			ParamType.[name] AS ParameterType,
			ParamType.[idfsReference] AS idfsParameterType, 
			Main.[strDefault] AS defParameterName,
			ISNULL(cMain.strTextString, Main.strDefault) AS setnParameterName,
			Main.idfsBASeReference AS idfsParameterName,
			AreaType.[strDefault] AS defAreaTypeName,
			AreaType.[name] AS setnAreaTypeName,
			PeriodType.[strDefault] AS defPeriodTypeName,
			PeriodType.[name] AS setnPeriodTypeName,
			Area.idfsCountry,
			Area.idfsRegion,
			Area.idfsRayon,
			Area.idfsSettlement,
			Area.strAreaName  AS setnArea
	FROM	tlbStatistic
	LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000090/*'rftStatisticDataType'*/) DataType
	ON				DataType.[idfsReference] = tlbStatistic.[idfsStatisticDataType]
	LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000089/*'rftStatisticAreaType'*/) AreaType
	ON				AreaType.[idfsReference] = tlbStatistic.[idfsStatisticAreaType]
	LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000091/*'rftStatisticPeriodType'*/) PeriodType
	ON				PeriodType.[idfsReference] = tlbStatistic.[idfsStatisticPeriodType]
	LEFT OUTER JOIN 	trtStatisticDataType sdt
	ON				sdt.[idfsStatisticDataType] = tlbStatistic.[idfsStatisticDataType]
	LEFT OUTER JOIN trtReferenceType rt
	ON				rt.idfsReferenceType = sdt.idfsReferenceType
	LEFT OUTER JOIN fnReferenceRepair(@LangID, 19000076/*'rftReferenceTypeName'*/) ParamType
	ON				ParamType.[idfsReference] = rt.idfsReferenceType
	LEFT OUTER JOIN 	fnReferenceRepair(@LangID, 19000145/*'rftStatisticalAgeGroup'*/) StatisticalAgeGroup
	ON				StatisticalAgeGroup.[idfsReference] = tlbStatistic.[idfsStatisticalAgeGroup]
	LEFT OUTER JOIN (
						dbo.trtBASeReference AS Main 
						LEFT JOIN dbo.trtStringNameTranslation AS cMain 
						ON			Main.idfsBASeReference = cMain.idfsBASeReference
							AND		cMain.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
					)
	ON				Main.idfsBASeReference = tlbStatistic.[idfsMainBASeReference]
					and ISNULL(Main.intRowStatus, 0) = 0
	LEFT OUTER JOIN vwAreaInfo Area 
	ON				Area.idfsArea = tlbStatistic.[idfsArea]
					and Area.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	WHERE tlbStatistic.intRowStatus = 0
