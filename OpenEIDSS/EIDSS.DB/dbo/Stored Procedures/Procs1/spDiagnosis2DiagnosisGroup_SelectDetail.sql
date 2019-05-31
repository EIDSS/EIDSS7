
CREATE PROCEDURE [dbo].[spDiagnosis2DiagnosisGroup_SelectDetail]
(
	@idfDiagnosisToDiagnosisGroup bigint
	,@LangID Nvarchar(50) = Null
)
AS
Begin
	Select
		DDG.idfDiagnosisToDiagnosisGroup
		,DDG.idfsDiagnosisGroup
		,DDGName.strDefault as [DiagnosisGroupName]
		,ISNULL(DDGName.name, DDGName.strDefault) as [DiagnosisGroupNameTranslated]
		,DDG.idfsDiagnosis
		,DiagnosisName.strDefault as [DiagnosisName]
		,ISNULL(DiagnosisName.name, DiagnosisName.strDefault) as [DiagnosisNameTranslated]
		,D.idfsUsingType
		,DDGName.intHACode
		,DDGName.intOrder
		, UsingType.name As [strUsingType]
		, HACodeList.name As [strHACode]		
	From [dbo].[trtDiagnosisToDiagnosisGroup] DDG
	Inner Join dbo.fnReferenceRepair(@LangID, 19000156) DDGName On DDG.idfsDiagnosisGroup = DDGName.idfsReference
	Inner Join dbo.trtDiagnosis D On DDG.idfsDiagnosis = D.idfsDiagnosis
	Inner Join dbo.fnReferenceRepair(@LangID, 19000019) DiagnosisName On DDG.idfsDiagnosis = DiagnosisName.idfsReference
	Left join dbo.fnAccessoryCode(@LangID) HACodeList on DiagnosisName.intHACode = HACodeList.intHACode
	Inner Join dbo.fnReferenceRepair(@LangID, 19000020) UsingType On D.idfsUsingType = UsingType.idfsReference
	Where (DDG.idfDiagnosisToDiagnosisGroup = @idfDiagnosisToDiagnosisGroup or @idfDiagnosisToDiagnosisGroup = 0 Or @idfDiagnosisToDiagnosisGroup Is null) and DDG.intRowStatus = 0
	Order by DDGName.intOrder 
End
