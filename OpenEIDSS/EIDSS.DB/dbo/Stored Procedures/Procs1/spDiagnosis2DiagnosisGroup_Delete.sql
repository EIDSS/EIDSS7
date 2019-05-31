
CREATE PROCEDURE [dbo].[spDiagnosis2DiagnosisGroup_Delete]
(
	@idfDiagnosisToDiagnosisGroup bigint
)
AS Begin
	Delete from dbo.trtDiagnosisToDiagnosisGroup Where [idfDiagnosisToDiagnosisGroup] = @idfDiagnosisToDiagnosisGroup
End
