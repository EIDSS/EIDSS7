
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		04/10/2017
-- Last modified by:		Joan Li
-- Description:				4/10/2017: Created baseed on V6 spsysGetNewID: change SP name for V7
/*
----testing code:

declare @ID bigint
exec dbo.[usp_sysGetNewID] @ID output
print @ID
GO
*/
--=====================================================================================================

--##SUMMARY This procedure returns new ID from main (system) ID set for current site.

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 03.11.2009

--##RETURNS Don't use


CREATE PROCEDURE [dbo].[usp_sysGetNewID](
	@ID bigint OUTPUT --##PARAM @ID - new ID (output)
	)
AS
BEGIN
  SET NOCOUNT ON
  INSERT INTO dbo.tstNewID (idfTable) VALUES (0)
  SET @ID = SCOPE_IDENTITY()
  SET NOCOUNT OFF 
END



