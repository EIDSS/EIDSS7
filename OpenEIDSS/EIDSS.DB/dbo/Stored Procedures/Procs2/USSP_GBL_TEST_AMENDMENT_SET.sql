

-- ================================================================================================
-- Name: USSP_GBL_TEST_AMENDMENT_SET
--
-- Description:	Inserts or updates test amendment records for various use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/01/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_TEST_AMENDMENT_SET]
(
	@LanguageID							NVARCHAR(50), 
	@TestAmendementID					BIGINT OUTPUT, 
	@TestID								BIGINT, 
	@AmendedByOrganizationID			BIGINT = NULL, 
	@AmendedByPersonID					BIGINT = NULL, 
	@AmendedDate						DATETIME, 
	@OldTestResultTypeID				BIGINT = NULL, 
	@NewTestResultTypeID				BIGINT = NULL, 
	@OldNote							NVARCHAR(500) = NULL,
	@NewNote							NVARCHAR(500) = NULL,
	@ReasonForAmendment					NVARCHAR(500) = NULL,
	@RowStatus							INT, 
	@RecordAction						NCHAR
)
AS

BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
			EXECUTE						dbo.USP_GBL_NEXTKEYID_GET 'tlbTestAmendmentHistory', @TestAmendementID OUTPUT;

			INSERT INTO					dbo.tlbTestAmendmentHistory
			(						
										idfTestAmendmentHistory, 
										idfTesting, 
										idfAmendByOffice, 
										idfAmendByPerson, 
										datAmendmentDate, 
										idfsOldTestResult,
										idfsNewTestResult, 
										strOldNote, 
										strNewNote, 
										strReason, 
										intRowStatus
			)
			VALUES
			(
										@TestAmendementID, 
										@TestID, 
										@AmendedByOrganizationID, 
										@AmendedByPersonID, 
										@AmendedDate, 
										@OldTestResultTypeID,
										@NewTestResultTypeID, 
										@OldNote, 
										@NewNote, 
										@ReasonForAmendment, 
										@RowStatus
			);
			END
		ELSE
			BEGIN
			UPDATE						dbo.tlbTestAmendmentHistory
			SET 
										idfTesting = @TestID,
										idfAmendByOffice = @AmendedByOrganizationID, 
										idfAmendByPerson = @AmendedByPersonID,
										datAmendmentDate = @AmendedDate,
										idfsOldTestResult = @OldTestResultTypeID,
										idfsNewTestResult = @NewTestResultTypeID,
										strOldNote = @OldNote,
										strNewNote = @NewNote,
										strReason = @ReasonForAmendment,
										intRowStatus = @RowStatus
			WHERE						idfTestAmendmentHistory = @TestID;
			END
	END TRY
	BEGIN CATCH
		;THROW;
	END CATCH
END
