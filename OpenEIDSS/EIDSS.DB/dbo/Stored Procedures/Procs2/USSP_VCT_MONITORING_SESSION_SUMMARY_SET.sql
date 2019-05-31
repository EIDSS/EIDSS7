-- ================================================================================================
-- Name: USSP_VCT_MONITORING_SESSION_SUMMARY_SET
--
-- Description:	Inserts or updates monitoring session summary for the human and veterinary module 
-- monitoring session enter and edit use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/07/2018 Initial release.
-- Stephen Long     04/30/2019 Modified for new API; removed maintenance flag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORING_SESSION_SUMMARY_SET] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionSummaryID BIGINT OUTPUT,
	@MonitoringSessionID BIGINT,
	@FarmID BIGINT = NULL,
	@SpeciesID BIGINT = NULL,
	@AnimalGenderTypeID BIGINT = NULL,
	@SampledAnimalsQuantity INT = NULL,
	@SamplesQuantity INT = NULL,
	@CollectionDate DATETIME = NULL,
	@PositiveAnimalsQuantity INT = NULL,
	@RowStatus INT,
	@DiseaseID BIGINT = NULL,
	@SampleTypeID BIGINT = NULL,
	@RowAction CHAR
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSessionSummary',
				@MonitoringSessionSummaryID OUTPUT;

			INSERT INTO dbo.tlbMonitoringSessionSummary (
				idfMonitoringSessionSummary,
				idfMonitoringSession,
				idfFarm,
				idfSpecies,
				idfsAnimalSex,
				intSampledAnimalsQty,
				intSamplesQty,
				datCollectionDate,
				intPositiveAnimalsQty,
				intRowStatus
				)
			VALUES (
				@MonitoringSessionSummaryID,
				@MonitoringSessionID,
				@FarmID,
				@SpeciesID,
				@AnimalGenderTypeID,
				@SampledAnimalsQuantity,
				@SamplesQuantity,
				@CollectionDate,
				@PositiveAnimalsQuantity,
				@RowStatus
				);

			INSERT INTO dbo.tlbMonitoringSessionSummaryDiagnosis (
				idfMonitoringSessionSummary,
				idfsDiagnosis,
				intRowStatus,
				blnChecked,
				strMaintenanceFlag
				)
			VALUES (
				@MonitoringSessionSummaryID,
				@DiseaseID,
				@RowStatus,
				1
				);

			INSERT INTO dbo.tlbMonitoringSessionSummarySample (
				idfMonitoringSessionSummary,
				idfsSampleType,
				intRowStatus,
				blnChecked
				)
			VALUES (
				@MonitoringSessionSummaryID,
				@SampleTypeID,
				@RowStatus,
				1
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbMonitoringSessionSummary
			SET idfMonitoringSessionSummary = @MonitoringSessionSummaryID,
				idfMonitoringSession = @MonitoringSessionID,
				idfFarm = @FarmID,
				idfSpecies = @SpeciesID,
				idfsAnimalSex = @AnimalGenderTypeID,
				intSampledAnimalsQty = @SampledAnimalsQuantity,
				intSamplesQty = @SamplesQuantity,
				datCollectionDate = @CollectionDate,
				intPositiveAnimalsQty = @PositiveAnimalsQuantity,
				intRowStatus = @RowStatus
			WHERE idfMonitoringSessionSummary = @MonitoringSessionSummaryID;

			UPDATE dbo.tlbMonitoringSessionSummaryDiagnosis
			SET idfMonitoringSessionSummary = @MonitoringSessionSummaryID,
				idfsDiagnosis = @DiseaseID,
				intRowStatus = @RowStatus
			WHERE idfMonitoringSessionSummary = @MonitoringSessionSummaryID
				AND idfsDiagnosis = @DiseaseID;

			UPDATE dbo.tlbMonitoringSessionSummarySample
			SET idfMonitoringSessionSummary = @MonitoringSessionSummaryID,
				idfsSampleType = @SampleTypeID,
				intRowStatus = @RowStatus
			WHERE idfMonitoringSessionSummary = @MonitoringSessionSummaryID
				AND idfsSampleType = @SampleTypeID;
		END
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
