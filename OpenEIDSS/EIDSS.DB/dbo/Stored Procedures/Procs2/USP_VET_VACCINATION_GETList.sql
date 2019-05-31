-- ================================================================================================
-- Name: USP_VET_VACCINATION_GETList
--
-- Description:	Get vaccination list for the avian and livestock veterinary disease enter and edit 
-- use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/17/2019 Updates for API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_VACCINATION_GETList] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@SpeciesID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT v.idfVaccination AS VaccinationID,
			v.idfVetCase AS VeterinaryDiseaseReportID,
			v.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			v.idfsVaccinationType AS VaccinationTypeID,
			vaccinationType.name AS VaccinationTypeName,
			v.idfsVaccinationRoute AS VaccinationRouteTypeID,
			vaccinationRoute.name AS VaccinationRouteTypeName,
			v.idfsDiagnosis AS DiseaseID,
			disease.name AS DiseaseName,
			d.strIDC10 AS DiseaseIDC10Code,
			d.strOIECode AS OIECode,
			v.datVaccinationDate AS VaccinationDate,
			v.strManufacturer AS Manufacturer,
			v.strLotNumber AS LotNumber,
			v.intNumberVaccinated AS NumberVaccinated,
			v.strNote AS Comments,
			v.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbVaccination v
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = v.idfVetCase
				AND vc.intRowStatus = 0
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = v.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000099) AS vaccinationType
			ON vaccinationType.idfsReference = v.idfsVaccinationType
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000098) AS vaccinationRoute
			ON vaccinationRoute.idfsReference = v.idfsVaccinationRoute
		LEFT JOIN dbo.trtDiagnosis AS d
			ON d.idfsDiagnosis = v.idfsDiagnosis
				AND d.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000019) AS disease
			ON disease.idfsReference = d.idfsDiagnosis
		WHERE (
				(v.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(v.idfSpecies = @SpeciesID)
				OR (@SpeciesID IS NULL)
				)
			AND v.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
