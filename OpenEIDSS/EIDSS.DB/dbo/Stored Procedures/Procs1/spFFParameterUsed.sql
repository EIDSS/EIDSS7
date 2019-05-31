

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:	
-- =============================================
CREATE PROCEDURE dbo.spFFParameterUsed
(	
	@idfsParameter Bigint	 	
)	
AS
BEGIN	
	Set Nocount On;

	Declare @Result Bit
	Set @Result = 0;
	
	If (Exists(Select Top 1 1 From dbo.ffParameterForTemplate Where [idfsParameter] = @idfsParameter And [intRowStatus] = 0)) Set @Result = 1;
	
	Select @Result As [idfsParameter]
End

