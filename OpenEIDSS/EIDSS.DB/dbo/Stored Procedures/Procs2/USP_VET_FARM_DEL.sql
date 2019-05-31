-- ============================================================================
-- Name: USP_VET_FARM_DEL
--
-- Description:	Sets a farm record to "inactive".
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/08/2019 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_DEL] (
	@LanguageID NVARCHAR(50),
	@FarmID BIGINT
	)
AS
DECLARE @ReturnCode INT = 0;
DECLARE @ReturnMessage NVARCHAR(max) = 'SUCCESS';
DECLARE @MonitoringSessionCount INT = 0,
	@DiseaseReportCount INT = 0,
	@LabSampleCount INT = 0;

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT @MonitoringSessionCount = COUNT(*)
		FROM dbo.tlbMonitoringSessionSummary m
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = m.idfFarm
		WHERE f.idfFarm = @FarmID;

		SELECT @DiseaseReportCount = COUNT(*)
		FROM dbo.tlbVetCase v
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = v.idfFarm
		WHERE f.idfFarm = @FarmID;

		SELECT @LabSampleCount = COUNT(*)
		FROM dbo.tlbAnimal a
		INNER JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = a.idfSpecies
		INNER JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
		WHERE f.idfFarm = @FarmID;

		IF @MonitoringSessionCount = 0
			AND @DiseaseReportCount = 0
			AND @LabSampleCount = 0
		BEGIN
			UPDATE dbo.tlbFarm
			SET intRowStatus = 1,
				datModificationDate = GETDATE()
			WHERE idfFarm = @FarmID;
		END;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@MonitoringSessionCount MonitoringSessionCount,
			@DiseaseReportCount DiseaseReportCount,
			@LabSampleCount LaboratorySampleTestResultCount;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
GO


