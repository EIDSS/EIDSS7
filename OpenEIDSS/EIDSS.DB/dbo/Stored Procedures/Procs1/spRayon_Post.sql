





CREATE   PROCEDURE spRayon_Post(
	@idfsRayon bigint,
	@idfsRegion bigint,
	@idfsCountry bigint,
	@strEnglishName nvarchar(200),
	@strNationalName nvarchar(200),
	@strHASC nvarchar(6),
	@LangID varchar(50)
	)
as
-- Post the rayon info on site (non-RC)
--declare @idfSiteER uniqueidentifier
if not exists(select idfsGISBaseReference from dbo.gisBaseReference
		where idfsGISBaseReference = @idfsRayon AND intRowStatus = 0)
begin
	insert into dbo.gisBaseReference(
		idfsGISBaseReference,
		idfsGISReferenceType,
		strDefault
		)
	values(
		@idfsRayon,
		19000002, --'rftRayon',
		@strEnglishName
		)
	insert into dbo.gisRayon(
		idfsRayon, 
		idfsCountry, 
		idfsRegion,
		strHASC)
	values (
		@idfsRayon, 
		@idfsCountry, 
		@idfsRegion,
		@strHASC)
	insert into dbo.gisStringNameTranslation(
		idfsGISBaseReference, 
		idfsLanguage, 
		strTextString)
	values (
		@idfsRayon,
		@LangID,
		@strNationalName)
end
else
begin
	update dbo.gisBaseReference
	set
		idfsGISReferenceType=19000002, --'rftRayon',
		strDefault=@strEnglishName
	where
		idfsGISBaseReference=@idfsRayon
	update dbo.gisRayon
	set		 
		idfsCountry = @idfsCountry, 
		idfsRegion = @idfsRegion,
		strHASC = @strHASC
	where 
		idfsRayon = @idfsRayon
	update dbo.gisStringNameTranslation
	set	
		strTextString=@strNationalName
	where
		idfsGISBaseReference=@idfsRayon 
		AND idfsLanguage=@LangID
end
	






