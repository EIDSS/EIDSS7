

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_CreateRunningApps
(
	@ClientID Nvarchar(50) 
   ,@Application Nvarchar(50)
)
AS
BEGIN
	Set Nocount On;
	
	If Exists (Select Top 1 1 From dbo.updRunningApps Where [strClientID] = @ClientID And [strApplication] = @Application)
		Update dbo.updRunningApps Set [datDateLastUpdate] = Getdate() Where [strClientID] = @ClientID And [strApplication] = @Application
	Else
		Insert into dbo.updRunningApps (strClientID, [strApplication], [datDateLastUpdate]) Values(@ClientID, @Application, Getdate())
	
END

