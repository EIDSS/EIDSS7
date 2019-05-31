
CREATE PROCEDURE [dbo].[spReportDiagnosesGroup2Diagnosis_Delete]
(
	@idfDiagnosisToGroupForReportType bigint	
)
AS Begin
	Delete from [dbo].[trtDiagnosisToGroupForReportType] 
		Where idfDiagnosisToGroupForReportType = @idfDiagnosisToGroupForReportType			
End
