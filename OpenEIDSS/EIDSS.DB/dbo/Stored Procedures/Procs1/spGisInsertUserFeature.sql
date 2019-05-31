

-- =============================================
-- Author:		Nikulin, Evgeniy
-- Create date: 22.07.2010
-- Description:	Insert new user feature in the layer
-- Dependences:  
--	  Tables: dbo.gisUserFeature 
--			  dbo.gisUserLayer (inderectly)
-- =============================================


CREATE PROCEDURE [dbo].[spGisInsertUserFeature] 
	@LAYERID BIGINT,			--User Layer Id
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

	--get new id
	declare @ID bigint
	exec dbo.[spgisGetNewID] @ID output

/*	--insert new feature
	INSERT INTO dbo.gisUserFeature 
		(idfFeature, idfLayer, strName, strDescription, dblRadius, blbWKBGeometry, dblEnvelopeMinX, dblEnvelopeMinY, dblEnvelopeMaxX, dblEnvelopeMaxY)
		VALUES (@ID, @LAYERID, @Name, @DESC, @RADIUS, @GEOMETRY, @ENVMINX, @ENVMINY, @ENVMAXX, @ENVMAXY);*/
END


