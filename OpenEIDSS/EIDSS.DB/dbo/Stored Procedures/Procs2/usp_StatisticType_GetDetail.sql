
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatisticType_SelectDetail:  V7 usp56
--                          purpose: select records from table:trtStatisticDataType
/*
----testing code:
exec usp_StatisticType_GetDetail 'en'
*/
--=====================================================================================================
CREATE              PROCEDURE [dbo].[usp_StatisticType_GetDetail](
	@LangID as NVARCHAR(50)
)
AS

SELECT  
	trtStatisticDataType.idfsStatisticDataType as idfsBaseReference,
	fnReferenceRepair.[strDefault],
	fnReferenceRepair.[name],
	trtBaseReference.blnSystem,
	fnReferenceRepair.intRowStatus,
	trtStatisticDataType.idfsReferenceType,
	trtStatisticDataType.idfsStatisticAreaType,
	trtStatisticDataType.idfsStatisticPeriodType,
	trtStatisticDataType.blnRelatedWithAgeGroup
FROM 
	trtStatisticDataType
LEFT JOIN 
	fnReferenceRepair(@LangID,19000090) ON--'rftStatisticDataType'
	fnReferenceRepair.idfsReference = trtStatisticDataType.idfsStatisticDataType
LEFT JOIN trtBaseReference ON 
	fnReferenceRepair.idfsReference = trtBaseReference.idfsBaseReference
WHERE 
	trtStatisticDataType.intRowStatus = 0


