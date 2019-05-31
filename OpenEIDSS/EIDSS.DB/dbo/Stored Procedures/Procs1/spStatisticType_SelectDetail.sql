








--exec spStatisticType_SelectDetail 'en'




CREATE              PROCEDURE dbo.spStatisticType_SelectDetail(
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








