
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroup_SelectDetail]
(
	@idfsDiagnosisAgeGroup bigint
	,@LangID Nvarchar(50) = Null
)
AS
Begin
	Select 
		DAG.[idfsDiagnosisAgeGroup]
		,DAGName.strDefault as [DiagnosisAgeGroupName]
		,ISNULL(DAGName.name, DAGName.strDefault) as [DiagnosisAgeGroupNameTranslated]
		,ISNULL(DAGName.intOrder, 0) As [intOrder]
		,DAG.[intLowerBoundary]
		,DAG.[intUpperBoundary]
		,DAG.[idfsAgeType]
		,ISNULL(AgeTypeName.name, AgeTypeName.strDefault) as [AgeTypeName]
	From [dbo].[trtDiagnosisAgeGroup] DAG
	Inner Join dbo.fnReference(@LangID, 19000146) DAGName On DAG.idfsDiagnosisAgeGroup = DAGName.idfsReference
	Inner Join dbo.fnReference(@LangID, 19000042) AgeTypeName On DAG.idfsAgeType = AgeTypeName.idfsReference
	LEFT JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = DAG.idfsDiagnosisAgeGroup
		AND tbr.idfsReferenceType = 19000146
		AND (
				tbr.blnSystem = 1 
				AND (ISNULL(tbr.strBaseReferenceCode, '') LIKE '%CDCAgeGroup%' OR ISNULL(tbr.strBaseReferenceCode, '') LIKE '%WHOAgeGroup%')
			)
		AND tbr.intRowStatus = 0
	Where (DAG.idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup or @idfsDiagnosisAgeGroup = 0) and DAG.intRowStatus = 0
		AND tbr.idfsBaseReference IS NULL
	Order by DAGName.intOrder
End
