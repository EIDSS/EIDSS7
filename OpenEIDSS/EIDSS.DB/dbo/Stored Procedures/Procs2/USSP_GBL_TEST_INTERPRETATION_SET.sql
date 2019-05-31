-- ================================================================================================
-- Name: USSP_GBL_TEST_INTERPRETATION_SET
--
-- Description:	Inserts or updates test interpretation records for various use cases.
--
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/27/2018 Initial release.
-- Stephen Long     04/17/2019 Removed strMaintenanceFlag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_TEST_INTERPRETATION_SET] (
	@LanguageID NVARCHAR(50) = NULL,
	@TestInterpretationID BIGINT OUTPUT,
	@DiseaseID BIGINT,
	@InterpretedStatusTypeID BIGINT = NULL,
	@ValidatedByOrganizationID BIGINT = NULL,
	@ValidatedByPersonID BIGINT = NULL,
	@InterpretedByOrganizationID BIGINT = NULL,
	@InterpretedByPersonID BIGINT = NULL,
	@TestID BIGINT,
	@ValidateStatusIndicator BIT = NULL,
	@ReportSessionCreatedIndicator BIT = NULL,
	@ValidationComment NVARCHAR(200) = NULL,
	@InterpretationComment NVARCHAR(200) = NULL,
	@ValidationDate DATETIME = NULL,
	@InterpretationDate DATETIME = NULL,
	@RowStatus INT,
	@ReadOnlyIndicator BIT,
	@RecordAction NCHAR(1)
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RecordAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbTestValidation',
				@TestInterpretationID OUTPUT;

			INSERT INTO dbo.tlbTestValidation (
				idfTestValidation,
				idfsDiagnosis,
				idfsInterpretedStatus,
				idfValidatedByOffice,
				idfValidatedByPerson,
				idfInterpretedByOffice,
				idfInterpretedByPerson,
				idfTesting,
				blnValidateStatus,
				blnCaseCreated,
				strValidateComment,
				strInterpretedComment,
				datValidationDate,
				datInterpretationDate,
				intRowStatus,
				blnReadOnly
				)
			VALUES (
				@TestInterpretationID,
				@DiseaseID,
				@InterpretedStatusTypeID,
				@ValidatedByOrganizationID,
				@ValidatedByPersonID,
				@InterpretedByOrganizationID,
				@InterpretedByPersonID,
				@TestID,
				@ValidateStatusIndicator,
				@ReportSessionCreatedIndicator,
				@ValidationComment,
				@InterpretationComment,
				@ValidationDate,
				@InterpretationDate,
				@RowStatus,
				@ReadOnlyIndicator
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbTestValidation
			SET idfsDiagnosis = @DiseaseID,
				idfsInterpretedStatus = @InterpretedStatusTypeID,
				idfValidatedByOffice = @ValidatedByOrganizationID,
				idfValidatedByPerson = @ValidatedByPersonID,
				idfInterpretedByOffice = @InterpretedByOrganizationID,
				idfInterpretedByPerson = @InterpretedByPersonID,
				idfTesting = @TestID,
				blnValidateStatus = @ValidateStatusIndicator,
				blnCaseCreated = @ReportSessionCreatedIndicator,
				strValidateComment = @ValidationComment,
				strInterpretedComment = @InterpretationComment,
				datValidationDate = @ValidationDate,
				datInterpretationDate = @InterpretationDate,
				intRowStatus = @RowStatus,
				blnReadOnly = @ReadOnlyIndicator
			WHERE idfTestValidation = @TestInterpretationID;
		END
	END TRY

	BEGIN CATCH
			;

		THROW;
	END CATCH
END
GO
