
-- ================================================================================================
-- Name: USP_GBL_ORGANIZATION_GETList
--
-- Description: Selects list of organizations based on parameterized criteria.
--          
-- Revision History:
-- Name		       Date		  Change Detail
-- --------------- ---------- --------------------------------------------------------------------
-- Stephen Long    11/13/2018 Initial release.
-- Stephen Long    12/18/2018 Added pagination set, page size and max pages per fetch parameters
--                            and fetch portion.
-- Stephen Long    03/12/2019 Added check for null value on order.  If null is found, then return 
--                            0.  Need a number in all cases, so the organizations can be sorted 
--                            by order if the user selects show foreign organizations (see SAUC05).
--
-- Testing Code:
-- EXEC USP_GBL_ORGANIZATION_GETList 'en', NULL, 2
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_ORGANIZATION_GETList] (
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
	@OrganizationTypeID BIGINT = NULL,
	@PaginationSet INT = 1,
	@PageSize INT = 10,
	@MaxPagesPerFetch INT = 10
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT idfOffice AS OrganizationID,
			[name] AS OrganizationAbbreviatedName,
			FullName AS OrganizationFullName,
			idfsOfficeName AS OrganizationNameTypeID,
			idfsOfficeAbbreviation AS OrganizationAbbreviationTypeID,
			CAST(CASE 
					WHEN (intHACode & 2) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS HumanIndicator,
			CAST(CASE 
					WHEN (intHACode & 96) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS VeterinaryIndicator,
			CAST(CASE 
					WHEN (intHACode & 32) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS LivestockIndicator,
			CAST(CASE 
					WHEN (intHACode & 64) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS AvianIndicator,
			CAST(CASE 
					WHEN (intHACode & 128) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS VectorIndicator,
			CAST(CASE 
					WHEN (intHACode & 256) > 0
						THEN 1
					ELSE 0
					END AS BIT) AS SyndromicIndicator,
			intHACode AS AccessoryCode,
			idfsSite AS SiteID,
			strOrganizationID AS OrganizationEIDSSID,
			intRowStatus AS RowStatus,
			(
				CASE 
					WHEN intOrder IS NULL
						THEN 0
					ELSE intOrder
					END
				) AS OrderNumber,
			idfLocation AS LocationID,
			idfGeoLocationShared AS SharedLocationID,
			idfsResidentType AS ResidentTypeID,
			idfsGroundType AS GroundTypeID,
			idfsGeoLocationType AS LocationTypeID,
			idfsCountry AS CountryID,
			Country AS CountryName,
			idfsRegion AS RegionID,
			Region AS RegionName,
			idfsRayon AS RayonID,
			Rayon AS RayonName,
			idfsSettlement AS SettlementID,
			Settlement AS SettlementName,
			strPostCode AS PostalCode,
			strStreetName AS StreetName,
			strHouse AS House,
			strBuilding AS Building,
			strApartment AS Apartment,
			strDescription AS DescriptionString,
			dblDistance AS Distance,
			dblLatitude AS Latitude,
			dblLongitude AS Longitude,
			dblAccuracy AS Accuracy,
			dblAlignment AS Alignment,
			blnForeignAddress AS ForeignAddressIndicator,
			strForeignAddress AS ForeignAddressString,
			strAddressString AS AddressString,
			strShortAddressString AS ShortAddressString,
			OrganizationTypeID
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
				)
		ORDER BY strOrganizationID OFFSET(@PageSize * @MaxPagesPerFetch) * (@PaginationSet - 1) ROWS

		FETCH NEXT (@PageSize * @MaxPagesPerFetch) ROWS ONLY;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END
