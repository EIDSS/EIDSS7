

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_DeleteRunningApps
(
	@ClientID Nvarchar(50) 
   ,@Application Nvarchar(50)  
)
AS
BEGIN
	Set Nocount On;
	
	Delete from dbo.updRunningApps Where [strClientID] = @ClientID And [strApplication] = @Application
	
END

