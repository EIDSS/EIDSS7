
-- =============================================
-- tkobilov: Get rayon info from statistic table
-- =============================================

CREATE function fn_GetRayonStatInfo(
		@LangID as nvarchar(50),--##PARAM @LangID - language ID
		@idfsGeoObject as BigInt --##PARAM @idfsGeoObject - object idfs
)
RETURNS TABLE
AS RETURN
SELECT strAreaName as strName, Table1.varArea, Table1.varPopulation FROM
(SELECT TOP 1 * FROM
(SELECT idfsGeoObject, StatTable.datStatisticStartDate, StatTable.strName as strName1, StatTable.varPopulation, geomShape.STArea()/1000000 as varArea FROM
(SELECT idfsArea, setnArea as strName, varValue as varPopulation, datStatisticStartDate	
FROM fn_Statistic_SelectList(@LangID) -- PARAM: current language id
WHERE idfsStatisticAreaType=10089002 AND idfsStatisticDataType=39850000000) as StatTable 
RIGHT JOIN gisWKBRayon ON StatTable.idfsArea=idfsGeoObject) AS JoinedTable
WHERE idfsGeoObject = @idfsGeoObject
ORDER BY datStatisticStartDate DESC) AS Table1
INNER JOIN vwAreaInfo ON idfsArea=idfsGeoObject AND idfsLanguage=@LangID
