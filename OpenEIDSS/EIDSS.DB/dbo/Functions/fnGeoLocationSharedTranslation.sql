
-- select * from fnGeoLocationSharedTranslation('ru')

create          function [dbo].[fnGeoLocationSharedTranslation](@LangID  nvarchar(50))
returns table
as
return(

select
			gl.idfGeoLocationShared, 
			IsNull(glt.strTextString, gl.strAddressString) as [name],
			case
				when	IsNull(gl.blnForeignAddress, 1) = 0
					then	gl.strAddressString
				else	gl.strForeignAddress
			end as [strDefault],
			case
				when	IsNull(gl.idfsGeoLocationType, 0) = 10036001 -- Address 
						and IsNull(gl.blnForeignAddress, 1) = 0
					then	IsNull(glt.strShortAddressString, gl.strShortAddressString)
				else	N''
			end as [strShortAddressString],
			case
				when	IsNull(gl.idfsGeoLocationType, 0) = 10036001 -- Address 
						and IsNull(gl.blnForeignAddress, 1) = 0
					then	gl.strShortAddressString
				else	N''
			end as [strDefaultShortAddressString]

from		dbo.tlbGeoLocationShared as gl 
left join	dbo.tlbGeoLocationSharedTranslation as glt 
on			glt.idfGeoLocationShared = gl.idfGeoLocationShared and glt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		gl.intRowStatus = 0
)
