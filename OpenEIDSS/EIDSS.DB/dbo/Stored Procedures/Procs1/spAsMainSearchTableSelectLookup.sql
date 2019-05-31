

--##SUMMARY Selects lookup tree of search tables used as main tables of search objects.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.01.2012

--##RETURNS Doesn't use

/*
--Example of procedure call:
exec spAsMainSearchTableSelectLookup 'en'

*/ 
CREATE          PROCEDURE dbo.spAsMainSearchTableSelectLookup
	@LangID	as nvarchar(50) --##PARAM @LangID - language ID
as
select		cast(so.idfsSearchObject as varchar(100)) + '__' + 
				cast(st_main.idfSearchTable as varchar(100)) as idfMainSearchTableTree,
			so.idfsSearchObject,
			st_main.idfSearchTable as idfMainSearchTable,
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
where		so.intRowStatus = 0
order by	idfMainSearchTableTree


