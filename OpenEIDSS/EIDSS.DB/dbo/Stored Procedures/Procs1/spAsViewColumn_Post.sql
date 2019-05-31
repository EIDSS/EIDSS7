

--##SUMMARY create view column

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idflLayout bigint
select top 1 @idflLayout = idflLayout from tasLayout

EXEC	[dbo].[spAsViewColumn_Post]
		 @LangID			= 'en'				
		,@idfView			= @idflLayout			
		,@idfViewBand			= null
		,@idfLayoutSearchField		= null
		,@strOriginalName		= 'OriginalBandName'
		,@strDisplayName		= 'DisplayBandName'
		,@blnAggregateColumn		= null
		,@idfsAggregateFunction		= null
		,@intPrecision			= null
		,@blnChartSeries		bit = 0
		,@blnMapDiagramSeries		= null
		,@blnMapGradientSeries		= null
		,@SourceViewColumn		= null
		,@DenominatorViewColumn	= null
		,@blnVisible			= 1
		,@blnFreeze				= 0
		,@intSortOrder			= null
		,@blnSortAscending		= null
		,@intOrder			= 0
		,@strColumnFilter		= null
		,@intColumnWidth		= null
		,@idfViewColumn			=-1 OUTPUT
	
		

*/ 

create PROCEDURE [dbo].[spAsViewColumn_Post]
	 @LangID				varchar(50)
	,@idfView				bigint
	,@idfViewBand				bigint
	,@idfLayoutSearchField		bigint
	,@strOriginalName			nvarchar(2000)
	,@strDisplayName			nvarchar(2000) = null
	,@blnAggregateColumn		bit = null
	,@idfsAggregateFunction		bigint = null
	,@intPrecision				int = null
	,@blnChartSeries			bit = 0
	,@blnMapDiagramSeries		bit = null
	,@blnMapGradientSeries		bit = null
	,@SourceViewColumn			nvarchar(MAX) = null
	,@DenominatorViewColumn		nvarchar(MAX) = null
	,@blnVisible				bit = 1
	,@blnFreeze					bit = 0
	,@intSortOrder				int = null
	,@blnSortAscending			bit = null
	,@intOrder					int = 0
	,@strColumnFilter			nvarchar(2000) = null
	,@intColumnWidth			int = null
	,@idfViewColumn				bigint OUTPUT
	
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


	
	-- inserting into tasViewColumn
	if not exists	(
				select	* 
				from	tasViewColumn
				where	idfView = @idfView
				and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
				and	idfViewColumn = @idfViewColumn
			)
	begin
		EXEC spsysGetNewID @idfViewColumn OUTPUT

        	insert into tasViewColumn
           	(idfViewColumn,idfView,idfsLanguage,strOriginalName)
			values
           	(@idfViewColumn, @idfView, dbo.fnGetLanguageCode(@LangID), @strOriginalName)
	end
	
	update	v
	set
			 v.idfViewBand = @idfViewBand
			,v.idfLayoutSearchField = @idfLayoutSearchField
			,v.strDisplayName = @strDisplayName
			,v.blnAggregateColumn = @blnAggregateColumn
			,v.idfsAggregateFunction = @idfsAggregateFunction
			,v.intPrecision = @intPrecision
			,v.blnChartSeries = @blnChartSeries
	  		,v.blnMapDiagramSeries = @blnMapDiagramSeries
	  		,v.blnMapGradientSeries = @blnMapGradientSeries
	  		,v.idfSourceViewColumn = numr.idfViewColumn
	  		,v.idfDenominatorViewColumn = denr.idfViewColumn
			,v.blnVisible = @blnVisible
	  		,v.blnFreeze = @blnFreeze
			,v.intSortOrder = @intSortOrder
	  		,v.blnSortAscending = @blnSortAscending
			,v.intOrder = @intOrder
	  		,v.strColumnFilter = @strColumnFilter
	  		,v.intColumnWidth = @intColumnWidth
	from tasViewColumn v
	Left OUTER JOIN tasViewColumn numr on numr.idfViewColumn = dbo.fnAsGetColumnOrBandIdByUniquePath(@idfView, @SourceViewColumn, 1)
	Left OUTER JOIN tasViewColumn denr on denr.idfViewColumn = dbo.fnAsGetColumnOrBandIdByUniquePath(@idfView, @DenominatorViewColumn, 1)
			
	where	v.idfView = @idfView
	and	v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	v.idfViewColumn = @idfViewColumn


						
	return 0
END


