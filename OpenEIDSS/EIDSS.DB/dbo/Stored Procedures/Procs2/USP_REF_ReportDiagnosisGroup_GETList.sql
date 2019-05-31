
--=====================================================================================================
-- Name: USP_REF_REPORTDIAGNOSISGROUP_GETList
-- Description:	Returns a list of active Report Diagnosis Groups
--
-- Author:		Ricky Moss
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		10/03/2018 Initial Release
-- Ricky Moss		01/16/2019 Remove return code
-- 
-- Test Code:
-- exec USP_REF_REPORTDIAGNOSISGROUP_GETList 'en'
-- 
--=====================================================================================================


CREATE PROCEDURE [dbo].[USP_REF_ReportDiagnosisGroup_GETList]
(
	@LangID  NVARCHAR(50) -- language ID 
)
AS
BEGIN
BEGIN TRY
	SELECT
		rdg.[idfsReportDiagnosisGroup], 
		br.[idfsReferenceType],
		br.[strDefault],
		br.[name] as strName,
		rdg.[strCode]

	FROM dbo.[trtReportDiagnosisGroup] as rdg
	INNER JOIN FN_GBL_Reference_GETList(@LangID, 19000130) br
	ON rdg.idfsReportDiagnosisGroup = br.idfsReference
	AND rdg.intRowStatus = 0
	ORDER BY
		br.[intOrder] asc,
		br.[strDefault] asc;
END TRY
BEGIN CATCH
	THROW;
END CATCH
END
