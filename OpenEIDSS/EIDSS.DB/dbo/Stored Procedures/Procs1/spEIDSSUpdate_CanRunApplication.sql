﻿

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_CanRunApplication
(
	@ClientID Nvarchar(50) 
    ,@Application Nvarchar(50)
	,@Result Bit output
)
AS
BEGIN
	Set Nocount On;
	
	Set @Result = 0
	
	-- приложение может быть запущено, если сейчас не идёт апдейт или идёт апдейт, не затрагивающий БД
	-- проверим наличие запущенного обновления	
	Exec dbo.spEIDSSUpdate_CanUpdateBlock @Result output
	
	If (@Result = 0) Begin
		Declare @WithDatabaseUpdate Bit
		Select Top 1 @WithDatabaseUpdate = [blnWithDatabaseUpdate] From dbo.[updUpdateBlock]
		If (@WithDatabaseUpdate = 0) Set @Result = 1
	End
		
	Return @Result
		
END

