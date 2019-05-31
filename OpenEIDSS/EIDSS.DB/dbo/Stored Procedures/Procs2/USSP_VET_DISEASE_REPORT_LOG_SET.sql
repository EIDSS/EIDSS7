-- ================================================================================================
-- Name: USSP_VET_DISEASE_REPORT_LOG_SET
--
-- Description:	Inserts or updates veterinary "case" log for the avian and livestock veterinary 
-- disease report use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/17/2019 Removed strMaintenanceFlag.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USSP_VET_DISEASE_REPORT_LOG_SET] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportLogID BIGINT OUTPUT,
	@LogStatusTypeID BIGINT = NULL,
	@VeterinaryDiseaseReportID BIGINT = NULL,
	@PersonID BIGINT = NULL,
	@LogDate DATETIME = NULL,
	@ActionRequired NVARCHAR(200) = NULL,
	@Comments NVARCHAR(1000) = NULL,
	@RowStatus INT,
	@RecordAction CHAR
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF @RecordAction = 'I'
		BEGIN
			EXECUTE dbo.USP_GBL_NEXTKEYID_GET 'tlbVetCaseLog',
				@VeterinaryDiseaseReportLogID OUTPUT;

			INSERT INTO dbo.tlbVetCaseLog (
				idfVetCaseLog,
				idfsCaseLogStatus,
				idfVetCase,
				idfPerson,
				datCaseLogDate,
				strActionRequired,
				strNote,
				intRowStatus
				)
			VALUES (
				@VeterinaryDiseaseReportLogID,
				@LogStatusTypeID,
				@VeterinaryDiseaseReportID,
				@PersonID,
				@LogDate,
				@ActionRequired,
				@Comments,
				@RowStatus
				);
		END
		ELSE
		BEGIN
			UPDATE dbo.tlbVetCaseLog
			SET idfsCaseLogStatus = @LogStatusTypeID,
				idfVetCase = @VeterinaryDiseaseReportID,
				idfPerson = @PersonID,
				datCaseLogDate = @LogDate,
				strActionRequired = @ActionRequired,
				strNote = @Comments,
				intRowStatus = @RowStatus
			WHERE idfVetCaseLog = @VeterinaryDiseaseReportLogID;
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
