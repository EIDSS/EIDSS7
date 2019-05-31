-- =========================================================================================
-- NAME: USP_CONF_DISEASEGROUPDISEASEMATRIX_DEL
-- DESCRIPTION: Deactivates a disease group to disease relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/04/2019	Initial Release
--
-- exec USP_CONF_DISEASEGROUPDISEASEMATRIX_DEL 6704450000000
-- =========================================================================================
CREATE PROCEDURE USP_CONF_DISEASEGROUPDISEASEMATRIX_DEL
(
	@idfDiagnosisToDiagnosisGroup BIGINT,
	@deleteAnyway bit = 0
)
AS
BEGIN
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
	BEGIN TRY
		UPDATE trtDiagnosisToDiagnosisGroup SET intRowStatus = 1 WHERE idfDiagnosisToDiagnosisGroup = @idfDiagnosisToDiagnosisGroup
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END