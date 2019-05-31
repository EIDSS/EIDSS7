
--##SUMMARY This procedure deletes all subqueries, subqueries search objects and subqueries related with specified query 
--##SUMMARY Should be calle before query posting, because subqueries are recreated during each query post
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 26.01.2014

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID	bigint
set @ID = 18710001100
exec spAsQuery_DeleteSubqueries @ID
*/ 
 
CREATE PROCEDURE [dbo].[spAsQuery_DeleteSubqueries]
	@idfParentQuerySearchObject bigint
AS

declare	@SubQueryToDel	table
(	idflQuery					bigint not null,
	idfRootQuerySearchObject	bigint not null primary key
)

insert into	@SubQueryToDel
(	idflQuery,
	idfRootQuerySearchObject
)
select		q.idflQuery,
			qso.idfQuerySearchObject
from		tasQuerySearchObject qso
inner join	tasQuery q
on			q.idflQuery = qso.idflQuery
			and IsNull(q.blnSubQuery, 0) = 1
inner join	tasQueryConditionGroup qcg_parent
on			qcg_parent.idfSubQuerySearchObject = qso.idfQuerySearchObject
inner join	tasQuerySearchObject qso_parent
on			qso_parent.idfQuerySearchObject = qcg_parent.idfQuerySearchObject
inner join	tasQuery q_parent
on			q_parent.idflQuery = qso_parent.idflQuery
			and IsNull(q_parent.blnSubQuery, 0) = 0
			and qso_parent.idfQuerySearchObject = @idfParentQuerySearchObject


delete		qsfc
from		tasQuerySearchFieldCondition qsfc
inner join	tasQuerySearchField qsf
on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qsf.idfQuerySearchObject

delete		qsfc
from		tasQuerySearchFieldCondition qsfc
inner join	tasQueryConditionGroup qcg
on			qcg.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qcg.idfQuerySearchObject

delete		qcg
from		tasQueryConditionGroup qcg
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qcg.idfQuerySearchObject

delete		qsf
from		tasQuerySearchField qsf
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qsf.idfQuerySearchObject

delete		qcg_parent
from		tasQueryConditionGroup qcg_parent
inner join	tasQuerySearchObject qso_parent
on			qso_parent.idfQuerySearchObject = qcg_parent.idfQuerySearchObject
			and qso_parent.idfQuerySearchObject = @idfParentQuerySearchObject
inner join	tasQuery q_parent
on			q_parent.idflQuery = qso_parent.idflQuery
			and IsNull(q_parent.blnSubQuery, 0) = 0
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qcg_parent.idfSubQuerySearchObject

delete		qso
from		tasQuerySearchObject qso
inner join	@SubQueryToDel subq_del
on			subq_del.idfRootQuerySearchObject = qso.idfQuerySearchObject


delete		q
from		tasQuery q
inner join	@SubQueryToDel subq_del
on			subq_del.idflQuery = q.idflQuery


RETURN 0

