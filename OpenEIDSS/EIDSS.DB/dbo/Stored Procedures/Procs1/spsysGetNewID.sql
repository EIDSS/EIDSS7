

--##SUMMARY This procedure returns new ID from main (system) ID set for current site.

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 03.11.2009

--##RETURNS Don't use


/*
--Example of a call of procedure:

declare @ID bigint
exec dbo.[spsysGetNewID] @ID output
print @ID
*/

CREATE PROCEDURE [dbo].[spsysGetNewID](
	@ID bigint OUTPUT --##PARAM @ID - new ID (output)
	)
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tstNewID (idfTable) VALUES (0)
  SET @ID = SCOPE_IDENTITY()
  SET NOCOUNT OFF 
END


