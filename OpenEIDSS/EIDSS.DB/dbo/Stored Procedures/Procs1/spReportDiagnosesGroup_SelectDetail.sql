
CREATE PROCEDURE [dbo].[spReportDiagnosesGroup_SelectDetail]
(
	@idfsReportDiagnosesGroup bigint
	,@LangID Nvarchar(50) = Null
)
AS
Begin

	Select
		BR.idfsReference as [idfsReportDiagnosesGroup]
		,BR.strDefault as [strName] 
		,BR.name as [strTranslatedName] 
		,DG.strCode as [Code]		
	From [dbo].[fnReference] (@LangID, 19000130) BR
	Inner Join [dbo].[trtReportDiagnosisGroup] DG On DG.idfsReportDiagnosisGroup = BR.idfsReference and DG.intRowStatus = 0
	Where (DG.idfsReportDiagnosisGroup = @idfsReportDiagnosesGroup or @idfsReportDiagnosesGroup = 0)
	Order by BR.intOrder asc
End
