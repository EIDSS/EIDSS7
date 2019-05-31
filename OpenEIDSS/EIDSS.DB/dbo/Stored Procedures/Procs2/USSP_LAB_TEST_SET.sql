
-- ================================================================================================
-- Name: USSP_LAB_TEST_SET
--
-- Description:	Inserts or updates test records for various laboratory module 
-- USE cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long		01/24/2019 Initial release.
-- Stephen Long     02/01/2019 Added null to the observation ID parameter.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_LAB_TEST_SET] (
	@LanguageID NVARCHAR(50),
	@TestID BIGINT,
	@TestNameTypeID BIGINT = NULL,
	@TestCategoryTypeID BIGINT = NULL,
	@TestResultTypeID BIGINT = NULL,
	@TestStatusTypeID BIGINT,
	@PreviousTestStatusTypeID BIGINT = NULL,
	@DiseaseID BIGINT,
	@SampleID BIGINT = NULL,
	@BatchTestID BIGINT = NULL,
	@ObservationID BIGINT = NULL,
	@TestNumber INT = NULL,
	@Note NVARCHAR(500) = NULL,
	@RowStatus INT = NULL,
	@StartedDate DATETIME = NULL,
	@ConcludedDate DATETIME = NULL,
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
	@RecordAction NCHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RecordAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET @tableName = N'tlbTesting',
				@idfsKey = @TestID OUTPUT;

			INSERT INTO dbo.tlbTesting (
				idfTesting,
				idfsTestName,
				idfsTestCategory,
				idfsTestResult,
				idfsTestStatus,
				PreviousTestStatusID,
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
				@PreviousTestStatusTypeID,
				@DiseaseID,
				@SampleID,
				@BatchTestID,
				@ObservationID,
				@TestNumber,
				@Note,
				@RowStatus,
				@StartedDate,
				@ConcludedDate,
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
		END;
		ELSE
		BEGIN
			UPDATE dbo.tlbTesting
			SET idfsTestName = @TestNameTypeID,
				idfsTestCategory = @TestCategoryTypeID,
				idfsTestResult = @TestResultTypeID,
				idfsTestStatus = @TestStatusTypeID,
				PreviousTestStatusID = @PreviousTestStatusTypeID,
				idfsDiagnosis = @DiseaseID,
				idfMaterial = @SampleID,
				idfBatchTest = @BatchTestID,
				idfObservation = @ObservationID,
				intTestNumber = @TestNumber,
				strNote = @Note,
				intRowStatus = @RowStatus,
				datStartedDate = @StartedDate,
				datConcludedDate = @ConcludedDate,
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
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;