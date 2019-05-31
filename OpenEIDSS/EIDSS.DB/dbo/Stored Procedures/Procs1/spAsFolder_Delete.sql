

--##SUMMARY delete folders for layouts in analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.05.2010

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 22.07.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:

select tlf.idflLayoutFolder, lsnt.strTextString from tasLayoutFolder tlf
inner join locBaseReference lbr
on lbr.idflBaseReference = tlf.idflLayoutFolder

inner join locStringNameTranslation lsnt
on lsnt.idflBaseReference = lbr.idflBaseReference

where lsnt.strTextString like 'F%'

begin tran

EXEC	[dbo].[spAsFolderDelete]	9710000870

select tlf.idflLayoutFolder, lsnt.strTextString from tasLayoutFolder tlf
inner join locBaseReference lbr
on lbr.idflBaseReference = tlf.idflLayoutFolder

inner join locStringNameTranslation lsnt
on lsnt.idflBaseReference = lbr.idflBaseReference

where lsnt.strTextString like 'F%'



rollback tran

*/


create PROCEDURE [dbo].[spAsFolder_Delete]
@idflFolder				bigint
AS
BEGIN



--deleting layouts from Folders tree
declare @FolderTree table
	(	idflLayoutFolder bigint not null primary key, 
		idflParentLayoutFolder bigint
	)


;with FolderTree(idflLayoutFolder, idflParentLayoutFolder) as(
	select	tlf.idflLayoutFolder
			,tlf.idflParentLayoutFolder

	from	tasLayoutFolder tlf 
	where	tlf.idflLayoutFolder = @idflFolder
	union all
	select	tlf.idflLayoutFolder
			,tlf.idflParentLayoutFolder
	from	tasLayoutFolder tlf 
			join FolderTree ft on ft.idflLayoutFolder = tlf.idflParentLayoutFolder
)

insert into @FolderTree (idflLayoutFolder, idflParentLayoutFolder)
select idflLayoutFolder, idflParentLayoutFolder
from FolderTree


declare @idflLayout bigint

declare LCur cursor local forward_only for
select tl.idflLayout
from @FolderTree ft
	inner join tasLayout tl
	on tl.idflLayoutFolder = ft.idflLayoutFolder
	
open LCur

fetch next from LCur into @idflLayout
while @@FETCH_STATUS = 0
begin
	exec spAsLayout_Delete	@idflLayout
	fetch next from LCur into @idflLayout
end

close LCur
deallocate LCur	


-- deleting Folders tree
delete lf
from	dbo.tasLayoutFolder lf
	inner join @FolderTree ft
	on ft.idflLayoutFolder = lf.idflLayoutFolder


-- deleting references for Folders tree


declare BRCur cursor local forward_only for
select ft.idflLayoutFolder
from @FolderTree ft

open BRCur

fetch next from BRCur into @idflFolder
while @@FETCH_STATUS = 0
begin
	exec dbo.spAsReferenceDelete  @idflFolder
	fetch next from BRCur into @idflFolder
end

close BRCur
deallocate BRCur	




return 0
END

