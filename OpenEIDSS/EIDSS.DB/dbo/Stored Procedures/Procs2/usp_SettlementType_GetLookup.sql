
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/07/2017
-- Last modified by:		Joan Li
-- Description:				06/07/2017:Created based on V6 spSettlementType_SelectLookup: rename for V7 USP49
--                          Select lookup data from tables: gisBaseReference;gisStringNameTranslation
--     
-- Testing code:
/*
----testing code:
exec usp_SettlementType_GetLookup 'en'
*/
--=====================================================================================================

CREATE        PROCEDURE [dbo].[usp_SettlementType_GetLookup]
	@LangID nvarchar(50) --##PARAM @LangID - language ID
AS
SELECT	
	gisBaseReference.idfsGISBaseReference AS idfsReference, 
	isnull(gisStringNameTranslation.strTextString, gisBaseReference.strDefault) AS [name],
	gisBaseReference.intRowStatus
FROM dbo.gisBaseReference 
LEFT JOIN gisStringNameTranslation  ON 
	gisBaseReference.idfsGISBaseReference = gisStringNameTranslation.idfsGISBaseReference
 	AND gisStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	AND gisStringNameTranslation.intRowStatus = 0
WHERE	
	 gisBaseReference.idfsGISReferenceType = 19000005 --'SettlementType'
ORDER BY intOrder, [name]



