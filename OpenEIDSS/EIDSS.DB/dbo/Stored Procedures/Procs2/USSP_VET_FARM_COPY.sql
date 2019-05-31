-- ================================================================================================
-- Name: USSP_VET_FARM_COPY
--
-- Description:	Get farm actual detail and copies to the farm table.  This includes the associated 
-- child records for the farm address and the farm owner (human table).
--
-- This is typically called from the veterinary disease report set stored procedure.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/08/2019 Initial release.
-- Stephen Long     05/13/2019 Fix to call of USP_GBL_GEOLOCATION_COPY to use 0 on the copy 
--                             default.
-- Stephen Long     05/26/2019 Added observation ID parameter.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_FARM_COPY] (
	@FarmMasterID BIGINT,
	@AvianTotalAnimalQuantity INT = NULL,
	@AvianSickAnimalQuantity INT = NULL,
	@AvianDeadAnimalQuantity INT = NULL,
	@LivestockTotalAnimalQuantity INT = NULL,
	@LivestockSickAnimalQuantity INT = NULL,
	@LivestockDeadAnimalQuantity INT = NULL,
	@MonitoringSessionID BIGINT = NULL,
	@ObservationID BIGINT = NULL, 
	@FarmID BIGINT = NULL OUTPUT
	)
AS
DECLARE @FarmAddressID BIGINT;
DECLARE @RootFarmAddressID BIGINT;
DECLARE @HumanID BIGINT;
DECLARE @HumanMasterID BIGINT;
DECLARE @ReturnCode INT = 0;
DECLARE @ReturnMessage NVARCHAR(MAX) = 'Vet Farm Copy Success';
DECLARE @SuppressSelect TABLE (
	ReturnCode INT,
	ReturnMessage NVARCHAR(MAX)
);

BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT @RootFarmAddressID = idfFarmAddress,
			@HumanMasterID = idfHumanActual
		FROM dbo.tlbFarmActual
		WHERE idfFarmActual = @FarmMasterID;

		IF @FarmID IS NULL
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbFarm',
				@FarmID OUTPUT;

		-- Get new FarmAddressID.
		SET @FarmAddressID = NULL;

		SELECT @FarmAddressID = idfFarmAddress
		FROM dbo.tlbFarm
		WHERE idfFarm = @FarmID;

		IF @FarmAddressID IS NULL
			AND NOT @RootFarmAddressID IS NULL
		BEGIN
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbGeoLocation',
				@FarmAddressID OUTPUT;

			-- Copy address from root farm.
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_GEOLOCATION_COPY @RootFarmAddressID,
				@FarmAddressID,
				0,
				@ReturnCode,
				@ReturnMessage;

			IF @ReturnCode <> 0
			BEGIN
				SET @ReturnMessage = 'Failed to copy farm address.'

				SELECT @ReturnCode,
					@ReturnMessage

				RETURN
			END
		END

		-- Get new HumanID for the farm owner.
		SET @HumanID = NULL;

		SELECT @HumanID = idfHuman
		FROM dbo.tlbHuman
		WHERE idfHuman = @HumanID

		IF @HumanID IS NULL
			AND NOT @HumanMasterID IS NULL
		BEGIN
			INSERT INTO @SuppressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbHuman',
				@HumanID OUTPUT;

			-- Copy root human actual to human snapshot for the farm owner.
			EXECUTE dbo.USP_HUM_COPYHUMANACTUALTOHUMAN @HumanMasterID,
				@HumanID,
				@ReturnCode,
				@ReturnMessage;

			IF @returnCode <> 0
			BEGIN
				SET @ReturnMessage = 'Failed to copy human (farm owner).';

				SELECT @ReturnCode,
					@ReturnMessage;

				RETURN;
			END
		END

		IF EXISTS (
				SELECT *
				FROM dbo.tlbFarm
				WHERE idfFarm = @FarmID
				)
		BEGIN
			UPDATE dbo.tlbFarm
			SET idfsFarmCategory = fa.idfsFarmCategory,
				idfsOwnershipStructure = fa.idfsOwnershipStructure,
				idfHuman = @HumanID,
				idfMonitoringSession = @MonitoringSessionID,
				idfFarmAddress = @FarmAddressID,
				strNationalName = fa.strNationalName,
				strFarmCode = fa.strFarmCode,
				strFax = fa.strFax,
				strEmail = fa.strEmail,
				strContactPhone = fa.strContactPhone,
				strNote = fa.strNote,
				intLivestockTotalAnimalQty = @LivestockTotalAnimalQuantity,
				intAvianTotalAnimalQty = @AvianTotalAnimalQuantity,
				intLivestockSickAnimalQty = @LivestockSickAnimalQuantity,
				intAvianSickAnimalQty = @AvianSickAnimalQuantity,
				intLivestockDeadAnimalQty = @LivestockDeadAnimalQuantity,
				intAvianDeadAnimalQty = @AvianDeadAnimalQuantity,
				idfObservation = @ObservationID, 
				datModificationDate = GETDATE()
			FROM dbo.tlbFarm f
			INNER JOIN dbo.tlbFarmActual fa
				ON fa.idfFarmActual = f.idfFarmActual
			WHERE f.idfFarm = @FarmID;
		END
		ELSE
		BEGIN
			INSERT INTO dbo.tlbFarm (
				idfFarm,
				idfFarmActual,
				idfMonitoringSession,
				idfsFarmCategory,
				idfsOwnershipStructure,
				idfHuman,
				idfFarmAddress,
				strNationalName,
				strFarmCode,
				strFax,
				strEmail,
				strContactPhone,
				strNote,
				intLivestockTotalAnimalQty,
				intAvianTotalAnimalQty,
				intLivestockSickAnimalQty,
				intAvianSickAnimalQty,
				intLivestockDeadAnimalQty,
				intAvianDeadAnimalQty,
				idfObservation, 
				intRowStatus,
				datModificationDate
				)
			SELECT @FarmID,
				@FarmMasterID,
				@MonitoringSessionID,
				idfsFarmCategory,
				idfsOwnershipStructure,
				@HumanID,
				@FarmAddressID,
				strNationalName,
				strFarmCode,
				strFax,
				strEmail,
				strContactPhone,
				strNote,
				@AvianTotalAnimalQuantity,
				@AvianSickAnimalQuantity,
				@AvianDeadAnimalQuantity,
				@LivestockTotalAnimalQuantity,
				@LivestockSickAnimalQuantity,
				@LivestockDeadAnimalQuantity,
				@ObservationID, 
				0,
				GETDATE()
			FROM dbo.tlbFarmActual
			WHERE idfFarmActual = @FarmMasterID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
