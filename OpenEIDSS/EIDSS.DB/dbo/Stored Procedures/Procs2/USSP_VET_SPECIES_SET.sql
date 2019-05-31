-- ================================================================================================
-- Name: USSP_VET_SPECIES_SET
--
-- Description:	Inserts or updates species for the avian veterinary disease report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     03/31/2018 Initial release.
-- Stephen Long     04/10/2019 Split out master (actual) from snapshot.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_SPECIES_SET] (
	@LanguageID NVARCHAR(50),
	@SpeciesID BIGINT = NULL OUTPUT,
	@SpeciesMasterID BIGINT = NULL,
	@SpeciesTypeID BIGINT,
	@HerdID BIGINT = NULL,
	@ObservationID BIGINT = NULL,
	@StartOfSignsDate DATETIME = NULL,
	@AverageAge NVARCHAR(200) = NULL,
	@SickAnimalQuantity INT = NULL,
	@TotalAnimalQuantity INT = NULL,
	@DeadAnimalQuantity INT = NULL,
	@Comments NVARCHAR(2000) = NULL,
	@RowStatus INT,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbSpecies',
				@SpeciesID OUTPUT;

			INSERT INTO dbo.tlbSpecies (
				idfSpecies,
				idfSpeciesActual,
				idfsSpeciesType,
				idfHerd,
				idfObservation,
				datStartOfSignsDate,
				strAverageAge,
				intSickAnimalQty,
				intTotalAnimalQty,
				intDeadAnimalQty,
				strNote,
				intRowStatus
				)
			VALUES (
				@SpeciesID,
				@SpeciesMasterID,
				@SpeciesTypeID,
				@HerdID,
				@ObservationID,
				@StartOfSignsDate,
				@AverageAge,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Comments,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbSpecies
			SET idfSpeciesActual = @SpeciesMasterID,
				idfsSpeciesType = @SpeciesTypeID,
				idfHerd = @HerdID,
				idfObservation = @ObservationID,
				datStartOfSignsDate = @StartOfSignsDate,
				strAverageAge = @AverageAge,
				intSickAnimalQty = @SickAnimalQuantity,
				intTotalAnimalQty = @TotalAnimalQuantity,
				intDeadAnimalQty = @DeadAnimalQuantity,
				strNote = @Comments,
				intRowStatus = @RowStatus
			WHERE idfSpecies = @SpeciesID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
GO


