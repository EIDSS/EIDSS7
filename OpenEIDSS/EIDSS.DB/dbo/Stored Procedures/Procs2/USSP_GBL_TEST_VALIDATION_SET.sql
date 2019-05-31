









-- ============================================================================
-- Name: USSP_GBL_TEST_VALIDATION_SET
-- Description:	Inserts or updates test validation records for various use 
-- cases.
--
-- Author: Stephen Long
-- Revision History:
-- Name  Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Stephen Long     04/03/2018 Initial release.
---Lamont Mitchell	1/11/19 Added Supress Table and Aliased Return Columns
-- ============================================================================
CREATE PROCEDURE [dbo].[USSP_GBL_TEST_VALIDATION_SET]
(
	@LangID								NVARCHAR(50), 
	@idfTestValidation					BIGINT OUTPUT, 
	@idfsDiagnosis						BIGINT, 
	@idfsInterpretedStatus				BIGINT = NULL, 
	@idfValidatedByOffice				BIGINT = NULL, 
	@idfValidatedByPerson				BIGINT = NULL, 
	@idfInterpretedByOffice				BIGINT = NULL, 
	@idfInterpretedByPerson				BIGINT = NULL, 
	@idfTesting							BIGINT, 
	@blnValidateStatus					BIT = NULL, 
	@blnCaseCreated						BIT = NULL, 
	@strValidateComment					NVARCHAR(200) = NULL,
	@strInterpretedComment				NVARCHAR(200) = NULL,
	@datValidationDate					DATETIME = NULL, 
	@datInterpretationDate				DATETIME = NULL, 
	@intRowStatus						INT, 
	@blnReadOnly						BIT, 
	@strMaintenanceFlag					NVARCHAR(20) = NULL, 
	@RecordAction						NCHAR(1) 
)
AS

DECLARE @returnCode						INT = 0;
DECLARE	@returnMsg						NVARCHAR(MAX) = 'SUCCESS';
		Declare @SupressSelect table
			( retrunCode int,
			  returnMessage varchar(200)
			)
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- Interfering with SELECT statements.
	SET NOCOUNT ON;

    BEGIN TRY
		IF @RecordAction = 'I' 
			BEGIN
			Insert Into @SupressSelect
			EXEC dbo.USP_GBL_NEXTKEYID_GET 'tlbTestValidation', @idfTestValidation OUTPUT;

			INSERT INTO					dbo.tlbTestValidation
			(						
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
										blnReadOnly, 
										strMaintenanceFlag
			)
			VALUES
			(
										@idfTestValidation, 
										@idfsDiagnosis, 
										@idfsInterpretedStatus, 
										@idfValidatedByOffice, 
										@idfValidatedByPerson, 
										@idfInterpretedByOffice,
										@idfInterpretedByPerson, 
										@idfTesting, 
										@blnValidateStatus, 
										@blnCaseCreated, 
										@strValidateComment,
										@strInterpretedComment,
										@datValidationDate,
										@datInterpretationDate,
										@intRowStatus, 
										@blnReadOnly, 
										@strMaintenanceFlag
				);
			END
		ELSE
			BEGIN
			UPDATE						dbo.tlbTestValidation
			SET 
										idfsDiagnosis = @idfsDiagnosis,
										idfsInterpretedStatus = @idfsInterpretedStatus, 
										idfValidatedByOffice = @idfValidatedByOffice,
										idfValidatedByPerson = @idfValidatedByPerson,
										idfInterpretedByOffice = @idfInterpretedByOffice,
										idfInterpretedByPerson = @idfInterpretedByPerson,
										idfTesting = @idfTesting,
										blnValidateStatus = @blnValidateStatus,
										blnCaseCreated = @blnCaseCreated,
										strValidateComment = @strValidateComment, 
										strInterpretedComment = @strInterpretedComment, 
										datValidationDate = @datValidationDate,
										datInterpretationDate = @datInterpretationDate, 
										intRowStatus = @intRowStatus,
										blnReadOnly = @blnReadOnly,
										strMaintenanceFlag = @strMaintenanceFlag
			WHERE						idfTestValidation = @idfTestValidation;
			END

		SELECT @returnCode 'ReturnCode', @returnMsg 'ReturnMessage',@idfTestValidation 'idfTestValidation';
	END TRY
	BEGIN CATCH
		THROW;

	END CATCH
END
