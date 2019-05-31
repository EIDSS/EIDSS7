

--##SUMMARY Selects lookup tree of search tables used as source tables of search fields.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.01.2012

--##RETURNS Doesn't use

/*
--Example of procedure call:
exec spAsFieldSourceTableSelectLookup 'en'

*/ 
CREATE          PROCEDURE dbo.spAsFieldSourceTableSelectLookup
	@LangID	as nvarchar(50) --##PARAM @LangID - language ID
as
select		cast(sf.idfsSearchField as varchar(100)) + '__' + 
				cast(st_union.idfSearchTable as varchar(100)) as idfFieldSourceTableTree,
			st_union.idfSearchTable as idfUnionSearchTable,
			sf.idfsSearchField,
			st.idfSearchTable as idfFieldSourceTable,
			st.strTableName as strFieldSourceTableName,
			st.strFrom as strFieldSourceFrom,
			st.intTableCount as intFieldSourceTableCount,
			st.blnPrimary as blnFieldSourcePrimary
from		tasSearchField sf
inner join	fnReference(@LangID, 19000080) sf_ref	-- 'rftSearchField'
on			sf_ref.idfsReference = sf.idfsSearchField
inner join	tasFieldSourceForTable fst
on			fst.idfsSearchField = sf.idfsSearchField
inner join	tasSearchTable st_union
on			st_union.idfSearchTable = fst.idfUnionSearchTable
inner join	tasSearchTable st
on			st.idfSearchTable = fst.idfSearchTable
where		sf.intRowStatus = 0


