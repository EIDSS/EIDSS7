

--##SUMMARY create view Band

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idflLayout bigint
select top 1 @idflLayout = idflLayout from tasLayout

EXEC	[dbo].[spAsViewBand_Post]
		 @LangID			= 'en'				
		,@idfView			= @idflLayout
		,@idfLayoutSearchField		= 0		
		,@strOriginalName		= 'OriginalBandName'
		,@strDisplayName		= 'DisplayBandName'
		,@blnVisible			= 1
		,@blnFreeze			= 0
		,@intOrder			= 0
		,@idfParentViewBand		= null
		,@idfViewBand			=-1 OUTPUT
	
		

*/ 

create PROCEDURE [dbo].[spAsViewBand_Post]
	 @LangID				varchar(50)
	,@idfView				bigint
	,@idfLayoutSearchField			bigint		
	,@strOriginalName			nvarchar(2000)
	,@strDisplayName			nvarchar(2000)
	,@blnVisible				bit = 1
	,@blnFreeze				bit = 0
	,@intOrder				int = 0
	,@idfParentViewBand			bigint = null
	,@idfViewBand				bigint OUTPUT
	
AS
BEGIN
	if	not exists (	
				select	*
				from	tasView
				where	idfView = @idfView
				and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
			   )
	begin
		Raiserror (N'View with ID=%I64d and language=%s doesnt exist.', 15, 1, @idfView, @LangID)
		return 1
	end


	
	-- inserting into tasViewBand
	if not exists	(
				select	* 
				from	tasViewBand
				where	idfView = @idfView
				and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
				and	idfViewBand = @idfViewBand
			)
	begin
		EXEC spsysGetNewID @idfViewBand OUTPUT

        	insert into tasViewBand
           	(idfViewBand,idfView,idfsLanguage, strOriginalName)
			values
           	(@idfViewBand, @idfView, dbo.fnGetLanguageCode(@LangID), @strOriginalName)
	end
	
	update	tasViewBand
	set		 strDisplayName = @strDisplayName
			,blnVisible = @blnVisible
	  		,blnFreeze = @blnFreeze
			,intOrder = @intOrder
			,idfParentViewBand = @idfParentViewBand
			,idfLayoutSearchField = @idfLayoutSearchField
			
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfViewBand = @idfViewBand


						
	return 0
END


