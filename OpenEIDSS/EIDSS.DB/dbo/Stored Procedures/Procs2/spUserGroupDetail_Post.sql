

CREATE PROCEDURE dbo.spUserGroupDetail_Post
(
	@Action 				int -- 4 - Added, 8 - Deleted, 16 - Modified
	,@idfEmployeeGroup		bigint
	,@idfsEmployeeGroupName	bigint
	,@idfsSite				bigint
	,@strGroupName			nvarchar(200)
	,@strNationalGroupName	nvarchar(200) = NULL
	,@strDescription		nvarchar(200) = NULL
	,@LangID				nvarchar(50) = 'en'

)
As begin

IF IsNull(@idfEmployeeGroup,-1) < 0 EXEC spsysGetNewID @idfEmployeeGroup OUTPUT
IF IsNull(@idfsEmployeeGroupName,-1) < 0 EXEC spsysGetNewID @idfsEmployeeGroupName OUTPUT
if(@Action<>8)--deleteing base reference must be called after deleting main record and is called explictly in spUserGroupDetail_Delete
	--insert or update base reference here
	Exec spBaseReference_Post @Action, @idfsEmployeeGroupName, 19000022, @strGroupName, @strNationalGroupName, null, 0, @LangID

-- Add or Modify
IF @Action = 4
BEGIN	
	Insert into dbo.tlbEmployee
	(
		idfEmployee
		,idfsEmployeeType
		,idfsSite
	)
	Values 
	(
		@idfEmployeeGroup
		,10023001 --group
		,@idfsSite
	)	 

	Insert into dbo.tlbEmployeeGroup
	(
		idfEmployeeGroup
		,strName
		,strDescription
		,idfsEmployeeGroupName
		,idfsSite
	)
	Values 
	(
		@idfEmployeeGroup
		,@strGroupName
		,@strDescription
		,@idfsEmployeeGroupName
		,@idfsSite
	)
END
-- Modify
IF @Action = 16
BEGIN		
		
	Update	dbo.tlbEmployeeGroup
	Set		strName = @strGroupName,
			strDescription = @strDescription,
			idfsEmployeeGroupName = @idfsEmployeeGroupName
	Where	idfEmployeeGroup = @idfEmployeeGroup

END
-- Delete
IF @Action = 8
BEGIN
	Exec dbo.spUserGroupDetail_Delete @idfEmployeeGroup
END

End
