

--##SUMMARY This procedure 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetProphylacticSpeciesSelectLookup 'en'

*/ 
 
CREATE PROCEDURE [dbo].[spRepVetProphylacticSpeciesSelectLookup]
	@LangID			as varchar(36)
AS
BEGIN
	select distinct
		r.idfsReference, 
		r.[name] as strName,
		r.intOrder  

			
--[Commented by Olga because of changes in report specification]			
--		from		tlbAggrMatrixVersionHeader h
--		inner join	tlbAggrMatrixVersion v
--		on			v.idfVersion = h.idfVersion
--					and v.intRowStatus = 0
--
--		-- P
--		inner join	tlbAggrProphylacticActionMTX p
--		on			p.idfAggrProphylacticActionMTX = v.idfRow
--					and p.intRowStatus = 0
--					and cast(v.varValue as bigint) = p.idfsSpeciesType
--		inner join	fnReferenceRepair(@LangID, 19000086) r
--		on			r.idfsReference = cast(v.varValue as bigint)
--
--		where		h.idfsAggrCaseSection = 71300000000
--					and h.blnIsActive = 1
--					and h.intRowStatus = 0
--					and v.idfsParameter = 239050000000
		from		fnReferenceRepair(@LangID, 19000086) r
		inner join	trtSpeciesType st
		on			st.idfsSpeciesType = r.idfsReference
					and st.intRowStatus = 0
		where		(	r.intHACode is null
						or	(r.intHACode & 32 > 0)
						or	(r.intHACode & 64 = 0)
					)
		order by	r.intOrder, r.[name], r.idfsReference

END

