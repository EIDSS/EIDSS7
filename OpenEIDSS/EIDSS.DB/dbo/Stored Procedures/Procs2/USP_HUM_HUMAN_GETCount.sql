
-- ================================================================================================
-- Name: USP_HUM_HUMAN_GETCount
--
-- Description: Get human list count for human, laboratory and veterinary modules.
--          
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/16/2018 Initial release.
-- Stephen Long     12/30/2018 Changed to query human instead of human actual.  New human master 
--                             get count created to query human actual.
-- Stephen Long     01/18/2019 Changed date of birth to date of birth range.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_GETCount] (
	@LanguageID NVARCHAR(50),
	@EIDSSPersonID NVARCHAR(200) = NULL,
	@PersonalIDType BIGINT = NULL,
	@PersonalID NVARCHAR(100) = NULL,
	@FirstOrGivenName NVARCHAR(200) = NULL,
	@SecondName NVARCHAR(200) = NULL,
	@LastOrSurname NVARCHAR(200) = NULL,
	@DateOfBirthFrom DATETIME = NULL,
	@DateOfBirthTo DATETIME = NULL,
	@GenderTypeID BIGINT = NULL,
	@RegionID BIGINT = NULL,
	@RayonID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @DateOfBirthDateFrom AS DATE = CAST(@DateOfBirthFrom AS DATE),
			@DateOfBirthDateTo AS DATE = CAST(@DateOfBirthTo AS DATE);

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbHuman h
		LEFT JOIN dbo.HumanAddlInfo AS hai
			ON h.idfHuman = hai.HumanAdditionalInfo 
				AND hai.intRowStatus = 0
		LEFT JOIN dbo.HumanActualAddlInfo AS haai
			ON h.idfHumanActual = haai.HumanActualAddlInfoUID
				AND haai.intRowStatus = 0
		LEFT JOIN dbo.tlbGeoLocationShared AS humanAddress
			ON h.idfCurrentResidenceAddress = humanAddress.idfGeoLocationShared 
				AND humanAddress.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS country
			ON humanAddress.idfsCountry = country.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000003) AS region
			ON humanAddress.idfsRegion = region.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000002) AS rayon
			ON humanAddress.idfsRayon = rayon.idfsReference
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000004) AS settlement
			ON humanAddress.idfsSettlement = settlement.idfsReference
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000043) AS gender
			ON gender.idfsReference = h.idfsHumanGender
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000148) AS idType
			ON idType.idfsReference = h.idfsPersonIDType
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS nationality
			ON h.idfsNationality = nationality.idfsReference
		WHERE (
				h.intRowStatus = 0
				AND (
					(
						h.datDateofBirth BETWEEN @DateOfBirthDateFrom
							AND @DateOfBirthDateTo
						)
					OR (
						@DateOfBirthDateFrom IS NULL
						OR @DateOfBirthDateTo IS NULL
						)
					)
				AND (
					(h.idfsPersonIDType = @PersonalIDType)
					OR (@PersonalIDType IS NULL)
					)
				AND (
					(h.idfsHumanGender = @GenderTypeID)
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
					(haai.EIDSSPersonID LIKE '%' + @EIDSSPersonID + '%')
					OR (@EIDSSPersonID IS NULL)
					)
				AND (
					(h.strPersonID LIKE '%' + @PersonalID + '%')
					OR (@PersonalID IS NULL)
					)
				AND (
					(h.strFirstName LIKE '%' + @FirstOrGivenName + '%')
					OR (@FirstOrGivenName IS NULL)
					)
				AND (
					(h.strSecondName LIKE '%' + @SecondName + '%')
					OR (@SecondName IS NULL)
					)
				AND (
					(h.strLastName LIKE '%' + @LastOrSurname + '%')
					OR (@LastOrSurname IS NULL)
					)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
