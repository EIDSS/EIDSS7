-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_DEL
--
-- Description:	Sets a disease report record to "inactive".
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/25/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_DEL] (
	@LanguageID NVARCHAR(50) = NULL,
	@VeterinaryDiseaseReportID BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION;

		DECLARE @ReturnCode INT = 0,
			@ReturnMessage NVARCHAR(MAX) = 'SUCCESS',
			@FarmCount AS INT = 0,
			@HerdFlockCount AS INT = 0,
			@SpeciesCount AS INT = 0,
			@AnimalCount AS INT = 0,
			@VaccinationCount AS INT = 0,
			@SampleCount AS INT = 0,
			@PensideTestCount AS INT = 0,
			@LabTestCount AS INT = 0,
			@TestInterpretationCount AS INT = 0,
			@ReportLogCount AS INT = 0, 
			@OutbreakSessionCount AS INT = 0;

		SELECT @HerdFlockCount = COUNT(*)
		FROM dbo.tlbHerd h
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		INNER JOIN dbo.tlbVetCase AS v
			ON v.idfFarm = f.idfFarm
		WHERE v.idfVetCase = @VeterinaryDiseaseReportID
			AND h.intRowStatus = 0;

		SELECT @SpeciesCount = COUNT(*)
		FROM dbo.tlbSpecies s
		INNER JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		INNER JOIN dbo.tlbVetCase AS v
			ON v.idfFarm = f.idfFarm
		WHERE v.idfVetCase = @VeterinaryDiseaseReportID
			AND s.intRowStatus = 0;

		SELECT @AnimalCount = COUNT(*)
		FROM dbo.tlbAnimal a
		INNER JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = a.idfSpecies
				AND s.intRowStatus = 0
		INNER JOIN dbo.tlbHerd AS h
			ON h.idfHerd = s.idfHerd
				AND h.intRowStatus = 0
		INNER JOIN dbo.tlbFarm AS f
			ON f.idfFarm = h.idfFarm
				AND f.intRowStatus = 0
		INNER JOIN dbo.tlbVetCase AS v
			ON v.idfFarm = f.idfFarm
		WHERE v.idfVetCase = @VeterinaryDiseaseReportID
			AND a.intRowStatus = 0;

		SELECT @VaccinationCount = COUNT(*)
		FROM dbo.tlbVaccination
		WHERE idfVetCase = @VeterinaryDiseaseReportID
			AND intRowStatus = 0;

		SELECT @SampleCount = COUNT(*)
		FROM dbo.tlbMaterial
		WHERE idfVetCase = @VeterinaryDiseaseReportID
			AND intRowStatus = 0;

		SELECT @PensideTestCount = COUNT(*)
		FROM dbo.tlbPensideTest p
		INNER JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = p.idfMaterial
				AND m.intRowStatus = 0
		WHERE m.idfVetCase = @VeterinaryDiseaseReportID
			AND p.intRowStatus = 0;

		SELECT @LabTestCount = COUNT(*)
		FROM dbo.tlbTesting t
		INNER JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = t.idfMaterial
				AND m.intRowStatus = 0
		WHERE m.idfVetCase = @VeterinaryDiseaseReportID
			AND t.intRowStatus = 0;

		SELECT @TestInterpretationCount = COUNT(*)
		FROM dbo.tlbTestValidation tv
		INNER JOIN dbo.tlbTesting AS t
			ON t.idfTesting = tv.idfTesting
				AND t.intRowStatus = 0
		INNER JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = t.idfMaterial
				AND m.intRowStatus = 0
		WHERE m.idfVetCase = @VeterinaryDiseaseReportID
			AND tv.intRowStatus = 0;

		SELECT @ReportLogCount = COUNT(*)
		FROM dbo.tlbVetCaseLog
		WHERE idfVetCase = @VeterinaryDiseaseReportID
			AND intRowStatus = 0;

		SELECT @OutbreakSessionCount = COUNT(*) 
		FROM dbo.tlbVetCase v
		INNER JOIN dbo.tlbOutbreak AS o 
			ON o.idfOutbreak = v.idfOutbreak AND o.intRowStatus = 0
		WHERE v.idfVetCase = @VeterinaryDiseaseReportID AND v.idfOutbreak IS NOT NULL

		IF @HerdFlockCount = 0
			AND @SpeciesCount = 0
			AND @AnimalCount = 0
			AND @VaccinationCount = 0
			AND @SampleCount = 0
			AND @PensideTestCount = 0
			AND @LabTestCount = 0
			AND @TestInterpretationCount = 0
			AND @ReportLogCount = 0 
			AND @OutbreakSessionCount = 0
		BEGIN
			UPDATE dbo.tlbVetCase
			SET idfParentMonitoringSession = NULL,
				idfOutbreak = NULL
			WHERE idfVetCase = @VeterinaryDiseaseReportID;

			UPDATE dbo.tlbVetCase
			SET intRowStatus = 1,
				datModificationForArchiveDate = GETDATE()
			WHERE idfVetCase = @VeterinaryDiseaseReportID;

			UPDATE dbo.tlbFarm
			SET intRowStatus = 1
			WHERE idfFarm = (
					SELECT idfFarm
					FROM dbo.tlbVetCase
					WHERE idfVetCase = @VeterinaryDiseaseReportID
					);
		END
		ELSE
		BEGIN
			IF @OutbreakSessionCount > 0 
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

		IF @@TRANCOUNT > 0
			AND @returnCode = 0
			COMMIT;

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;

		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
GO


