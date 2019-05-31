

--
--
-- renamed spCountry_SelectLookup to usp_Country_GetLookup by MCW
--
--


--exec usp_Country_SelectLookup 'en'

CREATE       PROCEDURE [dbo].[usp_Country_GetLookup]
	@LangID As nvarchar(50)
AS
SELECT	country.idfsReference	as idfsCountry, 
		country.name			as strCountryName, 
		country.ExtendedName	as strCountryExtendedName, 
		gisCountry.strCode		as strCountryCode, 
		country.intRowStatus
		
FROM	dbo.fnGisExtendedReferenceRepair(@LangID,19000001)  country --'rftCountry'
join	gisCountry on country.idfsReference = gisCountry.idfsCountry

ORDER BY strCountryName






