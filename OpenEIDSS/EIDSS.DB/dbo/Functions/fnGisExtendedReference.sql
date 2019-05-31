


-- select * from fnGisExtendedReference('ru',19000002)

CREATE          function fnGisExtendedReference(@LangID  nvarchar(50), @type bigint)
returns table
as
return
(

select
			br.idfsGISBaseReference as idfsReference, 
			IsNull(snt.strTextString, br.strDefault) as [name],
			br.idfsGISReferenceType, 
			br.strDefault, 
			IsNull(snt.strTextString, br.strDefault) as LongName,
			br.intOrder,
			case	@type
				when	19000001	-- rftCountry
					then	IsNull(snt.strTextString, br.strDefault) + IsNull(N' (' + c.strHASC + N')', N'')
				when	19000003	-- rftRegion
					then	IsNull(snt.strTextString, br.strDefault) + IsNull(N' (' + r.strHASC + N')', N'')
				when	19000002	-- rftRayon
					then	IsNull(snt.strTextString, br.strDefault) + IsNull(N' (' + rr.strHASC + N')', N'')
				when	19000004	-- rftSettlement
					then	IsNull(snt.strTextString, br.strDefault) + 
							IsNull(N' (' + cast(s.dblLatitude as nvarchar) + N'; ' + 
											cast(s.dblLongitude as nvarchar) + N')', N'')
				else	IsNull(snt.strTextString, br.strDefault)
			end as ExtendedName

from		gisBaseReference as br 
left join	gisStringNameTranslation as snt 
on			snt.idfsGISBaseReference = br.idfsGISBaseReference
			and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			AND snt.intRowStatus = 0
left join	gisCountry c
on			@type = 19000001	-- rftCountry
			and c.idfsCountry = br.idfsGISBaseReference
			AND c.intRowStatus = 0
left join	gisRegion r
on			@type = 19000003	-- rftRegion
			and r.idfsRegion = br.idfsGISBaseReference
			AND r.intRowStatus = 0
left join	gisRayon rr
on			@type = 19000002	-- rftRayon
			and rr.idfsRayon = br.idfsGISBaseReference
			AND rr.intRowStatus = 0
left join	gisSettlement s
on			@type = 19000004	-- rftSettlement
			and s.idfsSettlement = br.idfsGISBaseReference
			AND s.intRowStatus = 0

where		br.idfsGISReferenceType = @type 
	AND br.intRowStatus = 0
)




