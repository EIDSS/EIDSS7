--=====================================================================================================
-- Name: USP_CONF_CUSTOMREPORT_GETLIST
-- Description:	Returns list of custom disease reports
--							
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		03/21/2018  Initial Release
--
-- Test Code:
-- exec USP_CONF_CUSTOMREPORT_GETLIST 'en', 55540680000323 
-- exec USP_CONF_CUSTOMREPORT_GETLIST 'en', 55540680000324
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_CONF_CUSTOMREPORT_GETLIST]
(
	@langId NVARCHAR(10),
	@idfsCustomReportType BIGINT
)
AS
BEGIN
	BEGIN TRY
		SELECT rr.idfReportRows, rr.idfsCustomReportType, crtbr.name as strCustomReportType, d.idfsDiagnosisOrDiagnosisGroup, d.strDiagnosisOrDiagnosisGroupName, d.strDiseaseOrReportDiseaseGroup, d.strUsingType, rr.idfsReportAdditionalText, artbr.name AS strAdditionalReportText, rr.idfsICDReportAdditionalText, icdbr.name as strICDReportAdditionalText FROM trtReportRows rr
		JOIN FN_GBL_Reference_GETList(@langId, 19000129) crtbr
		ON rr.idfsCustomReportType = crtbr.idfsReference		
		join (SELECT dbr.idfsReference AS idfsDiagnosisOrDiagnosisGroup, dbr.name AS strDiagnosisOrDiagnosisGroupName, rtbr.name AS strDiseaseOrReportDiseaseGroup, utbr.name AS strUsingType from trtDiagnosis d
				JOIN FN_GBL_Reference_GETList(@langId, 19000019) dbr
				ON d.idfsDiagnosis = dbr.idfsReference
				JOIN FN_GBL_Reference_GETList(@langId, 19000076) rtbr
				ON dbr.idfsReferenceType = rtbr.idfsReference
				JOIN FN_GBL_Reference_GETList(@langId, 19000020) utbr
				ON d.idfsUsingType = utbr.idfsReference
				UNION
				SELECT rdgbr.idfsReference AS idfsDiagnosisOrDiagnosisGroup, rdgbr.name AS strDiagnosisOrDiagnosisGroupName, rtbr.name AS strDiseaseOrReportDiseaseGroup, null AS strUsingType from FN_GBL_Reference_GETList('en', 19000130) rdgbr
				JOIN FN_GBL_Reference_GETList(@langId, 19000076) rtbr
				ON rdgbr.idfsReferenceType = rtbr.idfsReference ) AS d
	ON d.idfsDiagnosisOrDiagnosisGroup = rr.idfsDiagnosisOrReportDiagnosisGroup
	LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000132) artbr
	ON rr.idfsReportAdditionalText = artbr.idfsReference
	LEFT JOIN FN_GBL_Reference_GETList(@langId, 19000132) icdbr
	ON rr.idfsICDReportAdditionalText = icdbr.idfsReference
	WHERE rr.intRowStatus = 0 AND rr.idfsCustomReportType = @idfsCustomReportType
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END