
-- ================================================================================================
-- Name: USP_LAB_FAVORITE_GETCount
--
-- Description:	Get laboratory favorites count for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/19/2018 Initial release.
-- Stephen Long     03/01/2019 Added return code and return message.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_FAVORITE_GETCount] (
	@LanguageID NVARCHAR(50),
	@UserID BIGINT
	)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		DECLARE @favorites XML

		SET @favorites = (
				SELECT PreferenceDetail
				FROM dbo.UserPreference Laboratory
				WHERE idfUserID = @UserID
					AND ModuleConstantID = 10508006
					AND intRowStatus = 0
				);

		SELECT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		INNER JOIN (
			SELECT SampleID = UserPref.value('@SampleID', 'bigint')
			FROM @favorites.nodes('/Favorites/Favorite') AS Tbl(UserPref)
			) AS f
			ON m.idfMaterial = f.SampleID;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END