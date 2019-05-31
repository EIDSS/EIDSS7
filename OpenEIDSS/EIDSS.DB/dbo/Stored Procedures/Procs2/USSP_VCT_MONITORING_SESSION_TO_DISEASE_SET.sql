-- ================================================================================================
-- Name: USSP_VCT_MONITORING_SESSION_TO_DISEASE_SET
--
-- Description:	Inserts or updates monitoring session to disease for the veterinary module 
-- monitoring session set up and edit use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/21/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORING_SESSION_TO_DISEASE_SET] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionToDiseaseID BIGINT OUTPUT,
	@MonitoringSessionID BIGINT,
	@DiseaseID BIGINT, 
	@OrderNumber INT,
	@RowStatus INT,
	@SpeciesTypeID BIGINT = NULL,
	@SampleTypeID BIGINT = NULL,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbMonitoringSessionToDiagnosis',
				@MonitoringSessionToDiseaseID OUTPUT;

			INSERT INTO dbo.tlbMonitoringSessionToDiagnosis (
				idfMonitoringSessionToDiagnosis,
				idfMonitoringSession,
				idfsDiagnosis, 
				intOrder,
				intRowStatus,
				idfsSpeciesType,
				idfsSampleType
				)
			VALUES (
				@MonitoringSessionToDiseaseID,
				@MonitoringSessionID,
				@DiseaseID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID
				);
		END;
		ELSE
		BEGIN
			UPDATE dbo.tlbMonitoringSessionToDiagnosis
			SET idfMonitoringSession = @MonitoringSessionID,
				idfsDiagnosis = @DiseaseID,
				intOrder = @OrderNumber,
				intRowStatus = @RowStatus,
				idfsSpeciesType = @SpeciesTypeID,
				idfsSampleType = @SampleTypeID
			WHERE idfMonitoringSessionToDiagnosis = @MonitoringSessionToDiseaseID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
GO


