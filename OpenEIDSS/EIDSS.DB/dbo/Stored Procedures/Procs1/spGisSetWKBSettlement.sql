

-- =============================================
-- Author:		<Timur Kobilov>
-- Create date: <18.08.2010>
-- Description:	<Create geometry in gisWKBSettlement on the basis of coordinates from gisSettlement>
-- =============================================
CREATE PROCEDURE [dbo].[spGisSetWKBSettlement] 
	@idfsGeoObject BIGINT
AS
BEGIN

	declare	@cmd	nvarchar(MAX)

	set	@cmd = N'
	SET QUOTED_IDENTIFIER ON; 
'	
	exec sp_executesql @cmd

	set @cmd = N'
	DECLARE @dblX FLOAT
	DECLARE @dblY FLOAT
	
	DECLARE @dblLat FLOAT
	DECLARE @dblLon FLOAT
	
	DECLARE @dblA FLOAT
	DECLARE @dblB FLOAT
	DECLARE @dblE FLOAT
	DECLARE @intElevationParam INT
	SET @dblA = 6378137
		
	DECLARE @intSRID INT
	DECLARE @geom GEOMETRY

	SELECT	 @dblLon = dblLongitude 
			,@dblLat = dblLatitude
			,@intElevationParam = intElevation
	FROM gisSettlement
	WHERE (idfsSettlement = @idfsGeoObjectParam)
	SET @intSRID = 3857 --4326
	
	SET @dblLon = @dblLon*PI()/180
	SET @dblLat = @dblLat*PI()/180
	
	SET @dblX = @dblA*@dblLon
	
	SET @dblY = @dblA*LOG(TAN(PI()/4 + @dblLat/2))
	
	SET @geom = geometry::Point(@dblX, @dblY, @intSRID)

	IF EXISTS(SELECT * FROM gisWKBSettlement WHERE idfsGeoObject=@idfsGeoObjectParam)
		UPDATE gisWKBSettlement
			SET geomShape = @geom, intElevation = @intElevationParam
			WHERE  idfsGeoObject=@idfsGeoObjectParam
	ELSE
		INSERT INTO 
			gisWKBSettlement (idfsGeoObject, geomShape, intElevation)
		VALUES (@idfsGeoObjectParam, @geom, @intElevationParam)
'
	exec sp_executesql @cmd, N'@idfsGeoObjectParam bigint', @idfsGeoObjectParam = @idfsGeoObject

	set	@cmd = N'
	SET QUOTED_IDENTIFIER OFF; 
'	
	exec sp_executesql @cmd

END



