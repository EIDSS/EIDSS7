
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/13/2017
-- Last modified by:		Joan Li
-- Description:				06/13/2017: Created based on V6 spStatistic_SelectCount:  V7 usp51
--                          Selects count  from table:tlbStatistic
/*
----testing code:
EXECUTE usp_Statistic_GetCount
*/

--=====================================================================================================

create procedure	[dbo].[usp_Statistic_GetCount]
as

	select	COUNT(*) 
	FROM	dbo.tlbStatistic
	WHERE	intRowStatus = 0


