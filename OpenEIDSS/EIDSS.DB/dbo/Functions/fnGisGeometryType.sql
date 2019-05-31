CREATE function [dbo].[fnGisGeometryType]( @p_geom geometry )
  Returns varchar(MAX)
As
Begin
  Declare @v_geomn        Int
	, @v_GeometryType varchar(100)
	, @v_return       varchar(MAX)

    If ( @p_geom is NULL ) 
      return NULL;

    SET @v_GeometryType = @p_geom.STGeometryType();

    IF ( @v_GeometryType <> 'GeometryCollection' )
      SET @v_return = @v_GeometryType
    ELSE
    BEGIN
	  SET @v_geomn  = 1;
	  SET @v_return = 'GeometryCollection';
	  WHILE ( @v_geomn <= @p_geom.STNumGeometries() )
	  BEGIN
	    SET @v_GeometryType = @p_geom.STGeometryN(@v_geomn).STGeometryType();
	    IF ( CHARINDEX(':' + @v_GeometryType,@v_return) = 0 )
		  SET @v_return = @v_return + ':' + @v_GeometryType;
		SET @v_geomn = @v_geomn + 1;
	  END
    END;
    RETURN @v_return;

End