

--##SUMMARY create view

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idfView bigint
declare @idfViewBand bigint

select @idfViewBand = 7300000000, @idfView=710000000

EXEC	[dbo].[spAsViewBand_Delete]
		 @LangID			= 'en'				
		,@idfView			= @idfView			
		,@idfViewBand			= @idfViewBand			
	

*/ 

create PROCEDURE [dbo].[spAsViewBand_Delete]
	 @LangID				nvarchar(50)
	,@idfView				bigint
	,@idfViewBand				bigint
	
AS
BEGIN

	update	tasView
	set	idfChartXAxisViewColumn = null
	from	tasView
	inner join tasViewColumn on tasViewColumn.idfViewColumn = tasView.idfChartXAxisViewColumn
	where	tasView.idfView = @idfView
	and	tasView.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	tasViewColumn.idfViewBand = @idfViewBand


	update	tasView
	set	idfMapAdminUnitViewColumn = null
	from	tasView
	inner join tasViewColumn on tasViewColumn.idfViewColumn = idfMapAdminUnitViewColumn 
	where	tasView.idfView = @idfView
	and	tasView.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	tasViewColumn.idfViewBand = @idfViewBand

	delete	from tasViewColumn
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfViewBand = @idfViewBand


	delete	from tasViewBand
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfParentViewBand = @idfViewBand
	

	delete	from tasViewBand
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfViewBand = @idfViewBand


						
	return 0
END


