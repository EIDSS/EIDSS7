
--##SUMMARY This procedure selects the list of search objects that can be used as child objects for subqueries.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.10.2013

--##RETURNS Don't use


/*
--Example of a call of procedure:
exec spAsQuery_SelectSubqueries 49540090000000, 'en'

*/ 
CREATE PROCEDURE [dbo].[spAsQuery_SelectSubqueries]
	@ID			as bigint = null, -- query search object ID
	@LangID	as nvarchar(50)
AS
--Select existing subqueries
Select 
	qso_subquery.idflQuery,
	qso_parent.idfsSearchObject as idfParentQuerySearchObject,
	qso_subquery.idfQuerySearchObject,
	qso_subquery.idfsSearchObject
from tasQueryConditionGroup qsc
inner join tasQuerySearchObject qso_parent
	on qso_parent.idfQuerySearchObject = qsc.idfQuerySearchObject
inner join tasQuerySearchObject qso_subquery
	on qsc.idfSubQuerySearchObject = qso_subquery.idfQuerySearchObject
inner join tasQuery q_subquery
	on qso_subquery.idflQuery = q_subquery.idflQuery
where qso_parent.idfQuerySearchObject = @ID
 and q_subquery.blnSubQuery = 1

-- search fields in existing subqueries
-- contains only fields required for search fields posting
select		qsf.idfQuerySearchField,
			qsf.idfQuerySearchObject,
			qsf.idfsSearchField,
			case
				when qsf.idfsParameter is not null
					then	sf.strSearchFieldAlias + '__' + 
							cast(sob.idfsFormType as varchar(20)) + '__' + 
							cast(qsf.idfsParameter as varchar(20))
				else sf.strSearchFieldAlias
			end as FieldAlias,
			qsf.blnShow,
			qsf.idfsParameter
from		tasQuerySearchField qsf
inner join	tasSearchField sf
on			sf.idfsSearchField = qsf.idfsSearchField
inner join	(
	tasQuerySearchObject qso
	inner join	tasSearchObject sob
	on			sob.idfsSearchObject = qso.idfsSearchObject
	inner join	trtBaseReference br_sob
	on			br_sob.idfsBaseReference = sob.idfsSearchObject
				and br_sob.intRowStatus = 0
			)
on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
inner join	tasQuery q
on			q.idflQuery = qso.idflQuery
inner join tasQueryConditionGroup qsc
	on qsc.idfSubQuerySearchObject = qso.idfQuerySearchObject
where qsc.idfQuerySearchObject = @ID 
and q.blnSubQuery = 1



