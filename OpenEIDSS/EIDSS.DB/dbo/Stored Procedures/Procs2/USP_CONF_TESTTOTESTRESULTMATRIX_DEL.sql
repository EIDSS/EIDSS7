-- =========================================================================================
-- NAME: USP_CONF_TESTTOTESTRESULTMATRIX_DEL
-- DESCRIPTION: Deactivates a test to test result relationship

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/08/2019	Initial Release
-- Ricky Moss		03/27/2019	Added delete anyway field
--
-- exec USP_CONF_TESTTOTESTRESULTMATRIX_DEL 19000097, 803960000000, 807830000000, 0
-- exec USP_CONF_TESTTOTESTRESULTMATRIX_DEL 19000104, 6618660000000, 808040000000, 0
-- ========================================================================================
CREATE PROCEDURE USP_CONF_TESTTOTESTRESULTMATRIX_DEL
(
	@idfsTestResultRelation BIGINT,
	@idfsTestName BIGINT,
	@idfsTestResult BIGINT,
	@deleteAnyway BIT
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
BEGIN
	BEGIN TRY
		IF @idfsTestResultRelation = 19000097
		BEGIN
			UPDATE trtTestTypeToTestResult SET intRowStatus = 1 WHERE idfsTestName = @idfsTestName AND idfsTestResult = @idfsTestResult AND intRowStatus = 0
		END
		ELSE
		BEGIN
			UPDATE trtPensideTestTypeToTestResult SET intRowStatus = 1 WHERE idfsPensideTestName = @idfsTestName AND idfsPensideTestResult = @idfsTestResult AND intRowStatus = 0
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END