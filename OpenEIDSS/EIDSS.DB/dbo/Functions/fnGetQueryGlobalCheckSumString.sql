
 

--##SUMMARY Returns check sum string of local Layout with format: Layout[1];LayoutSearchField[count];LayoutToMapImage[count];view[count];ViewBand[count];ViewColumn[count]

	

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 12.03.2015

--##RETURNS Returns check sum string of local Query with format: 
-- "Query[1 + count subquerys];QuerySearchObject[count for query + subqueries];QuerySearchField[count for query + subqueries];QueryConditionGroup[count for query + subqueries];QuerySearchFieldCondition[count for query + subqueries]"



/*
Example of function call:

SELECT  dbo.fnGetQueryGlobalCheckSumString (49542660000000) --VetCasesWithSamplesAndTestsReport_Both
*/


create   FUNCTION dbo.fnGetQueryGlobalCheckSumString(
	@idfsQuery bigint --##PARAM @@idfsQuery - Query ID
)
returns nvarchar(max)
as
BEGIN 

-- "Query[1 + count subquerys];QuerySearchObject[count for query + subqueries];QuerySearchField[count for query + subqueries];QueryConditionGroup[count for query + subqueries];QuerySearchFieldCondition[count for query + subqueries]"


declare 
	@intQuery int,
	@intQuerySearchObject int,
	@intQuerySearchField int,
	@intQueryConditionGroup int,
	@intQuerySearchFieldCondition int,
	
	@strQueryCheckSum nvarchar(max)
	
	
	
	declare @QuerySearchObjects table (idfQuerySearchObject bigint primary key)
	
	insert into @QuerySearchObjects (idfQuerySearchObject)
	select idfQuerySearchObject
	from dbo.tasglQuerySearchObject
	where idfsQuery = @idfsQuery 
	union
	select idfQuerySearchObject
	from dbo.tasglQuerySearchObject
	where idfParentQuerySearchObject = @idfsQuery 
	
	declare @QueryConditionGroups table (idfQueryConditionGroup bigint primary key)
	
	
	;with QueryConditionGroupTree as 
	(
		select tqcg.idfQueryConditionGroup, tqcg.idfParentQueryConditionGroup, idfQueryConditionGroup as idfRootQueryConditionGroup
		from tasglQueryConditionGroup tqcg
			inner join @QuerySearchObjects qso
			on qso.idfQuerySearchObject = tqcg.idfQuerySearchObject
		where tqcg.idfParentQueryConditionGroup is null
		union all
		select tqcg.idfQueryConditionGroup, tqcg.idfParentQueryConditionGroup, QCGTree.idfRootQueryConditionGroup
		from tasglQueryConditionGroup tqcg
			inner join @QuerySearchObjects qso
			on qso.idfQuerySearchObject = tqcg.idfQuerySearchObject
			
			inner join QueryConditionGroupTree QCGTree
			on QCGTree.idfQueryConditionGroup = tqcg.idfParentQueryConditionGroup
	)
	insert into @QueryConditionGroups (idfQueryConditionGroup)
	select idfQueryConditionGroup
	from QueryConditionGroupTree
	
	
	--
	select @intQuery = count(*)
	from tasglQuery tq
	where tq.idfsQuery = @idfsQuery
	
	select @intQuery = @intQuery + count(*)
	from @QueryConditionGroups
	inner join tasglQueryConditionGroup tqcg
	on tqcg.idfParentQueryConditionGroup = tqcg.idfQueryConditionGroup
	where tqcg.idfSubQuerySearchObject is not null
	
	--
	select @intQuerySearchObject = count(*) 
	from @QuerySearchObjects	
	
	--
	select @intQuerySearchField = count(*)
	from tasglQuerySearchField tqsf
	inner join @QuerySearchObjects tqso
	on tqso.idfQuerySearchObject = tqsf.idfQuerySearchObject

	--
	select @intQueryConditionGroup = count(*)
	from @QueryConditionGroups
	
	--
	select @intQuerySearchFieldCondition = count(*)
	from tasglQuerySearchFieldCondition tqsfc
	inner join @QueryConditionGroups qcg
	on qcg.idfQueryConditionGroup = tqsfc.idfQueryConditionGroup
	
		
	select @strQueryCheckSum = 
	'Query[' + cast(@intQuery as varchar(20)) + '];' + 
	'QuerySearchObject[' + cast(@intQuerySearchObject as varchar(20)) + '];' +
	'QuerySearchField[' + cast(@intQuerySearchField as varchar(20)) + '];' +
	'QueryConditionGroup[' + cast(@intQueryConditionGroup as varchar(20)) + '];' +
	'QuerySearchFieldCondition[' + cast(@intQuerySearchFieldCondition as varchar(20)) + ']'
	
	RETURN @strQueryCheckSum
	
END	
