

-- =============================================
-- Author:		Nikulin, Evgeniy
-- Create date: 26.07.2010
-- Updated: 16.01.2012
-- Description:	update user db layer metadata
-- Dependences:  
--	  Tables: dbo.gisUserLayer 
-- =============================================


CREATE PROCEDURE [dbo].[spGisUpdateUserLayerMetadata] 
	@LAYERID uniqueidentifier,		--Layer Id
	@Name  NVARCHAR(250),		--Layer name
	@STYLE	XML,				--Layer style
	@THEME	XML,				--Layer theme
	@DESC	NVARCHAR(350)		--Layer description		
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE	dbo.gisUserLayer 
		SET strName=@Name, 
			LastModifiedDate=GETUTCDATE(), 
			strDescription=@DESC, 
			xmlStyle=@STYLE,
			xmlTheme=@THEME

	WHERE	guidLayer=@LAYERID
END


