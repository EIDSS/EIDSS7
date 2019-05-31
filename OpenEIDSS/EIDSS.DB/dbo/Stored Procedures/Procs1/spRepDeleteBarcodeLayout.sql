

--##SUMMARY This procedure returns language, country and organization information related with current site.

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 30.11.2009

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spRepDeleteBarcodeLayout 10057020
*/ 
 
CREATE PROCEDURE [dbo].[spRepDeleteBarcodeLayout]
	@idfsNumberName bigint
AS
BEGIN
	delete 
	from	dbo.tstBarcodeLayout
	where	idfsNumberName = @idfsNumberName

END

