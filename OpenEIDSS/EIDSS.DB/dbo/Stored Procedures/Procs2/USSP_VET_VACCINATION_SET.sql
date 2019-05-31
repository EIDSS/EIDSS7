-- ================================================================================================
-- Name: USSP_VET_VACCINATION_SET
--
-- Description:	Inserts or updates vaccination info for the avian veterinary disease report use 
-- cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/17/2019 Updated for API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_VACCINATION_SET] (
	@LanguageID NVARCHAR(50),
	@VaccinationID BIGINT OUTPUT,
	@VeterinaryDieaseReportID BIGINT,
	@SpeciesID BIGINT = NULL,
	@VaccinationTypeID BIGINT = NULL,
	@VaccinationRouteTypeID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@VaccinationDate DATETIME = NULL,
	@Manufacturer NVARCHAR(200) = NULL,
	@LotNumber NVARCHAR(200) = NULL,
	@NumberVaccinated INT = NULL,
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
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbVaccination',
				@VaccinationID OUTPUT;

			INSERT INTO dbo.tlbVaccination (
				idfVaccination,
				idfVetCase,
				idfSpecies,
				idfsVaccinationType,
				idfsVaccinationRoute,
				idfsDiagnosis,
				datVaccinationDate,
				strManufacturer,
				strLotNumber,
				intNumberVaccinated,
				strNote,
				intRowStatus
				)
			VALUES (
				@VaccinationID,
				@VeterinaryDieaseReportID,
				@SpeciesID,
				@VaccinationTypeID,
				@VaccinationRouteTypeID,
				@DiseaseID,
				@VaccinationDate,
				@Manufacturer,
				@LotNumber,
				@NumberVaccinated,
				@Comments,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbVaccination
			SET idfVetCase = @VeterinaryDieaseReportID,
				idfSpecies = @SpeciesID,
				idfsVaccinationType = @VaccinationTypeID,
				idfsVaccinationRoute = @VaccinationRouteTypeID,
				idfsDiagnosis = @DiseaseID,
				datVaccinationDate = @VaccinationDate,
				strManufacturer = @Manufacturer,
				strLotNumber = @LotNumber,
				intNumberVaccinated = @NumberVaccinated,
				strNote = @Comments,
				intRowStatus = @RowStatus
			WHERE idfVaccination = @VaccinationID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
