

--##SUMMARY This procedure selects all sub-queries for specied query.
--##SUMMARY If the query is not specified, it returns all subqueries used in all queries.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 21.06.2015

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID				bigint
execute	spAsSubQuerySelectLookup @ID

*/ 


CREATE procedure	[dbo].[spAsSubQuerySelectLookup]
(
	@LangID	as nvarchar(50),		--##PARAM @LangID - System identifier of the output language
	@ID			as bigint = null	--##PARAM @ID - System identifier of the query to select sub-queries (nullable)
)
as

select	distinct
			q.idflQuery,
			q.strFunctionName as strQueryFunctionName,
			subquery.idflQuery as idflSubQuery,
			subquery.strFunctionName as strSubQueryFunctionName
from		tasQueryConditionGroup qcg
inner join	tasQuerySearchObject qso
on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
inner join	tasQuery q
on			q.idflQuery = qso.idflQuery
			and q.blnSubQuery = 0
inner join	tasQuerySearchObject qso_subquery
on			qso_subquery.idfQuerySearchObject = qcg.idfSubQuerySearchObject
inner join	tasQuery subquery
on			subquery.idflQuery = qso_subquery.idflQuery
			and subquery.blnSubQuery = 1
where		(q.idflQuery = @ID or @ID is null)


