
CREATE  PROCEDURE [dbo].[spDiagnosis2DiagnosisGroup_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfDiagnosisToDiagnosisGroup bigint
	,@idfsDiagnosisGroup bigint
	,@idfsDiagnosis bigint	
)
AS Begin

IF @Action = 4
BEGIN	
	IF ISNULL(@idfDiagnosisToDiagnosisGroup, -1)<0
	BEGIN
		EXEC spsysGetNewID @idfDiagnosisToDiagnosisGroup OUTPUT
	END
	
	INSERT INTO dbo.trtDiagnosisToDiagnosisGroup
			   (idfDiagnosisToDiagnosisGroup
				,idfsDiagnosisGroup
				,idfsDiagnosis)
	Values
		(@idfDiagnosisToDiagnosisGroup
		,@idfsDiagnosisGroup
		,@idfsDiagnosis)

END
ELSE IF @Action=16
BEGIN	
	UPDATE dbo.trtDiagnosisToDiagnosisGroup
	SET 
		[idfsDiagnosisGroup] = @idfsDiagnosisGroup
		,[idfsDiagnosis] = @idfsDiagnosis		
	Where [idfDiagnosisToDiagnosisGroup] = @idfDiagnosisToDiagnosisGroup      
end Else If @Action = 8 Begin
	exec [dbo].[spDiagnosis2DiagnosisGroup_Delete] @idfDiagnosisToDiagnosisGroup
End
End
