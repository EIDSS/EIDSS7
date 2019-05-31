





--exec spHACode_SelectCheckList 'en', 128
--select * from fnReference('en',19000040)


CREATE       PROCEDURE dbo.spHACode_SelectCheckList
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
	--dbo.trtHACodeList.idfsCodeName=10040003 --'hacAvian' 
	--OR dbo.trtHACodeList.idfsCodeName=10040007 --'hacLivestock'
	--OR dbo.trtHACodeList.idfsCodeName=10040005 --'hacHuman'
	--OR dbo.trtHACodeList.idfsCodeName=10040011 --'Vector'



