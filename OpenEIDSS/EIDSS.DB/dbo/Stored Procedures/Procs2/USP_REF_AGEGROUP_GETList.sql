
-- ============================================================================
-- Name: USP_REF_AGE_GROUP_GETList
-- Description:	Returns are
--                      
-- Author: Ricky Moss
-- Revision History:
-- Name             Date       Change Detail
-- ---------------- ---------- -----------------------------------------------
-- Ricky Moss		09/25/2018	Initial release.
-- Ricky Moss		10/03/2018	Update field name from idfsDiagnosisAgeGroup to idfsAgeGroup
-- Ricky Moss		12/19/2018	Removed returns codes and id variables
--
-- EXEC USP_REF_AGEGROUP_GETList 'ar'
-- ============================================================================

CREATE PROCEDURE [dbo].[USP_REF_AGEGROUP_GETList]
(
	@LangID NVARCHAR(50) = NULL
)
AS
BEGIN
	BEGIN TRY
		SELECT 
			DAG.[idfsDiagnosisAgeGroup] AS idfsAgeGroup
			,DAGName.strDefault AS [strDefault]
			,ISNULL(DAGName.[name], DAGName.strDefault) AS [strName]
			,ISNULL(DAGName.intOrder, 0) AS [intOrder]
			,DAG.[intLowerBoundary]
			,DAG.[intUpperBoundary]
			,DAG.[idfsAgeType]
			,ISNULL(AgeTypeName.[name], AgeTypeName.strDefault) AS [AgeTypeName]
		FROM [dbo].[trtDiagnosisAgeGroup] DAG
		INNER Join dbo.FN_GBL_Reference_GETList(@LangID, 19000146) DAGName ON DAG.idfsDiagnosisAgeGroup = DAGName.idfsReference
		INNER Join dbo.FN_GBL_Reference_GETList(@LangID, 19000042) AgeTypeName ON DAG.idfsAgeType = AgeTypeName.idfsReference
		LEFT JOIN trtBaseReference tbr ON
			tbr.idfsBaseReference = DAG.idfsDiagnosisAgeGroup
			AND tbr.idfsReferenceType = 19000146
			AND (
					tbr.blnSystem = 1 
					AND (ISNULL(tbr.strBaseReferenceCode, '') LIKE '%CDCAgeGroup%' OR ISNULL(tbr.strBaseReferenceCode, '') LIKE '%WHOAgeGroup%')
				)
			AND tbr.intRowStatus = 0
		WHERE DAG.intRowStatus = 0
			AND tbr.idfsBaseReference IS NULL
		ORDER BY DAGName.intOrder
	END TRY
	BEGIN CATCH
		THROW;
	END CATCH
END
