-- ================================================================================================
-- Name: USP_VET_ANIMAL_GETList
--
-- Description:	Get animal list for the avian veterinary disease enter and edit use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/18/2019 Updated for API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_ANIMAL_GETList] (
	@LanguageID NVARCHAR(50),
	@SpeciesID BIGINT = NULL,
	@ObservationID BIGINT = NULL,
	@SampleID BIGINT = NULL,
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@MonitoringSessionID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT a.idfAnimal AS AnimalID,
			a.idfsAnimalGender AS AnimalGenderTypeID,
			animalGender.name AS AnimalGenderTypeName,
			a.idfsAnimalCondition AS AnimalConditionTypeID,
			animalCondition.name AS AnimalConditionTypeName,
			a.idfsAnimalAge AS AnimalAgeTypeID,
			animalAge.name AS AnimalAgeTypeName,
			a.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			a.idfObservation AS ObservationID,
			a.strDescription AS AnimalDescription,
			a.strAnimalCode AS EIDSSAnimalID,
			a.strName AS AnimalName,
			a.strColor AS Color,
			a.intRowStatus AS RowStatus,
			h.idfHerd AS HerdID,
			h.strHerdCode AS EIDSSHerdID,
			'R' AS RowAction
		FROM dbo.tlbAnimal a
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = a.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		LEFT JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfAnimal = a.idfAnimal
				AND m.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000005) AS animalAge
			ON animalAge.idfsReference = a.idfsAnimalAge
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000006) AS animalCondition
			ON animalCondition.idfsReference = a.idfsAnimalCondition
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000007) AS animalGender
			ON animalGender.idfsReference = a.idfsAnimalGender
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
				AND vc.intRowStatus = 0
		WHERE (
				(a.idfSpecies = @SpeciesID)
				OR (@SpeciesID IS NULL)
				)
			AND (
				(a.idfObservation = @ObservationID)
				OR (@ObservationID IS NULL)
				)
			AND (
				(m.idfMaterial = @SampleID)
				OR (@SampleID IS NULL)
				)
			AND (
				(vc.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(f.idfMonitoringSession = @MonitoringSessionID)
				OR (@MonitoringSessionID IS NULL)
				)
			AND a.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
