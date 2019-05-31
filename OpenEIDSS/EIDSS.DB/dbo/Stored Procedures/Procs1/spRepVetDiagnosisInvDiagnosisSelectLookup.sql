

--##SUMMARY This procedure 

--##REMARKS Author: 
--##REMARKS Create date: 

--##RETURNS Don't use 

/*
--Example of a call of procedure:

exec spRepVetDiagnosisInvDiagnosisSelectLookup 'en'

*/ 
 
CREATE PROCEDURE [dbo].[spRepVetDiagnosisInvDiagnosisSelectLookup]
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
--		-- D
--		inner join	tlbAggrDiagnosticActionMTX d
--		on			d.idfAggrDiagnosticActionMTX = v.idfRow
--					and d.intRowStatus = 0
--					and cast(v.varValue as bigint) = d.idfsDiagnosis
--		inner join	fnReferenceRepair(@LangID, 19000019) r
--		on			r.idfsReference = cast(v.varValue as bigint)
--
--		where		h.idfsAggrCaseSection = 71460000000
--					and h.blnIsActive = 1
--					and h.intRowStatus = 0
--					and v.idfsParameter = 226930000000
		from		fnReferenceRepair(@LangID, 19000019) r
		inner join	trtDiagnosis d
		on			d.idfsDiagnosis = r.idfsReference
					and d.idfsUsingType = 10020002	-- Aggregate Case
					and d.intRowStatus = 0
		where		(	r.intHACode is null
						or	(r.intHACode & 32 > 0)
						or	(r.intHACode & 64 = 0)
					)
		order by	r.intOrder, r.[name], r.idfsReference

END

