

-- =============================================
-- Author:		Nikulin, Evgeniy
-- Create date: 22.07.2010
-- Description:	Insert new user feature in the layer
-- Dependences:  
--	  Tables: dbo.gisUserFeature 
--			  dbo.gisUserLayer (inderectly)
-- =============================================


create PROCEDURE [dbo].[spGisUpdateUserFeature] 
	@FEATUREID BIGINT,			--Feature Id for update
	@Name  NVARCHAR(256),		--Feature name
	@DESC	NVARCHAR(500),		--Feature description
	@RADIUS	REAL,				--Feature radius
	@GEOMETRY IMAGE,			--Feature geometry
	@ENVMINX  REAL,				--Envelope coord...
	@ENVMINY REAL,
	@ENVMAXX REAL,
	@ENVMAXY REAL	
AS
BEGIN
	SET NOCOUNT ON;
	select 1
/*	UPDATE dbo.gisUserFeature 
		SET strName=@Name,
			strDescription=@DESC,
			dblRadius=@RADIUS, 
			blbWKBGeometry=@GEOMETRY, 
			dblEnvelopeMinX=@ENVMINX, 
			dblEnvelopeMinY=@ENVMINY, 
			dblEnvelopeMaxX=@ENVMAXX, 
			dblEnvelopeMaxY=@ENVMAXY
	WHERE
			idfFeature=@FEATUREID*/
END


