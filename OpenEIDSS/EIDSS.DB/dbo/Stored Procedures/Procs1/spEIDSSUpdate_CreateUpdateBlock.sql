

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_CreateUpdateBlock
(
	@ClientID Nvarchar(50)
	,@Application Nvarchar(50)  
	,@WithDatabaseUpdate Bit
)
AS
BEGIN
	Set Nocount On;
	
	Declare @CanUpdate Bit
	
	Exec dbo.spEIDSSUpdate_CanUpdateBlock @CanUpdate Output
	
	If (@CanUpdate = 0) Return;
	
	Insert into dbo.updUpdateBlock (strClientID, [strApplication], [blnWithDatabaseUpdate], datDateStarted) Values(@ClientID, @Application, @WithDatabaseUpdate, Getdate())
	
END

