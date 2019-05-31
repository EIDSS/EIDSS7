

--##SUMMARY create folder for Folders for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.03.2010

--##RETURNS Don't use

/*

--Example of a call of procedure:

declare @idflQuery bigint
select top 1 @idflQuery = idflQuery from tasQuery

EXEC	[dbo].[spAsFolderPost]
		 @strLanguage			= 'en'				
		,@idflFolder			= 9110000002			
		,@idflParentFolder			= null	
		,@strFolderName			= 'some name'			
		,@strDefaultFolderName	= 'default name'	
		,@idflQuery				= @idflQuery		
		

*/ 

create PROCEDURE [dbo].[spAsFolderPost]
	 @strLanguage				nvarchar(50)
	,@idflFolder				bigint
	,@idflParentFolder			bigint
	,@strFolderName				nvarchar(2000)
	,@strDefaultFolderName		nvarchar(2000)
	,@idflQuery					bigint		
AS
BEGIN
	if	not exists	(	
					select	*
					from	tasQuery
					where	idflQuery = @idflQuery
					)
	begin
		Raiserror (N'Query with ID=%I64d doesnt exist.', 15, 1,  @idflQuery)
		return 1
	end

	-- inserting or updating references	
	if (@strLanguage <> 'en')
	begin
		exec spAsReferencePost @strLanguage, @idflFolder,	@strFolderName
	end
	exec spAsReferencePost 'en',			 @idflFolder,	@strDefaultFolderName
	
	-- inserting or update into Folder
	if not exists	(
					select	* 
					from	tasLayoutFolder
					where	idflLayoutFolder = @idflFolder
					)
	begin
        insert into tasLayoutFolder
           (idflLayoutFolder, idflParentLayoutFolder, idflQuery, blnReadOnly)
		values
           (@idflFolder, @idflParentFolder, @idflQuery, 0)
	end
	else begin
		update	tasLayoutFolder
		set		idflParentLayoutFolder = @idflParentFolder
		where	idflLayoutFolder = @idflFolder
	end
	

	return 0

END


