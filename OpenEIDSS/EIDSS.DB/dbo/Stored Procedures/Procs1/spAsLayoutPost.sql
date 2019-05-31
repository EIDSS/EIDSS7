

--##SUMMARY create layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.03.2010

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idflQuery bigint
select top 1 @idflQuery = idflQuery from tasQuery
declare @idfPerson bigint
select top 1 @idfPerson = idfPerson from tstUserTable order by idfUserID desc

EXEC	[dbo].[spAsLayoutPost]
		 @strLanguage			= 'en'				
		,@idflLayout			= 708000000001			
		,@strLayoutName			= 'some name'			
		,@strDefaultLayoutName	= 'default name'	
		,@idflQuery				= @idflQuery				
		,@idflLayoutFolder		= null		
		,@idfPerson				= @idfPerson	
		,@idflDescription		= 128760000000	
		,@strDescription		= null	
		,@blbPivotGridSettings		= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
		,@blnReadOnly			= 0	
		,@idfsDefaultGroupDate		= 10039001	
		,@blnShowColsTotals		= 1	
		,@blnShowRowsTotals		= 0	
		,@blnShowColGrandTotals	= 1	
		,@blnShowRowGrandTotals	= 0
		,@blnShowForSingleTotals	= 1
		,@blnApplyPivotGridFilter			= 0
		,@blnShareLayout		= 1	
		,@intPivotGridXmlVersion = 5
		,@blnCompactPivotGrid = 0
		,@blnFreezeRowHeaders = 0
		,@blnUseArchivedData = 0
		,@blnShowMissedValuesInPivotGrid = 0
		,@blnShowDataInPivotGrid = 0
	
			  
select * from tasLayout			  
*/ 

create PROCEDURE [dbo].[spAsLayoutPost]
	 @strLanguage				nvarchar(50)
	,@idflLayout				bigint
	,@strLayoutName				nvarchar(2000)
	,@strDefaultLayoutName		nvarchar(2000)
	,@idflQuery					bigint		
	,@idflLayoutFolder			bigint
	,@idfPerson					bigint
	,@idflDescription			bigint
	,@strDescription			nvarchar(2000)
	,@blbPivotGridSettings		image
	,@blnReadOnly				bit
	,@idfsDefaultGroupDate		bigint
	,@blnShowColsTotals			bit
	,@blnShowRowsTotals			bit
	,@blnShowColGrandTotals		bit
	,@blnShowRowGrandTotals		bit
	,@blnShowForSingleTotals	bit
	,@blnApplyPivotGridFilter	bit
	,@blnShareLayout			bit
	,@intPivotGridXmlVersion	int
	,@blnCompactPivotGrid		bit
	,@blnFreezeRowHeaders		bit
	,@blnUseArchivedData		bit
	,@blnShowMissedValuesInPivotGrid bit
	,@blnShowDataInPivotGrid	bit
	
	
	
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
		exec spAsReferencePost @strLanguage, @idflLayout,	@strLayoutName
	end
	exec spAsReferencePost 'en',		 @idflLayout,	@strDefaultLayoutName
	exec spAsReferencePost @strLanguage, @idflDescription, @strDescription
	
	set @blnShowDataInPivotGrid = isnull(@blnShowDataInPivotGrid, 0)
	
	-- inserting into layout
	if not exists	(
					select	* 
					  from	tasLayout
					 where	idflLayout = @idflLayout
					)
	begin
        insert into tasLayout
           (idflLayout, idflQuery, idfPerson, idfsDefaultGroupDate, idflDescription, idflLayoutFolder, blnShowDataInPivotGrid)
		values
           (@idflLayout, @idflQuery, @idfPerson, @idfsDefaultGroupDate, @idflDescription, @idflLayoutFolder, @blnShowDataInPivotGrid)
	end
	
	update	tasLayout
	   set 	idfPerson = @idfPerson
			,blbPivotGridSettings = @blbPivotGridSettings
			,blnReadOnly = @blnReadOnly
			
			,idflDescription = @idflDescription
			,idfsDefaultGroupDate = @idfsDefaultGroupDate
			
			,blnShowColsTotals = @blnShowColsTotals
			,blnShowRowsTotals = @blnShowRowsTotals
			,blnShowColGrandTotals = @blnShowColGrandTotals
			,blnShowRowGrandTotals = @blnShowRowGrandTotals
			,blnShowForSingleTotals = @blnShowForSingleTotals
			,blnApplyPivotGridFilter = @blnApplyPivotGridFilter
			,blnShareLayout = @blnShareLayout
			
			,intPivotGridXmlVersion	 = @intPivotGridXmlVersion
			,blnCompactPivotGrid = @blnCompactPivotGrid
			,blnFreezeRowHeaders = @blnFreezeRowHeaders		
			,blnUseArchivedData	= @blnUseArchivedData
			,blnShowMissedValuesInPivotGrid = @blnShowMissedValuesInPivotGrid
			,blnShowDataInPivotGrid	=	@blnShowDataInPivotGrid
			

	where	idflLayout = @idflLayout


						
	return 0
END


