

CREATE FUNCTION [dbo].[fn_SystemFunction_SelectList] 
(	
	-- Add the parameters for the function here
	@LangID nvarchar(100),
	@ModuleName varchar(36)
)
RETURNS TABLE 
AS
RETURN 
(
/*
select Ref.idfsReference,Ref.name, SF.idfsObjectType from fnReferenceRepair(@LangID,'rftSystemFunction') Ref INNER JOIN 
system_function SF ON Ref.idfsReference=SF.idfsSystem_Function
*/
SELECT 
		SF.idfsSystemFunction,
		SF.idfsObjectType,
		SFName.name as SystemFunction
--isnull(Module.name+', '+Module1.name,isnull(Module.name,'')+isnull(Module1.name,'')) as Modules
FROM		trtSystemFunction SF 
LEFT JOIN	fnReferenceRepair(@LangID,19000094) SFName
ON			SFName.idfsReference=SF.idfsSystemFunction
WHERE SF.intRowStatus = 0
/*LEFT OUTER JOIN
BaseReferenceRelation BRR on BRR.idfsParentBaseReference=SF.idfsSystem_Function and BRR.idfsRelatedBaseReference='smdEIDSS' and BRR.intRowStatus <>1 LEFT OUTER JOIN
BaseReferenceRelation BRR1 on BRR1.idfsParentBaseReference=SF.idfsSystem_Function and BRR1.idfsRelatedBaseReference='smdPACS' and BRR1.intRowStatus <>1 LEFT OUTER JOIN
fnReferenceRepair(@LangID,'rftSystemModule') Module on Module.idfsReference=BRR.idfsRelatedBaseReference LEFT OUTER JOIN
fnReferenceRepair(@LangID,'rftSystemModule') Module1 on Module1.idfsReference=BRR1.idfsRelatedBaseReference INNER JOIN
fnReferenceRepair(@LangID,'rftSystemFunction') SFName on SFName.idfsReference=SF.idfsSystem_Function
*/

--@ModuleName IS NULL OR Module.idfsReference= @ModuleName OR Module1.idfsReference= @ModuleName
)



