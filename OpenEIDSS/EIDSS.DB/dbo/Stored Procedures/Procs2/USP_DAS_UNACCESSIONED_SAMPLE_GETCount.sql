

-- ================================================================================================
-- Name: USP_DAS_UNACCESSIONED_SAMPLE_GETCount
--
-- Description:	Get unaccessioned sample count for the dashboard module use case SYSUC06.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/25/2019 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_DAS_UNACCESSIONED_SAMPLE_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL,
	@SiteID BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		SELECT COUNT(m.idfMaterial) AS RecordCount 
		FROM dbo.tlbMaterial m
		WHERE (m.blnAccessioned = 0)
			AND ((
				(m.idfSendToOffice = @OrganizationID)
				OR (@OrganizationID IS NULL)
				)
			OR (
				(m.idfsSite = @SiteID OR m.idfsCurrentSite = @SiteID)
				OR (@SiteID IS NULL)
				))
			AND (m.idfsSampleType <> '10320001')
			AND (m.idfsSampleStatus IS NULL)
			AND (m.intRowStatus = 0);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;