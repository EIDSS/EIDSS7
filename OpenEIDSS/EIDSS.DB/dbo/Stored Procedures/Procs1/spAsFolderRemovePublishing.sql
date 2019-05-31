

--##SUMMARY unpublish folder for analytical module

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 02.12.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

declare @idflFolder bigint
EXEC	[spAsFolderRemovePublishing] 	@idflFolder

*/ 

create PROCEDURE [dbo].[spAsFolderRemovePublishing]
	@idfsLayoutFolder		bigint
	,@idflLayoutFolder		bigint output
AS
BEGIN

	begin try
	
		-- Remove Publishing for child folders
		declare @idfsChildFolder bigint
		declare @idflFolder bigint
		declare @idflLayout bigint
		declare cur_folders cursor forward_only read_only local for
		select tlf.idfsGlobalLayoutFolder
		from tasLayoutFolder tlf
			inner join tasLayoutFolder parent
			on parent.idflLayoutFolder = tlf.idflParentLayoutFolder
		where parent.idfsGlobalLayoutFolder = @idfsLayoutFolder
		
		open cur_folders
		
		fetch next from cur_folders into @idfsChildFolder
		
		while @@FETCH_STATUS  = 0
		begin
			exec [dbo].[spAsFolderRemovePublishing] @idfsChildFolder, @idflFolder out
			fetch next from cur_folders into @idfsChildFolder
		end
		
		close cur_folders
		deallocate cur_folders
		
		
		-- Remove Publishing for layouts
		declare @idfsLayout bigint
		declare cur_layouts cursor forward_only read_only local for
		select tl.idfsGlobalLayout
		from tasLayout tl
			inner join tasLayoutFolder tlf
			on tlf.idflLayoutFolder = tl.idflLayoutFolder
		where tlf.idfsGlobalLayoutFolder = @idfsLayoutFolder
		
		open cur_layouts
		
		fetch next from cur_layouts into @idfsLayout
		
		while @@FETCH_STATUS = 0  
		begin
			exec [dbo].[spAsLayoutRemovePublishing] @idfsLayout, @idflLayout out
			fetch next from cur_layouts into @idfsLayout
		end
		
		close cur_layouts
		deallocate cur_layouts
		
		-- update local folder
		select top 1 @idflLayoutFolder = idflLayoutFolder
		from tasLayoutFolder
		where idfsGlobalLayoutFolder = @idfsLayoutFolder

		update tasLayoutFolder
		set
			idfsGlobalLayoutFolder = null,
			blnReadOnly = 0
		where idfsGlobalLayoutFolder = @idfsLayoutFolder		
				
		
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while removing publishing folder object: %s', 15, 1, @error)
		return 1
	end catch


	return 0		
end	

