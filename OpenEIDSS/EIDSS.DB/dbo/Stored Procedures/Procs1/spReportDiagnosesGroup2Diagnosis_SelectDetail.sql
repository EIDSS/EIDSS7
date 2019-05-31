
CREATE PROCEDURE [dbo].[spReportDiagnosesGroup2Diagnosis_SelectDetail]
(
	@idfDiagnosisToGroupForReportType bigint = null
	,@LangID Nvarchar(50) = Null
)
AS
Begin
	Select
		idfDiagnosisToGroupForReportType
		,DRT.[idfsCustomReportType]
		,SRT.name as [strSummaryReportType]
		,DRT.[idfsReportDiagnosisGroup]
		,RDG.name as [strReportDiagnosisGroup]
		,DRT.[idfsDiagnosis]
		,Diagn.name as [strDiagnosis]
		,Diagn.intHACode
		,D.idfsUsingType
		,UsingType.name As [strUsingType]
		,REPLACE (
			REPLACE(
					(
						SELECT
							HACodes.name + ', '  AS 'data()'
						FROM dbo.trtHACodeList HACodeList
						Inner Join dbo.fnReferenceRepair(@LangID, 19000040) HACodes On HACodeList.idfsCodeName = HACodes.idfsReference
						WHERE (Diagn.intHACode & HACodeList.intHACode = HACodeList.intHACode) 
							AND HACodeList.intHACode > 0
						ORDER BY HACodes.name
						FOR XML PATH ( '')
					) + '%'
				, ', %', '') 
			, '&amp;', 'and') As [strHACode]
		,YNU.idfsReference as [intIsDeleted]
		,YNU.name as [strIsDeleted]
	From [dbo].[trtDiagnosisToGroupForReportType] DRT
	Inner join dbo.fnReference(@LangID, 19000129) SRT On DRT.[idfsCustomReportType] = SRT.idfsReference
	Inner join dbo.fnReference(@LangID, 19000130) RDG On DRT.[idfsReportDiagnosisGroup] = RDG.idfsReference
	Inner join dbo.fnReferenceRepair(@LangID, 19000019) Diagn On DRT.idfsDiagnosis = Diagn.idfsReference
	Inner join dbo.trtDiagnosis D on DRT.idfsDiagnosis = D.idfsDiagnosis	
	Inner join dbo.fnReference(@LangID, 19000020) UsingType On D.idfsUsingType = UsingType.idfsReference
	Inner join dbo.fnReference(@LangID, 19000100) YNU On (case when Diagn.intRowStatus = 0 then 10100002 else 10100001 end) = YNU.idfsReference
	Order by DRT.[idfsCustomReportType], DRT.[idfsReportDiagnosisGroup], Diagn.name
End
