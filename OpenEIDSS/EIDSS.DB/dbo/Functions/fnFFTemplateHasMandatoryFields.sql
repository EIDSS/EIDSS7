

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFTemplateHasMandatoryFields
(
	@idfsFormTemplate BigInt	
)
RETURNS @ResultTable Table
(
		[Result] Bit
)
AS
BEGIN
	
	Declare @Result Bit
	Set @Result = 0
	
	If Exists(Select Top 1 1 From dbo.ffParameterForTemplate Where idfsEditMode = 10068003 And idfsFormTemplate = @idfsFormTemplate) Set @Result = 1
		
	Insert into @ResultTable([Result]) Values (@Result);	
	Return;
End

