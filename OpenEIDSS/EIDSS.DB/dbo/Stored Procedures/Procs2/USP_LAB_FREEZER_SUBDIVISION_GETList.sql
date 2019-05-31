
-- ================================================================================================
-- Name: USP_LAB_FREEZER_SUBDIVISION_GETList
--
-- Description:	Get freezer subdivision list (shelf, rack, box) for a specific freezer.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     01/19/2019 Initial release.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FREEZER_SUBDIVISION_GETList] (
	@LanguageID NVARCHAR(50),
	@FreezerID BIGINT = NULL,
	@OrganizationID BIGINT = NULL
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT fs.idfSubdivision AS SubdivisionID,
			fs.idfsSubdivisionType AS SubdivisionTypeID,
			subdivisionType.name AS SubdivisionTypeName,
			fs.idfFreezer AS FreezerID,
			f.strFreezerName AS FreezerName,
			f.LocBuildingName AS Building,
			f.LocRoom AS Room,
			fs.idfParentSubdivision AS ParentSubdivisionID,
			fs.idfsSite AS OrganizationID,
			fs.strBarcode AS EIDSSSubdivisionID,
			fs.strNameChars AS SubdivisionName,
			fs.strNote AS SubdivisionNote,
			fs.intCapacity AS NumberOfLocations,
			fs.BoxSizeID AS BoxSizeTypeID,
			boxSizeType.name AS BoxSizeTypeName,
			fs.BoxPlaceAvailability,
			(
				SELECT COUNT(m.idfMaterial)
				FROM dbo.tlbMaterial m
				WHERE m.idfSubdivision = fs.idfSubdivision
					AND m.intRowStatus = 0
					AND (
						m.idfsSampleStatus <> 10015008
						AND m.idfsSampleStatus <> 10015009
						)
				) AS SampleCount,
			fs.intRowStatus AS RowStatus,
			'R' AS RowAction
		FROM dbo.tlbFreezerSubdivision fs
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000093) AS subdivisionType
			ON subdivisionType.idfsReference = fs.idfsSubdivisionType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000512) AS boxSizeType
			ON boxSizeType.idfsReference = fs.BoxSizeID
		LEFT JOIN dbo.tlbFreezer AS f
			ON f.idfFreezer = fs.idfFreezer
		WHERE (
				(fs.idfFreezer = @FreezerID)
				OR (@FreezerID IS NULL)
				)
			AND (
				(fs.idfsSite = @OrganizationID)
				OR (@OrganizationID IS NULL)
				)
			AND fs.intRowStatus = 0
		ORDER BY fs.idfParentSubdivision;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;