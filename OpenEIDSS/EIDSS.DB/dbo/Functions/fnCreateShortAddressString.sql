


--##SUMMARY Builds short address string from passed compound parts basing on template specific for current customization country.
--##SUMMARY This function is designed for maximum speed execution so it assumes that passed compound parts is NOT NULL.
--##SUMMARY The statement that calls this function must provide NOT NULL values for address compound parts,
--##SUMMARY in other case NULL will be returned


--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 26.01.2014

--##RETURNS String representation of short address


/*
--Example of function call:

SELECT dbo.fnCreateShortAddressString (
  '111111'
  ,'Gugashvily street'
  ,'h'
  ,'b'
  ,'a'
  ,0
)

*/

create   function fnCreateShortAddressString	(
					@PostCode		nvarchar(200) = '', --##PARAM @PostCode - Postal Code
					@Street			nvarchar(200) = '', --##PARAM @Street - Street
					@House			nvarchar(200) = '', --##PARAM @House - House number
					@Building		nvarchar(200) = '', --##PARAM @Building - Building number
					@Apartment		nvarchar(200) = '', --##PARAM @Appartment - Appartment number
					@blnForeignAddress bit		  = 0
								)
returns nvarchar(1000)
as
BEGIN
	
declare @TempStr nvarchar(1000) = ''

IF (@blnForeignAddress = 0)
BEGIN
	SELECT 
		@TempStr = strShortAddress 
	FROM tstGeoLocationFormat 
	WHERE idfsCountry = dbo.fnCustomizationCountry()
	
	IF @TempStr = ''
		SELECT 
			@TempStr = strShortAddress
		FROM	tstGeoLocationFormat
		WHERE	idfsCountry = 2340000000 /*The USA*/
END
	
		IF 	LEN(@PostCode)>0 
			OR LEN(@Street)>0 
			OR LEN(@House)>0 
			OR LEN(@Building)>0 
			OR LEN(@Apartment)>0 
		BEGIN 
		set @TempStr = REPLACE(@TempStr, '@PostCode', @PostCode)
		set @TempStr = REPLACE(@TempStr, '@Street', @Street)
		set @TempStr = REPLACE(@TempStr, '@House', @House)
		set @TempStr = REPLACE(@TempStr, '@Building', @Building)
		set @TempStr = REPLACE(@TempStr, '@Apartment', @Apartment)

		set	@TempStr = LTRIM(RTRIM(REPLACE(@TempStr, N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N'- -', N'-'), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N'--', N'-'), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N', -', N' -'), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N',-', N'-'), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N', ,', N','), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N', ,', N','), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N',,', N','), N'  ', N' ')))
		set	@TempStr = LTRIM(RTRIM(REPLACE(REPLACE(@TempStr, N',,', N','), N'  ', N' ')))

		if	@TempStr like N', %' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 3, LEN(@TempStr) - 2)))
		if	@TempStr like N',%' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 2, LEN(@TempStr) - 1)))
		if	@TempStr like N'%-' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr) - 1)))
		if	@TempStr like N'%,' set @TempStr = LTRIM(RTRIM(SUBSTRING(@TempStr, 1, LEN(@TempStr) - 1)))
		END
		ELSE
		SET @TempStr = ''

		-- @PostCode, @Street @House-@Building-@Appartment
	
return @TempStr
end


