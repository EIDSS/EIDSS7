-- =============================================================================
-- Name:		EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_GETLIST
-- Description:	Returns a list of vector type to sample type matrices given a language and vector type id
-- Author:		Ricky Moss
--
-- Revision History:
-- Name:			Date:		Revision:
-- _____________________________________________________________________________
-- Ricky Moss		04/01/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPESAMPLETYPEMATRIX_GETLIST 'en', 6619340000000
-- =============================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPESAMPLETYPEMATRIX_GETLIST
(
	@langId NVARCHAR(50),
	@idfsVectorType BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT idfSampleTypeForVectorType, idfsVectorType, vtbr.name AS strVectorTypeName, idfsSampleType, stbr.name AS strSampleTypeName from trtSampleTypeForVectorType stvt
		JOIN FN_GBL_Reference_GETList(@langId, 19000087) stbr
		ON stvt.idfsSampleType = stbr.idfsReference
		JOIN FN_GBL_Reference_GETList(@langId, 19000140) vtbr
		ON stvt.idfsVectorType = vtbr.idfsReference
		WHERE stvt.intRowStatus = 0 AND idfsVectorType = @idfsVectorType
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END