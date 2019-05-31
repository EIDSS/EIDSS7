-- ================================================================================================
-- Name: USP_VET_FARM_MASTER_DEL
--
-- Description:	Sets a farm master record to "inactive".
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/08/2019 Initial release.
-- Stephen Long     04/26/2019 Made fixes to the laboratory sample count, and set the return code 
--                             accordingly; 0 if farm was soft deleted and 1 or 2 if a dependent 
--                             child objects exist or dependent on another object.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_MASTER_DEL] (
	@LanguageID NVARCHAR(50),
	@FarmMasterID BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0,
		@ReturnMessage NVARCHAR(MAX) = 'SUCCESS',
		@MonitoringSessionCount INT = 0,
		@DiseaseReportCount INT = 0,
		@OutbreakSessionCount INT = 0,
		@LabSampleCount INT = 0;

	BEGIN TRY
		SELECT @MonitoringSessionCount = COUNT(*)
		FROM dbo.tlbMonitoringSessionSummary m
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = m.idfFarm
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		WHERE fa.idfFarmActual = @FarmMasterID;

		SELECT @OutbreakSessionCount = COUNT(*) 
		FROM dbo.tlbOutbreak o 
		INNER JOIN dbo.tlbVetCase AS v
			ON v.idfOutbreak = o.idfOutbreak
				AND v.intRowStatus = 0
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = v.idfFarm
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		WHERE fa.idfFarmActual = @FarmMasterID;

		SELECT @DiseaseReportCount = COUNT(*)
		FROM dbo.tlbVetCase v
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = v.idfFarm
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		WHERE fa.idfFarmActual = @FarmMasterID;

		SELECT @LabSampleCount = COUNT(*)
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbVetCase AS v
			ON v.idfVetCase = m.idfVetCase
				AND v.intRowStatus = 0
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = v.idfFarm
				AND f.intRowStatus = 0
		INNER JOIN dbo.tlbFarmActual AS fa
			ON fa.idfFarmActual = f.idfFarmActual
		WHERE fa.idfFarmActual = @FarmMasterID
			AND m.intRowStatus = 0 
			AND m.blnAccessioned = 1;

		IF @MonitoringSessionCount = 0
			AND @OutbreakSessionCount = 0
			AND @DiseaseReportCount = 0
			AND @LabSampleCount = 0
		BEGIN
			UPDATE s
			SET s.intRowStatus = 1
			FROM dbo.tlbSpeciesActual AS s
			INNER JOIN dbo.tlbHerdActual AS h
				ON h.idfHerdActual = s.idfHerdActual
			WHERE h.idfFarmActual = @FarmMasterID;

			UPDATE dbo.tlbHerdActual
			SET intRowStatus = 1
			WHERE idfFarmActual = @FarmMasterID;

			UPDATE dbo.tlbFarmActual
			SET intRowStatus = 1,
				datModificationDate = GETDATE()
			WHERE idfFarmActual = @FarmMasterID;

			SET @ReturnCode = 0;
		END
		ELSE
		BEGIN
			IF @MonitoringSessionCount > 0 OR @LabSampleCount > 0
			BEGIN
					SET @ReturnCode = 2;
					SET @ReturnMessage = 'Unable to delete this record as it is dependent on another object.';
			END;
			ELSE
			BEGIN
				SET @ReturnCode = 1;
				SET @ReturnMessage = 'Unable to delete this record as it contains dependent child objects.';
			END;
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