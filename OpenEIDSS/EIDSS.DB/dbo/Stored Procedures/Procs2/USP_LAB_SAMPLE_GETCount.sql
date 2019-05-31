
-- ================================================================================================
-- Name: USP_LAB_SAMPLE_GETCount
--
-- Description:	Get sample count for the laboratory module use case LUC01.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/19/2018 Initial release.
-- Stephen Long     01/14/2019 Split out search functionality (where conditions) for better 
--                             performance on this procedure.
-- Stephen Long     02/01/2019 Removed count distinct and joins that were unnecessary.
-- Stephen Long     02/10/2019 Added un-accessioned sample count.
-- Stephen Long     02/13/2019 Correction on the unaccessioned count for null value.
-- Stephen Long     02/21/2019 Added sample ID and parent sample ID parameters.
-- Stephen Long     03/28/2019 Removed test status 'Not Started' as criteria for test assigned 
--                             count.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_SAMPLE_GETCount] (
	@LanguageID NVARCHAR(50),
	@OrganizationID BIGINT = NULL,
	@SiteID BIGINT = NULL,
	@SampleID BIGINT = NULL,
	@ParentSampleID BIGINT = NULL,
	@DaysFromAccessionDate INT
	)
AS
BEGIN
	DECLARE @returnCode INT = 0;
	DECLARE @returnMsg NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		IF @SampleID IS NULL
			AND @ParentSampleID IS NULL
		BEGIN
			SELECT COUNT(m.idfMaterial) AS RecordCount,
				IIF(SUM(CASE 
							WHEN m.blnAccessioned = 0
								AND m.idfsAccessionCondition IS NULL
								THEN 1
							ELSE 0
							END) IS NULL, 0, SUM(CASE 
							WHEN m.blnAccessioned = 0
								AND m.idfsAccessionCondition IS NULL
								THEN 1
							ELSE 0
							END)) AS UnaccessionedSampleCount
			FROM dbo.tlbMaterial m
			WHERE (
					(m.idfsSampleType <> 10320001)
					AND (m.intRowStatus = 0)
					AND (
						((m.idfSendToOffice = @OrganizationID))
						OR (
							(
								m.idfsSite = @SiteID
								OR m.idfsCurrentSite = @SiteID
								)
							)
						)
					AND (
						(m.blnAccessioned = 0)
						OR (
							(
								m.blnAccessioned = 1
								AND GETDATE() <= DATEADD(DAY, @DaysFromAccessionDate, m.datAccession)
								)
							AND (
								(
									m.idfsSampleKind = 12675430000000
									AND EXISTS (
										SELECT t3.*
										FROM dbo.tlbTesting t3
										WHERE t3.idfsTestStatus = 10001001
											AND t3.intRowStatus = 0
										)
									)
								OR m.idfsSampleKind IS NULL
								)
							AND (
								(m.idfsSampleStatus = 10015007)
								OR (m.idfsSampleStatus IS NULL)
								)
							AND NOT EXISTS (
								SELECT t4.*
								FROM dbo.tlbTesting t4
								WHERE t4.idfMaterial = m.idfMaterial
									AND t4.idfsTestStatus IN (
										10001003,
										10001004
										)
									AND t4.intRowStatus = 0
								)
							)
						)
					);
		END;
		ELSE
		BEGIN
			SELECT COUNT(m.idfMaterial) AS RecordCount,
				IIF(SUM(CASE 
							WHEN m.blnAccessioned = 0
								AND m.idfsAccessionCondition IS NULL
								THEN 1
							ELSE 0
							END) IS NULL, 0, SUM(CASE 
							WHEN m.blnAccessioned = 0
								AND m.idfsAccessionCondition IS NULL
								THEN 1
							ELSE 0
							END)) AS UnaccessionedSampleCount
			FROM dbo.tlbMaterial m
			WHERE (
					(m.idfMaterial = @SampleID)
					OR (@SampleID IS NULL)
					)
				AND (
					(m.idfParentMaterial = @ParentSampleID)
					OR (@ParentSampleID IS NULL)
					)
				AND (m.intRowStatus = 0);
		END;
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode,
		@returnMsg;
END;
