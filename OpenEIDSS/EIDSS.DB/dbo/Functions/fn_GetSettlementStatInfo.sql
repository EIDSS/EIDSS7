
-- =============================================
-- tkobilov: Get settlement info
-- =============================================
CREATE function [dbo].[fn_GetSettlementStatInfo](
		@LangID as nvarchar(50),--##PARAM @LangID - language ID
		@idfsGeoObject as BigInt
)
RETURNS TABLE
AS RETURN
SELECT 		 
		RayonTable.strSettlement, 
		RayonTable.strRayon,
		gisStringNameTranslation.strTextString as strRegion 
FROM
(SELECT 
		SttTable.idfsSettlement, 
		SttTable.idfsRayon, 
		SttTable.idfsRegion, 
		SttTable.strTextString as strSettlement, 
		gisStringNameTranslation.strTextString as strRayon 
FROM
(SELECT idfsSettlement, idfsRayon, idfsRegion, strTextString FROM gisSettlement 
INNER JOIN gisStringNameTranslation ON idfsGISBaseReference=idfsSettlement
WHERE idfsSettlement=@idfsGeoObject AND idfsLanguage=@LangID) as SttTable
INNER JOIN gisStringNameTranslation ON idfsGISBaseReference=idfsRayon
WHERE idfsLanguage=@LangID) as RayonTable
INNER JOIN gisStringNameTranslation ON idfsGISBaseReference=idfsRegion
WHERE idfsLanguage=@LangID
