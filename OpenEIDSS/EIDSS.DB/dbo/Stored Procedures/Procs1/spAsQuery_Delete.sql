

--##SUMMARY This procedure deletes records related to specified query.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 21.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 22.07.2015

--##RETURNS Don't use


/*
--Example of a call of procedure:
begin tran

select *
from tasQuery tq
where tq.blnSubQuery = 1
exec spAsQuery_Delete @ID = 8210000870




select *
from tasQuery tq
where tq.blnSubQuery = 1

rollback tran

				
*/ 


create procedure	[dbo].[spAsQuery_Delete]
	@ID bigint
as

declare	@QueryDescriptionID	bigint
declare	@FunctionName		varchar(200)

select	@FunctionName = strFunctionName,
		@QueryDescriptionID = idflDescription
from	tasQuery
where	idflQuery = @ID


--deleting Layouts
declare @idflLayout bigint
DECLARE LayoutDelete_Cursor CURSOR FOR 
	select	cast(idflLayout as bigint) as idflLayout 
	from		tasLayout
	where		idflQuery = @ID

OPEN LayoutDelete_Cursor;
FETCH NEXT FROM LayoutDelete_Cursor INTO @idflLayout;

WHILE @@FETCH_STATUS = 0
BEGIN
	exec [dbo].[spAsLayout_Delete]  @idflLayout 
	FETCH NEXT FROM LayoutDelete_Cursor INTO @idflLayout;
END;

CLOSE LayoutDelete_Cursor;
DEALLOCATE LayoutDelete_Cursor;

--deleting Folders 
declare @idflLayoutFolder bigint 

declare @Folders table (idflFolder bigint primary key)
insert into @Folders (idflFolder)
select 
	tlf.idflLayoutFolder
from tasLayoutFolder tlf
where tlf.idflQuery = @ID
and tlf.idflParentLayoutFolder is null

declare fcur cursor local forward_only for
select f.idflFolder
from @Folders f

open fcur

fetch next from fcur into @idflLayoutFolder

while @@FETCH_STATUS = 0 
begin
	exec spAsFolder_Delete @idflLayoutFolder 
	fetch next from fcur into @idflLayoutFolder
end

close fcur
deallocate fcur
-- END deleting Folders 

-- Get Query Search Objects
select	cast(idfQuerySearchObject as bigint) as idfQuerySearchObject into #DelQSO
from	tasQuerySearchObject
where	idflQuery = @ID


declare @GoOn int
set @GoOn = 1

while @GoOn > 0
begin
	insert into		#DelQSO
	select distinct	qso.idfQuerySearchObject
	from			tasQuerySearchObject qso
	inner join		#DelQSO qso_parent
	on				qso_parent.idfQuerySearchObject = qso.idfParentQuerySearchObject
	left join		#DelQSO qso_ex
	on				qso_ex.idfQuerySearchObject = qso.idfQuerySearchObject
	where			qso_ex.idfQuerySearchObject is NULL

	set @GoOn = @@rowcount
end

--select * from #DelQSO

--Get Query condition groups
select		cast(idfQueryConditionGroup as bigint) as idfQueryConditionGroup into #DelQCG
from		tasQueryConditionGroup qcg
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qcg.idfQuerySearchObject

set @GoOn = 1
while @GoOn > 0
begin
	insert into		#DelQCG
	select distinct	qcg.idfQueryConditionGroup
	from			tasQueryConditionGroup qcg
	inner join		#DelQCG qcg_parent
	on				qcg_parent.idfQueryConditionGroup = qcg.idfParentQueryConditionGroup
	left join		#DelQCG qcg_ex
	on				qcg_ex.idfQueryConditionGroup = qcg.idfQueryConditionGroup
	where			qcg_ex.idfQueryConditionGroup is NULL

	set @GoOn = @@rowcount
end

--select * from #DelQCG

--delete  subqueries
declare @idfQuerySearchObject bigint 

declare subqcur cursor local forward_only for
select idfQuerySearchObject
from #DelQSO

open subqcur

fetch next from subqcur into @idfQuerySearchObject

while @@FETCH_STATUS = 0
begin
	exec [spAsQuery_DeleteSubqueries] @idfParentQuerySearchObject = @idfQuerySearchObject
	fetch next from subqcur into @idfQuerySearchObject
end

close subqcur
deallocate subqcur
--END delete  subqueries


delete		qsfc
from		tasQuerySearchFieldCondition qsfc
inner join	#DelQCG qcg_del
on			qcg_del.idfQueryConditionGroup = qsfc.idfQueryConditionGroup

delete		qcg
from		tasQueryConditionGroup qcg
inner join	#DelQCG qcg_del
on			qcg_del.idfQueryConditionGroup = qcg.idfQueryConditionGroup

drop table	#DelQCG

delete		qsfc
from		tasQuerySearchFieldCondition qsfc
inner join	tasQuerySearchField qsf
on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qsf.idfQuerySearchObject


delete		qsf
from		tasQuerySearchField qsf
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qsf.idfQuerySearchObject

delete		qso
from		tasQuerySearchObject qso
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qso.idfQuerySearchObject

drop table	#DelQSO


delete from	tasQuery
where		idflQuery = @ID

if @ID is not null
begin
	execute	spAsReferenceDelete @ID
end

if @QueryDescriptionID is not null
begin
	execute	spAsReferenceDelete @QueryDescriptionID
end

if @FunctionName is not null
begin
	declare @sqlCmd nvarchar(2000)
	set @sqlCmd = '
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[' + @FunctionName + ']'') AND Type in (N''FN'', N''IF'', N''TF'', N''FS'', N''FT''))
DROP FUNCTION [dbo].[' + @FunctionName + ']
'
	exec sp_executesql @sqlCmd
end


