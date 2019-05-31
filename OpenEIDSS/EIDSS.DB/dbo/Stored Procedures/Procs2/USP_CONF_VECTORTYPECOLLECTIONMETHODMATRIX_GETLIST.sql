-- =========================================================================================
-- NAME: USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_GETLIST
-- DESCRIPTION: Returns a list of vector type to collection type relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/04/2019	Initial Release
--
-- exec USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_GETLIST 'en', 6619310000000
-- exec USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_GETLIST 'en', 6619330000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_GETLIST
(
	@LangId NVARCHAR(10),
	@idfsVectorType BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT idfCollectionMethodForVectorType, idfsVectorType, vbr.strDefault as strVectorTypeDefault, vbr.[name] as strVectorTypeName, idfsCollectionMethod, collbr.strDefault, collbr.[name] as strName  FROM trtCollectionMethodForVectorType AS cmvt
		JOIN FN_GBL_Reference_GETList(@LangId,19000135) AS collbr
		ON cmvt.idfsCollectionMethod = collbr.idfsReference AND cmvt.intRowStatus = 0
		JOIN FN_GBL_Reference_GETList(@LangId, 19000140) AS vbr
		ON cmvt.idfsVectorType = vbr.idfsReference
		WHERE idfsVectorType = @idfsVectorType
		ORDER BY collbr.strDefault
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END