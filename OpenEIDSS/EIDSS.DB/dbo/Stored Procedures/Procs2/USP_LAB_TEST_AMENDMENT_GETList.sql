
-- ================================================================================================
-- Name: USP_LAB_TEST_AMENDMENT_GETList
--
-- Description:	Get test amendment history list for the various lab use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/11/2018 Initial release.
-- Stephen Long     01/25/2019 Removed preceeding ; on CATCH.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TEST_AMENDMENT_GETList] (
	@LanguageID NVARCHAR(50),
	@TestID BIGINT
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT tah.idfTestAmendmentHistory AS TestAmendmentHistoryID,
			tah.idfTesting AS TestID,
			tah.idfAmendByOffice AS AmendedByOrganizationID,
			amendedByOfficeSite.strSiteName AS AmendedByOrganizationSiteName,
			tah.idfAmendByPerson AS AmendedByPersonID,
			ISNULL(amendedByPerson.strFamilyName, N'') + ISNULL(' ' + amendedByPerson.strFirstName, '') + ISNULL(' ' + amendedByPerson.strSecondName, '') AS AmendedByPersonName,
			tah.datAmendmentDate AS AmendmentDate,
			tah.idfsOldTestResult AS OriginalTestResultID,
			oldTestResult.name AS OriginalTestResultTypeName,
			tah.idfsNewTestResult AS ChangedTestResultID,
			newTestResult.name AS ChangedTestResultTypeName,
			tah.strReason AS ReasonForAmendment,
			'' AS RowAction
		FROM dbo.tlbTestAmendmentHistory tah
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS oldTestResult
			ON oldTestResult.idfsReference = tah.idfsOldTestResult
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000096) AS newTestResult
			ON newTestResult.idfsReference = tah.idfsNewTestResult
		LEFT JOIN dbo.tlbOffice AS amendedByOffice
			ON amendedByOffice.idfOffice = tah.idfAmendByOffice
		LEFT JOIN dbo.tstSite AS amendedByOfficeSite
			ON amendedByOfficeSite.idfsSite = amendedByOffice.idfsSite
		LEFT JOIN dbo.tlbPerson AS amendedByPerson
			ON amendedByPerson.idfPerson = tah.idfAmendByPerson
		WHERE tah.idfTesting = @TestID
			AND (tah.intRowStatus = 0);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;