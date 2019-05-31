
CREATE  PROCEDURE [dbo].[spDiagnosisAgeGroup_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfsDiagnosisAgeGroup bigint
	,@DiagnosisAgeGroupName nvarchar(200)
	,@DiagnosisAgeGroupNameTranslated nvarchar(200)
	,@intLowerBoundary int
	,@intUpperBoundary int
	,@idfsAgeType bigint	
	,@LangID Nvarchar(50) = Null
	,@intOrder int
)
AS Begin

IF @Action = 4 Or @Action=16
BEGIN
	Exec dbo.spBaseReference_SysPost @idfsDiagnosisAgeGroup, 19000146, @LangID, @DiagnosisAgeGroupName, @DiagnosisAgeGroupNameTranslated, @intOrder
End

IF @Action = 4
BEGIN	
	IF ISNULL(@idfsDiagnosisAgeGroup,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfsDiagnosisAgeGroup OUTPUT
	END
	
	INSERT INTO dbo.trtDiagnosisAgeGroup
			   ([idfsDiagnosisAgeGroup]
				,[intLowerBoundary]
				,[intUpperBoundary]
				,[idfsAgeType])
	Values
		(@idfsDiagnosisAgeGroup, 
		@intLowerBoundary, 
		@intUpperBoundary, 
		@idfsAgeType)

END
ELSE IF @Action=16
BEGIN	
	UPDATE dbo.trtDiagnosisAgeGroup
	SET 
		[intLowerBoundary] = @intLowerBoundary
		,[intUpperBoundary] = @intUpperBoundary
		,[idfsAgeType] = @idfsAgeType
	Where [idfsDiagnosisAgeGroup] = @idfsDiagnosisAgeGroup      
end Else If @Action = 8 Begin
	exec [dbo].[spDiagnosisAgeGroup_Delete] @idfsDiagnosisAgeGroup
End
End
