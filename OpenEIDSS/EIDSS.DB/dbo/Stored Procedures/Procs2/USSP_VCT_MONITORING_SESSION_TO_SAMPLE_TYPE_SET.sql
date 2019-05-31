-- ================================================================================================
-- Name: USSP_VCT_MONITORING_SESSION_TO_SAMPLE_TYPE_SET
--
-- Description:	Inserts or updates monitoring session to sample type for the veterinary module 
-- monitoring session set up and edit use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     05/01/2019 Initial release.
-- Stephen Long     05/22/2019 Removed output on MonitoringSessionToSampleTypeID parameter.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VCT_MONITORING_SESSION_TO_SAMPLE_TYPE_SET] (
	@LanguageID NVARCHAR(50),
	@MonitoringSessionToSampleTypeID BIGINT,
	@MonitoringSessionID BIGINT,
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
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'MonitoringSessionToSampleType',
				@MonitoringSessionToSampleTypeID OUTPUT;

			INSERT INTO dbo.MonitoringSessionToSampleType (
				MonitoringSessionToSampleType,
				idfMonitoringSession,
				intOrder,
				intRowStatus,
				idfsSpeciesType,
				idfsSampleType
				)
			VALUES (
				@MonitoringSessionToSampleTypeID,
				@MonitoringSessionID,
				@OrderNumber,
				@RowStatus,
				@SpeciesTypeID,
				@SampleTypeID
				);
		END;
		ELSE
		BEGIN
			UPDATE dbo.MonitoringSessionToSampleType
			SET idfMonitoringSession = @MonitoringSessionID,
				intOrder = @OrderNumber,
				intRowStatus = @RowStatus,
				idfsSpeciesType = @SpeciesTypeID,
				idfsSampleType = @SampleTypeID
			WHERE MonitoringSessionToSampleType = @MonitoringSessionToSampleTypeID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
