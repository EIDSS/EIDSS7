

--##SUMMARY Select facilities for the report Laboratory Research Result
--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 01.08.2014 

--##RETURNS Human or Vet Site List

/*
--Example of a call of function:


select ts.idfsSite, ts.strSiteName, ts.strSiteID
from [dbo].[fnRepSiteListForLMAReport]() hvl
	inner join tstSite ts
	on ts.idfsSite = hvl.idfsSite
 

*/



create function [dbo].[fnRepSiteListForLMAReport]()
returns table
as
return
(
	
	select ts.idfsSite from 
		trtBaseReferenceAttribute tbra
			inner join trtAttributeType tat
			on tat.idfAttributeType = tbra.idfAttributeType
			and tat.strAttributeTypeName = 'attr_part_in_report'
			
			inner join tlbOffice oabr
			on oabr.idfsOfficeAbbreviation = tbra.idfsBaseReference
			and oabr.intRowStatus = 0
			
			inner join tstSite ts
			on ts.idfOffice = oabr.idfOffice
			and ts.intRowStatus = 0
		where tbra.varValue = 10290030
		
) 
