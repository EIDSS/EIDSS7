




--##SUMMARY Deletes base reference record and all low level related records

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.01.2010

--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @idfsBaseReference bigint
EXECUTE spsysBaseReference_Delete
  @idfsBaseReference

*/


CREATE     PROCEDURE dbo.spsysBaseReference_Delete 
	@idfsBaseReference BIGINT --##PARAM @idfsBaseReference - diagnosis ID
AS
BEGIN
		DELETE FROM trtBaseReferenceToCP 
		WHERE idfsBaseReference = @idfsBaseReference

		DELETE FROM trtStringNameTranslation 
		WHERE idfsBaseReference = @idfsBaseReference

		DELETE FROM trtBaseReference 
		WHERE idfsBaseReference = @idfsBaseReference

END





