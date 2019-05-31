
CREATE  PROCEDURE [dbo].[spCaseClassification_Post](
	@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
	,@idfsCaseClassification bigint
	,@CaseClassificationName nvarchar(200)
	,@CaseClassificationNameTranslated nvarchar(200)
	,@blnInitialHumanCaseClassification bit		
	,@blnFinalHumanCaseClassification bit		
	,@LangID Nvarchar(50) = Null
	,@intOrder int
	,@intHACode int
)
AS Begin

IF @Action = 4 Or @Action=16
BEGIN
	Exec dbo.spBaseReference_SysPost @idfsCaseClassification, 19000011, @LangID, @CaseClassificationName, @CaseClassificationNameTranslated, @intHACode, @intOrder
End

IF @Action = 4
BEGIN	
	IF ISNULL(@idfsCaseClassification,-1)<0
	BEGIN
		EXEC spsysGetNewID @idfsCaseClassification OUTPUT
	END
	
	INSERT INTO [dbo].[trtCaseClassification]
			   (
				 idfsCaseClassification
				,blnInitialHumanCaseClassification
				,blnFinalHumanCaseClassification
				)
	Values
		(
			@idfsCaseClassification, 
			@blnInitialHumanCaseClassification,
			@blnFinalHumanCaseClassification
		)

END
ELSE IF @Action=16
BEGIN	
	UPDATE dbo.[trtCaseClassification]
	SET 
		blnInitialHumanCaseClassification = @blnInitialHumanCaseClassification		
		,blnFinalHumanCaseClassification = @blnFinalHumanCaseClassification
	Where [idfsCaseClassification] = @idfsCaseClassification      
end Else If @Action = 8 Begin
	exec [dbo].[spCaseClassification_Delete] @idfsCaseClassification
End
End
