

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_CanUpdateBlock
(
	@Result Bit output
)
AS
BEGIN
	Set Nocount On;
	
	Set @Result = 0
	
	-- если блокировка по апдейту висит дольше 1 часа, то считаем её мертвой и удаляем
	
	Declare @hourCount Int
	Set @hourCount = 1;
	
	Declare @deadLineDate Datetime
	Select  @deadLineDate = Dateadd(hour,  -@hourCount, Getdate())
	Delete from dbo.updUpdateBlock Where [datDateStarted] < @deadLineDate

	
	If Exists (Select Top 1 1 From dbo.updUpdateBlock)
		Set @Result = 0
	Else
		Set @Result = 1	
	
	Return @Result
		
END

