

--##SUMMARY create folder for Folders for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.08.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*

--Example of a call of procedure:

declare @idflFolder bigint
EXEC	[spAsFolderMakeLocal] 	717290000000,	717720000000,  @idflFolder output

*/ 

CREATE PROCEDURE [dbo].[spAsFolderMakeLocal]
	@idfsFolder			bigint,
	@idflQuery			bigint,
	@idflFolder			bigint output
AS
BEGIN


	if	not exists	(	
					select	*
					from	tasQuery
					where	idflQuery = @idflQuery
					)
	begin
		Raiserror (N'Query with ID=%I64d doesn''t exist.', 15, 1,  @idflQuery)
		return 1
	end
	
	if	not exists	(	
					select	*
					from	tasglLayoutFolder
					where	idfsLayoutFolder = @idfsFolder
					)
	begin
		Raiserror (N'Global Folder with ID=%I64d doesn''t exist.', 15, 1,  @idflFolder)
		return 1
	end
	
	begin try
		
		declare @idflParentLayoutFolder bigint
		declare @idfsParentLayoutFolder bigint
		declare @strENFolderName		nvarchar(2000)
		declare @strLocalFolderName		nvarchar(2000)
		declare @strBaseReferenceCode	varchar(36)

		--get @idflLayout
		select	 @idflFolder = idflLayoutFolder
		from	 tasLayoutFolder 
		where	 idfsGlobalLayoutFolder = @idfsFolder

		-- if local layout exists - nothing should be donr
		if (@idflFolder is not null)
			return 0 
			
		-- let local folder has the same id as global			
		set	 @idflFolder = @idfsFolder
			
		select		 @strENFolderName = refENFolder.name
		from		tasglLayoutFolder				as tFolder
		inner join	dbo.fnReference('en', 19000123)	as refENFolder
				on	tFolder.idfsLayoutFolder = refENFolder.idfsReference 
		where		idfsLayoutFolder = @idfsFolder
		
		-- insert local reference and english translation
		exec spAsReferencePost  'en',  @idflFolder,  @strENFolderName


		-- insert all translation
		insert into locStringNameTranslation(idflBaseReference,idfsLanguage,strTextString)
		select a.idfsBaseReference,a.idfsLanguage, a.strTextString
		from trtStringNameTranslation as a
		left join locStringNameTranslation as b
		on a.idfsBaseReference = b.idflBaseReference and a.idfsLanguage = b.idfsLanguage
		where a.idfsBaseReference in (@idflFolder)	
		and b.idflBaseReference is null

		--make local parent folder if needed
		select	@idfsParentLayoutFolder = idfsParentLayoutFolder 
		from	tasglLayoutFolder
		where	idfsLayoutFolder = @idfsFolder
		
		if (@idfsParentLayoutFolder is not null)
			exec spAsFolderMakeLocal @idfsParentLayoutFolder, @idflQuery, @idflParentLayoutFolder output
			
		-- insert local folder
		INSERT INTO tasLayoutFolder
		   (idflLayoutFolder
		   ,idflParentLayoutFolder
		   ,idfsGlobalLayoutFolder
		   ,idflQuery
		   ,blnReadOnly)
		VALUES
		   (@idflFolder
		   ,@idflParentLayoutFolder
		   ,@idfsFolder
		   ,@idflQuery
		   ,1)
	end try
	
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while making local folder: %s', 15, 1, @error)
		return 1
	end catch
end


