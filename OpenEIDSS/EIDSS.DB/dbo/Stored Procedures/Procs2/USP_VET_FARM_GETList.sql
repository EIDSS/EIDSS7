-- ================================================================================================
-- Name: USP_VET_FARM_GETList
--
-- Description:	Get farm list for farm search and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/05/2019 Initial release.
-- Stephen Long     05/13/2019 Correction to use tlbGeoLocation instead of tlbGeoLocationShared.
-- Stephen Long     05/22/2019 Added additional farm address fields to the select.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_GETList] (
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

		SELECT f.idfFarm AS FarmID,
			f.idfsFarmCategory AS FarmTypeID,
			farmType.name AS FarmTypeName,
			f.idfHuman AS FarmOwnerID,
			f.idfFarmAddress AS FarmAddressID,
			f.strNationalName AS FarmName,
			f.strFarmCode AS EIDSSFarmID,
			f.strFax AS Fax,
			f.strEmail AS Email,
			f.strContactPhone AS Phone,
			f.intLivestockTotalAnimalQty AS TotalLivestockAnimalQuantity,
			f.intAvianTotalAnimalQty AS TotalAvianAnimalQuantity,
			f.intLivestockSickAnimalQty AS SickLivestockAnimalQuantity,
			f.intAvianSickAnimalQty AS SickAvianAnimalQuantity,
			f.intLivestockDeadAnimalQty AS DeadLivestockAnimalQuantity,
			f.intAvianDeadAnimalQty AS DeadAvianAnimalQuantity,
			f.intRowStatus AS RowStatus,
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
					WHEN h.strFirstName IS NULL
						THEN ''
					WHEN h.strFirstName = ''
						THEN ''
					ELSE h.strFirstName
					END + CASE 
					WHEN h.strSecondName IS NULL
						THEN ''
					WHEN h.strSecondName = ''
						THEN ''
					ELSE ' ' + h.strSecondName
					END + CASE 
					WHEN h.strLastName IS NULL
						THEN ''
					WHEN h.strLastName = ''
						THEN ''
					ELSE ' ' + h.strLastName
					END
				) AS FarmOwnerName, 
				h.strFirstName AS FarmOwnerFirstName, 
				h.strLastName AS FarmOwnerLastName, 
				h.strSecondName AS FarmOwnerSecondName 
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
				)
		ORDER BY f.strFarmCode OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

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
