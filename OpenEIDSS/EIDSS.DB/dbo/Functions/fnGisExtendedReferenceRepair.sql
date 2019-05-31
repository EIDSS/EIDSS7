


-- select * from fnGisExtendedReferenceRepair('ru',19000002)

CREATE          function fnGisExtendedReferenceRepair(@LangID  nvarchar(50), @type bigint)
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
			end as ExtendedName,
			br.intRowStatus

from		gisBaseReference as br 
left join	gisStringNameTranslation as snt 
on			snt.idfsGISBaseReference = br.idfsGISBaseReference
			and snt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
left join	gisCountry c
on			@type = 19000001	-- rftCountry
			and c.idfsCountry = br.idfsGISBaseReference
left join	gisRegion r
on			@type = 19000003	-- rftRegion
			and r.idfsRegion = br.idfsGISBaseReference
left join	gisRayon rr
on			@type = 19000002	-- rftRayon
			and rr.idfsRayon = br.idfsGISBaseReference
left join	gisSettlement s
on			@type = 19000004	-- rftSettlement
			and s.idfsSettlement = br.idfsGISBaseReference

where		br.idfsGISReferenceType = @type 
)




