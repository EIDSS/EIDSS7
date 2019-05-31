-- ============================================================================
-- Name: USSP_GBL_FARM_COPY
-- Description:	Get farm actual detail and copies to the farm table.
-- This includes the associated child records for the farm address and the 
-- farm owner (human table).
-- This will be typically called from the verterinary disease report set 
-- stored procedure.
--                      
-- Author: Stephen Long
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/06/2018 Initial release.
-- Stephen Long     04/21/2019 Updated to use geo location shared.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_FARM_COPY] (
	@idfFarmActual BIGINT,
	@intAvianTotalAnimalQty INT = NULL,
	@intAvianSickAnimalQty INT = NULL,
	@intAvianDeadAnimalQty INT = NULL,
	@intLivestockTotalAnimalQty INT = NULL,
	@intLivestockSickAnimalQty INT = NULL,
	@intLivestockDeadAnimalQty INT = NULL,
	@idfMonitoringSession BIGINT = NULL,
	@idfFarm BIGINT OUTPUT
	)
AS
DECLARE @idfFarmAddress BIGINT;
DECLARE @idfRootFarmAddress BIGINT;
DECLARE @idfHuman BIGINT;
DECLARE @idfHumanActual BIGINT;
DECLARE @returnCode INT = 0;
DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT @idfRootFarmAddress = idfFarmAddress,
			@idfHumanActual = idfHumanActual
		FROM dbo.tlbFarmActual
		WHERE idfFarmActual = @idfFarmActual;

		IF @idfFarm IS NULL
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbFarm',
				@idfFarm OUTPUT;

		-- Get ID for idfFarmAddress.
		SET @idfFarmAddress = NULL;

		SELECT @idfFarmAddress = idfFarmAddress
		FROM dbo.tlbFarm
		WHERE idfFarm = @idfFarm;

		IF @idfFarmAddress IS NULL
			AND NOT @idfRootFarmAddress IS NULL
		BEGIN
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbGeoLocationShared',
				@idfFarmAddress OUTPUT;

			-- Copy address from root farm.
			EXEC dbo.USP_GBL_GEOLOCATION_COPY @idfRootFarmAddress,
				@idfFarmAddress,
				1,
				@returnCode,
				@returnMsg;

			IF @returnCode <> 0
			BEGIN
				SET @returnMsg = 'Failed to copy farm address.'

				SELECT @returnCode,
					@returnMsg

				RETURN
			END
		END

		-- Get ID for idfHuman for the farm owner.
		SET @idfHuman = NULL;

		SELECT @idfHuman = idfHuman
		FROM dbo.tlbHuman
		WHERE idfHuman = @idfHuman

		IF @idfHuman IS NULL
			AND NOT @idfHumanActual IS NULL
		BEGIN
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbHuman',
				@idfHuman OUTPUT;

			-- Copy root human (human actual) to human for the farm owner.
			EXEC dbo.USP_HUM_COPYHUMANACTUALTOHUMAN @idfHumanActual,
				@idfHuman,
				@returnCode,
				@returnMsg;

			IF @returnCode <> 0
			BEGIN
				SET @returnMsg = 'Failed to copy human (farm owner).';

				SELECT @returnCode,
					@returnMsg;

				RETURN;
			END
		END

		IF EXISTS (
				SELECT *
				FROM dbo.tlbFarm
				WHERE idfFarm = @idfFarm
				)
		BEGIN
			UPDATE dbo.tlbFarm
			SET idfsAvianFarmType = fa.idfsAvianFarmType,
				idfsAvianProductionType = fa.idfsAvianProductionType,
				idfsFarmCategory = fa.idfsFarmCategory,
				idfsOwnershipStructure = fa.idfsOwnershipStructure,
				idfsMovementPattern = fa.idfsMovementPattern,
				idfsIntendedUse = fa.idfsIntendedUse,
				idfsGrazingPattern = fa.idfsGrazingPattern,
				idfsLivestockProductionType = fa.idfsLivestockProductionType,
				idfHuman = @idfHuman,
				idfMonitoringSession = @idfMonitoringSession,
				idfFarmAddress = @idfFarmAddress,
				strInternationalName = fa.strInternationalName,
				strNationalName = fa.strNationalName,
				strFarmCode = fa.strFarmCode,
				strFax = fa.strFax,
				strEmail = fa.strEmail,
				strContactPhone = fa.strContactPhone,
				intLivestockTotalAnimalQty = @intLivestockTotalAnimalQty,
				intAvianTotalAnimalQty = @intAvianTotalAnimalQty,
				intLivestockSickAnimalQty = @intLivestockSickAnimalQty,
				intAvianSickAnimalQty = @intAvianSickAnimalQty,
				intLivestockDeadAnimalQty = @intLivestockDeadAnimalQty,
				intAvianDeadAnimalQty = @intAvianDeadAnimalQty,
				intBuidings = fa.intBuidings,
				intBirdsPerBuilding = fa.intBirdsPerBuilding,
				strNote = fa.strNote,
				datModificationDate = GETDATE()
			FROM dbo.tlbFarm f
			INNER JOIN dbo.tlbFarmActual fa
				ON fa.idfFarmActual = f.idfFarmActual
			WHERE f.idfFarm = @idfFarm;
		END
		ELSE
		BEGIN
			INSERT INTO dbo.tlbFarm (
				idfFarm,
				idfFarmActual,
				idfMonitoringSession,
				idfsAvianFarmType,
				idfsAvianProductionType,
				idfsFarmCategory,
				idfsOwnershipStructure,
				idfsMovementPattern,
				idfsIntendedUse,
				idfsGrazingPattern,
				idfsLivestockProductionType,
				idfHuman,
				idfFarmAddress,
				strInternationalName,
				strNationalName,
				strFarmCode,
				strFax,
				strEmail,
				strContactPhone,
				intLivestockTotalAnimalQty,
				intAvianTotalAnimalQty,
				intLivestockSickAnimalQty,
				intAvianSickAnimalQty,
				intLivestockDeadAnimalQty,
				intAvianDeadAnimalQty,
				intBuidings,
				intBirdsPerBuilding,
				strNote,
				intRowStatus,
				datModificationDate
				)
			SELECT @idfFarm,
				@idfFarmActual,
				@idfMonitoringSession,
				idfsAvianFarmType,
				idfsAvianProductionType,
				idfsFarmCategory,
				idfsOwnershipStructure,
				idfsMovementPattern,
				idfsIntendedUse,
				idfsGrazingPattern,
				idfsLivestockProductionType,
				@idfHuman,
				@idfFarmAddress,
				strInternationalName,
				strNationalName,
				strFarmCode,
				strFax,
				strEmail,
				strContactPhone,
				@intLivestockTotalAnimalQty,
				@intAvianTotalAnimalQty,
				@intLivestockSickAnimalQty,
				@intAvianSickAnimalQty,
				@intLivestockDeadAnimalQty,
				@intAvianDeadAnimalQty,
				intBuidings,
				intBirdsPerBuilding,
				strNote,
				0,
				GETDATE()
			FROM dbo.tlbFarmActual
			WHERE idfFarmActual = @idfFarmActual;
		END

		SELECT @returnCode,
			@returnMsg;
	END TRY

	BEGIN CATCH
		THROW;

		SELECT @returnCode,
			@returnMsg;
	END CATCH
END
