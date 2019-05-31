--=====================================================================================================
-- Author:		Ricky Moss.
-- Description:	Returns two (2) result sets.
--
-- 1) Checks to see if the species is being referred to as foreign key
-- 2) the return code and message.
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		2018/10/22 Initial Release
--
-- 
-- Test Code:
-- exec USP_REF_DIAGNOSISREFERENCE_CANDEL 837860000000
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_DIAGNOSISREFERENCE_CANDEL]
	@idfsDiagnosis BIGINT
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		Declare @exists bit
		IF	EXISTS(select idfAggrDiagnosticActionMTX from tlbAggrDiagnosticActionMTX where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfAggrHumanCaseMTX from tlbAggrHumanCaseMTX where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfAggrDiagnosticActionMTX from tlbAggrDiagnosticActionMTX where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfAggrProphylacticActionMTX from tlbAggrProphylacticActionMTX where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfAggrVetCaseMTX from tlbAggrVetCaseMTX where idfsSpeciesType = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfCampaign from tlbCampaign where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfCampaignToDiagnosis from tlbCampaignToDiagnosis where idfsSpeciesType = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSession from tlbMonitoringSession where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSessionToDiagnosis from tlbMonitoringSessionToDiagnosis where idfsSpeciesType = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSessionSummary from tlbMonitoringSessionSummaryDiagnosis where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfPensideTest from tlbPensideTest where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfTesting from tlbTesting where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfTestValidation from tlbTestValidation where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfVaccination from tlbVaccination where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfsVSSessionSummaryDiagnosis from tlbVectorSurveillanceSessionSummaryDiagnosis where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfDiagnosisAgeGroupToDiagnosis from trtDiagnosisAgeGroupToDiagnosis where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfDiagnosisToGroupForReportType from trtDiagnosisToGroupForReportType where idfsDiagnosis = @idfsDiagnosis)  OR
			EXISTS(select idfFFObjectToDiagnosisForCustomReport from trtFFObjectToDiagnosisForCustomReport where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfMaterialForDisease from trtMaterialForDisease where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfPensideTestForDisease from trtPensideTestForDisease where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0) OR
			EXISTS(select idfTestForDisease from trtTestForDisease where idfsDiagnosis = @idfsDiagnosis and intRowStatus = 0)
			BEGIN
				Select @exists = 1

				Select @exists as CurrentlyInUse
			END
			ELSE
			BEGIN
				Select @exists = 0

				Select @exists as CurrentlyInUse

			END
		SELECT						@returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
			BEGIN
			SET							@returnCode = ERROR_NUMBER();
			SET							@returnMsg = 
										'ErrorNumber: ' + CONVERT(VARCHAR, ERROR_NUMBER()) 
										+ ' ErrorSeverity: ' + CONVERT(VARCHAR, ERROR_SEVERITY())
										+ ' ErrorState: ' + CONVERT(VARCHAR, ERROR_STATE())
										+ ' ErrorProcedure: ' + ISNULL(ERROR_PROCEDURE(), '')
										+ ' ErrorLine: ' +  CONVERT(VARCHAR,ISNULL(ERROR_LINE(), ''))
										+ ' ErrorMessage: '+ ERROR_MESSAGE();

			SELECT						@returnCode, @returnMsg;
		END
	END CATCH
END
