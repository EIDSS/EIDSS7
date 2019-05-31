-- =========================================================================================
-- NAME: USP_CONF_TESTTOTESTRESULTMATRIX_GETLIST
-- DESCRIPTION: Returns a list of test to test result relationships

-- AUTHOR: Ricky Moss

-- Revision History:
-- Name             Date        Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/08/2019	Initial Release
--
-- exec USP_CONF_TESTTOTESTRESULTMATRIX_GETLIST 'en', 19000097, 803960000000
-- exec USP_CONF_TESTTOTESTRESULTMATRIX_GETLIST 'en', 190000104, 807510000000
-- ========================================================================================
CREATE PROCEDURE USP_CONF_TESTTOTESTRESULTMATRIX_GETLIST
(
	@langId NVARCHAR(10),
	@idfsTestResultRelation BIGINT,
	@idfsTestName BIGINT
)
AS
BEGIN
	BEGIN TRY
		IF @idfsTestResultRelation = 19000097
			SELECT idfsTestName, tnbr.strDefault as strTestNameDefault, tnbr.name as strTestName, idfsTestResult, trbr.strDefault as strTestResultDefault, trbr.name as strTestResultName, blnIndicative FROM trtTestTypeToTestResult ttr
			LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000097) tnbr
			ON ttr.idfsTestName = tnbr.idfsReference
			LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000096) trbr
			ON ttr.idfsTestResult = trbr.idfsReference	
			WHERE ttr.intRowStatus = 0 AND idfsTestName = @idfsTestName
		ELSE
			SELECT idfsPensideTestName, ptnbr.strDefault as strTestNameDefault, ptnbr.name as strTestName, idfsPensideTestResult, ptrbr.strDefault as strTestResultDefault, ptrbr.name as strTestResultName, blnIndicative FROM trtPensideTestTypeToTestResult pttr
			LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000104) ptnbr
			ON pttr.idfsPensideTestName = ptnbr.idfsReference
			LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000105) ptrbr
			ON pttr.idfsPensideTestResult = ptrbr.idfsReference
			WHERE pttr.intRowStatus = 0 AND idfsPensideTestName = @idfsTestName
	END TRY
	BEGIN CATCH
		THROW
	END CATCH
END