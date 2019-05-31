

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:	
-- =============================================
CREATE PROCEDURE dbo.spFFSectionUsed
(	
	@idfsSection Bigint	 	
)	
AS
BEGIN	
	Set Nocount On;

	Declare @Result Bit
	Set @Result = 0;
	
	If (Exists(Select Top 1 1 From dbo.ffSectionForTemplate Where [idfsSection] = @idfsSection And [intRowStatus] = 0)) Set @Result = 1;
	
	Select @Result As [idfsSection]
End

