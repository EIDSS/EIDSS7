
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_GetDataType:  V7 usp58
--                          purpose: select records from table: trtStatisticDataType
/*
----testing code:
DECLARE @idfsStatisticDataType BIGINT
EXECUTE usp_Statistic_GetDataType @idfsStatisticDataType=840900000000
*/
--=====================================================================================================

CREATE                  PROCEDURE [dbo].[usp_Statistic_GetDataType](
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


