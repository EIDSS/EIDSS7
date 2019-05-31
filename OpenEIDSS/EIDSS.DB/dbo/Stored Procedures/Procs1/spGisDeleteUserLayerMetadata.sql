
-- =============================================
-- Author:		Nikulin, Evgeniy
-- Create date: 26.07.2010
-- Updated: 16.01.2012
-- Description:	Delete user db layer metadata
-- Dependences:  
--	  Tables: dbo.gisUserLayer
-- =============================================


CREATE PROCEDURE [dbo].[spGisDeleteUserLayerMetadata] 
	@LAYERID uniqueidentifier		--ID of LAYER for DELETE
AS
BEGIN
		UPDATE dbo.gisUserLayer 
		SET intDeleted = 1
		WHERE	guidLayer=@LAYERID;
END


