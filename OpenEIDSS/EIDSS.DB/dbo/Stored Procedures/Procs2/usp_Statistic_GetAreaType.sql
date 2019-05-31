
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_GetAreaType:  V7 usp57
--                          purpose: select records from table:gisCountry,gisRegion,gisRayon,gisSettlement
/*
----testing code:
DECLARE @Area BIGINT
EXECUTE usp_Statistic_GetAreaType 170000000 -----@Area
select * from   gisCountry -----170000000
*/
--=====================================================================================================

CREATE                  PROCEDURE [dbo].[usp_Statistic_GetAreaType](
	@Area AS BIGINT --##PARAM @Area - Area ID (should point to Country, Region, Rayon or Settlement)
)
AS

if exists (select * from gisCountry where idfsCountry = @Area AND intRowStatus = 0)  
	select c.idfsCountry, null as idfsRegion, null as idfsRayon, null as idfsSettlement, 10089001 as AreaType  
	from   gisCountry c  
	where  c.idfsCountry = @Area  
else if exists (select * from gisRegion where idfsRegion = @Area AND intRowStatus = 0)  
	select r.idfsCountry, r.idfsRegion, null as idfsRayon, null as idfsSettlement, 10089003 as AreaType  
	from   gisRegion r  
	where  r.idfsRegion = @Area  
else if exists (select * from gisRayon where idfsRayon = @Area AND intRowStatus = 0)  
	select rr.idfsCountry, rr.idfsRegion, rr.idfsRayon, null as idfsSettlement, 10089002 as AreaType  
	from   gisRayon rr  
	where  rr.idfsRayon = @Area  
else  
	select s.idfsCountry, s.idfsRegion, s.idfsRayon, s.idfsSettlement, 10089004 as AreaType  
	from   gisSettlement s  
	where  s.idfsSettlement = @Area 











