
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/19/2017
-- Last modified by:		Joan Li
-- Description:				06/19/2017: Created based on V6 spHACode_SelectCheckList :  V7 USP67
--                          select list of records from the following tables:trtHACodeListand fnReference
--                          Type id 19000040: Accessory List Type
--                          Type id 19000041: Patient Location Type
/*
----testing code:
exec usp_HACode_GetCheckList 'en', 128  ---64 avian
----related fact data from
select * from trtHACodeList  
select * from trtBaseReference where idfsreferencetype in (19000040,19000041)
*/

--=====================================================================================================

CREATE       PROCEDURE [dbo].[usp_HACode_GetCheckList]
	@LangID As nvarchar(50),
	@intHACodeMask int = 226 --Human, Livestock, Avian, Vector
AS

	select dbo.trtHACodeList.intHACode, HACodeName.[name] as CodeName, trtHACodeList.intRowStatus 
	from dbo.trtHACodeList 
	left join fnReference(@LangID,19000040) as HACodeName  --'rftHA_Code_List'
	on HACodeName.idfsReference=dbo.trtHACodeList.idfsCodeName
	WHERE 
		dbo.trtHACodeList.intHACode & @intHACodeMask >0
		and dbo.trtHACodeList.idfsCodeName <> 10040001 --All

