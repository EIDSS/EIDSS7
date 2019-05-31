

--##SUMMARY select view settings for analytical module from GLOBAL table


--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.07.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec [spAsGlobalViewBinarySelect]  56370830000000, 'ru'
*/ 
 
create PROCEDURE [dbo].[spAsGlobalViewBinarySelect]
	 @idfsLayout	bigint,
	 @LangID		nvarchar(50)
AS
BEGIN


	select	 idfView
			,idfsLanguage
			,idfsLayout
			,blbChartLocalSettings
			,blbGisLayerLocalSettings
			,blbGisMapLocalSettings
			,blbViewSettings
		  
	from	dbo.tasglView
	where	idfsLayout = @idfsLayout
	and		idfsLanguage = dbo.fnGetLanguageCode(@LangID)

END



