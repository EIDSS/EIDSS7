
CREATE PROCEDURE [dbo].[spDiagnosisAgeGroupToDiagnosis_Post]
(
	@Action int  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfDiagnosisAgeGroupToDiagnosis bigint
    ,@idfsDiagnosis bigint
    ,@idfsDiagnosisAgeGroup bigint
)
AS
Begin
IF @Action = 4
BEGIN
	IF (ISNULL(@idfDiagnosisAgeGroupToDiagnosis, -1) < 0) EXEC spsysGetNewID @idfDiagnosisAgeGroupToDiagnosis OUTPUT

	Insert into dbo.trtDiagnosisAgeGroupToDiagnosis	
	(
		idfDiagnosisAgeGroupToDiagnosis 
		,idfsDiagnosis
		,idfsDiagnosisAgeGroup
	)
	Values
	(
		@idfDiagnosisAgeGroupToDiagnosis
		,@idfsDiagnosis
		,@idfsDiagnosisAgeGroup
	)	
END

IF @Action = 8
BEGIN
	Delete from dbo.trtDiagnosisAgeGroupToDiagnosis where idfDiagnosisAgeGroupToDiagnosis = @idfDiagnosisAgeGroupToDiagnosis
END

IF @Action = 16
BEGIN
	Update dbo.trtDiagnosisAgeGroupToDiagnosis
	Set 
		idfsDiagnosis = @idfsDiagnosis
		,idfsDiagnosisAgeGroup = @idfsDiagnosisAgeGroup
	Where 
		idfDiagnosisAgeGroupToDiagnosis = @idfDiagnosisAgeGroupToDiagnosis
END
	
End
