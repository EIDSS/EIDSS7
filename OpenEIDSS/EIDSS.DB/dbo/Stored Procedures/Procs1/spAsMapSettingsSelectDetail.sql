

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 03.04.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsMapSettingsSelectDetail 'en', 51403580000000
select * from tasLayout
*/ 
 
create PROCEDURE [dbo].[spAsMapSettingsSelectDetail]
	@LangID		as nvarchar(50),
	@LayoutID	as BIGINT
AS
BEGIN


	select	   l.idflLayout
			  ,refLayout.strName		as strLayoutName
			  ,l.idflQuery
			  ,v.blbGisLayerLocalSettings
			  ,v.blbGisMapLocalSettings
			  ,l.blbGisLayerGeneralSettings
			  ,l.blbGisMapGeneralSettings
			  ,l.intGisLayerPosition
		  
	from		dbo.tasLayout	as l
	inner join	dbo.fnLocalReference(@LangID)	as refLayout
			on	l.idflLayout = refLayout.idflBaseReference
	left join	dbo.tasView as v
			on	v.idfView = l.idflLayout
			and v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
		 where	@LayoutID = l.idflLayout

END

