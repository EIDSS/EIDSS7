

--##SUMMARY This procedure deletes records related to specified query.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 21.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spQuery_Delete @ID=30990001100
				
*/ 


create procedure	[dbo].[spQuery_Delete]
	@ID bigint
as

declare	@QueryDescriptionID	bigint
declare	@FunctionName		varchar(200)

select	@FunctionName = strFunctionName,
		@QueryDescriptionID = idflDescription
from	tasQuery
where	idflQuery = @ID


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

delete		lsf_date
from		tasLayoutSearchField lsf_date
inner join	tasLayoutSearchField lsf
on			lsf.idfLayoutSearchField = lsf_date.idfDateLayoutSearchField
inner join	tasQuerySearchField qsf
on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qsf.idfQuerySearchObject

--delete		lsf_denominator
--from		tasLayoutSearchField lsf_denominator
--inner join	tasLayoutSearchField lsf
--on			lsf.idfLayoutSearchField = lsf_denominator.idfDenominatorQuerySearchField
--inner join	tasQuerySearchField qsf
--on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
--inner join	#DelQSO qso_del
--on			qso_del.idfQuerySearchObject = qsf.idfQuerySearchObject

delete		lsf_unit
from		tasLayoutSearchField lsf_unit
inner join	tasLayoutSearchField lsf
on			lsf.idfLayoutSearchField = lsf_unit.idfUnitLayoutSearchField
inner join	tasQuerySearchField qsf
on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
inner join	#DelQSO qso_del
on			qso_del.idfQuerySearchObject = qsf.idfQuerySearchObject

delete		lsf
from		tasLayoutSearchField lsf
inner join	tasQuerySearchField qsf
on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
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
    

select		cast(idflLayoutFolder as bigint) as idflLayoutFolder into	#DelLayoutFolder
from		tasLayoutFolder
where		idflQuery = @ID

delete		lf
from		tasLayoutFolder lf
inner join	#DelLayoutFolder lf_del
on			lf_del.idflLayoutFolder = lf.idflLayoutFolder

delete		lsnt
from		locStringNameTranslation lsnt
inner join	#DelLayoutFolder lf_del
on			lf_del.idflLayoutFolder = lsnt.idflBaseReference

delete		lbr
from		locBaseReference lbr
inner join	#DelLayoutFolder lf_del
on			lf_del.idflLayoutFolder = lbr.idflBaseReference

drop table	#DelLayoutFolder


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


