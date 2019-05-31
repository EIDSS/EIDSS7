
-- ============================================================================
-- Name: USSP_VCT_MONITORINGSESSION_SUMMARY_SET
-- Description:	Inserts or updates monitoring session summary for the veterinary 
-- module monitoring session enter and edit use cases.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORINGSESSION_SUMMARY_SET]
(
	@LangID								NVARCHAR(50), 
	@idfMonitoringSessionSummary		BIGINT OUTPUT,
    @idfMonitoringSession				BIGINT,
    @idfFarm							BIGINT = NULL,
    @idfSpecies							BIGINT = NULL,
    @idfsAnimalSex						BIGINT = NULL,
	@intSampledAnimalsQty				INT = NULL,
	@intSamplesQty						INT = NULL, 
	@datCollectionDate					DATETIME = NULL,
	@intPositiveAnimalsQty				INT = NULL, 
	@intRowStatus						INT, 
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@idfsDiagnosis						BIGINT = NULL, 
	@idfsSampleType						BIGINT = NULL, 
	@RecordAction						NCHAR(1) 
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
				
			EXEC						dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSessionSummary', @idfMonitoringSessionSummary OUTPUT;

			INSERT INTO					dbo.tlbMonitoringSessionSummary
			(
										idfMonitoringSessionSummary,
										idfMonitoringSession,
										idfFarm,
										idfSpecies,
										idfsAnimalSex,
										intSampledAnimalsQty,
										intSamplesQty, 
										datCollectionDate,
										intPositiveAnimalsQty,
										intRowStatus,
										strMaintenanceFlag
           )
			VALUES
           (
										@idfMonitoringSessionSummary,
										@idfMonitoringSession,
										@idfFarm,
										@idfSpecies,
										@idfsAnimalSex,
										@intSampledAnimalsQty,
										@intSamplesQty, 
										@datCollectionDate,
										@intPositiveAnimalsQty,
										@intRowStatus,
										@strMaintenanceFlag
			);

			INSERT INTO					dbo.tlbMonitoringSessionSummaryDiagnosis
			(
										idfMonitoringSessionSummary,
										idfsDiagnosis, 
										intRowStatus, 
										blnChecked, 
										strMaintenanceFlag
			)
			VALUES 
			(
										@idfMonitoringSessionSummary,
										@idfsDiagnosis, 
										@intRowStatus, 
										1,
										@strMaintenanceFlag
			);

			INSERT INTO					dbo.tlbMonitoringSessionSummarySample 
			(
										idfMonitoringSessionSummary,
										idfsSampleType, 
										intRowStatus,
										blnChecked, 
										strMaintenanceFlag
			)
			VALUES
			(
										@idfMonitoringSessionSummary,
										@idfsSampleType, 
										@intRowStatus, 
										1, 
										@strMaintenanceFlag
			);
			END
		ELSE
			BEGIN
			
			UPDATE						dbo.tlbMonitoringSessionSummary
			SET 
										idfMonitoringSessionSummary = @idfMonitoringSessionSummary, 
										idfMonitoringSession = @idfMonitoringSession, 
										idfFarm = @idfFarm, 
										idfSpecies = @idfSpecies, 
										idfsAnimalSex = @idfsAnimalSex, 
										intSampledAnimalsQty = @intSampledAnimalsQty,
										intSamplesQty = @intSamplesQty, 
										datCollectionDate = @datCollectionDate, 
										intPositiveAnimalsQty = @intPositiveAnimalsQty, 
										intRowStatus = @intRowStatus, 
										strMaintenanceFlag = @strMaintenanceFlag 
			WHERE						idfMonitoringSessionSummary = @idfMonitoringSessionSummary;

			UPDATE						dbo.tlbMonitoringSessionSummaryDiagnosis
			SET							
										idfMonitoringSessionSummary = @idfMonitoringSessionSummary, 
										idfsDiagnosis = @idfsDiagnosis, 
										intRowStatus = @intRowStatus, 
										strMaintenanceFlag = @strMaintenanceFlag
			WHERE						idfMonitoringSessionSummary = @idfMonitoringSessionSummary 
			AND							idfsDiagnosis = @idfsDiagnosis;

			UPDATE						dbo.tlbMonitoringSessionSummarySample
			SET							
										idfMonitoringSessionSummary = @idfMonitoringSessionSummary, 
										idfsSampleType = @idfsSampleType, 
										intRowStatus = @intRowStatus, 
										strMaintenanceFlag = @strMaintenanceFlag
			WHERE						idfMonitoringSessionSummary = @idfMonitoringSessionSummary 
			AND							idfsSampleType = @idfsSampleType;

			END

		SELECT @returnCode, @returnMsg;
	END TRY
	BEGIN CATCH
		THROW;

		SELECT @returnCode, @returnMsg;
	END CATCH
END
