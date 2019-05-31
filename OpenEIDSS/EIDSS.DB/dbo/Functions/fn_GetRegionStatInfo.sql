
-- =============================================
-- tkobilov: 
-- Get agregated region info from statistic table
-- =============================================

CREATE function fn_GetRegionStatInfo(
		@LangID as nvarchar(50),--##PARAM @LangID - language ID
		@idfsGeoObject as BigInt --##PARAM @idfsGeoObject - object idfs
)
RETURNS TABLE
AS RETURN
SELECT strAreaName as strName, varValue as varPopulation, geomShape.STArea()/1000000 as varArea FROM
	(SELECT idfsRegion, SUM(varValue) as varValue FROM
		(SELECT idfsRegion, idfsRayon, varValue FROM
			(SELECT GroupTbl.idfsArea,varValue FROM
				(SELECT idfsArea, MAX(datStatisticStartDate) as statDate
				FROM fn_Statistic_SelectList(@LangID)
				WHERE idfsStatisticAreaType = 10089002 -- RAYONS
				GROUP BY idfsArea) AS GroupTbl
			INNER JOIN fn_Statistic_SelectList(10049003) AS StatTbl
			ON StatTbl.idfsArea=GroupTbl.idfsArea AND StatTbl.datStatisticStartDate=GroupTbl.statDate) AS RayonValTbl
		RIGHT JOIN gisRayon ON RayonValTbl.idfsArea=gisRayon.idfsRayon) AS RayonRegionValTbl
	GROUP BY idfsRegion) AS RegionValTbl
INNER JOIN vwAreaInfo ON idfsArea=idfsRegion AND idfsLanguage=@LangID
INNER JOIN gisWKBRegion ON idfsRegion=idfsGeoObject
WHERE idfsRegion=@idfsGeoObject

