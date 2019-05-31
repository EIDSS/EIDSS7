
--##SUMMARY Selects statistic Area attributes depending on Area ID

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 24.11.2009

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

DECLARE @idfStatistic BIGINT
EXECUTE spStatistic_SelectDetail @idfStatistic

*/



CREATE                  PROCEDURE dbo.spStatistic_GetAreaType(
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










