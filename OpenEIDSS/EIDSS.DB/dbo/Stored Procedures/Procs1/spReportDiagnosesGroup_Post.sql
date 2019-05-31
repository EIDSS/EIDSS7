
CREATE  PROCEDURE [dbo].[spReportDiagnosesGroup_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfsReportDiagnosesGroup bigint	
	,@strName nvarchar(4000) 
	,@strTranslatedName nvarchar(4000)  
	,@Code nvarchar(400)	
	,@LangID Nvarchar(50) = Null
	,@intOrder int = null
)
AS Begin

IF @Action = 4 Or @Action=16
BEGIN
	Exec dbo.spBaseReference_SysPost @idfsReportDiagnosesGroup, 19000130, @LangID, @strName, @strTranslatedName, @intOrder
End

IF @Action = 4
BEGIN	
	IF ISNULL(@idfsReportDiagnosesGroup,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfsReportDiagnosesGroup OUTPUT
	END
	
	INSERT INTO dbo.[trtReportDiagnosisGroup]
			   (
				idfsReportDiagnosisGroup
				,strCode
				)
	Values
		(
		@idfsReportDiagnosesGroup
		,@Code 
		)

END
Else if @Action = 8 begin
	exec [dbo].[spReportDiagnosesGroup_Delete] @idfsReportDiagnosesGroup
End
ELSE IF @Action=16
BEGIN	
	UPDATE dbo.[trtReportDiagnosisGroup]
	SET 
		strCode = @Code		
	Where [idfsReportDiagnosisGroup] = @idfsReportDiagnosesGroup      
End
End
