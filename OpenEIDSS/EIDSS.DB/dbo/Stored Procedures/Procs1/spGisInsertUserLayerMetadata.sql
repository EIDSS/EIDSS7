


-- =============================================
-- Author:		Nikulin, Evgeniy
-- Create date: 26.07.2010
-- Updated: 16.01.2012
-- Description:	Insert new user layer metadata
-- Dependences:  
--	  Tables: dbo.gisUserLayer 
-- =============================================


CREATE PROCEDURE [dbo].[spGisInsertUserLayerMetadata]
	@ID uniqueidentifier,		--Layer Id
	@Name  NVARCHAR(250),		--Layer name
	@UserID BIGINT,				--User Id
	@LayerType INT,				--Type of layer
	@STYLE	XML,				--Layer style
	@THEME	XML,				--Layer theme
	@DESC	NVARCHAR(350),		--Layer description		
	@PIVOTALLAYER INT			--Base layer type
AS
BEGIN
	SET NOCOUNT ON;

	--insert new layer
	INSERT INTO dbo.gisUserLayer 
		(guidLayer, strName, idfUser, CreationDate, LastModifiedDate, intType, xmlStyle, xmlTheme, strDescription, intPivotalLayer)
	VALUES(@ID, @Name, @UserID, GETUTCDATE(), GETUTCDATE(), @LayerType, @STYLE, @THEME, @DESC, @PIVOTALLAYER);
END


