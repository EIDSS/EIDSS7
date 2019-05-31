
 

--##SUMMARY Returns check sum string of global Layout with format: Layout[1];LayoutSearchField[count];LayoutToMapImage[count];view[count];ViewBand[count];ViewColumn[count]

	

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 12.03.2015

--##RETURNS Returns check sum string of global Layout with format: Layout[1];LayoutSearchField[count];LayoutToMapImage[count];view[count];ViewBand[count];ViewColumn[count]



/*
Example of function call:

SELECT  dbo.fnGetLayoutGlobalCheckSumString (10620002271)
*/


create   FUNCTION dbo.fnGetLayoutGlobalCheckSumString(
	@idfsLayout bigint --##PARAM @@idfsLayout - Layout ID
)
returns nvarchar(max)
as
BEGIN 

-- Layout[1];LayoutSearchField[count];LayoutToMapImage[count];View[count];ViewBand[count];ViewColumn[count]


declare 
	@intLayoutSearchField int,
	@intLayoutToMapImage int,
	@intView int,
	@intViewBand int,
	@intViewColumn int,
	
	@strLayoutCheckSum nvarchar(max)
	
	

	select @intLayoutSearchField = count(*) 
	from dbo.tasglLayoutSearchField
	where idfsLayout = @idfsLayout
	
	select @intLayoutToMapImage = count(*) 
	from dbo.tasglLayoutToMapImage
	where idfsLayout = @idfsLayout
	
	select @intView = count(*) 
	from dbo.tasglView
	where idfsLayout = @idfsLayout
	
	select @intViewBand = count(tvb.idfViewBand) 
	from dbo.tasglView v
		inner join tasglViewBand tvb
		on tvb.idfView = v.idfView 
		and tvb.idfsLanguage = v.idfsLanguage
	where v.idfsLayout = @idfsLayout
	
	select @intViewColumn = count(tvc.idfViewColumn) 
	from dbo.tasglView v
		inner join tasglViewBand tvb
		on tvb.idfView = v.idfView 
		and tvb.idfsLanguage = v.idfsLanguage
		
		inner join tasglViewColumn tvc
		on tvc.idfView = v.idfView
		and tvc.idfsLanguage = v.idfsLanguage
	where v.idfsLayout = @idfsLayout
	
	
	select @strLayoutCheckSum = 
		'Layout[1];' +
		'LayoutSearchField[' + cast(@intLayoutSearchField as nvarchar(20)) + '];' +
		'LayoutToMapImage[' + cast(@intLayoutToMapImage as nvarchar(20)) + '];' + 
		'View[' + cast(@intLayoutToMapImage as nvarchar(20)) + '];' + 
		'ViewBand[' + cast(@intViewBand as nvarchar(20)) + '];' +
		'ViewColumn[' + cast(@intViewColumn as nvarchar(20)) + ']'
	
	RETURN @strLayoutCheckSum
	
END	
