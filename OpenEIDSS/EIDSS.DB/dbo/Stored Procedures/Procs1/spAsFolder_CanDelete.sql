
--##SUMMARY Checks if Folder object can be deleted.

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.07.2015

--##RETURNS 0 if Folder can't be deleted 
--##RETURNS 1 if Folder can be deleted 

/*
Example of procedure call:

DECLARE @ID bigint
DECLARE @Result BIT

set @ID = 9710000870 --9670000870
EXEC spAsFolder_CanDelete @ID, @Result OUTPUT

Print @Result

*/


create PROCEDURE [dbo].[spAsFolder_CanDelete]
	@ID AS BIGINT --##PARAM @ID - Layout ID
	, @Result AS BIT OUTPUT --##PARAM  @Result - 0 if Folder can't be deleted, 1 in other case
AS

SET @Result = 1

declare @FolderTree table
	(	idflLayoutFolder bigint not null primary key, 
		idflParentLayoutFolder bigint
	)


;with FolderTree(idflLayoutFolder, idflParentLayoutFolder) as(
	select	tlf.idflLayoutFolder
			,tlf.idflParentLayoutFolder

	from	tasLayoutFolder tlf 
	where	tlf.idflLayoutFolder = @ID
	union all
	select	tlf.idflLayoutFolder
			,tlf.idflParentLayoutFolder
	from	tasLayoutFolder tlf 
			join FolderTree ft on ft.idflLayoutFolder = tlf.idflParentLayoutFolder
)

insert into @FolderTree (idflLayoutFolder, idflParentLayoutFolder)
select idflLayoutFolder, idflParentLayoutFolder
from FolderTree


if exists (select top 1 1
				 from @FolderTree ft
					inner join tasLayout tl
					on tl.idflLayoutFolder = ft.idflLayoutFolder
)
begin
	set @Result = 0
end
	


RETURN @Result
