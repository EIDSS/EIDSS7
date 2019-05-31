

--##SUMMARY Select Reporting Facilities List for Rayon
--##REMARKS Author: Romasheva
--##REMARKS Create date: 26.06.2014 

--##RETURNS Reporting Facilities List

/*
--Example of a call of function:

declare @idfsLanguage bigint
set @idfsLanguage = dbo.fnGetLanguageCode('en')
select * from [dbo].[fnReportingFacilitiesList](@idfsLanguage, 1343010000000)

*/



create function [dbo].[fnReportingFacilitiesList](@idfsLanguage bigint, @idfsRayon bigint)
returns table
as
return
(
	select 
		ts.idfsSite,
		ISNULL(snt.strTextString, br.strDefault) as strNameOfRespondent ,
		dbo.fnAddressSharedString(@idfsLanguage, o.idfLocation) as strActualAddress,
		o.strContactPhone as strContactPhone
	from tstRayonToReportSite trtrs
		inner join tstSite ts
			inner join tlbOffice o
			on ts.idfOffice = o.idfOffice
			and o.intRowStatus = 0

			inner join trtBaseReference br
			ON o.idfsOfficeName = br.idfsBaseReference

			left outer join trtStringNameTranslation snt
			ON br.idfsBaseReference = snt.idfsBaseReference
			AND snt.idfsLanguage = @idfsLanguage
			AND snt.intRowStatus = 0
		on ts.idfsSite = trtrs.idfsSite 
		and ts.intRowStatus = 0
	where trtrs.idfsRayon = @idfsRayon 
)	
