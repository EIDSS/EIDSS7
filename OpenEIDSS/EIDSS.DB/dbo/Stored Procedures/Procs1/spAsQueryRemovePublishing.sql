

--##SUMMARY unpublish Query for analytical module

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 02.12.2013

--##RETURNS Don't use

/*
 New folder 1

--Example of a call of procedure:
begin tran 

declare @idfsQuery bigint
declare @idflQuery bigint
set @idfsQuery = 51741940000000
EXEC	[spAsQueryRemovePublishing] 	@idfsQuery, @idflQuery

IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO
*/ 

create PROCEDURE [dbo].[spAsQueryRemovePublishing]
	@idfsQuery	bigint
	,@idflQuery	bigint output
AS
BEGIN

	begin try
		-- Remove Publishing for layouts
		declare @idfsLayout bigint
		declare @idflLayout bigint
		declare cur_layouts cursor forward_only read_only local for
		select tl.idfsGlobalLayout
		from tasLayout tl
			inner join tasQuery tq
			on tq.idflQuery = tl.idflQuery
		where tq.idfsGlobalQuery = @idfsQuery
			and tl.idflLayoutFolder is null
		
		open cur_layouts
		
		fetch next from cur_layouts into @idfsLayout
		
		while @@FETCH_STATUS = 0  
		begin
			exec [dbo].[spAsLayoutRemovePublishing] @idfsLayout, @idflLayout out
			fetch next from cur_layouts into @idfsLayout
		end
		
		close cur_layouts
		deallocate cur_layouts
	
	
		-- Remove Publishing for folders
		declare @idfsFolder bigint
		declare @idflFolder bigint
		
		declare cur_folders cursor forward_only read_only local for
		select tlf.idfsGlobalLayoutFolder
		from tasLayoutFolder tlf
			inner join tasQuery tq
			on tq.idflQuery = tlf.idflQuery
		where tq.idfsGlobalQuery = @idfsQuery
			and tlf.idflParentLayoutFolder is null		
		
		open cur_folders
		
		fetch next from cur_folders into @idfsFolder
		
		while @@FETCH_STATUS  = 0
		begin
			exec [dbo].[spAsFolderRemovePublishing] @idfsFolder, @idflFolder out
			fetch next from cur_folders into @idfsFolder
		end
		
		close cur_folders
		deallocate cur_folders	
	

		select top 1 @idflQuery = idflQuery
		from tasQuery 
		where		idfsGlobalQuery = @idfsQuery
			
		update tasQuery
		set
			idfsGlobalQuery = null,
			blnReadOnly = 0
		where		idfsGlobalQuery = @idfsQuery	

	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while removing publishing query object: %s', 15, 1, @error)
		return 1
	end catch


	return 0		
end	
	
