

--##SUMMARY unpublish folder analytical module

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:
begin tran 

declare @idfsFolder bigint
set @idfsFolder = 51734430000000
EXEC	[spAsFolderUnpublish] 	@idfsFolder

IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO

*/ 

create PROCEDURE [dbo].[spAsFolderUnpublish]
	@idfsLayoutFolder		bigint
	,@idflLayoutFolder		bigint output
AS
BEGIN

	if	not exists	(	
					select	*
					from	tasglLayoutFolder
					where	idfsLayoutFolder = @idfsLayoutFolder
					)
	begin
		Raiserror (N'Global Folder with ID=%I64d doesn''t exist.', 15, 1,  @idfsLayoutFolder)
		return 1
	end

	begin try
	
		-- unpublish child folders
		declare @idfsChildFolder bigint
		declare @idflChildFolder bigint
		
		declare cur_folders cursor forward_only read_only local for
		select tlf.idfsLayoutFolder
		from tasglLayoutFolder tlf
		where tlf.idfsParentLayoutFolder = @idfsLayoutFolder
		
		open cur_folders
		
		fetch next from cur_folders into @idfsChildFolder
		
		while @@FETCH_STATUS  = 0
		begin
			exec [dbo].[spAsFolderUnpublish] @idfsChildFolder,  @idflChildFolder out
			fetch next from cur_folders into @idfsChildFolder
		end
		
		close cur_folders
		deallocate cur_folders
		
		
		-- unpublish layouts
		declare @idfsLayout bigint
		declare @idflLayout bigint
		declare cur_layouts cursor forward_only read_only local for
		select tl.idfsLayout
		from tasglLayout tl
		where tl.idfsLayoutFolder = @idfsLayoutFolder
		
		open cur_layouts
		
		fetch next from cur_layouts into @idfsLayout
		
		while @@FETCH_STATUS = 0  
		begin
			exec [dbo].[spAsLayoutUnpublish] @idfsLayout, @idflLayout out
			fetch next from cur_layouts into @idfsLayout
		end
		
		close cur_layouts
		deallocate cur_layouts
		
		-- update base reference
		update br_lf
			set intRowStatus = 1
		from		tasglLayoutFolder lf
		inner join	trtBaseReference br_lf
		on			br_lf.idfsBaseReference = lf.idfsLayoutFolder
					and br_lf.idfsReferenceType = 19000123	-- AVR Folder Name
		where		lf.idfsLayoutFolder = @idfsLayoutFolder
						
		update snt
			set intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000123	-- AVR Folder Name
		inner join tasglLayoutFolder lf
		on	lf.idfsLayoutFolder = br.idfsBaseReference				
		where	lf.idfsLayoutFolder = @idfsLayoutFolder		
				
		-- update local folder
		select top 1 @idflLayoutFolder = idflLayoutFolder
		from tasLayoutFolder
		where idfsGlobalLayoutFolder = @idfsLayoutFolder

		update tasLayoutFolder
		set
			idfsGlobalLayoutFolder = null,
			blnReadOnly = 0
		where idfsGlobalLayoutFolder = @idfsLayoutFolder		
				
		-- delete global folder		
		delete from tasglLayoutFolder where idfsLayoutFolder = @idfsLayoutFolder
		
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while unpublishing folder object: %s', 15, 1, @error)
		return 1
	end catch


	return 0		
end	

