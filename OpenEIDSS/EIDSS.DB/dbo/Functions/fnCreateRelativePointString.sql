




--##SUMMARY Builds relative point geoplocation string from passed compound parts basing on template specific for current customization country.
--##SUMMARY This function is designed for maximum speed execution so it assumes that passed compound parts is NOT NULL.
--##SUMMARY The statement that calls this function must provide NOT NULL values for relative point geoplocation string compound parts,
--##SUMMARY in other case NULL will be returned


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.11.2009

--##RETURNS String representation of relative point geoplocation


/*
--Example of function call:

SELECT dbo.fnCreateRelativePointString (
  'en'
  ,'Georgia'
  ,'Imereti'
  ,'Khoni'
  ,''
  ,'Khoni'
  ,'20.1'
  ,'46.345'

  )

*/



Create   function fnCreateRelativePointString(
	@LangID			nvarchar(50), --##PARAM @LangID  - language ID
	@Country		nvarchar(200) = '', --##PARAM @Country - Country name
	@Region			nvarchar(200) = '', --##PARAM @Region - Region name
	@Rayon			nvarchar(200) = '', --##PARAM @Rayon - Rayon name
	@SettlementType	nvarchar(200) = '', --##PARAM @SettlementType - Settlement Type
	@Settlement		nvarchar(200) = '', --##PARAM @Settlement -Settlement
	@Alignment		nvarchar(200) = '', --##PARAM @Alignment - Azimuth of direction from settlement
	@Distance		nvarchar(200) = '' --##PARAM @Distance - Distance from settlement
)
returns nvarchar(1000)
as
BEGIN

DECLARE @From	nvarchar(200)
DECLARE @Azimuth	nvarchar(200)
DECLARE @At_distance_of	nvarchar(200)
DECLARE @Km	nvarchar(200)

SELECT 
	@From = frr.name 
FROM dbo.fnReferenceRepair(@LangID, 19000132) frr 
WHERE frr.idfsReference = 10300058 /*from*/

SELECT 
	@Azimuth = frr.name 
FROM dbo.fnReferenceRepair(@LangID, 19000132) frr
WHERE frr.idfsReference = 10300059 /*Azimuth*/

SELECT 
	@At_distance_of = frr.name 
FROM dbo.fnReferenceRepair(@LangID, 19000132) frr 
WHERE frr.idfsReference = 10300060 /*At_distance_of*/

SELECT 
	@Km = frr.name 
FROM dbo.fnReferenceRepair(@LangID, 19000132) frr 
WHERE frr.idfsReference = 10300061 /*Km*/
	


declare @TempStr nvarchar(1000) = ''

select	@TempStr = strRelativePointString
FROM	tstGeoLocationFormat
WHERE	idfsCountry = dbo.fnCustomizationCountry()

IF @TempStr = ''
select	@TempStr = strRelativePointString
FROM	tstGeoLocationFormat
WHERE	idfsCountry = 2340000000 /*The USA*/

IF (LEN(@Region)>0 AND LEN(@Rayon)>0 AND LEN(@Settlement)>0) 
BEGIN 
set @TempStr = REPLACE(@TempStr, '@Country', @Country)
set @TempStr = REPLACE(@TempStr, '@Region', @Region)
set @TempStr = REPLACE(@TempStr, '@Rayon', @Rayon)
set @TempStr = REPLACE(@TempStr, '@SettlementType', @SettlementType)
set @TempStr = REPLACE(@TempStr, '@Settlement', @Settlement)
set @TempStr = REPLACE(@TempStr, '@Alignment', @Alignment)
set @TempStr = REPLACE(@TempStr, '@Distance', @Distance)
set @TempStr = REPLACE(@TempStr, '@From', @From)
set @TempStr = REPLACE(@TempStr, '@Azimuth', @Azimuth)
set @TempStr = REPLACE(@TempStr, '@At_distance_of', @At_distance_of)
set @TempStr = REPLACE(@TempStr, '@Km', @Km)
END
ELSE
SET @TempStr = ''

return @TempStr

end








