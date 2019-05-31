


--##SUMMARY Builds exact point geoplocation string from passed compound parts basing on template specific for current customization country.
--##SUMMARY This function is designed for maximum speed execution so it assumes that passed compound parts is NOT NULL.
--##SUMMARY The statement that calls this function must provide NOT NULL values for exact point geoplocation string compound parts,
--##SUMMARY in other case NULL will be returned


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 25.11.2009

--##RETURNS String representation of exact point geoplocation


/*
--Example of function call:

SELECT dbo.fnCreateExactPointString (
  'Georgia'
  ,'Imereti'
  ,'Khoni'
  ,'Settlement'
  ,'hhh'
  ,'20,1'
  ,'46,345')


SELECT dbo.fnCreateExactPointString (
  'Georgia'
  ,''
  ,''
  ,''
  ,''
  ,'1'
  ,'46,345')
  
Georgia, Imereti, Khoni, hhh (, )
'Georgia, (46,345, 1)'  
*/

create    function fnCreateExactPointString(
	@Country		nvarchar(200) = '', --##PARAM @Country - Country name
	@Region			nvarchar(200) = '', --##PARAM @Region - Region name
	@Rayon			nvarchar(200) = '', --##PARAM @Rayon - Rayon name
	@SettlementType	nvarchar(200) = '', --##PARAM @SettlementType - Settlement Type
	@Settlement		nvarchar(200) = '', --##PARAM @Settlement - Settlement name
	@Latitude		nvarchar(200) = '', --##PARAM @Latitude - Latitude
	@Longitude		nvarchar(200) = '' --##PARAM @Longitude - Longitude
)
returns nvarchar(1000)
as
BEGIN
	
declare @TempStr nvarchar(1000) = ''

select	@TempStr = strExactPointString
FROM	tstGeoLocationFormat
WHERE	idfsCountry = dbo.fnCustomizationCountry()

IF @TempStr = ''
select	@TempStr = strExactPointString
FROM	tstGeoLocationFormat
WHERE	idfsCountry = 2340000000 /*The USA*/

if len(@Latitude) = 0 or len(@Longitude) = 0 
begin
	set @Latitude = '' 
	set @Longitude = ''
end

IF (	len(@Country) > 0 or
		len(@Region) > 0 or 
		len(@Rayon) > 0 or 
		len(@SettlementType) > 0 or
		len(@Settlement) > 0 or
		(len(@Latitude) > 0 and len(@Longitude) > 0) 
	) 
BEGIN 
set @TempStr = REPLACE(@TempStr, '@Country', @Country)
set @TempStr = REPLACE(@TempStr, '@Region', @Region)
set @TempStr = REPLACE(@TempStr, '@Rayon', @Rayon)
set @TempStr = REPLACE(@TempStr, '@SettlementType', @SettlementType)
set @TempStr = REPLACE(@TempStr, '@Settlement', @Settlement)
set @TempStr = REPLACE(@TempStr, '@Latitude', @Latitude)
set @TempStr = REPLACE(@TempStr, '@Longitude', @Longitude)

set	@TempStr = LTRIM(RTRIM(REPLACE(@TempStr, N'  ', N' ')))
set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N', ,', N','), N'  ', N' ')))
set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N', ,', N','), N'  ', N' ')))
set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N',,', N','), N'  ', N' ')))
set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N',,', N','), N'  ', N' ')))
set @TempStr = LTRIM(RTRIM(REPLACE(@TempStr, N' (, )', N' '))) 
set @TempStr = LTRIM(RTRIM(REPLACE(@TempStr, N', (', N' ('))) 


if	@TempStr like N', %' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 3, LEN(@TempStr) - 2)))
if	@TempStr like N',%' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 2, LEN(@TempStr) - 1)))
if	@TempStr like N'%,' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr) - 1)))
END
ELSE
SET @TempStr = ''

return  LTRIM(RTRIM(@TempStr))

end










