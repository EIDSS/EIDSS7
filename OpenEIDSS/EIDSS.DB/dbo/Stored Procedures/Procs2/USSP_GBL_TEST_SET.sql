-- ================================================================================================
-- Name: USSP_GBL_TEST_SET
--
-- Description:	Inserts or updates laboratory and field test records for various use cases.
--
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/17/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_TEST_SET] (
	@LanguageID NVARCHAR(50),
	@TestID BIGINT,
	@TestNameTypeID BIGINT = NULL,
	@TestCategoryTypeID BIGINT = NULL,
	@TestResultTypeID BIGINT = NULL,
	@TestStatusTypeID BIGINT,
	@DiseaseID BIGINT,
	@SampleID BIGINT = NULL,
	@BatchTestID BIGINT = NULL,
	@ObservationID BIGINT,
	@TestNumber INT = NULL,
	@Comments NVARCHAR(500) = NULL,
	@RowStatus INT = NULL,
	@StartedDate DATETIME = NULL,
	@ResultDate DATETIME = NULL,
	@TestedByOrganizationID BIGINT = NULL,
	@TestedByPersonID BIGINT = NULL,
	@ResultEnteredByOrganizationID BIGINT = NULL,
	@ResultEnteredByPersonID BIGINT = NULL,
	@ValidatedByOrganizationID BIGINT = NULL,
	@ValidatedByPersonID BIGINT = NULL,
	@ReadOnlyIndicator BIT,
	@NonLaboratoryTestIndicator BIT,
	@ExternalTestIndicator BIT = NULL,
	@PerformedByOrganizationID BIGINT = NULL,
	@ReceivedDate DATETIME = NULL,
	@ContactPerson NVARCHAR(200) = NULL,
	@RowAction CHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RowAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbTesting',
				@TestID OUTPUT;

			INSERT INTO dbo.tlbTesting (
				idfTesting,
				idfsTestName,
				idfsTestCategory,
				idfsTestResult,
				idfsTestStatus,
				idfsDiagnosis,
				idfMaterial,
				idfBatchTest,
				idfObservation,
				intTestNumber,
				strNote,
				intRowStatus,
				datStartedDate,
				datConcludedDate,
				idfTestedByOffice,
				idfTestedByPerson,
				idfResultEnteredByOffice,
				idfResultEnteredByPerson,
				idfValidatedByOffice,
				idfValidatedByPerson,
				blnReadOnly,
				blnNonLaboratoryTest,
				blnExternalTest,
				idfPerformedByOffice,
				datReceivedDate,
				strContactPerson
				)
			VALUES (
				@TestID,
				@TestNameTypeID,
				@TestCategoryTypeID,
				@TestResultTypeID,
				@TestStatusTypeID,
				@DiseaseID,
				@SampleID,
				@BatchTestID,
				@ObservationID,
				@TestNumber,
				@Comments,
				@RowStatus,
				@StartedDate,
				@ResultDate,
				@TestedByOrganizationID,
				@TestedByPersonID,
				@ResultEnteredByOrganizationID,
				@ResultEnteredByPersonID,
				@ValidatedByOrganizationID,
				@ValidatedByPersonID,
				@ReadOnlyIndicator,
				@NonLaboratoryTestIndicator,
				@ExternalTestIndicator,
				@PerformedByOrganizationID,
				@ReceivedDate,
				@ContactPerson
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbTesting
			SET idfsTestName = @TestNameTypeID,
				idfsTestCategory = @TestCategoryTypeID,
				idfsTestResult = @TestResultTypeID,
				idfsTestStatus = @TestStatusTypeID,
				idfsDiagnosis = @DiseaseID,
				idfMaterial = @SampleID,
				idfBatchTest = @BatchTestID,
				idfObservation = @ObservationID,
				intTestNumber = @TestNumber,
				strNote = @Comments,
				intRowStatus = @RowStatus,
				datStartedDate = @StartedDate,
				datConcludedDate = @ResultDate,
				idfTestedByOffice = @TestedByOrganizationID,
				idfTestedByPerson = @TestedByPersonID,
				idfResultEnteredByOffice = @ResultEnteredByOrganizationID,
				idfResultEnteredByPerson = @ResultEnteredByPersonID,
				idfValidatedByOffice = @ValidatedByOrganizationID,
				idfValidatedByPerson = @ValidatedByPersonID,
				blnReadOnly = @ReadOnlyIndicator,
				blnNonLaboratoryTest = @NonLaboratoryTestIndicator,
				blnExternalTest = @ExternalTestIndicator,
				idfPerformedByOffice = @PerformedByOrganizationID,
				datReceivedDate = @ReceivedDate,
				strContactPerson = @ContactPerson
			WHERE idfTesting = @TestID;
		END
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
GO


