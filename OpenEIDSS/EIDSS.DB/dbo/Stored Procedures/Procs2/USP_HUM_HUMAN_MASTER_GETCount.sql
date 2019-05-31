

-- ================================================================================================
-- Name: USP_HUM_HUMAN_MASTER_GETCount
--
-- Description: Get human actual list count for human, laboratory and veterinary modules.
--          
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/30/2018 Initial release.
-- Stephen Long     01/18/2019 Changed date of birth to date of birth range, and duplicate check.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_HUM_HUMAN_MASTER_GETCount] (
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
	@RayonID BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		DECLARE @DateOfBirthDateFrom AS DATE = CAST(@DateOfBirthFrom AS DATE),
			@DateOfBirthDateTo AS DATE = CAST(@DateOfBirthTo AS DATE),
			@ExactDateOfBirthDate AS DATE = CAST(@ExactDateOfBirth AS DATE);

		SELECT COUNT(*) AS RecordCount
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
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000043) AS gender
			ON gender.idfsReference = ha.idfsHumanGender
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000148) AS idType
			ON idType.idfsReference = ha.idfsPersonIDType
		LEFT JOIN dbo.FN_GBL_GIS_Reference(@LanguageID, 19000001) AS nationality
			ON ha.idfsNationality = nationality.idfsReference
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
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;
END;
