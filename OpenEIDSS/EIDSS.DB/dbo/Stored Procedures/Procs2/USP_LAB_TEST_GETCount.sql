
-- ================================================================================================
-- Name: USP_LAB_TEST_GETCount
--
-- Description:	Get laboratory tests count for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     10/18/2018 Initial release.
-- Stephen Long     12/19/2018 Added pagination logic.
-- Stephen Long     02/21/2019 Added test status type id, batch test, sample ID,  test ID and
--                             site ID parameters.
-- Stephen Long     03/28/2019 Changed batch test portion of the where clause to bring back test 
--                             records with a null batch test/in progress unless an actual 
--                             batch test records is specified.  The Testing grid on the labor-
--                             atory module should exclude tests associated with a batch.  These 
--                             display on the Batches tab.
-- Stephen Long     04/03/2019 Changed tests where clause to look at the performed by organization 
--                             instead of sample sent to organization.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TEST_GETCount] (
	@LanguageID NVARCHAR(50),
	@TestStatusTypeID BIGINT = NULL,
	@SampleID BIGINT = NULL,
	@TestID BIGINT = NULL,
	@OrganizationID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@BatchTestID BIGINT = NULL
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
				AND t.intRowStatus = 0
		WHERE (t.idfsTestName IS NOT NULL)
			AND (
				(t.idfsTestStatus = @TestStatusTypeID)
				OR (@TestStatusTypeID IS NULL)
				)
			AND (
				(t.idfPerformedByOffice = @OrganizationID) 
				OR (@OrganizationID IS NULL)
			)
			AND (
				(t.idfMaterial = @SampleID)
				OR (@SampleID IS NULL)
				)
			AND (
				(t.idfTesting = @TestID)
				OR (@TestID IS NULL)
				)
			AND (
				(t.idfBatchTest = @BatchTestID)
				OR (t.idfBatchTest IS NULL AND @BatchTestID IS NULL)
				)
			AND (t.intRowStatus = 0);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;
