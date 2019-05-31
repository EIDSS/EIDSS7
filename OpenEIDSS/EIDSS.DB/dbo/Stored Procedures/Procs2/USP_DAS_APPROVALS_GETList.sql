
-- ================================================================================================
-- Name: USP_DAS_APPROVALS_GETList
--
-- Description: Returns a list of accessioned samples and test that need to destroyed or deleted 
-- or tests that need to be validated

-- Author: Ricky Moss
-- 
-- Revision History:
-- Name                  Date       Change Detail
-- --------------------- ---------- --------------------------------------------------------------
-- Ricky Moss            11/27/2018 Initial release
-- Ricky Moss            11/30/2018	Remove reference type id variables
-- Ricyk Moss            12/30/2018	Rename fields to fit standards and consistency
-- Stephen Long          02/25/2019 Modified selects to be in sync with the use case.
--
-- Testing Code:
-- exec USP_DAS_APPROVALS_GETList 'en', 1100
-- ================================================================================================
CREATE PROCEDURE [dbo].[USP_DAS_APPROVALS_GETList]
(
	@LanguageID NVARCHAR(50),
	@SiteID BIGINT
)
AS
BEGIN
    DECLARE @returnCode				INT = 0;
    DECLARE @returnMsg				NVARCHAR(MAX) = 'SUCCESS';

	BEGIN TRY		
		SELECT 'Samples to be destroyed' AS Approval, 
			COUNT(m.idfsSampleStatus) AS NumberOfRecords, 
			'~/Laboratory/Laboratory.aspx?Tab=Approvals&ActionRequested=38' AS [Action]
		FROM dbo.tlbMaterial m
			WHERE m.idfsSampleStatus = 10015003 AND m.intRowStatus = 0 AND m.idfsCurrentSite = @SiteID
		UNION

		SELECT 'Records to be deleted' AS Approval, 
		(
			(SELECT COUNT(m.idfMaterial) FROM dbo.tlbMaterial m WHERE m.idfsSampleStatus = 10015002 AND m.intRowStatus = 0 AND m.idfsCurrentSite = @SiteID) + 
			(SELECT COUNT(t.idfTesting) FROM dbo.tlbTesting t INNER JOIN dbo.tlbMaterial AS m ON m.idfMaterial = t.idfMaterial WHERE t.idfsTestStatus = 10001007 AND t.intRowStatus = 0 AND m.idfsCurrentSite = @SiteID)
		) AS NumberOfRecords,
		'~/Laboratory/Laboratory.aspx?Tab=Approvals&ActionRequested=39' AS [Action] 

		UNION

		SELECT 'Test Results to be validated' AS Approval, 
		(SELECT COUNT(t.idfTesting) FROM dbo.tlbTesting t INNER JOIN dbo.tlbMaterial AS m ON m.idfMaterial = t.idfMaterial WHERE t.idfsTestStatus = 10001004 AND t.intRowStatus = 0 AND m.idfsCurrentSite = @SiteID) AS NumberOfRecords,
		'~/Laboratory/Laboratory.aspx?Tab=Approvals&ActionRequested=40' AS [Action];

	END TRY
	BEGIN CATCH
		THROW;
	END CATCH

	SELECT @returnCode, @returnMsg;
END