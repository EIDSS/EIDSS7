

--##SUMMARY This procedure returns new ID from GIS ID set for current site.

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 03.11.2009

--##RETURNS Don't use


/*
--Example of a call of procedure:

declare @ID bigint
exec dbo.[spgisGetNewID] @ID output
print @ID
*/


CREATE PROCEDURE [dbo].[spgisGetNewID](
	@ID bigint OUTPUT --##PARAM @ID - new ID (output)
	)
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.gisNewID (strA) VALUES ('')
  SET @ID = SCOPE_IDENTITY()
  SET NOCOUNT OFF 
END


