-- ==========================================================================================
-- Name:		USP_CONF_VECTORTYPEFIELDTESTMATRIX_DEL
-- Description:	Removes vector type to field test matrix
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		04/02/2019	Initial Release
--
-- EXEC USP_CONF_VECTORTYPEFIELDTESTMATRIX_DEL 6706660000000, 1
-- ==========================================================================================
CREATE PROCEDURE USP_CONF_VECTORTYPEFIELDTESTMATRIX_DEL
(
	@idfPensideTestTypeForVectorType BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		UPDATE trtPensideTestTypeForVectorType SET intRowStatus = 1 WHERE idfPensideTestTypeForVectorType = @idfPensideTestTypeForVectorType
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END