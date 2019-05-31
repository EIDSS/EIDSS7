-- ================================================================================================
-- Name: USP_VET_FARM_MASTER_GETCount
--
-- Description:	Get farm master list counts for farm search and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/06/2019 Initial release.
-- Stephen Long     04/27/2019 Correction to where clause; added row status check.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_MASTER_GETCount] (
	@LanguageID NVARCHAR(20),
	@FarmMasterID BIGINT = NULL,
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

		SELECT COUNT(fa.idfFarmActual) AS SearchCount,
			(
				SELECT COUNT(*)
				FROM dbo.tlbFarmActual
				WHERE intRowStatus = 0
				) AS TotalCount
		FROM dbo.tlbFarmActual fa
		LEFT JOIN dbo.tlbHumanActual AS ha
			ON ha.idfHumanActual = fa.idfHumanActual
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON haai.HumanActualAddlInfoUID = ha.idfHumanActual
		LEFT JOIN dbo.tlbGeoLocationShared AS gls
			ON gls.idfGeoLocationShared = fa.idfFarmAddress
				AND gls.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS Country
			ON Country.idfsReference = gls.idfsCountry
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS Rayon
			ON Rayon.idfsReference = gls.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS Region
			ON Region.idfsReference = gls.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS Settlement
			ON Settlement.idfsReference = gls.idfsSettlement
		LEFT JOIN dbo.gisSettlement AS gisS
			ON gisS.idfsSettlement = gls.idfsSettlement
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000040) AS farmType
			ON farmType.idfsReference = fa.idfsFarmCategory
		WHERE fa.intRowStatus = 0
			AND
				(
				(fa.idfFarmActual = @FarmMasterID)
				OR (@FarmMasterID IS NULL)
				)
			AND (
				(fa.strFarmCode LIKE @EIDSSFarmID + '%')
				OR (@EIDSSFarmID IS NULL)
				)
			AND (
				(fa.idfsFarmCategory = @FarmTypeID)
				OR (@FarmTypeID IS NULL)
				)
			AND (
				(fa.strNationalName LIKE @FarmName + '%')
				OR (@FarmName IS NULL)
				)
			AND (
				(ha.strFirstName LIKE @FarmOwnerFirstName + '%')
				OR (@FarmOwnerFirstName IS NULL)
				)
			AND (
				(ha.strLastName LIKE @FarmOwnerLastName + '%')
				OR (@FarmOwnerLastName IS NULL)
				)
			AND (
				(haai.EIDSSPersonID LIKE @EIDSSPersonID + '%')
				OR (@EIDSSPersonID IS NULL)
				)
			AND (
				(ha.idfHumanActual = @FarmOwnerID)
				OR (@FarmOwnerID IS NULL)
				)
			AND (
				(gls.idfsRegion = @RegionID)
				OR (@RegionID IS NULL)
				)
			AND (
				(gls.idfsRayon = @RayonID)
				OR (@RayonID IS NULL)
				)
			AND (
				(gisS.idfsSettlementType = @SettlementTypeID)
				OR (@SettlementTypeID IS NULL)
				)
			AND (
				(gls.idfsSettlement = @SettlementID)
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
