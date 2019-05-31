

--##SUMMARY delete view settins in database

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:



declare @idflLayout bigint
select top 1 @idflLayout = idflLayout from tasLayout

EXEC	[dbo].[spAsView_Delete]
		 @LangID			= 'en'				
		,@idfView			= @idflLayout			
	
	
	exec [dbo].[spAsView_Delete]  'en', 112770001100 

*/ 

create PROCEDURE [dbo].[spAsView_Delete]
	 @LangID				nvarchar(50)
	,@idfView				bigint
	
AS
BEGIN

	update	 tasView
	set idfChartXAxisViewColumn = null,
	idfMapAdminUnitViewColumn = null
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)

	delete	from tasViewColumn
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)


	delete	from tasViewBand
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	

	delete	from tasView
	where	idfView = @idfView
	and	idfsLanguage = dbo.fnGetLanguageCode(@LangID)


						
	return 0
END




