-- ================================================================================================
-- Name: USP_VET_FARM_MASTER_GETList
--
-- Description:	Get farm actual list for farm search and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/05/2019 Initial release.
-- Stephen Long     04/27/2019 Correction to where clause; added row status check.
-- Stephen Long     05/22/2019 Added additional farm address fields to the select.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_MASTER_GETList] (
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
	@SettlementID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @ReturnMessage VARCHAR(MAX) = 'SUCCESS';
		DECLARE @ReturnCode BIGINT = 0;

		SELECT fa.idfFarmActual AS FarmMasterID,
			fa.idfsFarmCategory AS FarmTypeID,
			farmType.name AS FarmTypeName,
			fa.idfHumanActual AS FarmOwnerMasterID,
			fa.idfFarmAddress AS FarmAddressID,
			fa.strNationalName AS FarmName,
			fa.strFarmCode AS EIDSSFarmID,
			fa.strFax AS Fax,
			fa.strEmail AS Email,
			fa.strContactPhone AS Phone,
			fa.intLivestockTotalAnimalQty AS TotalLivestockAnimalQuantity,
			fa.intAvianTotalAnimalQty AS TotalAvianAnimalQuantity,
			fa.intLivestockSickAnimalQty AS SickLivestockAnimalQuantity,
			fa.intAvianSickAnimalQty AS SickAvianAnimalQuantity,
			fa.intLivestockDeadAnimalQty AS DeadLivestockAnimalQuantity,
			fa.intAvianDeadAnimalQty AS DeadAvianAnimalQuantity,
			fa.intRowStatus AS RowStatus,
			gl.idfsCountry AS CountryID,
			gl.idfsRegion AS RegionID,
			Region.name AS RegionName,
			gl.idfsRayon AS RayonID,
			Rayon.name AS RayonName,
			gl.idfsSettlement AS SettlementID,
			Settlement.name AS SettlementName,
			gl.strApartment AS Apartment, 
			gl.strBuilding AS Building, 
			gl.strHouse AS House, 
			gl.strPostCode AS PostalCode, 
			gl.strStreetName AS Street,
			gl.dblLatitude AS Latitude, 
			gl.dblLongitude AS Longitude, 
			(
				IIF(gl.strForeignAddress IS NULL, (
						(
							CASE 
								WHEN gl.strStreetName IS NULL
									THEN ''
								WHEN gl.strStreetName = ''
									THEN ''
								ELSE gl.strStreetName
								END
							) + IIF(gl.strBuilding = '', '', ', Bld ' + gl.strBuilding) + IIF(gl.strApartment = '', '', ', Apt ' + gl.strApartment) + IIF(gl.strHouse = '', '', ', ' + gl.strHouse) + IIF(gl.idfsSettlement IS NULL, '', ', ' + Settlement.name) + (
							CASE 
								WHEN gl.strPostCode IS NULL
									THEN ''
								WHEN gl.strPostCode = ''
									THEN ''
								ELSE ', ' + gl.strPostCode
								END
							) + IIF(gl.idfsRayon IS NULL, '', ', ' + Rayon.name) + IIF(gl.idfsRegion IS NULL, '', ', ' + Region.name) + IIF(gl.idfsCountry IS NULL, '', ', ' + Country.name)
						), gl.strForeignAddress)
				) AS FarmAddress,
			(CONVERT(NVARCHAR(100), gl.dblLatitude) + ', ' + CONVERT(NVARCHAR(100), gl.dblLongitude)) AS FarmAddressCoordinates,
			haai.EIDSSPersonID AS EIDSSFarmOwnerID,
			(
				CASE 
					WHEN ha.strFirstName IS NULL
						THEN ''
					WHEN ha.strFirstName = ''
						THEN ''
					ELSE ha.strFirstName
					END + CASE 
					WHEN ha.strSecondName IS NULL
						THEN ''
					WHEN ha.strSecondName = ''
						THEN ''
					ELSE ' ' + ha.strSecondName
					END + CASE 
					WHEN ha.strLastName IS NULL
						THEN ''
					WHEN ha.strLastName = ''
						THEN ''
					ELSE ' ' + ha.strLastName
					END
				) AS FarmOwnerName, 
				ha.strFirstName AS FarmOwnerFirstName, 
				ha.strLastName AS FarmOwnerLastName, 
				ha.strSecondName AS FarmOwnerSecondName 
		FROM dbo.tlbFarmActual fa
		LEFT JOIN dbo.tlbHumanActual AS ha
			ON ha.idfHumanActual = fa.idfHumanActual
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON haai.HumanActualAddlInfoUID = ha.idfHumanActual
		LEFT JOIN dbo.tlbGeoLocationShared AS gl
			ON gl.idfGeoLocationShared = fa.idfFarmAddress
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
				)
		ORDER BY fa.strFarmCode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH;
END;
