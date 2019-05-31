

--##SUMMARY delete folders for layouts in analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.05.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:


EXEC	[dbo].[spAsFolderDelete]	9110000002
*/

CREATE PROCEDURE [dbo].[spAsFolderDelete]
@idflFolder				bigint
AS
BEGIN

-- update reference to this folder

update  dbo.tasLayoutFolder
set		idflParentLayoutFolder = null
where	idflParentLayoutFolder = @idflFolder


update  dbo.tasLayout
set		idflLayoutFolder = null
where	idflLayoutFolder = @idflFolder

-- deleting from folder table
delete
from	dbo.tasLayoutFolder
where	idflLayoutFolder = @idflFolder

-- deleting references
exec dbo.spAsReferenceDelete  @idflFolder


return 0
END

