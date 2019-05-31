
-- ================================================================================================
-- Name: USP_LAB_APPROVAL_GETCount
--
-- Description:	Get laboratory approval count for the various lab use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/19/2018 Initial release.
-- Stephen Long     01/25/2019 Cleaned up syntax.
-- Stephen Long     02/19/2019 Split out counts between sample and test to fix bug on count.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_APPROVAL_GETCount] (
	@LanguageID NVARCHAR(50),
	@SiteID BIGINT = NULL
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT (
				SELECT COUNT(*)
				FROM dbo.tlbMaterial m
				WHERE (
						(m.idfsSampleStatus = 10015003)
						OR (m.idfsSampleStatus = 10015002)
						)
						AND (m.idfsCurrentSite = @SiteID)
						AND (m.intRowStatus = 0)
				) + (
				SELECT COUNT(*)
				FROM dbo.tlbTesting t
				INNER JOIN dbo.tlbMaterial AS m
					ON t.idfMaterial = m.idfMaterial
						AND m.intRowStatus = 0
				WHERE (
						(t.idfsTestStatus = 10001004)
						OR (t.idfsTestStatus = 10001007)
						)
						AND (m.idfsCurrentSite = @SiteID)
						AND (t.intRowStatus = 0)
				) AS RecordCount;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END