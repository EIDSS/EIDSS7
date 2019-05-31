
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/01/2017
-- Last modified by:		Joan Li
-- Description:				06/01/2017:Created based on V6 spSettlement_SelectCount: rename for V7 USP45
--                                     Select count(*) from gisBaseReference
-- Testing code:
/*
----testing code:
EXEC usp_Settlement_GetCount 
	
*/
--=====================================================================================================
create procedure	[dbo].[usp_Settlement_GetCount]

as



select	COUNT(*) 

from	dbo.gisBaseReference

where	idfsGISReferenceType = 19000004  ----JL: gisReference: rftSettlement


	AND intRowStatus = 0
