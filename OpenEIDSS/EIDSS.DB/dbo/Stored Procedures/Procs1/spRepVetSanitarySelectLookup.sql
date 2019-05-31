

--##SUMMARY This procedure 
--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetSanitarySelectLookup 'en'

*/ 
 
CREATE PROCEDURE [dbo].[spRepVetSanitarySelectLookup]
	@LangID			as varchar(36)
AS
BEGIN
	select distinct
		r.idfsReference, 
		r.[name] as strName,
		r.intOrder  

--[Commented by Olga because of changes in report specification]			
--	from  tlbAggrMatrixVersionHeader h
--	inner join tlbAggrMatrixVersion v
--	on   v.idfVersion = h.idfVersion
--	   and v.intRowStatus = 0
--	-- S
--	inner join fnReferenceRepair(@LangID, 19000079) r
--	on   r.idfsReference = cast(v.varValue as bigint)
--
--	where  h.idfsAggrCaseSection = 71260000000
--	   and h.blnIsActive = 1
--	   and h.intRowStatus = 0
--	   and v.idfsParameter = 233190000000
	from		fnReferenceRepair(@LangID, 19000079) r
	inner join	trtSanitaryAction sa
	on			sa.idfsSanitaryAction = r.idfsReference
				and sa.intRowStatus = 0
	order by r.intOrder, r.[name], r.idfsReference

END

