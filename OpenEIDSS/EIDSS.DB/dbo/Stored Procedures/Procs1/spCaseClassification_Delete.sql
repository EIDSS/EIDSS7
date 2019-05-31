
CREATE PROCEDURE [dbo].[spCaseClassification_Delete]
(
	@idfsCaseClassification bigint
)
AS Begin
	Delete from dbo.[trtCaseClassification] Where [idfsCaseClassification] = @idfsCaseClassification	
	exec dbo.spsysBaseReference_Delete @idfsCaseClassification

End
