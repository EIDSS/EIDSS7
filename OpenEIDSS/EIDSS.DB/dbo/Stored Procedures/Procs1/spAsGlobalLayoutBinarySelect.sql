

--##SUMMARY select layout settings for analytical module from GLOBAL table


--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 16.07.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsGlobalLayoutBinarySelect  56370830000000
*/ 
 
create PROCEDURE [dbo].[spAsGlobalLayoutBinarySelect]
	 @idfsLayout		bigint 
AS
BEGIN


	select	 idfsLayout
			,blbChartGeneralSettings
			,blbGisLayerGeneralSettings
			,blbGisMapGeneralSettings
			,blbPivotGridSettings
			,intGisLayerPosition
			,intPivotGridXmlVersion
		  
	from	dbo.tasglLayout	
	where	idfsLayout = @idfsLayout

END



