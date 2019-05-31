--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/20/2017
-- Last modified by:		Joan Li
-- Description:				06/20/2017: Created based on V6 fn_HumanCase_SelectList :  V7 USP73
--                          Function called by SP ; get data from: tlbGeoLocation;tlbGeoLocationTranslation
/*
----testing code:
----related fact data from
-- select * from fnGeoLocationTranslation('ru')
*/
--=====================================================================================================

CREATE          function [dbo].[fnGeoLocationTranslation](@LangID  nvarchar(50))
returns table
as
return(

select
			gl.idfGeoLocation, 
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
			

from		dbo.tlbGeoLocation as gl 
left join	dbo.tlbGeoLocationTranslation as glt 
on			glt.idfGeoLocation = gl.idfGeoLocation and glt.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		gl.intRowStatus = 0
)












