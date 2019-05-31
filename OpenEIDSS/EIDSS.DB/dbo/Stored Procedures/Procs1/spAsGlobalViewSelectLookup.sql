

--##SUMMARY Selects GLOBAL lookup lists of AVR View

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 17.07.2015

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spAsGlobalViewSelectLookup  56370830000000

*/
--0 View
create  PROCEDURE dbo.spAsGlobalViewSelectLookup
	@idflLayout	as bigint = null
AS
begin


	SELECT 
		   v.idfView
		  ,v.idfsLanguage
		  ,lang.strBaseReferenceCode as strLanguage
		  ,v.idfsLayout
		  ,v.blbChartLocalSettings
		  ,v.blbGisLayerLocalSettings
		  ,v.blbGisMapLocalSettings
		  ,v.blbViewSettings
		  ,l.intGisLayerPosition
		  ,l.blnReadOnly
	FROM	 tasglView v
	inner join tasglLayout l on v.idfsLayout = l.idfsLayout
	inner join trtBaseReference lang
	on		lang.idfsBaseReference = v.idfsLanguage
	where	lang.idfsReferenceType = 19000049
	and		lang.intRowStatus = 0
	and		(@idflLayout is null or @idflLayout = l.idfsLayout)
 


end


