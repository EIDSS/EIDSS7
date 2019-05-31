





CREATE       PROCEDURE dbo.spRayon_SelectDetail(
	@idfsRayon AS BIGINT,
	@LangID as NVARCHAR(50)
)
AS
SELECT  
	idfsRayon, 
	idfsCountry, 
	idfsRegion,
	natRayon.[name] as strNationalName,
	enRayon.[name] as strEnglishName,
	strHASC
FROM 
	gisRayon
LEFT JOIN 
	fnGisReference(@LangID,19000002) as natRayon --'rftRayon'
on	natRayon.idfsReference = idfsRayon
LEFT JOIN 
	fnGisReference('en',19000002) as enRayon --'rftRayon'
on	enRayon.idfsReference = idfsRayon
WHERE
	idfsRayon = @idfsRayon 






