-- ================================================================================================
-- Name: USP_VET_FARM_GETCount
--
-- Description:	Get farm list counts for farm search and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/06/2019 Initial release.
-- Stephen Long     05/13/2019 Correction to use tlbGeoLocation instead of tlbGeoLocationShared.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_GETCount] (
	@LanguageID NVARCHAR(20),
	@FarmID BIGINT = NULL,
	@EIDSSFarmID NVARCHAR(200) = NULL,
	@FarmTypeID BIGINT = NULL,
	@FarmName NVARCHAR(200) = '',
	@FarmOwnerFirstName NVARCHAR(200) = '',
	@FarmOwnerLastName NVARCHAR(200) = '',
	@EIDSSPersonID NVARCHAR(100) = NULL,
	@FarmOwnerID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@SettlementTypeID BIGINT = NULL,
	@SettlementID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT COUNT(f.idfFarm) AS SearchCount,
			(
				SELECT COUNT(*)
				FROM dbo.tlbFarmActual
				WHERE intRowStatus = 0
				) AS TotalCount
		FROM dbo.tlbFarm f
		LEFT JOIN dbo.tlbHuman AS h
			ON h.idfHuman = f.idfHuman
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON haai.HumanActualAddlInfoUID = h.idfHumanActual
		LEFT JOIN dbo.tlbGeoLocation AS gl
			ON gl.idfGeoLocation = f.idfFarmAddress
				AND gl.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS Country
			ON Country.idfsReference = gl.idfsCountry
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS Rayon
			ON Rayon.idfsReference = gl.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS Region
			ON Region.idfsReference = gl.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS Settlement
			ON Settlement.idfsReference = gl.idfsSettlement
		LEFT JOIN dbo.gisSettlement AS gisS
			ON gisS.idfsSettlement = gl.idfsSettlement
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000040) AS farmType
			ON farmType.idfsReference = f.idfsFarmCategory
		WHERE (
				(f.idfFarm = @FarmID)
				OR (@FarmID IS NULL)
				)
			AND (
				(f.strFarmCode LIKE @EIDSSFarmID + '%')
				OR (@EIDSSFarmID IS NULL)
				)
			AND (
				(f.idfsFarmCategory = @FarmTypeID)
				OR (@FarmTypeID IS NULL)
				)
			AND (
				(f.strNationalName LIKE @FarmName + '%')
				OR (@FarmName IS NULL)
				)
			AND (
				(h.strFirstName LIKE @FarmOwnerFirstName + '%')
				OR (@FarmOwnerFirstName IS NULL)
				)
			AND (
				(h.strLastName LIKE @FarmOwnerLastName + '%')
				OR (@FarmOwnerLastName IS NULL)
				)
			AND (
				(haai.EIDSSPersonID LIKE @EIDSSPersonID + '%')
				OR (@EIDSSPersonID IS NULL)
				)
			AND (
				(h.idfHumanActual = @FarmOwnerID)
				OR (@FarmOwnerID IS NULL)
				)
			AND (
				(gl.idfsRegion = @RegionID)
				OR (@RegionID IS NULL)
				)
			AND (
				(gl.idfsRayon = @RayonID)
				OR (@RayonID IS NULL)
				)
			AND (
				(gisS.idfsSettlementType = @SettlementTypeID)
				OR (@SettlementTypeID IS NULL)
				)
			AND (
				(gl.idfsSettlement = @SettlementID)
				OR (@SettlementID IS NULL)
				);
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END;
GO


