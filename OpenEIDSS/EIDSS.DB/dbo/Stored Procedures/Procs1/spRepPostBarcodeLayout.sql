

--##SUMMARY This procedure returns language, country and organization information related with current site.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 30.11.2009

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spRepPostBarcodeLayout 10057020, "test"
*/ 
 
CREATE PROCEDURE [dbo].[spRepPostBarcodeLayout]
	@idfsNumberName		bigint,
	@strBarcodeLayout	nvarchar(max)
AS
BEGIN
	if  exists 
		(	select  idfsNumberName
			from	dbo.tstBarcodeLayout
			where	idfsNumberName = @idfsNumberName
		)
	exec dbo.spRepDeleteBarcodeLayout @idfsNumberName

	insert into	dbo.tstBarcodeLayout
				(idfsNumberName, strBarcodeLayout)
	values 
				(@idfsNumberName, @strBarcodeLayout)

END

