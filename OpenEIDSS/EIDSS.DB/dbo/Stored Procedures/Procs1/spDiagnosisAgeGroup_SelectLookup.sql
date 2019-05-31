
CREATE PROCEDURE dbo.spDiagnosisAgeGroup_SelectLookup
(
	@LangID As nvarchar(50) --##PARAM @LangID - language ID	
)
AS
Begin
	Select 
		DAG.[idfsDiagnosisAgeGroup] as idfsReference
		,ISNULL(DAGName.name, DAGName.strDefault) as [name]
		,DAG.intRowStatus		
	From [dbo].[trtDiagnosisAgeGroup] DAG
	Inner Join dbo.fnReferenceRepair(@LangID, 19000146) DAGName On DAG.idfsDiagnosisAgeGroup = DAGName.idfsReference
	LEFT JOIN trtBaseReference tbr ON
		tbr.idfsBaseReference = DAG.idfsDiagnosisAgeGroup
		AND tbr.idfsReferenceType = 19000146
		AND (
				tbr.blnSystem = 1 
				AND (ISNULL(tbr.strBaseReferenceCode, '') LIKE '%CDCAgeGroup%' OR ISNULL(tbr.strBaseReferenceCode, '') LIKE '%WHOAgeGroup%')
			)
	Where tbr.idfsBaseReference IS NULL
	Order by DAGName.intOrder
end 
