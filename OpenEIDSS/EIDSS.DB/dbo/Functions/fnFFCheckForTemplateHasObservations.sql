

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Function dbo.fnFFCheckForTemplateHasObservations
(
	@idfsFormTemplate BigInt	
)
Returns @ResultTable Table
(
		[Result]	Bit
)
As
BEGIN		
	Declare @Result bit
	-- если на шаблон завязаны какие-то данные, то удалять шаблон нельзя
	If Exists(Select Top 1 1 From dbo.tlbObservation Where idfsFormTemplate = @idfsFormTemplate And intRowStatus = 0)	Set @Result = 1 Else Set @Result = 0;
	
	If (@Result = 1) begin
		Insert into @ResultTable
			([Result])
		Values
			(@Result)
	End;
	
	Return;
End

