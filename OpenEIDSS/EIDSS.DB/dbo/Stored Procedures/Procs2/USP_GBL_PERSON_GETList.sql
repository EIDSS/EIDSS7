-- ================================================================================================
-- Name: USP_GBL_PERSON_GETList
--
-- Description:	Get person list for the disease reports, sessions and other use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     04/18/2019 Initial release
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_PERSON_GETList] (
	@LanguageID AS NVARCHAR(50) = 'EN',
	@FirstName AS NVARCHAR(400) = NULL,
	@SecondName AS NVARCHAR(400) = NULL,
	@LastName AS NVARCHAR(400) = NULL,
	@OrganizationID AS BIGINT = NULL,
	@OrganizationName AS NVARCHAR(4000) = NULL,
	@EIDSSOrganizationID AS NVARCHAR(200) = NULL, 
	@PositionID AS BIGINT = NULL
	)
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @ReturnMessage VARCHAR(MAX) = 'Success'
		DECLARE @ReturnCode BIGINT = 0

		SELECT p.idfPerson AS PersonID,
			p.strFirstName AS FirstName,
			p.strSecondName AS SecondName,
			p.strFamilyName AS LastName,
			p.idfInstitution AS OrganizationID,
			organization.strOrganizationID AS EIDSSOrganizationID,
			organization.[name] AS OrganizationName,
			organization.FullName AS OrganizationFullName,
			position.idfsReference AS PositionID,
			position.[name] AS PositionName
		FROM dbo.tlbPerson p
		LEFT JOIN dbo.FN_GBL_ReferenceRepair(@LanguageID, 19000073) AS position
			ON p.idfsStaffPosition = position.idfsReference
		LEFT JOIN dbo.FN_GBL_InstitutionRepair(@LanguageID) AS organization
			ON organization.idfOffice = p.idfInstitution
		WHERE (
				(p.strFirstName = @FirstName)
				OR (@FirstName IS NULL)
				)
			AND (
				(p.strSecondName = @SecondName)
				OR (@SecondName IS NULL)
				)
			AND (
				(p.strFamilyName = @LastName)
				OR (@LastName IS NULL)
				)
			AND (
				(organization.[name] = @OrganizationName)
				OR (@OrganizationName IS NULL)
				)
			AND (
				(organization.strOrganizationID = @EIDSSOrganizationID)
				OR (@EIDSSOrganizationID IS NULL)
				)
			AND (
				(p.idfsStaffPosition = @PositionID)
				OR (@PositionID IS NULL)
				);
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		SELECT @ReturnCode ReturnCode,
			@ReturnMessage ReturnMessage;

		THROW;
	END CATCH
END
