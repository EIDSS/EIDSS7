
-- ================================================================================================
-- Name: USP_LAB_TRANSFER_GETCount
--
-- Description:	Get laboratory transfer count for the various laboratory use cases.
--                      
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -------------------------------------------------------------------
-- Stephen Long     12/19/2018 Initial release.
-- Stephen Long     01/25/2019 Removed preceeding ; on CATCH and corrected intRowStatus on the 
--                             where clause to use sample instead of testing table.
-- Stephen Long     02/21/2019 Added organization ID parameter.
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_LAB_TRANSFER_GETCount] (@LanguageID NVARCHAR(50), @SampleID BIGINT = NULL, @OrganizationID BIGINT = NULL)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY
		SET NOCOUNT ON;

		SELECT DISTINCT COUNT(*) AS RecordCount
		FROM dbo.tlbMaterial m
		INNER JOIN dbo.tlbTransferOutMaterial AS tom
			ON tom.idfMaterial = m.idfMaterial
				AND tom.intRowStatus = 0
		INNER JOIN dbo.tlbTransferOUT AS tr
			ON tr.idfTransferOut = tom.idfTransferOut
				AND tr.intRowStatus = 0
		LEFT JOIN dbo.tlbTesting AS t
			ON t.idfMaterial = m.idfMaterial
		WHERE ((tr.idfSendFromOffice = @OrganizationID OR tr.idfSendToOffice = @OrganizationID) OR (@OrganizationID IS NULL)) 
			AND ((m.idfMaterial = @SampleID)
				OR (@SampleID IS NULL)
				)
			AND (tr.idfsTransferStatus IN (10001002, 10001003, 10001006))
			AND (m.intRowStatus = 0);
	END TRY

	BEGIN CATCH
		THROW;
	END CATCH;

	SELECT @returnCode, @returnMsg;
END;