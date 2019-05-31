
-- ================================================================================================
-- Name: USP_GBL_USER_PREFERENCE_SET
--
-- Description:	Inserts or updates user preferences by module.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     10/27/2018 Initial release.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_GBL_USER_PREFERENCE_SET]
(
	@UserPreferenceID						BIGINT = NULL,
	@UserID									BIGINT,
	@ModuleConstantID						BIGINT, 
	@PreferenceDetail						XML
)
AS
BEGIN
	SET XACT_ABORT, NOCOUNT ON;

    BEGIN TRY
		DECLARE @ReturnCode					INT = 0,
			@ReturnMessage					NVARCHAR(2048) = 'SUCCESS';
		DECLARE @SupressSelect				TABLE
		(
			ReturnCode						INT,
			ReturnMessage					VARCHAR(2048), 
			ID								BIGINT 
		);

		BEGIN TRANSACTION

		IF									@UserPreferenceID IS NULL 
		BEGIN
			INSERT INTO						@SupressSelect
			EXECUTE							dbo.USP_GBL_NEXTKEYID_GET 'UserPreference', @UserPreferenceID OUTPUT;

			INSERT INTO						dbo.UserPreference 
			(
											UserPreferenceUID, 
											idfUserID, 
											ModuleConstantID, 
											PreferenceDetail, 
											intRowStatus, 
											AuditCreateUser, 
											AuditCreateDTM
			)
			VALUES
			(
											@UserPreferenceID,
											@UserID, 
											@ModuleConstantID, 
											@PreferenceDetail,
											0, 
											'srvcEIDSS', 
											GETDATE()
			)
		END
		ELSE
		BEGIN
			UPDATE							dbo.UserPreference 
			SET								idfUserID = @UserID, 
											PreferenceDetail = @PreferenceDetail, 
											AuditUpdateUser = 'srvcEIDSS', 
											AuditUpdateDTM = GETDATE()
			WHERE							UserPreferenceUID = @UserPreferenceID;
		END;

		IF @@TRANCOUNT > 0 
			COMMIT;

		SELECT @ReturnCode ReturnCode, @ReturnMessage ReturnMessage, @UserPreferenceID UserPreferenceID;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT = 1 
			ROLLBACK;

		THROW;
	END CATCH
END
