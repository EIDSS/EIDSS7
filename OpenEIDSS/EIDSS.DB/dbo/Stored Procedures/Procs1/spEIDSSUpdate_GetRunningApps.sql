

-- =============================================
-- Author:		Leonov E.N.
-- Create date:
-- Description:
-- =============================================
Create Procedure dbo.spEIDSSUpdate_GetRunningApps
AS
BEGIN
	Set Nocount On;
	
	-- очистим аварийно завершившиеся приложения
	Exec dbo.spEIDSSUpdate_RemoveApplications
	
	-- TODO переделать правильно
	Select [strClientID]
				,[strApplication]
				,[datDateLastUpdate]
	From dbo.updRunningApps
	Where [strApplication] <> 'ns'
	
END

