-- ================================================================================================
-- Name: USP_VET_FARM_MASTER_SET
--
-- Description:	Inserts and updates farm records.
-- 
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/05/2019 Initial release.
-- Stephen Long     04/23/2019 Added suppress select on herd and species stored procedure calls.
-- Stephen Long     05/24/2019 Correction on flock/herds and species parameters.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_MASTER_SET] (
	@LanguageID NVARCHAR(50),
	@FarmMasterID BIGINT,
	@FarmTypeID BIGINT = NULL,
	@FarmOwnerID BIGINT = NULL,
	@FarmName NVARCHAR(200) = NULL,
	@EIDSSFarmID NVARCHAR(200) = NULL,
	@OwnershipStructureTypeID BIGINT = NULL,
	@Fax NVARCHAR(200) = NULL,
	@Email NVARCHAR(200) = NULL,
	@Phone NVARCHAR(200) = NULL,
	@FarmAddressID BIGINT = NULL,
	@ForeignAddressIndicator BIT = 0,
	@FarmAddressCountryID BIGINT = NULL,
	@FarmAddressRegionID BIGINT = NULL,
	@FarmAddressRayonID BIGINT = NULL,
	@FarmAddressSettlementID BIGINT = NULL,
	@FarmAddressStreet NVARCHAR(200) = NULL,
	@FarmAddressApartment NVARCHAR(200) = NULL,
	@FarmAddressBuilding NVARCHAR(200) = NULL,
	@FarmAddressHouse NVARCHAR(200) = NULL,
	@FarmAddressPostalCode NVARCHAR(200) = NULL,
	@FarmAddressLatitude FLOAT = NULL,
	@FarmAddressLongitude FLOAT = NULL,
	@HerdsOrFlocks NVARCHAR(MAX) = NULL,
	@Species NVARCHAR(MAX) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ReturnCode INT = 0;
	DECLARE @ReturnMessage NVARCHAR(MAX) = 'SUCCESS';
	DECLARE @SupressSelect TABLE (
		ReturnCode INT,
		ReturnMessage NVARCHAR(MAX)
		);
	DECLARE @HerdMasterID BIGINT,
		@EIDSSHerdID NVARCHAR(200) = NULL,
		@SickAnimalQuantity INT = NULL,
		@TotalAnimalQuantity INT = NULL,
		@DeadAnimalQuantity INT = NULL,
		@Note NVARCHAR(2000) = NULL,
		@RowAction CHAR(1) = NULL,
		@RowID BIGINT = NULL,
		@RowStatus INT = NULL,
		---------------
		@SpeciesMasterID BIGINT,
		@SpeciesTypeID BIGINT,
		@StartOfSignsDate DATETIME = NULL,
		@AverageAge NVARCHAR(200) = NULL,
		@ObservationID BIGINT = NULL;
	DECLARE @HerdOrFlockMasterTemp TABLE (
		HerdMasterID BIGINT NOT NULL,
		EIDSSHerdID NVARCHAR(200) NULL,
		FarmMasterID BIGINT NOT NULL, 
		SickAnimalQuantity INT NULL,
		TotalAnimalQuantity INT NULL,
		DeadAnimalQuantity INT NULL,
		RowStatus INT NULL,
		RowAction CHAR(1) NULL
		);
	DECLARE @SpeciesMasterTemp TABLE (
		SpeciesMasterID BIGINT NOT NULL,
		HerdMasterID BIGINT NOT NULL,
		SpeciesTypeID BIGINT NOT NULL,
		SickAnimalQuantity INT NULL,
		TotalAnimalQuantity INT NULL,
		DeadAnimalQuantity INT NULL,
		StartOfSignsDate DATETIME NULL,
		AverageAge NVARCHAR(200) NULL,
		ObservationID BIGINT NULL,
		RowStatus INT NULL,
		RowAction CHAR(1) NULL
		);

	BEGIN TRY
		BEGIN TRANSACTION;

		-- Set farm address 
		IF @FarmAddressCountryID IS NOT NULL
			AND @FarmAddressRayonID IS NOT NULL
			AND @FarmAddressRegionID IS NOT NULL
			EXECUTE dbo.USP_GBL_ADDRESS_SET @FarmAddressID OUTPUT,
				NULL,
				NULL,
				NULL,
				@FarmAddressCountryID,
				@FarmAddressRegionID,
				@FarmAddressRayonID,
				@FarmAddressSettlementID,
				@FarmAddressApartment,
				@FarmAddressBuilding,
				@FarmAddressStreet,
				@FarmAddressHouse,
				@FarmAddressPostalCode,
				NULL,
				NULL,
				@FarmAddressLatitude,
				@FarmAddressLongitude,
				NULL,
				NULL,
				@ForeignAddressIndicator,
				NULL,
				1,
				@ReturnCode OUTPUT,
				@ReturnMessage OUTPUT;

		IF NOT EXISTS (
				SELECT *
				FROM dbo.tlbFarmActual
				WHERE idfFarmActual = @FarmMasterID
					AND intRowStatus = 0
				)
		BEGIN
			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbFarmActual',
				@idfsKey = @FarmMasterID OUTPUT;

			INSERT INTO @SupressSelect
			EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Farm',
				@NextNumberValue = @EIDSSFarmID OUTPUT,
				@InstallationSite = NULL;

			INSERT INTO dbo.tlbFarmActual (
				idfFarmActual,
				idfsFarmCategory,
				idfHumanActual,
				idfFarmAddress,
				strNationalName,
				strFarmCode,
				idfsOwnershipStructure,
				strFax,
				strEmail,
				strContactPhone,
				intLivestockTotalAnimalQty,
				intAvianTotalAnimalQty,
				intLivestockSickAnimalQty,
				intAvianSickAnimalQty,
				intLivestockDeadAnimalQty,
				intAvianDeadAnimalQty,
				intRowStatus,
				datModificationDate
				)
			VALUES (
				@FarmMasterID,
				@FarmTypeID,
				@FarmOwnerID,
				@FarmAddressID,
				@FarmName,
				@EIDSSFarmID,
				@OwnershipStructureTypeID,
				@Fax,
				@Email,
				@Phone,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				GETDATE()
				);
		END
		ELSE
		BEGIN
			IF @EIDSSFarmID IS NULL
				OR @EIDSSFarmID = ''
			BEGIN
				INSERT INTO @SupressSelect
				EXECUTE dbo.USP_GBL_NextNumber_GET @ObjectName = N'Farm',
					@NextNumberValue = @EIDSSFarmID OUTPUT,
					@InstallationSite = NULL;
			END;

			UPDATE dbo.tlbFarmActual
			SET idfsFarmCategory = @FarmTypeID,
				idfHumanActual = @FarmOwnerID,
				idfFarmAddress = @FarmAddressID,
				strNationalName = @FarmName,
				strFarmCode = @EIDSSFarmID,
				idfsOwnershipStructure = @OwnershipStructureTypeID,
				strFax = @Fax,
				strEmail = @Email,
				strContactPhone = @Phone,
				datModificationDate = GETDATE()
			WHERE idfFarmActual = @FarmMasterID;
		END;

		INSERT INTO @HerdOrFlockMasterTemp
		SELECT *
		FROM OPENJSON(@HerdsOrFlocks) WITH (
				HerdMasterID BIGINT,
				EIDSSHerdID NVARCHAR(200),
				FarmMasterID BIGINT, 
				SickAnimalQuantity INT,
				TotalAnimalQuantity INT,
				DeadAnimalQuantity INT,
				RowStatus INT,
				RowAction CHAR
				);

		INSERT INTO @SpeciesMasterTemp
		SELECT *
		FROM OPENJSON(@Species) WITH (
				SpeciesMasterID BIGINT,
				HerdMasterID BIGINT, 
				SpeciesTypeID BIGINT,
				SickAnimalQuantity INT,
				TotalAnimalQuantity INT,
				DeadAnimalQuantity INT,
				StartOfSignsDate DATETIME,
				AverageAge NVARCHAR(200),
				ObservationID BIGINT,
				RowStatus INT,
				RowAction CHAR
				);

		WHILE EXISTS (
				SELECT *
				FROM @HerdOrFlockMasterTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = HerdMasterID,
				@HerdMasterID = HerdMasterID,
				@EIDSSHerdID = EIDSSHerdID,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @HerdOrFlockMasterTemp;

			INSERT INTO @SupressSelect
			EXECUTE dbo.USSP_VET_HERD_MASTER_SET @LanguageID,
				@HerdMasterID OUTPUT,
				@FarmMasterID,
				@EIDSSHerdID OUTPUT,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				NULL,
				@RowStatus,
				@RowAction;

			IF @RowAction = 'I'
			BEGIN
				UPDATE @SpeciesMasterTemp
				SET HerdMasterID = @HerdMasterID
				WHERE HerdMasterID = @RowID;
			END

			DELETE
			FROM @HerdOrFlockMasterTemp
			WHERE HerdMasterID = @RowID;
		END;

		WHILE EXISTS (
				SELECT *
				FROM @SpeciesMasterTemp
				)
		BEGIN
			SELECT TOP 1 @RowID = SpeciesMasterID,
				@SpeciesMasterID = SpeciesMasterID,
				@SpeciesTypeID = SpeciesTypeID,
				@StartOfSignsDate = StartOfSignsDate,
				@AverageAge = AverageAge,
				@SickAnimalQuantity = SickAnimalQuantity,
				@TotalAnimalQuantity = TotalAnimalQuantity,
				@DeadAnimalQuantity = DeadAnimalQuantity,
				@ObservationID = ObservationID,
				@RowStatus = RowStatus,
				@RowAction = RowAction
			FROM @SpeciesMasterTemp;

			INSERT INTO @SupressSelect
			EXECUTE dbo.USSP_VET_SPECIES_MASTER_SET @LanguageID,
				@SpeciesMasterID OUTPUT,
				@SpeciesTypeID,
				@HerdMasterID,
				@ObservationID,
				@StartOfSignsDate,
				@AverageAge,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				NULL,
				@RowStatus,
				@RowAction;

			DELETE
			FROM @SpeciesMasterTemp
			WHERE SpeciesMasterID = @RowID;
		END;

		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@FarmMasterID FarmMasterID,
			@EIDSSFarmID EIDSSFarmID;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage,
			@FarmMasterID FarmMasterID,
			@EIDSSFarmID EIDSSFarmID;

		THROW;
	END CATCH
END
