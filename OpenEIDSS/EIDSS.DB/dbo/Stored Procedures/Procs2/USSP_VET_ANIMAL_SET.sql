-- ================================================================================================
-- Name: USSP_VET_ANIMAL_SET
--
-- Description:	Inserts or updates animal for the avian veterinary disease report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     03/28/2019 Changed from V6.1 get next number call to V7.
-- Stephen Long     04/17/2019 Rename params and removed strMaintenanceFlag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_ANIMAL_SET] (
	@LanguageID NVARCHAR(50),
	@AnimalID BIGINT OUTPUT,
	@AnimalGenderTypeID BIGINT = NULL,
	@AnimalConditionTypeID BIGINT = NULL,
	@AnimalAgeTypeID BIGINT = NULL,
	@SpeciesID BIGINT = NULL,
	@ObservationID BIGINT = NULL,
	@AnimalDescription NVARCHAR(200) = NULL,
	@EIDSSAnimalID NVARCHAR(200) = NULL,
	@AnimalName NVARCHAR(200) = NULL,
	@Color NVARCHAR(200) = NULL,
	@RowStatus INT,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbAnimal',
				@AnimalID OUTPUT;

			EXECUTE dbo.USP_GBL_NextNumber_GET 'Animal',
				@EIDSSAnimalID OUTPUT,
				NULL;

			INSERT INTO dbo.tlbAnimal (
				idfAnimal,
				idfsAnimalGender,
				idfsAnimalCondition,
				idfsAnimalAge,
				idfSpecies,
				idfObservation,
				strAnimalCode,
				strName,
				strDescription,
				strColor,
				intRowStatus,
				strMaintenanceFlag
				)
			VALUES (
				@AnimalID,
				@AnimalGenderTypeID,
				@AnimalConditionTypeID,
				@AnimalAgeTypeID,
				@SpeciesID,
				@ObservationID,
				@EIDSSAnimalID,
				@AnimalName,
				@AnimalDescription,
				@Color,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbAnimal
			SET idfsAnimalGender = @AnimalGenderTypeID,
				idfsAnimalCondition = @AnimalConditionTypeID,
				idfsAnimalAge = @AnimalAgeTypeID,
				idfSpecies = @SpeciesID,
				idfObservation = @ObservationID,
				strAnimalCode = @EIDSSAnimalID,
				strName = @AnimalName,
				strDescription = @AnimalDescription,
				strColor = @Color,
				intRowStatus = @RowStatus
			WHERE idfAnimal = @AnimalID;
		END
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
