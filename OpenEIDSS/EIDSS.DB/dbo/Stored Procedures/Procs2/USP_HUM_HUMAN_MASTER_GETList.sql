-- ================================================================================================
-- Name: USP_HUM_HUMAN_MASTER_GETList
--
-- Description: Get human actual list for human, laboratory and veterinary modules.
--          
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Mandar Kulkarni             Initial release.
-- Stephen Long     03/13/2018 Added additional address fields.
-- Stephen Long     08/23/2018 Added EIDSS person ID to list.
-- Stephen Long     09/26/2018 Added wildcard to the front of fields using the wildcard symbol, as 
--                             per use case.
-- Stephen Long		09/28/2018 Added order by and total records, as per use case.
-- Stephen Long     11/26/2018 Updated for the new API; removed returnCode and returnMsg. Total 
--                             records will need to be handled differently.
-- Stephen Long     12/14/2018 Added pagination set, page size and max pages per fetch parameters
--                             and fetch portion.
-- Stephen Long     12/30/2018 Renamed to master so the human get list stored procedure can query 
--                             the human table which is needed for the lab module instead of human 
--                             actual.
-- Stephen Long     01/18/2019 Changed date of birth to date of birth range, and duplicate check.
-- Stephen Long     04/08/2019 Changed full name from first name last name second name to last 
--                             name ', ' first name and then second name.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_MASTER_GETList] (
	@LanguageID NVARCHAR(50),
	@EIDSSPersonID NVARCHAR(200) = NULL,
	@PersonalIDType BIGINT = NULL,
	@PersonalID NVARCHAR(100) = NULL,
	@FirstOrGivenName NVARCHAR(200) = NULL,
	@SecondName NVARCHAR(200) = NULL,
	@LastOrSurname NVARCHAR(200) = NULL,
	@ExactDateOfBirth DATETIME = NULL,
	@DateOfBirthFrom DATETIME = NULL,
	@DateOfBirthTo DATETIME = NULL,
	@GenderTypeID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @DateOfBirthDateFrom AS DATE = CAST(@DateOfBirthFrom AS DATE),
			@DateOfBirthDateTo AS DATE = CAST(@DateOfBirthTo AS DATE),
			@ExactDateOfBirthDate AS DATE = CAST(@ExactDateOfBirth AS DATE);

		SELECT ha.idfHumanActual AS HumanMasterID,
			hai.EIDSSPersonID AS EIDSSPersonID,
			ha.strFirstName AS FirstOrGivenName,
			ha.strSecondName AS SecondName,
			ha.strLastName AS LastOrSurname,
			(
				CASE 
				WHEN ha.strLastName IS NULL
						THEN ''
					WHEN ha.strLastName = ''
						THEN ''
					ELSE ha.strLastName + ', '
					END + CASE
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
					END
				) AS FullName,
			ha.datDateofBirth AS DateOfBirth,
			ha.strPersonID AS PersonalID,
			idType.name AS PersonIDTypeName,
			humanAddress.strStreetName AS StreetName,
			humanAddress.strAddressString AS AddressString,
			(CONVERT(NVARCHAR(100), humanAddress.dblLatitude) + ', ' + CONVERT(NVARCHAR(100), humanAddress.dblLongitude)) AS LongitudeLatitude,
			hai.ContactPhoneCountryCode AS ContactPhoneCountryCode,
			hai.ContactPhoneNbr AS ContactPhoneNumber,
			hai.ReportedAge AS Age,
			ha.idfsNationality AS CitizenshipTypeID,
			citizenshipType.name AS CitizenshipTypeName,
			ha.idfsHumanGender AS GenderTypeID,
			genderType.name AS GenderTypeName,
			humanAddress.idfsCountry AS CountryID,
			country.name AS CountryName,
			humanAddress.idfsRegion AS RegionID,
			region.name AS RegionName,
			humanAddress.idfsRayon AS RayonID,
			rayon.name AS RayonName,
			(
				IIF(humanAddress.strForeignAddress IS NULL, (
						(
							CASE 
								WHEN humanAddress.strStreetName IS NULL
									THEN ''
								WHEN humanAddress.strStreetName = ''
									THEN ''
								ELSE humanAddress.strStreetName
								END
							) + IIF(humanAddress.strBuilding = '', '', ', Bld ' + humanAddress.strBuilding) + IIF(humanAddress.strApartment = '', '', ', Apt ' + humanAddress.strApartment) + IIF(humanAddress.strHouse = '', '', ', ' + humanAddress.strHouse) + IIF(humanAddress.idfsSettlement IS NULL, '', ', ' + settlement.name) + (
							CASE 
								WHEN humanAddress.strPostCode IS NULL
									THEN ''
								WHEN humanAddress.strPostCode = ''
									THEN ''
								ELSE ', ' + humanAddress.strPostCode
								END
							) + IIF(humanAddress.idfsRayon IS NULL, '', ', ' + rayon.name) + IIF(humanAddress.idfsRegion IS NULL, '', ', ' + region.name) + IIF(humanAddress.idfsCountry IS NULL, '', ', ' + country.name)
						), humanAddress.strForeignAddress)
				) AS FormattedAddressString
		FROM dbo.tlbHumanActual ha
		INNER JOIN dbo.HumanActualAddlInfo AS hai
			ON ha.idfHumanActual = hai.HumanActualAddlInfoUID
				AND hai.intRowStatus = 0
		LEFT JOIN dbo.tlbGeoLocationShared AS humanAddress
			ON ha.idfCurrentResidenceAddress = humanAddress.idfGeoLocationShared
				AND humanAddress.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS country
			ON humanAddress.idfsCountry = country.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS region
			ON humanAddress.idfsRegion = region.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS rayon
			ON humanAddress.idfsRayon = rayon.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS settlement
			ON humanAddress.idfsSettlement = settlement.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000043) AS genderType
			ON genderType.idfsReference = ha.idfsHumanGender
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000148) AS idType
			ON idType.idfsReference = ha.idfsPersonIDType
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000054) AS citizenshipType
			ON ha.idfsNationality = citizenshipType.idfsReference
		WHERE (
				ha.intRowStatus = 0
				AND
				--Duplicate person check...
				(
					(
						ha.datDateofBirth = @ExactDateOfBirthDate
						AND ha.strFirstName = @FirstOrGivenName
						AND ha.strLastName = @LastOrSurname
						)
					OR (@ExactDateOfBirth IS NULL)
					)
				AND (
					(
						ha.datDateofBirth BETWEEN @DateOfBirthDateFrom
							AND @DateOfBirthDateTo
						)
					OR (
						@DateOfBirthDateFrom IS NULL
						OR @DateOfBirthDateTo IS NULL
						)
					)
				AND (
					(ha.idfsPersonIDType = @PersonalIDType)
					OR (@PersonalIDType IS NULL)
					)
				AND (
					(ha.idfsHumanGender = @GenderTypeID)
					OR (@GenderTypeID IS NULL)
					)
				AND (
					(humanAddress.idfsRegion = @RegionID)
					OR (@RegionID IS NULL)
					)
				AND (
					(humanAddress.idfsRayon = @RayonID)
					OR (@RayonID IS NULL)
					)
				AND (
					(hai.EIDSSPersonID LIKE '%' + @EIDSSPersonID + '%')
					OR (@EIDSSPersonID IS NULL)
					)
				AND (
					(ha.strPersonID LIKE '%' + @PersonalID + '%')
					OR (@PersonalID IS NULL)
					)
				AND (
					(ha.strFirstName LIKE '%' + @FirstOrGivenName + '%')
					OR (@FirstOrGivenName IS NULL)
					)
				AND (
					(ha.strSecondName LIKE '%' + @SecondName + '%')
					OR (@SecondName IS NULL)
					)
				AND (
					(ha.strLastName LIKE '%' + @LastOrSurname + '%')
					OR (@LastOrSurname IS NULL)
					)
				)
		ORDER BY EIDSSPersonID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
GO