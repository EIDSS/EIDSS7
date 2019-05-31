

--##SUMMARY Selects lookup list of search objects.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 20.04.2010

--##RETURNS Doesn't use

/*
--Example of procedure call:
exec spAsSearchObject_SelectLookup 'en'

*/ 
CREATE          PROCEDURE dbo.spAsSearchObject_SelectLookup
	@LangID	as nvarchar(50) --##PARAM @LangID - language ID
as

select		tasSearchObject.idfsSearchObject,
			sobRef.[name],
			tasSearchObject.blnPrimary,
			tasSearchObject.idfsFormType,
			sobRef.intHACode
from		tasSearchObject
inner join	fnReference(@LangID, 19000082) sobRef  --'rftSearchObject'
on			sobRef.idfsReference = tasSearchObject.idfsSearchObject
order by	sobRef.[name]



