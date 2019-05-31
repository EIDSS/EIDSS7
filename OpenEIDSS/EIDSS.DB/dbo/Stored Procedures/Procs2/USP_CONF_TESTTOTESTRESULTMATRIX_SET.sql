-- ============================================================================
-- Name: USP_CONF_TESTTOTESTRESULTMATRIX_SET
-- Description:	Creates a test to test result matrix
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/11/2018 Initial release.
--
-- exec USP_CONF_TESTTOTESTRESULTMATRIX_SET 803960000000, '807830000000, 807990000000, 808040000000', 0
-- ============================================================================
ALTER PROCEDURE USP_CONF_TESTTOTESTRESULTMATRIX_SET
(
	@idfsTestResultRelation BIGINT,
	@idfsTestName BIGINT,
	@idfsTestResult BIGINT,
	@blnIndicative BIT
)
AS
DECLARE @returnCode					INT = 0  
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 
DECLARE @SupressSelect TABLE (retrunCode INT, returnMessage VARCHAR(200))
BEGIN
	BEGIN TRY
		IF @idfsTestResultRelation = 19000097
		BEGIN
				IF NOT EXISTS(SELECT idfsTestResult FROM trtTestTypeToTestResult WHERE idfsTestResult = @idfsTestResult AND idfsTestName = @idfsTestName)
				BEGIN
					INSERT INTO trtTestTypeToTestResult(idfsTestName, idfsTestResult, blnIndicative, intRowStatus) VALUES(@idfsTestName, @idfsTestResult, @blnIndicative, 0)
				END
				ELSE IF EXISTS(SELECT idfsTestResult FROM trtTestTypeToTestResult WHERE idfsTestResult = @idfsTestResult AND idfsTestName = @idfsTestName)
				BEGIN
					UPDATE trtTestTypeToTestResult SET intRowStatus = 0, blnIndicative = @blnIndicative WHERE idfsTestResult = @idfsTestResult AND idfsTestName = @idfsTestName
				END
		END
		ELSE
		BEGIN
				--creates new test for disease
				IF NOT EXISTS(SELECT idfsPensideTestResult FROM trtPensideTestTypeToTestResult WHERE idfsPensideTestResult = @idfsTestResult AND idfsPensideTestName = @idfsTestName)
				BEGIN
					INSERT INTO trtPensideTestTypeToTestResult(idfsPensideTestName, idfsPensideTestResult, blnIndicative, intRowStatus) VALUES(@idfsTestName, @idfsTestResult, @blnIndicative, 0)
				END
				ELSE IF EXISTS(SELECT idfsTestResult FROM trtTestTypeToTestResult WHERE idfsTestResult = @idfsTestResult AND idfsTestName = @idfsTestName)
				BEGIN
					UPDATE trtTestTypeToTestResult SET intRowStatus = 0, blnIndicative = @blnIndicative WHERE idfsTestResult = @idfsTestResult AND idfsTestName = @idfsTestName
				END
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfsTestName 'idfsTestName'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END