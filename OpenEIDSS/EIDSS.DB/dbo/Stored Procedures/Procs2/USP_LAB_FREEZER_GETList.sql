
-- ================================================================================================
-- Name: USP_LAB_FREEZER_GETList
--
-- Description:	Get freezer list for the various laboratory module use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/26/2018 Initial release.
-- Stephen Long     12/19/2018 Added pagination logic.
-- Stephen Long     01/19/2019 Added site ID as parameter and part of the where clause.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FREEZER_GETList] (
	@LanguageID NVARCHAR(50),
	@SiteID BIGINT = NULL,
	@FreezerName NVARCHAR(200) = NULL,
	@Note NVARCHAR(200) = NULL,
	@StorageTypeID BIGINT = NULL,
	@Building NVARCHAR(200) = NULL,
	@Room NVARCHAR(200) = NULL,
	@SearchString NVARCHAR(2000) = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT f.idfFreezer AS FreezerID,
			f.strFreezerName AS FreezerName,
			f.strBarcode AS EIDSSFreezerID,
			f.idfsStorageType AS StorageTypeID,
			storageType.name AS StorageTypeName,
			f.LocBuildingName AS Building,
			f.LocRoom AS Room,
			f.idfsSite AS OrganizationID,
			freezerSite.strSiteName AS OrganizationName,
			f.strNote AS FreezerNote,
			f.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbFreezer f
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000092) AS storageType
			ON storageType.idfsReference = f.idfsStorageType
		LEFT JOIN dbo.tstSite AS freezerSite
			ON freezerSite.idfsSite = f.idfsSite
		WHERE (
				(
					(f.idfsSite = @SiteID)
					OR (@SiteID IS NULL)
					)
				AND (
					(f.idfsStorageType = @StorageTypeID)
					OR (@StorageTypeID IS NULL)
					)
				AND (
					(f.strFreezerName LIKE '%' + @FreezerName + '%')
					OR (@FreezerName IS NULL)
					)
				AND (
					(f.strNote LIKE '%' + @Note + '%')
					OR (@Note IS NULL)
					)
				AND (
					(f.LocBuildingName LIKE '%' + @Building + '%')
					OR (@Building IS NULL)
					)
				AND (
					(f.LocRoom LIKE '%' + @Room + '%')
					OR (@Room IS NULL)
					)
				)
			AND f.intRowStatus = 0
			AND (
				(
					f.strFreezerName LIKE '%' + @SearchString + '%'
					OR f.strNote LIKE '%' + @SearchString + '%'
					OR f.LocBuildingName LIKE '%' + @SearchString + '%'
					OR f.LocRoom LIKE '%' + @SearchString + '%'
					)
				OR (@SearchString IS NULL)
				)
		ORDER BY f.strBarcode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;