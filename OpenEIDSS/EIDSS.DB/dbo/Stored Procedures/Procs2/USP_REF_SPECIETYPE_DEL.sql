--=====================================================================================================
-- Name: USP_REF_SPECIETYPE_DEL
-- Description:	Removes species type FROM active list of species types
-- Author:		Ricky Moss
--							
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/26/2018	Initial Release
-- Ricky Moss		01/03/2019	Added deleteAnyway parameter
-- 
-- Test Code:
-- exec USP_REF_SPECIETYPE_DEL 55615180000088, 0
-- 
--=====================================================================================================
CREATE PROCEDURE [dbo].[USP_REF_SPECIETYPE_DEL]
(
	@idfsSpeciesType BIGINT,
	@deleteAnyway BIT
)
AS

DECLARE @returnCode					INT = 0 
DECLARE	@returnMsg					NVARCHAR(max) = 'SUCCESS' 

BEGIN
	BEGIN TRY
	IF  (NOT EXISTS(SELECT idfAggrDiagnosticActionMTX FROM tlbAggrDiagnosticActionMTX WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfAggrProphylacticActionMTX FROM tlbAggrProphylacticActionMTX WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfAggrVetCaseMTX FROM tlbAggrVetCaseMTX WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfCampaignToDiagnosis FROM tlbCampaignToDiagnosis WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfMonitoringSessionToDiagnosis FROM tlbMonitoringSessionToDiagnosis WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfCampaignToDiagnosis FROM tlbCampaignToDiagnosis WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfSpecies FROM tlbSpecies WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT CampaignToSampleTypeUID FROM CampaignToSampleType WHERE idfsSpeciesType = @idfsSpeciesType)  AND
		NOT EXISTS(SELECT MonitoringSessionToSampleType FROM MonitoringSessionToSampleType WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfSpeciesActual FROM tlbSpeciesActual WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfSpeciesToGroupForCustomReport FROM trtSpeciesToGroupForCustomReport WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0) AND
		NOT EXISTS(SELECT idfSpeciesTypeToAnimalAge FROM trtSpeciesTypeToAnimalAge WHERE idfsSpeciesType = @idfsSpeciesType AND intRowStatus = 0)) OR @deleteAnyway = 1
		BEGIN
		UPDATE trtSpeciesType SET intRowStatus = 1 
			WHERE idfsSpeciesType = @idfsSpeciesType 
			AND intRowStatus = 0

		UPDATE trtBaseReference SET intRowStatus = 1 
			WHERE idfsBaseReference = @idfsSpeciesType 
			AND intRowStatus = 0

		UPDATE trtStringNameTranslation SET intRowStatus = 1
			WHERE idfsBaseReference = @idfsSpeciesType
		END
		ELSE
		BEGIN
			SELECT @returnCode = 1
		END
		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMsg'
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
