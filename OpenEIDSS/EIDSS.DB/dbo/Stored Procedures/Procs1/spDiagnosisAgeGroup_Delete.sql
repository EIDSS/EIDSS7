
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroup_Delete]
(
	@idfsDiagnosisAgeGroup bigint
)
AS Begin
	Delete from dbo.trtDiagnosisAgeGroup Where [idfsDiagnosisAgeGroup] = @idfsDiagnosisAgeGroup	
	exec dbo.spsysBaseReference_Delete @idfsDiagnosisAgeGroup
End
