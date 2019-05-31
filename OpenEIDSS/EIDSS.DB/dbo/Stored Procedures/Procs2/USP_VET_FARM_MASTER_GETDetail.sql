-- ================================================================================================
-- Name: USP_VET_FARM_MASTER_GETDetail
--
-- Description:	Get farm details for a specific farm master or farm record.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/06/2019 Initial release.
-- Stephen Long     04/29/2019 Added audit create date as entered date.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_VET_FARM_MASTER_GETDetail] (
	@LanguageID NVARCHAR(50),
	@FarmMasterID BIGINT
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT fa.idfFarmActual AS FarmMasterID,
			fa.idfsFarmCategory AS FarmTypeID,
			farmType.name AS FarmTypeName,
			fa.idfsOwnershipStructure AS OwnershipStructureTypeID,
			fa.idfHumanActual AS FarmOwnerID,
			haai.EIDSSPersonID,
			ISNULL(ha.strLastName, N'') + ISNULL(', ' + ha.strFirstName, '') + ISNULL(' ' + ha.strSecondName, '') + ISNULL(' ' + CHAR(150) + ' ' + haai.EIDSSPersonID, '') AS FarmOwner,
			ha.strLastName AS FarmOwnerLastName, 
			ha.strFirstName AS FarmOwnerFirstName, 
			ha.strSecondName AS FarmOwnerSecondName, 
			(
				CASE 
					WHEN fa.strNationalName IS NULL
						THEN fa.strInternationalName
					WHEN fa.strNationalName = ''
						THEN fa.strInternationalName
					ELSE fa.strNationalName
					END
				) AS FarmName,
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
			fa.strNote AS Note,
			fa.intRowStatus AS RowStatus,
			fa.datModificationDate AS ModifiedDate,
			fa.AuditCreateDTM AS EnteredDate, 
			fa.idfFarmAddress AS FarmAddressID,
			glFarm.idfsCountry AS FarmAddressidfsCountry,
			glFarm.idfsRegion AS FarmAddressidfsRegion,
			glFarm.idfsRayon AS FarmAddressidfsRayon,
			glFarm.idfsSettlement AS FarmAddressidfsSettlement,
			glFarm.strPostCode AS FarmAddressstrPostalCode,
			glFarm.strStreetName AS FarmAddressstrStreetName,
			glFarm.strBuilding AS FarmAddressstrBuilding,
			glFarm.strApartment AS FarmAddressstrApartment,
			glFarm.strHouse AS FarmAddressstrHouse,
			glFarm.dblLatitude AS FarmAddressstrLatitude,
			glFarm.dblLongitude AS FarmAddressstrLongitude,
			Region.name AS RegionName,
			Rayon.name AS RayonName,
			Settlement.name AS SettlementName,
			(CONVERT(NVARCHAR(100), glFarm.dblLatitude) + ', ' + CONVERT(NVARCHAR(100), glFarm.dblLongitude)) AS Coordinates,
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
		FROM dbo.tlbFarmActual fa
		LEFT JOIN dbo.tlbHumanActual AS ha
			ON ha.idfHumanActual = fa.idfHumanActual
				AND ha.intRowStatus = 0
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON haai.HumanActualAddlInfoUID = ha.idfHumanActual
				AND haai.intRowStatus = 0
		LEFT JOIN dbo.tlbGeoLocationShared glFarm
			ON glFarm.idfGeoLocationShared = fa.idfFarmAddress
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
			ON farmType.idfsReference = fa.idfsFarmCategory
		WHERE fa.idfFarmActual = @FarmMasterID;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END
GO


