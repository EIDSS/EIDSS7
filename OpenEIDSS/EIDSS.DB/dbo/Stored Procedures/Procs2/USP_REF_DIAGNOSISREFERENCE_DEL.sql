--=====================================================================================================
-- Name: USP_REF_DIAGNOSISREFERENCE_DEL
-- Description: Removes diagnosis reference FROM active list of diagnoses
--							
-- Author:		Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/26/2018	Initial Release
-- Ricky Moss		12/12/2018	Removed return codes
-- Ricky Moss		02/09/2019	Added removal of tests, sample type and penside tests from disease
-- 
-- Test Code:
-- exec USP_REF_DIAGNOSISREFERENCE_DEL 6618200000000, 0
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_DIAGNOSISREFERENCE_DEL]
(
	@idfsDiagnosis BIGINT,
	@deleteAnyway BIT = 0
)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
	IF	(NOT EXISTS(SELECT idfAggrDiagnosticActionMTX FROM tlbAggrDiagnosticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfAggrHumanCaseMTX FROM tlbAggrHumanCaseMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfAggrDiagnosticActionMTX FROM tlbAggrDiagnosticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfAggrProphylacticActionMTX FROM tlbAggrProphylacticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfAggrVetCaseMTX FROM tlbAggrVetCaseMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfCampaign FROM tlbCampaign WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfCampaignToDiagnosis FROM tlbCampaignToDiagnosis WHERE idfsSpeciesType = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfMonitoringSession FROM tlbMonitoringSession WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfMonitoringSessionToDiagnosis FROM tlbMonitoringSessionToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfMonitoringSessionSummary FROM tlbMonitoringSessionSummaryDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfPensideTest FROM tlbPensideTest WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfTesting FROM tlbTesting WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfTestValidation FROM tlbTestValidation WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfVaccination FROM tlbVaccination WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfsVSSessionSummaryDiagnosis FROM tlbVectorSurveillanceSessionSummaryDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfDiagnosisToGroupForReportType FROM trtDiagnosisToGroupForReportType WHERE idfsDiagnosis = @idfsDiagnosis)  AND
			NOT EXISTS(SELECT idfFFObjectToDiagnosisForCustomReport FROM trtFFObjectToDiagnosisForCustomReport WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfMaterialForDisease FROM trtMaterialForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfPensideTestForDisease FROM trtPensideTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) AND
			NOT EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0)) OR @deleteAnyway = 1
	BEGIN

		UPDATE trtPensideTestForDisease SET intRowStatus = 1
			WHERE idfsDiagnosis = @idfsDiagnosis
			AND intRowStatus = 0
		
		UPDATE trtTestForDisease SET intRowStatus = 1
			WHERE idfsDiagnosis = @idfsDiagnosis
			AND intRowStatus = 0

		UPDATE trtMaterialForDisease SET intRowStatus = 1
			WHERE idfsDiagnosis = @idfsDiagnosis
			AND intRowStatus = 0

		UPDATE trtDiagnosis SET intRowStatus = 1 
			WHERE idfsDiagnosis = @idfsDiagnosis 
			AND intRowStatus = 0

		UPDATE trtBaseReference SET intRowStatus = 1 
			WHERE idfsBaseReference = @idfsDiagnosis 
			AND intRowStatus = 0

		UPDATE trtStringNameTranslation SET intRowStatus = 1
			WHERE idfsBaseReference = @idfsDiagnosis

	END
	ELSE IF	EXISTS(SELECT idfAggrDiagnosticActionMTX FROM tlbAggrDiagnosticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfAggrHumanCaseMTX FROM tlbAggrHumanCaseMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfAggrDiagnosticActionMTX FROM tlbAggrDiagnosticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfAggrProphylacticActionMTX FROM tlbAggrProphylacticActionMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfAggrVetCaseMTX FROM tlbAggrVetCaseMTX WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfCampaign FROM tlbCampaign WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfCampaignToDiagnosis FROM tlbCampaignToDiagnosis WHERE idfsSpeciesType = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfMonitoringSession FROM tlbMonitoringSession WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfMonitoringSessionToDiagnosis FROM tlbMonitoringSessionToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfMonitoringSessionSummary FROM tlbMonitoringSessionSummaryDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfPensideTest FROM tlbPensideTest WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfTesting FROM tlbTesting WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfTestValidation FROM tlbTestValidation WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfVaccination FROM tlbVaccination WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfsVSSessionSummaryDiagnosis FROM tlbVectorSurveillanceSessionSummaryDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfDiagnosisAgeGroupToDiagnosis FROM trtDiagnosisAgeGroupToDiagnosis WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfDiagnosisToGroupForReportType FROM trtDiagnosisToGroupForReportType WHERE idfsDiagnosis = @idfsDiagnosis)  OR
			EXISTS(SELECT idfFFObjectToDiagnosisForCustomReport FROM trtFFObjectToDiagnosisForCustomReport WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfMaterialForDisease FROM trtMaterialForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfPensideTestForDisease FROM trtPensideTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0) OR
			EXISTS(SELECT idfTestForDisease FROM trtTestForDisease WHERE idfsDiagnosis = @idfsDiagnosis AND intRowStatus = 0)
	BEGIN
		SELECT @returnCode = -1
		SELECT @returnMsg = 'IN USE'
	END
	SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END