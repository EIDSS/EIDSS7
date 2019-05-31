

--##SUMMARY Selects lookup lists of AVR View

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 17.07.2015

--##RETURNS Doesn't use

/*
Example of procedure call:

EXECUTE spAsViewSelectLookup  55748880000000

*/
--0 View
create  PROCEDURE dbo.spAsViewSelectLookup
	@idflLayout	as bigint = null
AS
begin


	SELECT 
		   v.idfView
		  ,v.idfsLanguage
		  ,lang.strBaseReferenceCode as strLanguage
		  ,v.idflLayout
		  ,v.idfGlobalView
		  ,v.blbChartLocalSettings
		  ,v.blbGisLayerLocalSettings
		  ,v.blbGisMapLocalSettings
		  ,v.blbViewSettings
		  ,l.intGisLayerPosition
		  ,l.blnReadOnly
	FROM	 tasView v
	inner join tasLayout l on v.idflLayout = l.idflLayout
	inner join trtBaseReference lang
	on		lang.idfsBaseReference = v.idfsLanguage
	where	lang.idfsReferenceType = 19000049
	and		lang.intRowStatus = 0
	and		(@idflLayout is null or @idflLayout = l.idflLayout)
 


end


