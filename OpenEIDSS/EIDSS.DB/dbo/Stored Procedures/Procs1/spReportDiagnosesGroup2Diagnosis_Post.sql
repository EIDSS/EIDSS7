
CREATE  PROCEDURE [dbo].[spReportDiagnosesGroup2Diagnosis_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfDiagnosisToGroupForReportType bigint
	,@idfsCustomReportType bigint	
	,@idfsReportDiagnosisGroup bigint
	,@idfsDiagnosis bigint	
)
AS Begin

IF (@Action = 4)
BEGIN		
	INSERT INTO [dbo].[trtDiagnosisToGroupForReportType]
				(
				[idfDiagnosisToGroupForReportType]
				,[idfsCustomReportType]	
				,[idfsReportDiagnosisGroup]
				,[idfsDiagnosis]
				)
	Values
		(
		@idfDiagnosisToGroupForReportType
		,@idfsCustomReportType	
		,@idfsReportDiagnosisGroup
		,@idfsDiagnosis 
		)	
END
Else if @Action = 16 begin
	Update [dbo].[trtDiagnosisToGroupForReportType]
		Set [idfsCustomReportType]	= @idfsCustomReportType
			,[idfsReportDiagnosisGroup] = @idfsReportDiagnosisGroup
			,[idfsDiagnosis] = @idfsDiagnosis
		Where idfDiagnosisToGroupForReportType = @idfDiagnosisToGroupForReportType

end
Else if @Action = 8 begin
	exec [dbo].[spReportDiagnosesGroup2Diagnosis_Delete] @idfDiagnosisToGroupForReportType
End
End
