
-- ================================================================================================
-- Name: USP_LAB_BATCH_GETCount
--
-- Description:	Get laboratory batch count for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     11/10/2018 Initial release.
-- Stephen Long     01/25/2019 Changed where clause to look at batch test row status instead of 
--                             test.
-- Stephen Long     02/21/2019 Added organization ID parameter.
-- Stephen Long     03/19/2019 Added in progress count.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_BATCH_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL
	)
AS
BEGIN
	DECLARE @ReturnCode INT = 0;
	DECLARE @ReturnMessage NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT COUNT(b.idfBatchTest) AS RecordCount,
			IIF(SUM(CASE 
						WHEN b.idfsBatchStatus = 10001003
							THEN 1
						ELSE 0
						END) IS NULL, 0, SUM(CASE 
						WHEN b.idfsBatchStatus = 10001003
							THEN 1
						ELSE 0
						END)) AS InProgressCount
		FROM dbo.tlbBatchTest b
		WHERE (
				(b.idfPerformedByOffice = @OrganizationID)
				OR (@OrganizationID IS NULL)
				)
			AND (b.intRowStatus = 0);
	END TRY

	BEGIN CATCH
		SET @ReturnCode = ERROR_NUMBER();
		SET @ReturnMessage = ERROR_MESSAGE();

		THROW;
	END CATCH;

	SELECT @ReturnCode ReturnCode,
		@ReturnMessage ReturnMessage;
END