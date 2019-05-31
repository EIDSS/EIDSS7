
--##SUMMARY Posts settlement data.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##RETURNS Doesn't use


/*
--Example of a call of procedure:

DECLARE @idfsSettlement bigint
DECLARE @strEnglishName nvarchar(200)
DECLARE @strNationalName nvarchar(200)
DECLARE @LangID varchar(50)
DECLARE @dblLatitude float
DECLARE @dblLongitude float
DECLARE @idfsSettlementType bigint
DECLARE @idfsRayon bigint
DECLARE @idfsRegion bigint
DECLARE @idfsCountry bigint


EXECUTE spSettlement_Post
   @idfsSettlement
  ,@strEnglishName
  ,@strNationalName
  ,@LangID
  ,@dblLatitude
  ,@dblLongitude
  ,@idfsSettlementType
  ,@idfsRayon
  ,@idfsRegion
  ,@idfsCountry
*/


CREATE proc spSettlement_Post(
	@idfsSettlement bigint, --##PARAM @idfsSettlement - settlement ID
	@strEnglishName nvarchar(200), --##PARAM @strEnglishName - settlement name in English
	@strNationalName nvarchar(200), --##PARAM @strNationalName - settlement name in language defined by @LangID
	@LangID varchar(50), --##PARAM @LangID - language ID
	@dblLatitude float, --##PARAM @dblLatitude - settlement latitude
	@dblLongitude float, --##PARAM @dblLongitude - settlement longitude
	@idfsSettlementType bigint, --##PARAM @idfsSettlementType - settlement Type, reference to rftSettlementType (19000083)
	@idfsRayon bigint, --##PARAM @idfsRayon - settlement rayon
	@idfsRegion bigint, --##PARAM @idfsRegion - settlement region
	@idfsCountry bigint, --##PARAM @idfsCountry -  settlement country
	@strSettlementCode nvarchar(200),
	@blnIsCustomSettlement bit,
	@intElevation int
	)
as
-------------
if not exists(select idfsGISBaseReference from dbo.gisBaseReference
		where idfsGISBaseReference = @idfsSettlement)
begin
	insert into dbo.gisBaseReference(
		idfsGISBaseReference,
		idfsGISReferenceType,
		strDefault
	)
	values(
		@idfsSettlement,
		19000004, --'rftSettlement',
		@strEnglishName
	)
end
else
begin
	update dbo.gisBaseReference
	set
		strDefault=@strEnglishName
	where
		idfsGISBaseReference=@idfsSettlement
		AND ISNULL(@strEnglishName,N'')<>ISNULL(strDefault,N'')
end
----------------
if not exists(select idfsSettlement from dbo.gisSettlement
		where idfsSettlement = @idfsSettlement)

	insert into dbo.gisSettlement(
		idfsSettlement, 
		dblLongitude, 
		dblLatitude, 
		idfsSettlementType, 
		idfsRayon, 
		idfsCountry, 
		idfsRegion,
		strSettlementCode,
		blnIsCustomSettlement,
		intElevation
		)
	values (
		@idfsSettlement, 
		@dblLongitude, 
		@dblLatitude, 
		@idfsSettlementType, 
		@idfsRayon, 
		@idfsCountry, 
		@idfsRegion,
		@strSettlementCode,
		@blnIsCustomSettlement,
		@intElevation
		)
else
	update dbo.gisSettlement
	set		 
		dblLongitude = @dblLongitude, 
		dblLatitude = @dblLatitude, 
		idfsSettlementType = @idfsSettlementType, 
		idfsRayon = @idfsRayon, 
		idfsCountry = @idfsCountry, 
		idfsRegion = @idfsRegion,
		strSettlementCode = @strSettlementCode,
		blnIsCustomSettlement = @blnIsCustomSettlement,
		intElevation = @intElevation
	where 
		idfsSettlement = @idfsSettlement
----------------
if not exists(select idfsGISBaseReference from dbo.gisStringNameTranslation
		where idfsGISBaseReference = @idfsSettlement AND idfsLanguage=dbo.fnGetLanguageCode(@LangID))
	insert into dbo.gisStringNameTranslation(
		idfsGISBaseReference, 
		idfsLanguage, 
		strTextString)
	values (
		@idfsSettlement,
		dbo.fnGetLanguageCode(@LangID),
		@strNationalName)
else
	update dbo.gisStringNameTranslation
	set	
		strTextString=@strNationalName
	where
		idfsGISBaseReference=@idfsSettlement 
		AND idfsLanguage=dbo.fnGetLanguageCode(@LangID)
		AND ISNULL(@strNationalName,N'')<>ISNULL(strTextString,N'')

---------
if exists(select idfsGISBaseReference from dbo.gisStringNameTranslation
		where idfsGISBaseReference = @idfsSettlement AND idfsLanguage=dbo.fnGetLanguageCode('en'))
	update dbo.gisStringNameTranslation
	set	
		strTextString=@strEnglishName
	where
		idfsGISBaseReference=@idfsSettlement 
		AND idfsLanguage=dbo.fnGetLanguageCode('en')
		AND ISNULL(@strEnglishName,N'')<>ISNULL(strTextString,N'')


EXEC spGisSetWKBSettlement 	@idfsSettlement



