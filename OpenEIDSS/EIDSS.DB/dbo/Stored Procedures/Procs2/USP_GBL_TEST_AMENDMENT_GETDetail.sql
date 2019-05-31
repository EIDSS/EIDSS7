
-- ================================================================================================
-- Name: USP_GBL_TEST_AMENDMENT_GETList
--
-- Description:	Get a single test amendment record.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     10/31/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_TEST_AMENDMENT_GETDetail]
(
    @LanguageID NVARCHAR(50),
    @TestAmendmentID BIGINT
)
AS
BEGIN
    BEGIN TRY
        SELECT tah.idfTestAmendmentHistory AS TestAmendmentID,
               tah.idfTesting AS TestID,
               tah.idfAmendByOffice AS AmendedByOfficeID,
               tah.idfAmendByPerson AS AmendedByPersonID,
               tah.datAmendmentDate AS AmendmentDate,
               tah.idfsOldTestResult AS OldTestResultTypeID,
               tah.idfsNewTestResult AS NewTestResultTypeID,
               tah.strOldNote AS OldNote,
               tah.strNewNote AS NewNote,
               tah.strReason AS ReasonForAmendment,
               tah.intRowStatus AS RowStatus
        FROM dbo.tlbTestAmendmentHistory tah
        WHERE tah.idfTestAmendmentHistory = @TestAmendmentID
              AND tah.intRowStatus = 0;
    END TRY
    BEGIN CATCH
        BEGIN
            ; THROW;
        END;
    END CATCH;
END;
