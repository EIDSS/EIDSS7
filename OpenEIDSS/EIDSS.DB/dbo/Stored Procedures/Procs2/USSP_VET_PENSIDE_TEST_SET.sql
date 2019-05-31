-- ================================================================================================
-- Name: USSP_VET_PENSIDE_TEST_SET
--
-- Description:	Inserts or updates penside test for the avian and livestock veterinary disease 
-- report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/17/2019 Updates for API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_PENSIDE_TEST_SET] (
	@LanguageID NVARCHAR(50),
	@PensideTestID BIGINT OUTPUT,
	@SampleID BIGINT,
	@PensideTestResultTypeID BIGINT = NULL,
	@PensideTestNameTypeID BIGINT = NULL,
	@TestedByPersonID BIGINT = NULL,
	@TestedByOrganizationID BIGINT = NULL,
	@DiseaseID BIGINT = NULL,
	@TestDate DATETIME = NULL,
	@PensideTestCategoryTypeID BIGINT = NULL,
	@RowStatus INT,
	@RowAction NCHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbPensideTest',
				@PensideTestID OUTPUT;

			INSERT INTO dbo.tlbPensideTest (
				idfPensideTest,
				idfMaterial,
				idfsPensideTestResult,
				idfsPensideTestName,
				intRowStatus,
				idfTestedByPerson,
				idfTestedByOffice,
				idfsDiagnosis,
				datTestDate,
				idfsPensideTestCategory
				)
			VALUES (
				@PensideTestID,
				@SampleID,
				@PensideTestResultTypeID,
				@PensideTestNameTypeID,
				@RowStatus,
				@TestedByPersonID,
				@TestedByOrganizationID,
				@DiseaseID,
				@TestDate,
				@PensideTestCategoryTypeID
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbPensideTest
			SET idfMaterial = @SampleID,
				idfsPensideTestResult = @PensideTestResultTypeID,
				idfsPensideTestName = @PensideTestNameTypeID,
				intRowStatus = @RowStatus,
				idfTestedByPerson = @TestedByPersonID,
				idfTestedByOffice = @TestedByOrganizationID,
				idfsDiagnosis = @DiseaseID,
				datTestDate = @TestDate,
				idfsPensideTestCategory = @PensideTestCategoryTypeID
			WHERE idfPensideTest = @PensideTestID;
		END
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
