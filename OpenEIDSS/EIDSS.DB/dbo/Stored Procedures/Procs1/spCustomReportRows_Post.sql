
CREATE  PROCEDURE [dbo].[spCustomReportRows_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfReportRows bigint
	,@idfsCustomReportType bigint		
	,@idfsDiagnosisOrReportDiagnosisGroup bigint
    ,@intRowOrder bigint
	,@idfsReportAdditionalText bigint
    ,@idfsICDReportAdditionalText bigint
)
AS Begin

IF (@Action = 4)
BEGIN		
	
	INSERT INTO [dbo].[trtReportRows]
				(
				[idfReportRows]
				,[idfsCustomReportType]	
				,[idfsDiagnosisOrReportDiagnosisGroup]
				,[intRowOrder]
				,[idfsReportAdditionalText]
				,[idfsICDReportAdditionalText]
				)
	Values
		(
		@idfReportRows
		,@idfsCustomReportType	
		,@idfsDiagnosisOrReportDiagnosisGroup
		,@intRowOrder
		,@idfsReportAdditionalText
		,@idfsICDReportAdditionalText 
		)
END
Else if @Action = 16 begin
	Update [dbo].[trtReportRows]
	Set [idfsCustomReportType]	= @idfsCustomReportType
		,[idfsDiagnosisOrReportDiagnosisGroup]=@idfsDiagnosisOrReportDiagnosisGroup
		,[intRowOrder]=@intRowOrder
		,[idfsReportAdditionalText]=@idfsReportAdditionalText
		,[idfsICDReportAdditionalText]=@idfsICDReportAdditionalText
	where idfReportRows = @idfReportRows
end
Else if @Action = 8 begin
	exec [dbo].[spCustomReportRows_Delete] @idfReportRows
End

End
