-- =========================================================================================
-- NAME: USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_DEL
-- DESCRIPTION: Deactivates a vector type to collection type relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/04/2019	Initial Release
--
-- exec USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_DEL 6704450000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPECOLLECTIONMETHODMATRIX_DEL
(
	@idfCollectionMethodForVectorType BIGINT
)
AS
BEGIN
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	BEGIN TRY
		UPDATE trtCollectionMethodForVectorType SET intRowStatus = 1 WHERE idfCollectionMethodForVectorType = @idfCollectionMethodForVectorType
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END