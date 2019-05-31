


--##SUMMARY This procedure selects the list of search objects' relations utilized for sub-queries.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 29.01.2014

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsSearchObjectToSearchObjectForSubQuery_SelectLookup 'en'

*/ 

create procedure	spAsSearchObjectToSearchObjectForSubQuery_SelectLookup
	@LangID	as nvarchar(50),
	@ID			as bigint = null
as


select		
			cast(sobChild.idfsSearchObject as varchar(20)) + '__' + cast(sobParent.idfsSearchObject as varchar(20)) as SearchObjectToSearchObjectId,
			sobChild.idfsSearchObject as idfsChildSearchObject,
			sobParent.idfsSearchObject as idfsParentSearchObject,
			N'<' + sobChildRef.[name] + N'>' as ChildSearchObjectName

from		tasSearchObjectToSearchObject sob_to_sob

inner join	tasSearchObject sobParent
on			sobParent.idfsSearchObject = sob_to_sob.idfsParentSearchObject

inner join	(
	tasSearchObject sobChild
	inner join	fnReference(@LangID, 19000082) sobChildRef			-- 'rftSearchObject'
	on			sobChildRef.idfsReference = sobChild.idfsSearchObject
			)
on			sobChild.idfsSearchObject = sob_to_sob.idfsRelatedSearchObject

where		sob_to_sob.blnUseForSubQuery = 1
			and	(@ID is null or @ID = sobParent.idfsSearchObject)

order by	sobChildRef.[name], sobChild.idfsSearchObject


