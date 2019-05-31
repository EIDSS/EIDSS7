
-- ============================================================================
-- Name: USSP_GBL_TESTING_SET
-- Description:	Inserts or updates testing records for various use cases.
--
-- Author: Stephen Long
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_TESTING_SET]
(
	@LangID								NVARCHAR(50), 
	@idfTesting							BIGINT, 
	@idfsTestName						BIGINT = NULL, 
	@idfsTestCategory					BIGINT = NULL, 
	@idfsTestResult						BIGINT = NULL, 
	@idfsTestStatus						BIGINT, 
	@idfsDiagnosis						BIGINT, 
	@idfMaterial						BIGINT = NULL, 
	@idfBatchTest						BIGINT = NULL, 
	@idfObservation						BIGINT, 
	@intTestNumber						INT = NULL, 
	@strNote							NVARCHAR(500) = NULL, 
	@intRowStatus						INT = NULL, 
	@datStartedDate						DATETIME = NULL, 
	@datConcludedDate					DATETIME = NULL, 
	@idfTestedByOffice					BIGINT = NULL, 
	@idfTestedByPerson					BIGINT = NULL, 
	@idfResultEnteredByOffice			BIGINT = NULL, 
	@idfResultEnteredByPerson			BIGINT = NULL, 
	@idfValidatedByOffice				BIGINT = NULL, 
	@idfValidatedByPerson				BIGINT = NULL, 
	@blnReadOnly						BIT, 
	@blnNonLaboratoryTest				BIT, 
	@blnExternalTest					BIT = NULL, 
	@idfPerformedByOffice				BIGINT = NULL, 
	@datReceivedDate					DATETIME = NULL, 
	@strContactPerson					NVARCHAR(200) = NULL,
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@RecordAction						NCHAR(1) 
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';

BEGIN
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
			EXEC						dbo.USP_GBL_NEXTKEYID_GET 'tlbTesting', @idfTesting OUTPUT;

			INSERT INTO					dbo.tlbTesting
			(						
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
										strContactPerson, 
										strMaintenanceFlag
			)
			VALUES
			(
										@idfTesting, 
										@idfsTestName, 
										@idfsTestCategory, 
										@idfsTestResult, 
										@idfsTestStatus, 
										@idfsDiagnosis, 
										@idfMaterial, 
										@idfBatchTest, 
										@idfObservation, 
										@intTestNumber, 
										@strNote, 
										@intRowStatus, 
										@datStartedDate, 
										@datConcludedDate, 
										@idfTestedByOffice, 
										@idfTestedByPerson, 
										@idfResultEnteredByOffice, 
										@idfResultEnteredByPerson, 
										@idfValidatedByOffice, 
										@idfValidatedByPerson, 
										@blnReadOnly, 
										@blnNonLaboratoryTest, 
										@blnExternalTest, 
										@idfPerformedByOffice, 
										@datReceivedDate, 
										@strContactPerson, 
										@strMaintenanceFlag
			);
			END
		ELSE
			BEGIN
			UPDATE						dbo.tlbTesting
			SET 
										idfsTestName = @idfsTestName,
										idfsTestCategory = @idfsTestCategory,
										idfsTestResult = @idfsTestResult,
										idfsTestStatus = @idfsTestStatus,
										idfsDiagnosis = @idfsDiagnosis,
										idfMaterial = @idfMaterial,
										idfBatchTest = @idfBatchTest,
										idfObservation = @idfObservation,
										intTestNumber = @intTestNumber,
										strNote = @strNote,
										intRowStatus = @intRowStatus,
										datStartedDate = @datStartedDate,
										datConcludedDate = @datConcludedDate,
										idfTestedByOffice = @idfTestedByOffice,
										idfTestedByPerson = @idfTestedByPerson,
										idfResultEnteredByOffice = @idfResultEnteredByOffice,
										idfResultEnteredByPerson = @idfResultEnteredByPerson,
										idfValidatedByOffice = @idfValidatedByOffice,
										idfValidatedByPerson = @idfValidatedByPerson,
										blnReadOnly = @blnReadOnly,
										blnNonLaboratoryTest = @blnNonLaboratoryTest,
										blnExternalTest = @blnExternalTest,
										idfPerformedByOffice = @idfPerformedByOffice,
										datReceivedDate = @datReceivedDate, 
										strContactPerson = @strContactPerson,
										strMaintenanceFlag = @strMaintenanceFlag
			WHERE						idfTesting = @idfTesting;
			END

		SELECT							@returnCode 'ReturnCode', @returnMsg 'ReturnMessage', @idfTesting 'idfTesting';
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
