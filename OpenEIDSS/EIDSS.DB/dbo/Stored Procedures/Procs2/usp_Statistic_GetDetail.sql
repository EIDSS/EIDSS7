
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_SelectDetail: V7 usp52
--                          Select data for StatisticDetail form from table:tlbStatistic,trtStatisticDataType
/*
----testing code:JL no data but fnreference does return data.
DECLARE @idfStatistic BIGINT, @LangID varchar(50)
----SET @idfStatistic = 73890000000
----EXECUTE usp_Statistic_GetDetail 73890000000, 'en'
EXECUTE usp_Statistic_GetDetail 19000076, 'ru'

*/

--=====================================================================================================
CREATE                  PROCEDURE [dbo].[usp_Statistic_GetDetail](
	@idfStatistic AS BIGINT, --##PARAM @idfStatistic - statistic record ID
	@LangID AS NVARCHAR(50) --##PARAM @LangID - languageID
)
AS

--0 Statistic
SELECT tlbStatistic.idfStatistic
      ,tlbStatistic.idfsStatisticDataType
      ,tlbStatistic.idfsMainBaseReference
      ,tlbStatistic.idfsStatisticAreaType
      ,tlbStatistic.idfsStatisticPeriodType
      ,tlbStatistic.idfsArea
      ,tlbStatistic.datStatisticStartDate
      ,tlbStatistic.datStatisticFinishDate
      ,Cast(tlbStatistic.varValue as bigint) as varValue
	  ,ParamType.name as strParameterType
	  ,sdt.idfsReferenceType
	  ,tlbStatistic.idfsStatisticalAgeGroup
	  ,sdt.blnRelatedWithAgeGroup
FROM tlbStatistic 
LEFT OUTER JOIN	trtStatisticDataType sdt
ON				sdt.[idfsStatisticDataType] = tlbStatistic.[idfsStatisticDataType]
LEFT OUTER JOIN	fnReference(@LangID, 19000076/*'rftReferenceTypeName'*/) ParamType
ON				ParamType.[idfsReference] = sdt.idfsReferenceType
WHERE tlbStatistic.idfStatistic = @idfStatistic
	AND tlbStatistic.intRowStatus = 0










