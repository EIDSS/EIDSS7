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
-- exec USP_REF_SPECIESTYPEREFERENCE_CANDEL 837840000000
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_SPECIESTYPEREFERENCE_CANDEL]
	@idfsSpeciesType BIGINT
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
		Declare @exists bit
		IF	EXISTS(select idfAggrDiagnosticActionMTX from tlbAggrDiagnosticActionMTX where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfAggrProphylacticActionMTX from tlbAggrProphylacticActionMTX where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfAggrVetCaseMTX from tlbAggrVetCaseMTX where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfCampaignToDiagnosis from tlbCampaignToDiagnosis where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfMonitoringSessionToDiagnosis from tlbMonitoringSessionToDiagnosis where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfCampaignToDiagnosis from tlbCampaignToDiagnosis where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfSpecies from tlbSpecies where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select CampaignToSampleTypeUID from CampaignToSampleType where idfsSpeciesType = @idfsSpeciesType)  OR
			EXISTS(select MonitoringSessionToSampleType from MonitoringSessionToSampleType where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfSpeciesActual from tlbSpeciesActual where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfSpeciesToGroupForCustomReport from trtSpeciesToGroupForCustomReport where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0) OR
			EXISTS(select idfSpeciesTypeToAnimalAge from trtSpeciesTypeToAnimalAge where idfsSpeciesType = @idfsSpeciesType and intRowStatus = 0)
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
