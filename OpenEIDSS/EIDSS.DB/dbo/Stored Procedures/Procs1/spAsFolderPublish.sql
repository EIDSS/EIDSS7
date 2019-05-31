

--##SUMMARY create folder for Folders for analytical module


--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 19.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

begin tran 

declare 
	@idflLayoutFolder			bigint,
	@idfsLayoutFolder			bigint 

set @idflLayoutFolder	= 51734190000000

exec [spAsFolderPublish] @idflLayoutFolder, @idfsLayoutFolder out

select @idfsLayoutFolder


IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO

*/ 


create PROCEDURE [dbo].[spAsFolderPublish]
	@idflLayoutFolder			bigint,
	@idfsLayoutFolder			bigint output
AS
BEGIN
	if	not exists	(	
					select	*
					from	tasLayoutFolder
					where	idflLayoutFolder = @idflLayoutFolder
					)
	begin
		Raiserror (N'Folder with ID=%I64d doesn''t exist.', 15, 1,  @idflLayoutFolder)
		return 1
	end
	begin try
		declare @idflParentLayoutFolder bigint
		declare @idfsParentLayoutFolder bigint
		declare @strENFolderName		nvarchar(2000)
		declare @idfsQuery bigint
		declare @idflQuery bigint
		

		select	@idfsQuery = q.idfsGlobalQuery ,
				@idflQuery = q.idflQuery
		from	tasQuery q
			inner join tasLayoutFolder tlf
			on tlf.idflQuery = q.idflQuery
		where	tlf.idflLayoutFolder = @idflLayoutFolder
		
		--publish query and get global query id if needed
		if (@idfsQuery is null)
			exec spAsQueryPublish @idflQuery, @idfsQuery output
			
		select	@idfsLayoutFolder = glf.idfsLayoutFolder
		from	tasLayoutFolder	as lf
			inner join tasglLayoutFolder glf
			on glf.idfsLayoutFolder = lf.idfsGlobalLayoutFolder
		where	lf.idflLayoutFolder = @idflLayoutFolder 
		
		-- if local folder contains reference to global folder - return
		if @idfsLayoutFolder is not null
			return
		
		select @strENFolderName = lsnt.strTextString
		from locBaseReference lbr
			inner join locStringNameTranslation lsnt
			on lsnt.idflBaseReference = lbr.idflBaseReference
			and lsnt.idfsLanguage = 10049003
		where lbr.idflBaseReference = @idflLayoutFolder
		

		-- insert base reference and english translation		
		exec spsysGetNewID @idfsLayoutFolder out
		
		insert into trtBaseReference(idfsBaseReference,	idfsReferenceType, strDefault)
		values	(@idfsLayoutFolder, 19000123, @strENFolderName)
			
		-- insert all translation
		insert into trtStringNameTranslation
			(
				idfsBaseReference, 
				idfsLanguage, 
				strTextString
			)
		select 
			@idfsLayoutFolder, 
			lsnt.idfsLanguage, 
			lsnt.strTextString
		from locStringNameTranslation as lsnt
		where lsnt.idflBaseReference = @idflLayoutFolder	

		
		--publish parent folder if needed
		select	@idflParentLayoutFolder = idflParentLayoutFolder 
		from	tasLayoutFolder
		where	idflLayoutFolder = @idflLayoutFolder
		if (@idflParentLayoutFolder is not null)
		begin
			exec spAsFolderPublish @idflParentLayoutFolder, @idfsParentLayoutFolder output
		end
		
		-- insert global folder
		insert into tasglLayoutFolder
		   (idfsLayoutFolder
		   ,idfsParentLayoutFolder
		   ,idfsQuery
		   ,blnReadOnly)
		values
		   (@idfsLayoutFolder
		   ,@idfsParentLayoutFolder
		   ,@idfsQuery
		   ,1)
           
        -- create reference from local folder to global
		update	 tasLayoutFolder
		set		 idfsGlobalLayoutFolder = @idfsLayoutFolder
				,blnReadOnly = 1
		where	idflLayoutFolder = @idflLayoutFolder	
		
	end try
	
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while publishing query search object: %s', 15, 1, @error)
		return 1
	end catch

end


