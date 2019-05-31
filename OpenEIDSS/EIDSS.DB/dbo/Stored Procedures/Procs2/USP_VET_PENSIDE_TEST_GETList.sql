-- ================================================================================================
-- Name: USP_VET_PENSIDE_TEST_GETList
--
-- Description:	Get penside test list for the avian and livestock veterinary disease enter and edit 
-- use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/18/2019 Updated for API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_PENSIDE_TEST_GETList] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@SampleID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT p.idfPensideTest AS PensideTestID,
			p.idfMaterial AS SampleID,
			m.strFieldBarCode AS EIDSSLocalOrFieldSampleID,
			sampleType.strSampleCode AS SampleTypeName,
			s.idfSpecies AS SpeciesID,
			speciesType.name AS SpeciesTypeName,
			a.idfAnimal AS AnimalID,
			a.strAnimalCode AS EIDSSAnimalID,
			p.idfsPensideTestResult AS PensideTestResultTypeID,
			testResult.name AS PensideTestResultTypeName,
			p.idfsPensideTestName AS PensideTestNameTypeID,
			testName.name AS PensideTestNameTypeName,
			p.intRowStatus AS RowStatus,
			p.idfTestedByPerson AS TestedByPersonID,
			ISNULL(per.strFamilyName, N'') + ISNULL(', ' + per.strFirstName, '') + ISNULL(' ' + per.strSecondName, '') AS TestedByPersonName,
			p.idfTestedByOffice AS TestedByOrganizationID,
			officeSite.strSiteName AS TestedByOrganizationName,
			p.idfsDiagnosis AS DiseaseID,
			d.strIDC10 AS DiseaseIDC10Code,
			p.datTestDate AS TestDate,
			p.idfsPensideTestCategory AS PensideTestCategoryTypeID,
			testCategory.name AS PensideTestCategoryTypeName,
			'R' AS RowAction
		FROM dbo.tlbPensideTest p
		LEFT JOIN dbo.tlbMaterial AS m
			ON m.idfMaterial = p.idfMaterial
				AND m.intRowStatus = 0
		LEFT JOIN dbo.tlbSpecies AS s
			ON s.idfSpecies = m.idfSpecies
				AND s.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000086) AS speciesType
			ON speciesType.idfsReference = s.idfsSpeciesType
		LEFT JOIN dbo.tlbAnimal AS a
			ON a.idfAnimal = m.idfAnimal
				AND a.intRowStatus = 0
		LEFT JOIN dbo.trtSampleType AS sampleType
			ON sampleType.idfsSampleType = m.idfsSampleType
				AND sampleType.intRowStatus = 0
		LEFT JOIN dbo.tlbVetCase AS vc
			ON vc.idfVetCase = m.idfVetCase
				AND vc.intRowStatus = 0
		LEFT JOIN dbo.tlbOffice AS o
			ON o.idfOffice = p.idfTestedByOffice
				AND o.intRowStatus = 0
		LEFT JOIN dbo.tstSite AS officeSite
			ON officeSite.idfsSite = o.idfsSite
				AND officeSite.intRowStatus = 0
		LEFT JOIN dbo.tlbPerson AS per
			ON per.idfPerson = p.idfTestedByPerson
				AND per.intRowStatus = 0
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000105) AS testResult
			ON testResult.idfsReference = p.idfsPensideTestResult
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000104) AS testName
			ON testName.idfsReference = p.idfsPensideTestName
		LEFT JOIN FN_GBL_ReferenceRepair(@LanguageID, 19000134) AS testCategory
			ON testCategory.idfsReference = p.idfsPensideTestCategory
		LEFT JOIN dbo.trtDiagnosis AS d
			ON d.idfsDiagnosis = p.idfsDiagnosis
				AND d.intRowStatus = 0
		WHERE (
				(vc.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND (
				(p.idfMaterial = @SampleID)
				OR (@SampleID IS NULL)
				)
			AND p.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
