-- ================================================================================================
-- Name: USSP_VET_SPECIES_MASTER_SET
--
-- Description:	Inserts or updates species actual for the avian veterinary disease report use 
-- cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/10/2019 Initial release.
-- Stephen Long     04/23/2019 Changed specied master ID parameter to include OUTPUT.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_SPECIES_MASTER_SET] (
	@LanguageID NVARCHAR(50),
	@SpeciesMasterID BIGINT = NULL OUTPUT,
	@SpeciesTypeID BIGINT,
	@HerdMasterID BIGINT = NULL,
	@ObservationID BIGINT = NULL,
	@StartOfSignsDate DATETIME = NULL,
	@AverageAge NVARCHAR(200) = NULL,
	@SickAnimalQuantity INT = NULL,
	@TotalAnimalQuantity INT = NULL,
	@DeadAnimalQuantity INT = NULL,
	@Note NVARCHAR(2000) = NULL,
	@RowStatus INT,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbSpeciesActual',
				@SpeciesMasterID OUTPUT;

			INSERT INTO dbo.tlbSpeciesActual (
				idfSpeciesActual,
				idfsSpeciesType,
				idfHerdActual,
				datStartOfSignsDate,
				strAverageAge,
				intSickAnimalQty,
				intTotalAnimalQty,
				intDeadAnimalQty,
				strNote,
				intRowStatus
				)
			VALUES (
				@SpeciesMasterID,
				@SpeciesTypeID,
				@HerdMasterID,
				@StartOfSignsDate,
				@AverageAge,
				@SickAnimalQuantity,
				@TotalAnimalQuantity,
				@DeadAnimalQuantity,
				@Note,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbSpeciesActual
			SET idfsSpeciesType = @SpeciesTypeID,
				idfHerdActual = @HerdMasterID,
				datStartOfSignsDate = @StartOfSignsDate,
				strAverageAge = @AverageAge,
				intSickAnimalQty = @SickAnimalQuantity,
				intTotalAnimalQty = @TotalAnimalQuantity,
				intDeadAnimalQty = @DeadAnimalQuantity,
				strNote = @Note,
				intRowStatus = @RowStatus
			WHERE idfSpeciesActual = @SpeciesMasterID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
