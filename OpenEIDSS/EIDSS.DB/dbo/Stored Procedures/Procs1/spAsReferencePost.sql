

--##SUMMARY post record to locBaseReference

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:


EXEC	[dbo].[spAsReferencePost]
		 @strLanguage			= 'en'				
		,@idflBaseReference		= 716230000000			
		,@strBaseReferenceName	= 'some name 12'			
*/ 

CREATE PROCEDURE [dbo].[spAsReferencePost]
	 @strLanguage				nvarchar(50)
	,@idflBaseReference			bigint
	,@strBaseReferenceName		nvarchar(2000)
AS
BEGIN
	-- insering into locBaseReference
	if not exists	(
					select	idflBaseReference 
					  from	locBaseReference
					 where	idflBaseReference = @idflBaseReference
					)
	begin
		insert into locBaseReference
           (idflBaseReference)
		values
           (@idflBaseReference)
	end
	
	-- insering into locStringNameTranslation
	if not exists	(
					select	idflBaseReference 
					  from	locStringNameTranslation
					 where	idflBaseReference = @idflBaseReference
					   and	idfsLanguage = dbo.fnGetLanguageCode(@strLanguage)
					)
	begin
		insert into locStringNameTranslation
           (idflBaseReference, idfsLanguage, strTextString)
		values
           (@idflBaseReference, dbo.fnGetLanguageCode(@strLanguage), @strBaseReferenceName)
	end
	else begin
		-- updating string name
		update	locStringNameTranslation
		   set	strTextString = @strBaseReferenceName
		 where	idflBaseReference = @idflBaseReference
		   and	idfsLanguage = dbo.fnGetLanguageCode(@strLanguage)
		   and	(strTextString <> @strBaseReferenceName Or strTextString Is Null)
	end

	return 0
END


