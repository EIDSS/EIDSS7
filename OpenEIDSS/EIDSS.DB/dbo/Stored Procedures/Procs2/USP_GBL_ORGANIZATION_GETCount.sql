
-- ================================================================================================
-- Name: USP_GBL_ORGANIZATION_GETCount
--
-- Description: Selects a count for the list of organizations based on parameterized criteria.
--          
-- Revision History:
-- Name		       Date		  Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    12/18/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_ORGANIZATION_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL,
	@EIDSSOrganizationID NVARCHAR(100) = NULL,
	@OrganizationAbbreviatedName NVARCHAR(2000) = NULL,
	@OrganizationFullName NVARCHAR(2000) = NULL,
	@AccessoryCode INT = NULL,
	@SiteID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@SettlementID BIGINT = NULL,
	@OrganizationTypeID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT COUNT(*) AS RecordCount
		FROM dbo.FN_GBL_INSTITUTION(@LanguageID)
		WHERE (
				(idfOffice = @OrganizationID)
				OR (@OrganizationID IS NULL)
				)
			AND (
				(
					@AccessoryCode IN (
						SELECT intHACode
						FROM dbo.FN_GBL_SplitHACode(intHACode, 510)
						)
					)
				OR (@AccessoryCode IS NULL)
				)
			AND (
				(idfsSite = @SiteID)
				OR (@SiteID IS NULL)
				)
			AND (
				(idfsRegion = @RegionID)
				OR (@RegionID IS NULL)
				)
			AND (
				(idfsRayon = @RayonID)
				OR (@RayonID IS NULL)
				)
			AND (
				(idfsSettlement = @SettlementID)
				OR (@SettlementID IS NULL)
				)
			AND (
				(OrganizationTypeID = @OrganizationTypeID)
				OR (@OrganizationTypeID IS NULL)
				)
			AND (
				(strOrganizationID LIKE '%' + @EIDSSOrganizationID + '%')
				OR (@EIDSSOrganizationID IS NULL)
				)
			AND (
				([name] LIKE '%' + @OrganizationAbbreviatedName + '%')
				OR (@OrganizationAbbreviatedName IS NULL)
				)
			AND (
				(FullName LIKE '%' + @OrganizationFullName + '%')
				OR (@OrganizationFullName IS NULL)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END