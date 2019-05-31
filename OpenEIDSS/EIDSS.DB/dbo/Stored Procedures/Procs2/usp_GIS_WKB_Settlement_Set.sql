




--=====================================================================================================
-- Created by:				Mark Wilson
-- Description:				07/10/2017: Created based on V6 usp_Settlement_Set : V7 USP86
--
-- removed call to sp_executesql
-- 
--
-- previous name             new name
--
--  --> usp_GIS_WKB_Settlement_Set
--=====================================================================================================

-- =============================================
-- Author:		<Timur Kobilov>
-- Create date: <18.08.2010>
-- Description:	<Create geometry in gisWKBSettlement on the basis of coordinates from gisSettlement>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GIS_WKB_Settlement_Set] 
	@idfsGeoObject BIGINT
AS
BEGIN

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
	WHERE (idfsSettlement = @idfsGeoObject)
	SET @intSRID = 3857 --4326
	
	SET @dblLon = @dblLon*PI()/180
	SET @dblLat = @dblLat*PI()/180
	
	SET @dblX = @dblA*@dblLon
	
	SET @dblY = @dblA*LOG(TAN(PI()/4 + @dblLat/2))
	
	SET @geom = geometry::Point(@dblX, @dblY, @intSRID)

	IF EXISTS(SELECT * FROM gisWKBSettlement WHERE idfsGeoObject=@idfsGeoObject)
		UPDATE gisWKBSettlement
			SET geomShape = @geom, intElevation = @intElevationParam
			WHERE  idfsGeoObject=@idfsGeoObject
	ELSE
		INSERT INTO 
			gisWKBSettlement (idfsGeoObject, geomShape, intElevation)
		VALUES (@idfsGeoObject, @geom, @intElevationParam)

	SET QUOTED_IDENTIFIER OFF; 


END






