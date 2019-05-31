

--##SUMMARY Returns a string value of the filter, adding, if necessary, additional quotes
--##SUMMARY depending on the Type of the field and a reference to the reference table.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.04.2010

--##RETURNS Function returns a string value of the filter, adding, if necessary, additional quotes.


/*
--Example of a call of function:
declare @idfsFieldType			bigint
declare @idfsReferenceType		bigint
declare @idfsGISReferenceType	bigint
declare @varValue				sql_variant

select	dbo.fnAsGetSearchValue
		(	@idfsFieldType,
			@idfsReferenceType,
			@idfsGISReferenceType,
			@varValue
		)

*/


create	function	fnAsGetSearchValue
(
	@idfsFieldType			bigint,		--##PARAM @idfsFieldType Id of the search field Type or parameter Type
	@idfsReferenceType		bigint,		--##PARAM @idfsReferenceType Id of the reference Type that should contain the specified value
	@idfsGISReferenceType	bigint,		--##PARAM @idfsGISReferenceType Id of the GIS reference Type that should contain the specified value
	@varValue				sql_variant	--##PARAM @varValue The value to be converted to a string
)
returns nvarchar(MAX)
as
begin

declare @strValue nvarchar(MAX)
set @strValue = N''

if	@varValue is not null
begin
	if	@idfsReferenceType is not null 
		or @idfsGISReferenceType is not null
		or @idfsFieldType in
			(	-- Search field Type
				10081001,	-- Bit
				10081004,	-- Float
				10081006,	-- Integer
				-- FF parameter Type
				10071007,	-- Numeric
				10071025,	-- Boolean
				10071059,	-- Numeric Natural
				10071060,	-- Numeric Positive
				10071061	-- Numeric Integer
			)
	begin
			set	@strValue = N' ' + cast(@varValue as nvarchar(MAX))
	end
	else begin
		if cast(SQL_VARIANT_PROPERTY(@varValue, 'BaseType')  as nvarchar) like N'%date%'
			set	@strValue = N' ' + 'N''' + 
				replace(replace(left(CONVERT(nvarchar, CAST(@varValue as datetime), 120), 10), N'-', N''), '''', '''''') + ''''
		else
			set	@strValue = N' ' + 'N''' + replace(cast(@varValue as nvarchar(MAX)), '''', '''''') + ''''
	end
end

return @strValue
end



