

--##SUMMARY create folder for Folders for analytical module

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

delete from tasLayoutFolder 
where idflLayoutFolder = 24440002271

delete from locStringNameTranslation
where idflBaseReference = 24440002271

delete from locBaseReference
where idflBaseReference = 24440002271

begin tran 


declare @idflFolder bigint
--EXEC	[spAsFolderCopyPublished] 	1510000870,	@idflFolder output

EXEC	[spAsFolderCopyPublished] 	24440002271,	@idflFolder output

print @idflFolder

SELECT     TOP (200) tasLayoutFolder.idflLayoutFolder, tasLayoutFolder.idfsGlobalLayoutFolder, tasLayoutFolder.idflParentLayoutFolder, 
                      locStringNameTranslation.strTextString
FROM         tasLayoutFolder INNER JOIN
                      locBaseReference ON tasLayoutFolder.idflLayoutFolder = locBaseReference.idflBaseReference INNER JOIN
                      locStringNameTranslation ON locBaseReference.idflBaseReference = locStringNameTranslation.idflBaseReference
                      
ROLLBACK TRAN


IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN



*/ 

create PROCEDURE [dbo].[spAsFolderCopyPublished]
	@idfsLayoutFolder		bigint,
	@idflLayoutFolder		bigint = null output 
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
	
	-- if local layout exists - nothing should be don
	select @idflLayoutFolder = idflLayoutFolder
	from	tasLayoutFolder
	where	idfsGlobalLayoutFolder = @idfsLayoutFolder
		
	if @idflLayoutFolder is not null
		return 0 
				
	begin try
		declare @idfsQuery bigint
		declare @idflQuery bigint
		
		
		-- let local folder has the same id as global			
		set	 @idflLayoutFolder = @idfsLayoutFolder
		
		select @idfsQuery = tq.idfsQuery,  @idflQuery = tq_loc.idflQuery
		from tasglLayoutFolder tlf
			inner join tasglQuery tq
			on tq.idfsQuery = tlf.idfsQuery
			
			left join tasQuery tq_loc
			on tq_loc.idfsGlobalQuery = tq.idfsQuery
		where tlf.idfsLayoutFolder = @idfsLayoutFolder
		
		if @idflQuery is null	
			exec spAsQueryCopyPublished @idfsQuery, @idflQuery out
		
			
		declare @Folders table (
			idfsLayoutFolder bigint primary key,
			idfsParentLayoutFolder bigint,
			idflLayoutFolder bigint null,
			isNew bit not null default(0)
		)
			
		;with FolderTree(idfsLayoutFolder, idfsParentLayoutFolder) 
		as
		(
			select	 lf.idfsLayoutFolder
					,lf.idfsParentLayoutFolder
					
			from	tasglLayoutFolder lf
			where	lf.idfsLayoutFolder = @idfsLayoutFolder
					and lf.idfsQuery = @idfsQuery
			union all
			select	 lf.idfsLayoutFolder
					,lf.idfsParentLayoutFolder
					
			from	tasglLayoutFolder lf
				join  FolderTree ft
				on ft.idfsParentLayoutFolder = lf.idfsLayoutFolder
				and lf.idfsQuery = @idfsQuery
		)		
		
		insert into @Folders (idfsLayoutFolder, idfsParentLayoutFolder)
		select idfsLayoutFolder, idfsParentLayoutFolder from FolderTree
	
		update f set 
			f.idflLayoutFolder = tlf_local.idflLayoutFolder,
			f.isNew = case when tlf_local.idflLayoutFolder is null then 1 else 0 end
		
		from @Folders f
			left join tasLayoutFolder tlf_local
			on  f.idfsLayoutFolder = tlf_local.idfsGlobalLayoutFolder 

		insert into	locBaseReference
		(	idflBaseReference
		)
		select		lf.idfsLayoutFolder
		from		tasglLayoutFolder lf
		inner join @Folders f
		on f.idfsLayoutFolder = lf.idfsLayoutFolder
		inner join	trtBaseReference br_lf
		on			br_lf.idfsBaseReference = lf.idfsLayoutFolder
					and br_lf.idfsReferenceType = 19000123	-- AVR Folder Name
					and br_lf.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = lf.idfsLayoutFolder
		left join	tasLayoutFolder lf_loc
		on			lf_loc.idfsGlobalLayoutFolder = lf.idfsLayoutFolder
		where		lf_loc.idflLayoutFolder is null
					and lbr.idflBaseReference is null
			
						
		insert into	locStringNameTranslation
		(	idflBaseReference,
			idfsLanguage,
			strTextString
		)
		select		lbr.idflBaseReference,
					snt.idfsLanguage,
					snt.strTextString
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000123	-- AVR Folder Name
					and br.intRowStatus = 0
		inner join @Folders f
		on f.idfsLayoutFolder = br.idfsBaseReference
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null			
			

		insert into	tasLayoutFolder
		(	idflLayoutFolder,
			idfsGlobalLayoutFolder,
			idflParentLayoutFolder,
			idflQuery,
			blnReadOnly
		)
		select		glf.idfsLayoutFolder,
					glf.idfsLayoutFolder,
					null,
					q.idflQuery,
					glf.blnReadOnly
		from		tasglLayoutFolder glf
		inner join	@Folders f
		on			f.idfsLayoutFolder = glf.idfsLayoutFolder
		inner join	tasQuery q
		on			q.idfsGlobalQuery = glf.idfsQuery
		left join	tasLayoutFolder lf
		on			lf.idflLayoutFolder = glf.idfsLayoutFolder
		left join	tasLayoutFolder lf_original
		on			lf_original.idfsGlobalLayoutFolder = glf.idfsLayoutFolder
		where		glf.idfsParentLayoutFolder is null
					and lf_original.idflLayoutFolder is null
					and lf.idflLayoutFolder is null


		declare	@RowCount	int
		set	@RowCount = 1

		while	@RowCount > 0
		begin

			insert into	tasLayoutFolder
			(	idflLayoutFolder,
				idfsGlobalLayoutFolder,
				idflParentLayoutFolder,
				idflQuery,
				blnReadOnly
			)
			select		glf.idfsLayoutFolder,
						glf.idfsLayoutFolder,
						IsNull(lf_parent.idflLayoutFolder, glf.idfsParentLayoutFolder),
						q.idflQuery,
						glf.blnReadOnly
			from		tasglLayoutFolder glf
			inner join	@Folders f
			on			f.idfsLayoutFolder = glf.idfsLayoutFolder
			inner join	tasQuery q
			on			q.idfsGlobalQuery = glf.idfsQuery
			inner join	tasLayoutFolder lf_parent
			on			lf_parent.idflQuery = q.idflQuery
						and lf_parent.idfsGlobalLayoutFolder = glf.idfsParentLayoutFolder
			left join	tasLayoutFolder lf
			on			lf.idflLayoutFolder = glf.idfsLayoutFolder
			left join	tasLayoutFolder lf_original
			on			lf_original.idfsGlobalLayoutFolder = glf.idfsLayoutFolder
			where		lf_original.idflLayoutFolder is null
						and lf.idflLayoutFolder is null


			set	@RowCount = @@rowcount
		end
					
		update f set 
			f.idflLayoutFolder = tlf_local.idflLayoutFolder		
		from @Folders f
			left join tasLayoutFolder tlf_local
			on  f.idfsLayoutFolder = tlf_local.idfsGlobalLayoutFolder 			
		
					
		declare @RowsUpdated int
		
		declare	@LayoutFolderNameConflicts	table
		(	idflLayoutFolder	bigint not null,
			idfsLanguage		bigint not null,
			idflQuery			bigint not null,
			idflParentLayoutFolder bigint null,
			strLayoutFolderName	nvarchar(2000) collate database_default null,
			intIndex			int null,
			primary key	(
				idflLayoutFolder asc,
				idfsLanguage asc
						)
		)

	
		-- get old folders with same parent as the new folders, but without new folders
		insert into	@LayoutFolderNameConflicts
		(	idflLayoutFolder,
			idfsLanguage,
			idflQuery,
			strLayoutFolderName,
			idflParentLayoutFolder,
			intIndex
		)
		select		lf.idflLayoutFolder,
					lsnt.idfsLanguage,
					lf.idflQuery,
					lsnt.strTextString,
					lf.idflParentLayoutFolder,
					null
		from		tasLayoutFolder lf
		inner join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lf.idflLayoutFolder
		left join @Folders f_new
		on f_new.idflLayoutFolder = lf.idflLayoutFolder
		and f_new.isNew = 1
		where exists (
			select * from @Folders f
			inner join tasLayoutFolder tlf_local
			on f.idfsLayoutFolder = tlf_local.idfsGlobalLayoutFolder
			where 
			isnull(tlf_local.idflParentLayoutFolder, 0) = isnull(lf.idflParentLayoutFolder, 0)
			and f.isNew = 1
		)
		and f_new.idfsLayoutFolder is null


		update folder_conflict set
			folder_conflict.intIndex = s.intIndex
		from @LayoutFolderNameConflicts folder_conflict
			inner join (
					select 
						tlf_new.idflParentLayoutFolder as idflParentLayoutFolder,
						max(cast(substring(lfnc.strLayoutFolderName, len(lsnt_new.strTextString) + 2, len(lfnc.strLayoutFolderName)) as int)) + 1 as intIndex,
						lsnt_new.strTextString as strTextString,
						lfnc.idfsLanguage as idfsLanguage

					from @LayoutFolderNameConflicts lfnc
					
						inner join locStringNameTranslation lsnt_new  
						on lfnc.idfsLanguage = lsnt_new.idfsLanguage
						and 
						(lsnt_new.strTextString = lfnc.strLayoutFolderName collate database_default
						or (lsnt_new.strTextString = substring(lfnc.strLayoutFolderName, 1, len(lsnt_new.strTextString)) collate database_default
							and isnumeric (substring(lfnc.strLayoutFolderName, len(lsnt_new.strTextString) + 2, len(lfnc.strLayoutFolderName))) = 1 
							) 
						)

						inner join @Folders f_new
						on f_new.idflLayoutFolder = lsnt_new.idflBaseReference
						and f_new.isNew = 1
						
						inner join tasLayoutFolder tlf_new
						on tlf_new.idflLayoutFolder = f_new.idflLayoutFolder
						and isnull(tlf_new.idflParentLayoutFolder, 0) = isnull(lfnc.idflParentLayoutFolder, 0)
						and tlf_new.idflQuery = lfnc.idflQuery
					group by tlf_new.idflParentLayoutFolder, lsnt_new.strTextString, lfnc.idfsLanguage
			
			) as s
			on	folder_conflict.idfsLanguage = s.idfsLanguage  
			and isnull(folder_conflict.idflParentLayoutFolder,0) = isnull(s.idflParentLayoutFolder, 0)
			and folder_conflict.strLayoutFolderName = s.strTextString collate database_default
			
		


		
		--select * from @LayoutFolderNameConflicts 
		
		update		lsnt
		set			lsnt.strTextString = IsNull(lfnc.strLayoutFolderName, N'') + N'_' + 
											cast(lfnc.intIndex as nvarchar(20))
		from		locStringNameTranslation lsnt
		inner join	@LayoutFolderNameConflicts lfnc
		on			lfnc.idflLayoutFolder = lsnt.idflBaseReference
					and lfnc.idfsLanguage = lsnt.idfsLanguage
					and IsNull(lfnc.intIndex, 0) > 0	
			
			
	end try
	
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while making local folder: %s', 15, 1, @error)
		return 1
	end catch
end


