
 

--##SUMMARY Returns check sum string of local Layout with format: Layout[1];LayoutSearchField[count];LayoutToMapImage[count];view[count];ViewBand[count];ViewColumn[count]

	

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 12.03.2015

--##RETURNS Returns check sum string of local Layout with format: Layout[1];LayoutSearchField[count];LayoutToMapImage[count];view[count];ViewBand[count];ViewColumn[count]



/*
Example of function call:

SELECT  dbo.fnGetLayoutCheckSumString (10620002271)
*/


create   FUNCTION dbo.fnGetLayoutCheckSumString(
	@idflLayout bigint --##PARAM @@idflLayout - Layout ID
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
	from dbo.tasLayoutSearchField
	where idflLayout = @idflLayout
	
	select @intLayoutToMapImage = count(*) 
	from dbo.tasLayoutToMapImage
	where idflLayout = @idflLayout
	
	select @intView = count(*) 
	from dbo.tasView
	where idflLayout = @idflLayout
	
	select @intViewBand = count(tvb.idfViewBand) 
	from dbo.tasView v
		inner join tasViewBand tvb
		on tvb.idfView = v.idfView 
		and tvb.idfsLanguage = v.idfsLanguage
	where v.idflLayout = @idflLayout
	
	select @intViewColumn = count(tvc.idfViewColumn) 
	from dbo.tasView v
		inner join tasViewBand tvb
		on tvb.idfView = v.idfView 
		and tvb.idfsLanguage = v.idfsLanguage
		
		inner join tasViewColumn tvc
		on tvc.idfView = v.idfView
		and tvc.idfsLanguage = v.idfsLanguage
	where v.idflLayout = @idflLayout
	
	
	select @strLayoutCheckSum = 
		'Layout[1];' +
		'LayoutSearchField[' + cast(@intLayoutSearchField as nvarchar(20)) + '];' +
		'LayoutToMapImage[' + cast(@intLayoutToMapImage as nvarchar(20)) + '];' + 
		'View[' + cast(@intLayoutToMapImage as nvarchar(20)) + '];' + 
		'ViewBand[' + cast(@intViewBand as nvarchar(20)) + '];' +
		'ViewColumn[' + cast(@intViewColumn as nvarchar(20)) + ']'
	
	RETURN @strLayoutCheckSum
	
END	
