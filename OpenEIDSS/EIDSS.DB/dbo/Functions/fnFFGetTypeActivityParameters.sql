

-- =============================================
-- Author:		Leonov E.N.
-- Create date: 
-- Description:
-- =============================================
Create Function dbo.fnFFGetTypeActivityParameters
(
	@idfsParameter Bigint
)
Returns Bigint
Begin
	Declare @Result Bigint, @idfsSection Bigint, @blnGrid Bit, @matrixType bigint

	select top 1 @matrixType = idfsMatrixType from dbo.trtMatrixType MT
				inner join dbo.ffParameter P On MT.idfsFormType = P.idfsFormType
				where P.idfsParameter = @idfsParameter;
				
	if (@matrixType is not null and @matrixType > 0) begin
		set @Result = @matrixType
	end else	 begin
		Select @idfsSection = P.[idfsSection], @blnGrid = [blnGrid] From dbo.ffParameter P
			Left Join dbo.ffSection S On P.idfsSection = S.idfsSection And (S.intRowStatus = 0)
			Where idfsParameter = @idfsParameter
						And (P.intRowStatus = 0);					
	
		 Select @Result = Case
				When (@idfsSection Is Null  or @blnGrid = 0) Then 0			
				When @blnGrid = 1 Then 1
			End;
	End;
	
	Return @Result
END

