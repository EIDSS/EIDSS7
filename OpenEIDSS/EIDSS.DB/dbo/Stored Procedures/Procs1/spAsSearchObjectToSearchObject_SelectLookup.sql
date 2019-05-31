


--##SUMMARY This procedure selects the list of search objects' relations.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 21.04.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:
exec spAsSearchObjectToSearchObject_SelectLookup 'en'

*/ 

create procedure	spAsSearchObjectToSearchObject_SelectLookup
	@LangID	as nvarchar(50),
	@ID			as bigint = null
as


select		sobPrimary.idfsSearchObject as idfsParentSearchObject,
			sobPrimaryRef.[name] as ParentSearchObjectName,
			sobChild.idfsSearchObject as idfsChildSearchObject,
			sobChildRef.[name] as ChildSearchObjectName

from		tasSearchObjectToSearchObject sob_to_sob

inner join	(
	tasSearchObject sobPrimary
	inner join	fnReference(@LangID, 19000082) sobPrimaryRef		-- 'rftSearchObject'
	on			sobPrimaryRef.idfsReference = sobPrimary.idfsSearchObject
			)
on			sobPrimary.idfsSearchObject = sob_to_sob.idfsParentSearchObject
			and sobPrimary.blnPrimary = 1

inner join	(
	tasSearchObject sobChild
	inner join	fnReference(@LangID, 19000082) sobChildRef			-- 'rftSearchObject'
	on			sobChildRef.idfsReference = sobChild.idfsSearchObject
			)
on			sobChild.idfsSearchObject = sob_to_sob.idfsRelatedSearchObject

where		(sobPrimary.idfsSearchObject <> sobChild.idfsSearchObject)
			and	(@ID is null or @ID = sobPrimary.idfsSearchObject)

order by	sobPrimaryRef.[name], sobPrimary.idfsSearchObject, 
			sobChildRef.[name], sobChild.idfsSearchObject



