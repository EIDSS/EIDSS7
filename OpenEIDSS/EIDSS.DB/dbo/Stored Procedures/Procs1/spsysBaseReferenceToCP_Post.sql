


--##SUMMARY Fills trtBaseReferenceToCountry table with passed reference and country ID.
--##SUMMARY Called from spBaseReference_SysPost to link reference with country.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 23.01.2010

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
DECLARE @idfsReference bigint
DECLARE @idfCustomizationPackage bigint


EXECUTE spsysBaseReferenceToCP_Post
   @idfsReference
  ,@idfCustomizationPackage

*/




CREATE     PROCEDURE dbo.spsysBaseReferenceToCP_Post 
	@idfsReference BIGINT, --##PARAM @idfsReference - reference ID
	@idfCustomizationPackage BIGINT --##PARAM @idfCustomizationPackage - Customization Package ID

AS
BEGIN
	IF NOT EXISTS (SELECT * FROM trtBaseReferenceToCP WHERE idfsBaseReference = @idfsReference AND idfCustomizationPackage = @idfCustomizationPackage)
		INSERT INTO trtBaseReferenceToCP(
				idfsBaseReference
			   ,idfCustomizationPackage
		)
		Values (
				@idfsReference
			   ,@idfCustomizationPackage
		)


END





