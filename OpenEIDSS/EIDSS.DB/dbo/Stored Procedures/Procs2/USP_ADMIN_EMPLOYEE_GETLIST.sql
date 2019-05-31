
-- ================================================================================================
-- Name: USP_ADMIN_EMPLOYEE_GETLIST
--
-- Description:	Get a list of employees for the various EIDSS use cases.
--
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     02/09/2019 Initial release for new API.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_ADMIN_EMPLOYEE_GETLIST] (
	@LanguageID AS NVARCHAR(50),
	@EmployeeID AS BIGINT = NULL,
	@FirstOrGivenName AS NVARCHAR(400) = NULL,
	@SecondName AS NVARCHAR(400) = NULL,
	@LastOrSurName AS NVARCHAR(400) = NULL,
	@ContactPhone AS NVARCHAR(400) = NULL,
	@OrganizationAbbreviatedName AS NVARCHAR(4000) = NULL,
	@OrganizationFullName AS NVARCHAR(4000) = NULL,
	@EIDSSOrganizationID AS NVARCHAR(200) = NULL,
	@OrganizationID AS BIGINT = NULL,
	@PositionTypeName AS NVARCHAR(4000) = NULL,
	@PositionTypeID AS BIGINT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT p.idfPerson AS EmployeeID,
			p.strFirstName AS FirstOrGivenName,
			p.strSecondName AS SecondName,
			p.strFamilyName AS LastOrSurName,
			ISNULL(p.strFirstName, '') + ISNULL(' ' + p.strFamilyName, '') AS EmployeeFullName,
			p.strContactPhone AS ContactPhone,
			organization.[name] AS OrganizationAbbreviatedName,
			organization.FullName AS OrganizationFullName,
			organization.strOrganizationID AS EIDSSOrganizationID,
			p.idfInstitution AS OrganizationID,
			positionType.[name] AS PositionTypeName,
			positionType.idfsReference AS PositionTypeID
		FROM dbo.tlbPerson p
		INNER JOIN dbo.tlbEmployee AS e
			ON e.idfEmployee = p.idfPerson
				AND e.intRowStatus = 0
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000073) AS positionType
			ON p.idfsStaffPosition = positionType.idfsReference
		LEFT JOIN dbo.FN_GBL_Institution(@LanguageID) AS organization
			ON organization.idfOffice = p.idfInstitution
		WHERE p.intRowStatus = 0
			AND (
				(
					(p.idfPerson = @EmployeeID)
					OR (@EmployeeID IS NULL)
					)
				OR (
					(p.strContactPhone = @ContactPhone)
					OR (@ContactPhone IS NULL)
					)
				OR (
					(p.idfInstitution = @OrganizationID)
					OR (@OrganizationID IS NULL)
					)
				OR (
					(positionType.idfsReference = @PositionTypeID)
					OR (@PositionTypeID IS NULL)
					)
				OR (
					(positionType.[name] = @PositionTypeName)
					OR (@PositionTypeName IS NULL)
					)
				OR (
					(p.strContactPhone = @ContactPhone)
					OR (@ContactPhone IS NULL)
					)
				OR (
					(p.strFirstName LIKE '%' + @FirstOrGivenName + '%')
					OR (@FirstOrGivenName IS NULL)
					)
				OR (
					(p.strSecondName LIKE '%' + @SecondName + '%')
					OR (@SecondName IS NULL)
					)
				OR (
					(p.strFamilyName LIKE '%' + @LastOrSurName + '%')
					OR (@LastOrSurName IS NULL)
					)
				OR (
					(organization.strOrganizationID LIKE '%' + @EIDSSOrganizationID + '%')
					OR (@EIDSSOrganizationID IS NULL)
					)
				OR (
					(organization.[name] LIKE '%' + @OrganizationAbbreviatedName + '%')
					OR (@OrganizationAbbreviatedName IS NULL)
					)
				OR (
					(organization.FullName LIKE '%' + @OrganizationFullName + '%')
					OR (@OrganizationFullName IS NULL)
					)
				);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH
END;