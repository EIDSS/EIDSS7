
CREATE PROCEDURE [dbo].[spReportDiagnosesGroup_Delete]
(
	@idfsReportDiagnosisGroup bigint
)
AS Begin
	Delete from dbo.[trtReportDiagnosisGroup] Where idfsReportDiagnosisGroup = @idfsReportDiagnosisGroup
	exec dbo.spsysBaseReference_Delete @idfsReportDiagnosisGroup
End
