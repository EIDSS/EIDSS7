

--##SUMMARY change layout parent folder

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.06.2010

--##RETURNS Don't use

/*

--Example of a call of procedure:

EXEC	[dbo].[spAsLayoutParentPost]
		 @idflLayout			= 151440000000			
		,@idflLayoutFolder		= null		

*/ 

CREATE PROCEDURE [dbo].[spAsLayoutParentPost]
	 @idflLayout				bigint
	,@idflFolder			bigint
	
AS
BEGIN
	
	update	tasLayout
	   set 	idflLayoutFolder = @idflFolder
	where	idflLayout = @idflLayout

	return 0
END

