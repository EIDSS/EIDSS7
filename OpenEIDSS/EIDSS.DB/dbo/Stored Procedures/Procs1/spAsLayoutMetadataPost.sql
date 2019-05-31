
CREATE PROCEDURE [dbo].[spAsLayoutMetadataPost]
(
	 @strLanguage				nvarchar(50)
	,@idflLayout				bigint
	,@strDefaultLayoutName		nvarchar(2000)
	,@strLayoutName				nvarchar(2000)
	,@idfsDefaultGroupDate      bigint --???
	,@idflQuery					bigint
	,@idflDescription			bigint
	,@strDescription			nvarchar(2000)	
	,@strDescriptionEnglish 	nvarchar(2000)	
	,@intPivotGridXmlVersion	int
	,@blnReadOnly				bit = 0 -- equal Is Published	
	,@blnShareLayout			bit = 0
	,@idfPerson					Bigint = null
)
	
AS
BEGIN
	if not exists (select top 1 1 from	dbo.tasQuery where	idflQuery = @idflQuery)
	begin
		Raiserror (N'Query with ID=%I64d doesnt exist.', 15, 1,  @idflQuery)
		return 1
	end

	-- inserting or updating references	
	if (@strLanguage <> 'en')
	begin
		exec dbo.spAsReferencePost @strLanguage, @idflLayout, @strLayoutName
		exec dbo.spAsReferencePost @strLanguage, @idflDescription, @strDescription
	end
	exec dbo.spAsReferencePost 'en', @idflLayout, @strDefaultLayoutName
	exec dbo.spAsReferencePost 'en', @idflDescription, @strDescriptionEnglish
		
	-- inserting into layout
	if not exists (select top 1 1 from dbo.tasLayout where	idflLayout = @idflLayout)
	begin
        insert into dbo.tasLayout
           (idflLayout, idflQuery, idfsDefaultGroupDate, idflDescription)
		values
           (@idflLayout, @idflQuery, @idfsDefaultGroupDate, @idflDescription)
	end
	
	update	dbo.tasLayout
	   set 	blnReadOnly = @blnReadOnly
			,idflDescription = @idflDescription
			,idfsDefaultGroupDate = @idfsDefaultGroupDate			
			,blnShareLayout = @blnShareLayout			
			,blnShowMissedValuesInPivotGrid = 0
			,idfPerson = @idfPerson
			,intPivotGridXmlVersion = @intPivotGridXmlVersion

	where	idflLayout = @idflLayout
						
	return 0
END


