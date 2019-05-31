

--##SUMMARY Selects lookup list of settlement types.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
exec spSettlementType_SelectLookup 'en'
*/

CREATE        PROCEDURE dbo.spSettlementType_SelectLookup
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


