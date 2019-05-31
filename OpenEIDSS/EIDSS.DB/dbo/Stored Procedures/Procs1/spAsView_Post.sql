
--##SUMMARY create view

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idflLayout bigint
select top 1 @idflLayout = idflLayout from tasLayout

EXEC	[dbo].[spAsView_Post]
		 @LangID			= 'en'				
		,@idflLayout			= @idflLayout			
		,@ChartXAxisViewColumn	= null		
		,@MapAdminUnitViewColumn	= null	
		,@idfGlobalView			= null	
		,@blbChartLocalSettings		= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
		,@blbGisLayerLocalSettings	= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
		,@blbGisMapLocalSettings	= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
		,@blbViewSettings		= 0x78DAB3B1AFC8CD51284B2D2ACECCCFB35532D433505248CD4BCE4FC9CC4BB7552A2D49D3B550B2B7B349CECF4BCB4C2F2D4A2C012AB3B3D147E503002DD1182F
		,@intGisLayerPosition		= 1
		

*/ 

CREATE PROCEDURE [dbo].[spAsView_Post]
	 @LangID						nvarchar(50)
	,@idflLayout					bigint
	,@ChartXAxisViewColumn			nvarchar(MAX) = null
	,@MapAdminUnitViewColumn		nvarchar(MAX) = null
	,@idfGlobalView					bigint		
	,@blbChartLocalSettings			image
	,@blbGisLayerLocalSettings		image
	,@blbGisMapLocalSettings		image
	,@blbViewSettings				image
	,@intGisLayerPosition			int
	
AS
BEGIN
	if	not exists (	
				select	*
				from	tasLayout
				where	idflLayout = @idflLayout
			   )
	begin
		Raiserror (N'Layout with ID=%I64d doesnt exist.', 15, 1,  @idflLayout)
		return 1
	end


	
	declare	@viewId	bigint
	
	select	@viewId = idfView
	from	tasView
	where	idflLayout = @idflLayout
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	
	-- inserting into view
	if @viewId is null
	begin
		set @viewId = @idflLayout
        insert into tasView
           (idfView,idfsLanguage,idflLayout,idfGlobalView)
		values
           (@viewId, dbo.fnGetLanguageCode(@LangID), @idflLayout, @idfGlobalView)
	end


	
	update	 v
	set		 v.idfChartXAxisViewColumn = xax.idfViewColumn
			,v.idfMapAdminUnitViewColumn = adu.idfViewColumn
			
			,v.blbChartLocalSettings = @blbChartLocalSettings
			,v.blbGisLayerLocalSettings = @blbGisLayerLocalSettings
			,v.blbGisMapLocalSettings = @blbGisMapLocalSettings
			,v.blbViewSettings = @blbViewSettings
	from tasView v
	Left OUTER JOIN tasViewColumn xax on xax.idfViewColumn = dbo.fnAsGetColumnOrBandIdByUniquePath(@idflLayout, @ChartXAxisViewColumn, 1)
	Left OUTER JOIN tasViewColumn adu on adu.idfViewColumn = dbo.fnAsGetColumnOrBandIdByUniquePath(@idflLayout, @MapAdminUnitViewColumn, 1)
	where	v.idfView = @viewId
	and	v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)



	
	update	 tasLayout
	set		 blbChartGeneralSettings = @blbChartLocalSettings
			,blbGisLayerGeneralSettings = @blbGisLayerLocalSettings
			,blbGisMapGeneralSettings = @blbGisMapLocalSettings
			,intGisLayerPosition = @intGisLayerPosition
	where	idflLayout = @idflLayout


						
	return 0
END


