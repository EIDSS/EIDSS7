

--##SUMMARY This procedure selects the tree of query condition groups 
--##SUMMARY related to specified query search object.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 20.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID	bigint
exec spAsQuerySearchObject_SelectConditionGroupTree @ID, 'en'
*/ 
 
create procedure	[dbo].[spAsQuerySearchObject_SelectConditionGroupTree]
	@ID			bigint,
	@LangID		nvarchar(50)
as
begin

declare	@ConditionGroupTree	table
(	idfID							int not null identity(1, 1) primary key,
	idfParentQueryConditionGroup	bigint null,
	idfQueryConditionGroup			bigint null,
	intOrder						int not null,
	idfQuerySearchObject			bigint not null,
	blnJoinByOr						bit null default (0),
	blnUseNot						bit null default (0),
	idfSubQuerySearchObject			bigint null,
	idfQuerySearchFieldCondition	bigint null,
	SearchFieldConditionText		nvarchar(MAX) collate database_default null default (N''),
	strOperator						nvarchar(200) collate database_default null,
	intOperatorType					int null,
	idfQuerySearchField				bigint null,
	blnFieldConditionUseNot			bit null default (0),
	varValue						sql_variant null
)


;
with	ConditionGroupTree
		(	idfParentQueryConditionGroup,
			idfQueryConditionGroup,
			intOrder,
			idfQuerySearchObject,
			blnJoinByOr,
			blnUseNot,
			idfSubQuerySearchObject,
			strOperator
		)
as	(	select		qcg.idfParentQueryConditionGroup,
					qcg.idfQueryConditionGroup,
					qcg.intOrder,
					qcg.idfQuerySearchObject,
					qcg.blnJoinByOr,
					qcg.blnUseNot,
					qcg.idfSubQuerySearchObject,
					CASE WHEN qcg.idfSubQuerySearchObject IS NOT NULL THEN N'Exists' ELSE null END as strOperator
		from		tasQueryConditionGroup qcg
		where		qcg.idfQuerySearchObject = @ID
					and qcg.idfParentQueryConditionGroup is null
		union all
		select		qcg_child.idfParentQueryConditionGroup,
					qcg_child.idfQueryConditionGroup,
					qcg_child.intOrder,
					qcg_child.idfQuerySearchObject,
					qcg_child.blnJoinByOr,
					qcg_child.blnUseNot,
					qcg_child.idfSubQuerySearchObject,
					CASE WHEN qcg_child.idfSubQuerySearchObject IS NOT NULL THEN N'Exists' ELSE null END as strOperator
		from		tasQueryConditionGroup qcg_child
		inner join	ConditionGroupTree
		on			ConditionGroupTree.idfQueryConditionGroup = qcg_child.idfParentQueryConditionGroup
	)

insert into	@ConditionGroupTree
(	idfParentQueryConditionGroup,
	idfQueryConditionGroup,
	intOrder,
	idfQuerySearchObject,
	blnJoinByOr,
	blnUseNot,
	idfSubQuerySearchObject,
	strOperator
)
select		idfParentQueryConditionGroup,
			idfQueryConditionGroup,
			intOrder,
			idfQuerySearchObject,
			blnJoinByOr,
			blnUseNot,
			idfSubQuerySearchObject,
			strOperator
from		ConditionGroupTree


insert into	@ConditionGroupTree
(	idfParentQueryConditionGroup,
	idfQueryConditionGroup,
	intOrder,
	idfQuerySearchObject,
	blnJoinByOr,
	blnUseNot,
	idfSubQuerySearchObject,
	idfQuerySearchFieldCondition,
	strOperator,
	intOperatorType,
	idfQuerySearchField,
	blnFieldConditionUseNot,
	varValue
)
select		cgt.idfQueryConditionGroup as idfParentQueryConditionGroup,
			CAST(NULL as bigint) AS idfQueryConditionGroup,
			cgt.intOrder,
			cgt.idfQuerySearchObject,
			cgt.blnJoinByOr,
			cgt.blnUseNot,
			cgt.idfSubQuerySearchObject,
			qsfc.idfQuerySearchFieldCondition,
			qsfc.strOperator,
			qsfc.intOperatorType,
			qsfc.idfQuerySearchField,
			qsfc.blnUseNot as blnFieldConditionUseNot,
			qsfc.varValue
from		tasQuerySearchFieldCondition qsfc
inner join	(
	tasQuerySearchField qsf
	left join	fnReference(@LangID, 19000080) sf_ref		-- 'rftSearchField'
	on			sf_ref.idfsReference = qsf.idfsSearchField
			)
on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
inner join	@ConditionGroupTree cgt
on			cgt.idfQueryConditionGroup = qsfc.idfQueryConditionGroup

-- tasQueryConditionGroup
select		
			ROW_NUMBER() OVER	(	ORDER BY	qgt.idfParentQueryConditionGroup, 
												qgt.intOrder, 
												qgt.idfQueryConditionGroup,
												qgt.idfQuerySearchFieldCondition
								) as idfCondition,
			qgt.idfParentQueryConditionGroup,
			qgt.idfQueryConditionGroup,
			qgt.intOrder,
			qgt.idfQuerySearchObject,
			qgt.blnJoinByOr,
			qgt.blnUseNot,
			qgt.idfSubQuerySearchObject,
			qgt.idfQuerySearchFieldCondition,
			qgt.SearchFieldConditionText,
			qgt.strOperator,
			qgt.intOperatorType,
			qgt.idfQuerySearchField,
			qgt.blnFieldConditionUseNot,
			qgt.varValue

from		@ConditionGroupTree qgt

order by	qgt.idfParentQueryConditionGroup, 
			qgt.intOrder, 
			qgt.idfQueryConditionGroup,
			qgt.idfQuerySearchFieldCondition

			
end

