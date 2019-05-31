

--##SUMMARY select layout settings for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.07.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsLayoutBinarySelect  56370830000000
*/ 
 
create PROCEDURE [dbo].[spAsLayoutBinarySelect]
	 @idflLayout		bigint 
AS
BEGIN


	select	 idflLayout
			,blbChartGeneralSettings
			,blbGisLayerGeneralSettings
			,blbGisMapGeneralSettings
			,blbPivotGridSettings
			,intGisLayerPosition
			,intPivotGridXmlVersion
		  
	from	dbo.tasLayout	
	where	idflLayout = @idflLayout

END



