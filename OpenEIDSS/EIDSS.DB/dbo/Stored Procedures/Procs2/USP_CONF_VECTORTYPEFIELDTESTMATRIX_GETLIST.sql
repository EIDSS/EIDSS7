-- =============================================================================
-- Name:		USP_CONF_VECTORTYPEFIELDTESTMATRIX_GETLIST
-- Description:	Returns a list of vector type to field test matrices given a language and vector type id
-- Author:		Ricky Moss
--
-- Revision History:
-- Name:			Date:		Revision:
-- _____________________________________________________________________________
-- Ricky Moss		04/02/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_GETLIST 'en', 6619340000000
-- EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_GETLIST 'en', 6619360000000
-- =============================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPEFIELDTESTMATRIX_GETLIST
(
	@langId NVARCHAR(10),
	@idfsVectorType BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT idfPensideTestTypeForVectorType, idfsVectorType, vtbr.name AS strVectorTypeName, idfsPensideTestName, ptnbr.name AS strPensideTestName FROM trtPensideTestTypeForVectorType ptvt
		JOIN FN_GBL_Reference_GETList(@langId, 19000104) ptnbr
		ON ptvt.idfsPensideTestName = ptnbr.idfsReference
		JOIN FN_GBL_Reference_GETList(@langId, 19000140) vtbr
		ON ptvt.idfsVectorType = vtbr.idfsReference
		WHERE ptvt.intRowStatus = 0 AND idfsVectorType = @idfsVectorType 
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END