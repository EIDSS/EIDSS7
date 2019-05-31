-- ============================================================================
-- Name: USP_REF_CaseClassification_GETList
-- Description:	Get the Case Classification for reference listings.
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date		Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/25/2018	Initial release.
-- Ricky Moss		12/19/2018	Removed return codes
-- exec USP_REF_CASECLASSIFICATION_GETList 'en'
-- ============================================================================
CREATE PROCEDURE [dbo].[USP_REF_CASECLASSIFICATION_GETList]
(
	@LangID NVARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SELECT 
			CC.[idfsCaseClassification] 
			,CCName.strDefault AS [strDefault]
			,ISNULL(CCName.name, CCName.strDefault) AS [strName]
			,ISNULL(CCName.intOrder, 0) AS [intOrder]
			,ISNULL(CC.[blnInitialHumanCaseClassification], CAST(0 AS BIT)) AS blnInitialHumanCaseClassification
			,ISNULL(CC.[blnFinalHumanCaseClassification], CAST(0 AS BIT)) AS blnFinalHumanCaseClassification
			,CCName.intHACode
			,dbo.FN_GBL_HACode_ToCSV(@LangID, CCName.[intHACode]) AS [strHACode]
			,dbo.FN_GBL_HACodeNames_ToCSV(@LangID, CCName.[intHACode]) AS [strHACodeNames]
		FROM [dbo].[trtCaseClassification] CC
		INNER Join dbo.FN_GBL_ReferenceRepair('en', 19000011) CCName ON CC.[idfsCaseClassification] = CCName.idfsReference
		LEFT JOIN dbo.trtHACodeList HACodeList ON CCName.intHACode = HACodeList.intHACode
		LEFT JOIN dbo.FN_GBL_ReferenceRepair('en', 19000040) HACodes ON HACodeList.idfsCodeName = HACodes.idfsReference
		Where CC.intRowStatus = 0
		Order by CCName.intOrder, strDefault
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
