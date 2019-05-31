


--##SUMMARY This procedure deletes all query condition groups and search fields conditions 
--##SUMMARY of specified query search object.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 20.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@idfQuerySearchObject			bigint

execute	spAsQuerySearchObject_DeleteConditions	@idfQuerySearchObject

*/ 


CREATE procedure	[dbo].[spAsQuerySearchObject_DeleteConditions]
(
	@idfQuerySearchObject			bigint
)
as

delete		qsfc
from		tasQuerySearchFieldCondition qsfc
inner join	tasQueryConditionGroup qcg
on			qcg.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
where		qcg.idfQuerySearchObject = @idfQuerySearchObject

delete		qcg
from		tasQueryConditionGroup qcg
where		qcg.idfQuerySearchObject = @idfQuerySearchObject


return 0


