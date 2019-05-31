-- ================================================================================================
-- Name: USP_VET_FARM_GETDetail
--
-- Description:	Get farm details for a specific farm "snapshot" record.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/06/2019 Initial release.
-- Stephen Long     04/23/3019 Added postal code to the select list.
-- Stephen Long     04/29/2019 Added audit create date as entered date.
-- Stephen Long     05/13/2019 Fix to join to tlbGeoLocation instead of tlbGeoLocationShared.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_GETDetail] (
	@LanguageID NVARCHAR(50),
	@FarmID BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT f.idfFarmActual AS FarmMasterID,
			f.idfsFarmCategory AS FarmTypeID,
			farmType.name AS FarmTypeName,
			f.idfsOwnershipStructure AS OwnershipStructureTypeID,
			f.idfHuman AS FarmOwnerID,
			haai.EIDSSPersonID,
			ISNULL(h.strLastName, N'') + ISNULL(', ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') + ISNULL(' ' + haai.EIDSSPersonID, '') AS FarmOwner,
			h.strLastName AS FarmOwnerLastName, 
			h.strFirstName AS FarmOwnerFirstName, 
			h.strSecondName AS FarmOwnerSecondName, 
			(
				CASE 
					WHEN f.strNationalName IS NULL
						THEN f.strInternationalName
					WHEN f.strNationalName = ''
						THEN f.strInternationalName
					ELSE f.strNationalName
					END
				) AS FarmName,
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
			f.strNote AS Note,
			f.intRowStatus AS RowStatus,
			f.datModificationDate AS ModifiedDate,
			f.AuditCreateDTM AS EnteredDate, 
			f.idfFarmAddress AS FarmAddressID,
			glFarm.idfsCountry AS FarmAddressidfsCountry,
			glFarm.idfsRegion AS FarmAddressidfsRegion,
			glFarm.idfsRayon AS FarmAddressidfsRayon,
			glFarm.idfsSettlement AS FarmAddressidfsSettlement,
			glFarm.strStreetName AS FarmAddressstrStreetName,
			glFarm.strBuilding AS FarmAddressstrBuilding,
			glFarm.strApartment AS FarmAddressstrApartment,
			glFarm.strHouse AS FarmAddressstrHouse,
			glFarm.strPostCode AS FarmAddressstrPostalCode,
			glFarm.dblLatitude AS FarmAddressstrLatitude,
			glFarm.dblLongitude AS FarmAddressstrLongitude,
			Region.name AS RegionName,
			Rayon.name AS RayonName,
			Settlement.name AS SettlementName,
			(CONVERT(NVARCHAR(100), glFarm.dblLatitude) + ', ' + CONVERT(NVARCHAR(100), glFarm.dblLongitude)) AS Coordinates,
			ISNULL(h.strLastName, N'') + ISNULL(', ' + h.strFirstName, '') + ISNULL(' ' + h.strSecondName, '') AS FarmOwnerName,
			(
				IIF(glFarm.strForeignAddress IS NULL, (
						(
							CASE 
								WHEN glFarm.strStreetName IS NULL
									THEN ''
								WHEN glFarm.strStreetName = ''
									THEN ''
								ELSE glFarm.strStreetName
								END
							) + IIF(glFarm.strBuilding = '', '', ', Bld ' + glFarm.strBuilding) + IIF(glFarm.strApartment = '', '', ', Apt ' + glFarm.strApartment) + IIF(glFarm.strHouse = '', '', ', ' + glFarm.strHouse) + IIF(glFarm.idfsSettlement IS NULL, '', ', ' + Settlement.name) + (
							CASE 
								WHEN glFarm.strPostCode IS NULL
									THEN ''
								WHEN glFarm.strPostCode = ''
									THEN ''
								ELSE ', ' + glFarm.strPostCode
								END
							) + IIF(glFarm.idfsRayon IS NULL, '', ', ' + Rayon.name) + IIF(glFarm.idfsRegion IS NULL, '', ', ' + Region.name) + IIF(glFarm.idfsCountry IS NULL, '', ', ' + Country.name)
						), glFarm.strForeignAddress)
				) AS FarmAddress
		FROM dbo.tlbFarm f
		LEFT JOIN dbo.tlbHuman AS h
			ON h.idfHuman = f.idfHuman
				AND h.intRowStatus = 0
		LEFT JOIN dbo.HumanAddlInfo AS hai
			ON hai.HumanAdditionalInfo = h.idfHuman
				AND hai.intRowStatus = 0
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON haai.HumanActualAddlInfoUID = h.idfHumanActual
				AND haai.intRowStatus = 0
		LEFT JOIN dbo.tlbGeoLocation glFarm
			ON glFarm.idfGeoLocation = f.idfFarmAddress
				AND glFarm.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS Country
			ON Country.idfsReference = glFarm.idfsCountry
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000002) AS Rayon
			ON Rayon.idfsReference = glFarm.idfsRayon
		LEFT JOIN dbo.FN_GBL_GIS_REFERENCE(@LanguageID, 19000003) AS Region
			ON Region.idfsReference = glFarm.idfsRegion
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS Settlement
			ON Settlement.idfsReference = glFarm.idfsSettlement
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000040) AS farmType
			ON farmType.idfsReference = f.idfsFarmCategory
		WHERE f.idfFarm = @FarmID;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
