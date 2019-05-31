

--##SUMMARY Select Human or Vet Sites
--##REMARKS Author: Romasheva
--##REMARKS Create date: 07.07.2014 

--##RETURNS Human or Vet Site List

/*
--Example of a call of function:

--	Input Parameter:
--	2	=	HumanSites
--	96	=	VetSites

select ts.intFlags, ts.idfsSite, ts.strSiteName
from [dbo].[fnRepVetOrHumanSiteList](96) hvl
	inner join tstSite ts
	on ts.idfsSite = hvl.idfsSite
 

*/



create function [dbo].[fnRepVetOrHumanSiteList](@intHACode bigint)
returns table
as
return
(
	select 
		ts.idfsSite
	from tstSite ts
	where ts.intFlags & @intHACode > 0
)	
