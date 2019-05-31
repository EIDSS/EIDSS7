



--##SUMMARY Deletes vector field test.
--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spVector_Delete 
	@ID

*/




CREATE proc	[dbo].[spVectorFieldTest_Delete]
	@ID AS BIGINT --#PARAM @ID - vector ID
as



DELETE FROM  dbo.tlbPensideTest WHERE idfPensideTest = @ID
