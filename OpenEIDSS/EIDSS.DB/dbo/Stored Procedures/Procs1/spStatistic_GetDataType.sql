
--##SUMMARY Selects statistic parameters for specific statistic data Type

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 26.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

DECLARE @idfsStatisticDataType BIGINT
EXECUTE spStatistic_GetDataType @idfsStatisticDataType

*/



CREATE                  PROCEDURE dbo.spStatistic_GetDataType(
	@idfsStatisticDataType AS BIGINT --##PARAM @idfsStatisticDataType - Statistic Data Type
)
AS
SELECT 
       idfsReferenceType
      ,idfsStatisticAreaType
      ,idfsStatisticPeriodType
	  ,blnRelatedWithAgeGroup
  FROM trtStatisticDataType
WHERE idfsStatisticDataType = @idfsStatisticDataType





