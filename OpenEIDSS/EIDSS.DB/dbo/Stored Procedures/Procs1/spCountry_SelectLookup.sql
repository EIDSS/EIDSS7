
--exec spCountry_SelectLookup 'en'

CREATE       PROCEDURE dbo.spCountry_SelectLookup
	@LangID As nvarchar(50)
AS
SELECT	country.idfsReference	as idfsCountry, 
		country.[name]			as strCountryName, 
		country.[ExtendedName]	as strCountryExtendedName, 
		gisCountry.strCode		as strCountryCode, 
		country.intRowStatus
FROM	dbo.fnGisExtendedReferenceRepair(@LangID,19000001)  country --'rftCountry'
join	gisCountry
on	country.idfsReference = gisCountry.idfsCountry
ORDER BY strCountryName



