

--##SUMMARY create view

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

exec spAsViewColumn_Delete
			@LangID=N'en',
			@idfView=51842250000000
			,@idfViewColumn=51843690000000
					
	

*/ 

create PROCEDURE [dbo].[spAsViewColumn_Delete]
	 @LangID				nvarchar(50)
	,@idfView				bigint
	,@idfViewColumn				bigint
	
AS
BEGIN

	update	tasView
	set	idfChartXAxisViewColumn = null
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfChartXAxisViewColumn = @idfViewColumn


	update	tasView
	set	idfMapAdminUnitViewColumn = null
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfMapAdminUnitViewColumn = @idfViewColumn


	update	tasViewColumn
	set		idfSourceViewColumn = null
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfSourceViewColumn = @idfViewColumn 
	
	
	update	tasViewColumn
	set		idfDenominatorViewColumn = null
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfDenominatorViewColumn = @idfViewColumn 
	
	delete	from tasViewColumn
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	and	idfViewColumn = @idfViewColumn


						
	return 0
END


