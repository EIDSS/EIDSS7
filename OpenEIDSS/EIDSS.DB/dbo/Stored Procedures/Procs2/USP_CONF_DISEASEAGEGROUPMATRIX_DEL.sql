-- =========================================================================================
-- NAME: USP_CONF_DISEASEAGEGROUPMATRIX_DEL
-- DESCRIPTION: Deactivates a vector type to collection type relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/06/2019	Initial Release
--
-- exec USP_CONF_DISEASEAGEGROUPMATRIX_DEL 51526220000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEAGEGROUPMATRIX_DEL
(
	@idfDiagnosisAgeGroupToDiagnosis BIGINT
)
AS
BEGIN
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	BEGIN TRY
		UPDATE trtDiagnosisAgeGroupToDiagnosis SET intRowStatus = 1 WHERE idfDiagnosisAgeGroupToDiagnosis= @idfDiagnosisAgeGroupToDiagnosis
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END