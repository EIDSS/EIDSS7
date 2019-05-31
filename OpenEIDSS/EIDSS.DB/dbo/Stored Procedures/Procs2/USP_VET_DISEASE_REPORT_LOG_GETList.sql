-- ================================================================================================
-- Name: USP_VET_DISEASE_REPORT_LOG_GETList
--
-- Description:	Get disease case log list for the veterinary disease edit/enter and other use 
-- cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/02/2018 Initial release.
-- Stephen Long     04/18/2019 Updated for the API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_DISEASE_REPORT_LOG_GETList] (
	@LanguageID NVARCHAR(50),
	@VeterinaryDiseaseReportID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT vcl.idfVetCaseLog AS VeterinaryDiseaseReportLogID,
			vcl.idfsCaseLogStatus AS LogStatusTypeID,
			vetCaseLogStatus.name AS LogStatusTypeName,
			vcl.idfVetCase AS VeterinaryDiseaseReportID,
			vcl.idfPerson AS PersonID,
			ISNULL(p.strFamilyName, N'') + ISNULL(' ' + p.strFirstName, '') + ISNULL(' ' + p.strSecondName, '') AS PersonName,
			vcl.datCaseLogDate AS LogDate,
			vcl.strActionRequired AS ActionRequired,
			vcl.strNote AS Comments,
			vcl.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbVetCaseLog vcl
		LEFT JOIN dbo.tlbPerson AS p
			ON p.idfPerson = vcl.idfPerson
				AND p.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000103) AS vetCaseLogStatus
			ON vetCaseLogStatus.idfsReference = vcl.idfsCaseLogStatus
		WHERE (
				(vcl.idfVetCase = @VeterinaryDiseaseReportID)
				OR (@VeterinaryDiseaseReportID IS NULL)
				)
			AND vcl.intRowStatus = 0;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END
