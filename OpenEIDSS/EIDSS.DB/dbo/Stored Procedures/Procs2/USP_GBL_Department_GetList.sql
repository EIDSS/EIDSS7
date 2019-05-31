
-- ================================================================================================
-- Name: USP_GBL_Department_GetList
--
-- Description:	Get department list filterable by organization and department identifiers.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Joan Li          05/02/2017 Initial release; based on V6 spDepartment_SelectLookup.
-- Stephen Long     11/19/2018 Renamed for global use; used by multiple modules.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_Department_GetList]
	@LanguageID				NVARCHAR(50),
	@OrganizationID			BIGINT = NULL,
	@DepartmentID			BIGINT = NULL
AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;

		SELECT				idfDepartment AS DepartmentID, 
							idfInstitution AS OrganizationID, 
							[name] AS DepartmentName, 
							intRowStatus AS RowStatus 
		FROM				dbo.fnDepartment(@LanguageID) 
		WHERE				(@OrganizationID IS NULL OR idfInstitution = @OrganizationID)
		AND					(@DepartmentID IS NULL OR @DepartmentID = idfDepartment)
		ORDER BY			[name];
	END TRY
	BEGIN CATCH
		;THROW;
	END CATCH
END
