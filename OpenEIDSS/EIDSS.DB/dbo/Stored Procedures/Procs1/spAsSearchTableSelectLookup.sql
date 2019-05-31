

--##SUMMARY Selects lookup tree of search tables.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 24.01.2012

--##RETURNS Doesn't use

/*
--Example of procedure call:
exec spAsSearchTableSelectLookup 'en'

*/ 
CREATE          PROCEDURE dbo.spAsSearchTableSelectLookup
	@LangID	as nvarchar(50) --##PARAM @LangID - language ID
as
select		cast(stjr.idfUnionSearchTable as varchar(100)) + '__' + 
				cast(stjr.idfMainSearchTable as varchar(100)) + '__' + 
				cast(stjr.idfSearchTable as varchar(100)) as idfSearchTableTree,
			stjr.idfMainSearchTable,
			stjr.idfSearchTable,
			stjr.idfParentSearchTable,
			stjr.strJoinCondition,
			st.strTableName,
			st.strFrom,
			st.intTableCount,
			st.blnPrimary,
			stjr.idfUnionSearchTable
from		tasSearchTableJoinRule stjr
inner join	tasSearchTable st
on			st.idfSearchTable = stjr.idfSearchTable
union
select		cast(st_main.idfSearchTable as varchar(100)) + '__' + 
				cast(st_main.idfSearchTable as varchar(100)) + '__' + 
				cast(st_main.idfSearchTable as varchar(100)) as idfSearchTableTree,
			st_main.idfSearchTable as idfMainSearchTable,
			st_main.idfSearchTable,
			null as idfParentSearchTable,
			null as strJoinCondition,
			st_main.strTableName,
			st_main.strFrom,
			st_main.intTableCount,
			st_main.blnPrimary,
			st_main.idfSearchTable as idfUnionSearchTable
from		tasSearchObject so
inner join	trtBaseReference br_so
on			br_so.idfsBaseReference = so.idfsSearchObject
			and br_so.idfsReferenceType = 19000082	-- Search Object
			and br_so.intRowStatus = 0
inner join	tasMainTableForObject mto
on			mto.idfsSearchObject = so.idfsSearchObject
inner join	tasSearchTable st_main
on			st_main.idfSearchTable = mto.idfMainSearchTable
order by	idfSearchTableTree



