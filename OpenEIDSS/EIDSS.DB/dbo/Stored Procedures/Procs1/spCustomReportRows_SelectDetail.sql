
CREATE PROCEDURE [dbo].[spCustomReportRows_SelectDetail]
(
	@idfReportRows bigint = null
	,@LangID Nvarchar(50) = Null
)
AS
Begin
	 Select
		RR.idfReportRows
		,RR.[idfsCustomReportType]
		,RefTypes.idfsReference as [idfsDiagnosisOrGroup]
		,RefTypes.name as [strDiagnosisOrGroup]
		,RR.[idfsDiagnosisOrReportDiagnosisGroup]
		,IsNull(RDG.name, Diagn.name) as [strDiagnosisOrReportDiagnosisGroup]
		,RR.[intRowOrder]      
		,RR.[idfsReportAdditionalText]
		,RR.[idfsICDReportAdditionalText]
		,Diagn.intHACode
		,D.idfsUsingType
		,UsingType.name As [strUsingType]
		,HACodeList.name As [strHACode]
		,ReportAdditionalText1.name as [strReportAdditionalText]
		,ReportAdditionalText2.name as [strICDReportAdditionalText]
	 From [dbo].[trtReportRows] RR
	 inner join trtBaseReference br
	 on br.idfsBaseReference = RR.idfsDiagnosisOrReportDiagnosisGroup
	 inner Join dbo.fnReference(@LangID, 19000076) RefTypes On br.idfsReferenceType = RefTypes.idfsReference
	 Left join dbo.fnAccessoryCode(@LangID) HACodeList on br.intHACode = HACodeList.intHACode

	 Left Join dbo.fnReferenceRepair(@LangID, 19000019) Diagn 
	  inner Join dbo.trtDiagnosis D On Diagn.idfsReference = D.idfsDiagnosis
	  inner join dbo.fnReference(@LangID, 19000020) UsingType On D.idfsUsingType = UsingType.idfsReference
	 On RR.[idfsDiagnosisOrReportDiagnosisGroup] = Diagn.idfsReference
 
	 Left Join dbo.fnReference(@LangID, 19000130) RDG On RR.[idfsDiagnosisOrReportDiagnosisGroup] = RDG.idfsReference

	 Left join dbo.fnReference(@LangID, 19000132) ReportAdditionalText1 On RR.[idfsReportAdditionalText] = ReportAdditionalText1.idfsReference
	 Left join dbo.fnReference(@LangID, 19000132) ReportAdditionalText2 On RR.[idfsICDReportAdditionalText] = ReportAdditionalText2.idfsReference

	 Where
	  RR.intRowStatus = 0
	  and (Diagn.idfsReference is not null or RDG.idfsReference is not null)
	 Order by RR.intRowOrder ASC, RR.[idfsCustomReportType], RR.[idfsDiagnosisOrReportDiagnosisGroup], Diagn.name, RDG.name
End
