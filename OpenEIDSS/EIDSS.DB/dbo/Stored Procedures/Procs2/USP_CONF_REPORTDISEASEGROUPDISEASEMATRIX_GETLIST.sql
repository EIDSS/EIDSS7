-- ==============================================================================================================
--Name: USP_CONF_REPORTDISEASEGROUPDISEASEMATRIX_GETLIST
-- Description:	Returns list of report disease group to disease matrices given a custom report type and report disease group  						
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/25/2018  Initial Release
--
-- Test Code:
-- exec USP_CONF_REPORTDISEASEGROUPDISEASEMATRIX_GETLIST 'en', 55540680000323, 53352780000000
-- ==============================================================================================================
CREATE PROCEDURE USP_CONF_REPORTDISEASEGROUPDISEASEMATRIX_GETLIST
(
	@langId NVARCHAR(50),
	@idfsCustomReportType BIGINT,
	@idfsReportDiagnosisGroup BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT dgrt.idfDiagnosisToGroupForReportType, dgrt.idfsCustomReportType, crtbr.name as strCustomReportType, dgrt.idfsDiagnosis, dbr.name as strDiagnosis, d.idfsUsingType, utbr.name as strUsingType, dbo.FN_GBL_HACodeNames_ToCSV(@langId, dbr.intHACode) as strAccessoryCode, dgrt.idfsReportDiagnosisGroup, rdgbr.name as strReportDiagnosisGroup, CASE WHEN dgrt.intRowStatus = 0 THEN 'No' ELSE 'Yes' END AS strIsDelete  FROM trtDiagnosisToGroupForReportType dgrt
		JOIN trtDiagnosis d
		ON dgrt.idfsDiagnosis = d.idfsDiagnosis
		JOIN FN_GBL_Reference_GETList('en',19000019) dbr
		ON d.idfsDiagnosis = dbr.idfsReference
		JOIN FN_GBL_Reference_GETList('en',19000020) utbr
		ON d.idfsUsingType = utbr.idfsReference		
		JOIN FN_GBL_Reference_GETList('en',19000129) crtbr
		ON dgrt.idfsCustomReportType = crtbr.idfsReference		
		JOIN FN_GBL_Reference_GETList('en',19000130) rdgbr
		ON dgrt.idfsReportDiagnosisGroup = rdgbr.idfsReference
		WHERE dgrt.idfsCustomReportType = @idfsCustomReportType AND dgrt.idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END