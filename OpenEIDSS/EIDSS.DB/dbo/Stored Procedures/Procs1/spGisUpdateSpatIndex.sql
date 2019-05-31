
CREATE Procedure [dbo].[spGisUpdateSpatIndex]
(
 @TableName NVARCHAR(250)
)
AS
BEGIN

SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON; 

DECLARE @DROP nvarchar(5) = 'OFF'
IF EXISTS (SELECT name FROM sys.indexes WHERE name = 'IX_'+@TableName+'_geomShape')
	SELECT @DROP='ON'


DECLARE @sql NVARCHAR(MAX) = ''
SET @sql = '
DECLARE @MinX FLOAT = 0
DECLARE @MinY FLOAT = 0
DECLARE @MaxX FLOAT = 0
DECLARE @MaxY FLOAT = 0

DECLARE @thisGeom geometry;
DECLARE @totalGeom geometry;
DECLARE @firstRow INT = 1 -- Used as BOOLEAN = TRUE

DECLARE GeomCursor CURSOR FAST_FORWARD FOR SELECT geomShape FROM ' + @TableName +'; -- WITH (NOLOCK);
OPEN GeomCursor;
FETCH NEXT FROM GeomCursor INTO @thisGeom;
WHILE @@FETCH_STATUS = 0
    BEGIN
        IF (@firstRow = 1) BEGIN -- First Row Returned
            SET @totalGeom = @thisGeom;
            SET @firstRow = 0; -- FALSE
        END;
        ELSE BEGIN
            SET @totalGeom = ( SELECT @totalGeom.STUnion(@thisGeom).STEnvelope()); -- NB: Envelope of Shape
        END;
        FETCH NEXT FROM GeomCursor INTO @thisGeom;
    END;
CLOSE GeomCursor;
DEALLOCATE GeomCursor;

SELECT @MinX = @totalGeom.STPointN(1).STX, @MinY=@totalGeom.STPointN(1).STY,
  @MaxX=@totalGeom.STPointN(3).STX, @MaxY=@totalGeom.STPointN(3).STY;

DECLARE @internal_sql NVARCHAR(max)

SET @internal_sql = ''
CREATE SPATIAL INDEX [IX_'+@TableName+'_geomShape] ON ' + @TableName + ' (geomShape) USING  GEOMETRY_GRID 
WITH (
BOUNDING_BOX =('' + CAST(FLOOR(@MinX*10000)/10000 AS NVARCHAR(50)) + '', '' + CAST(FLOOR(@MinY*10000)/10000 AS NVARCHAR(50)) + '', '' + CAST(CEILING(@MaxX*10000)/10000 AS NVARCHAR(50)) + '', '' + CAST(CEILING(@MaxY*10000)/10000 AS NVARCHAR(50)) + 
''), GRIDS =(LEVEL_1 = MEDIUM,LEVEL_2 = MEDIUM,LEVEL_3 = MEDIUM,LEVEL_4 = MEDIUM), 
CELLS_PER_OBJECT = 16, SORT_IN_TEMPDB = OFF, DROP_EXISTING = '+@DROP+', ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON)''

EXEC (@internal_sql)
'
EXEC (@sql)
END
