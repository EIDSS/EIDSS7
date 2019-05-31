

--##SUMMARY This procedure saves changes of specified sub-query and its root object
--##SUMMARY (including creation and deletion of related objects in case of modification of root object).

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 30.01.2014

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@idflSubQuery				bigint
declare	@idfSubQuerySearchObject	bigint
declare	@idfsSearchObject			bigint
declare	@strFunctionName			nvarchar(200)
declare	@idflSubQueryDescription	bigint

execute	spAsSubQuery_PostWithRootObject
		 @idflSubQuery output
		,@idfSubQuerySearchObject output
		,@idfsSearchObject
		,@strFunctionName output
		,@idflSubQueryDescription output

*/ 


CREATE procedure	[dbo].[spAsSubQuery_PostWithRootObject]
(
	@idflSubQuery				bigint = -1 output,
	@idfSubQuerySearchObject	bigint = -1 output,
	@idfsSearchObject			bigint,
	@strFunctionName			nvarchar(200) = null output,
	@idflSubQueryDescription	bigint = null output
)
as

declare	@DefFunctionNamePrefix varchar(50)
declare	@FunctionNameIndex int
declare @NewFunctionName varchar(200)


declare	@blnSubQuery int
set	@blnSubQuery = -1

select	@blnSubQuery = cast(IsNull(q.blnSubQuery, 0) as int)
from	tasQuery q
where	q.blnSubQuery = @idflSubQuery

if @blnSubQuery = 0 or @idfsSearchObject is null
begin
	set	@idflSubQuery = -1
	set	@idfSubQuerySearchObject = -1
	set	@strFunctionName = null
	set	@idflSubQueryDescription = null
end	


if	not exists	(
			select	*
			from	tasQuery q
			where	q.idflQuery = @idflSubQuery
				)
begin
	-- Generate new IDs for query and its description
	execute	spsysGetNewID	@idflSubQuery output
	execute	spsysGetNewID	@idflSubQueryDescription output

	-- Save local BR related to query description
	insert into	locBaseReference
	(	idflBaseReference
	)
	values
	(	@idflSubQueryDescription
	)

	-- Save local BR related to query
	insert into	locBaseReference
	(	idflBaseReference
	)
	values
	(	@idflSubQuery
	)

	-- Generate unique name of the query function
	select top 1	@DefFunctionNamePrefix = 'fn' + s.strSiteID + 'SubQuery__' + cast(@idflSubQuery as varchar(30))
	from			tstSite s
	inner join		tstLocalSiteOptions lso
	on				lso.strName = N'SiteID'
					and lso.strValue = cast(s.idfsSite as nvarchar(200))
	where			s.intRowStatus = 0

	set @FunctionNameIndex = 0
	set @NewFunctionName = @DefFunctionNamePrefix

	while	exists
			(	select	*
				from	dbo.sysobjects
				where	xtype in ('IF','FN','TF')
						and category = 0
						and [name] = @NewFunctionName
			)
			or exists
				(	select	*
					from	tasQuery
					where	strFunctionName = @NewFunctionName
				)
	begin
		set @FunctionNameIndex = @FunctionNameIndex + 1
		set @NewFunctionName = @DefFunctionNamePrefix + '__' + cast(@FunctionNameIndex as varchar(100))
	end

	set	@strFunctionName = @NewFunctionName

	-- Create query
	insert into	tasQuery
	(	idflQuery,
		strFunctionName,
		idflDescription,
		blnReadOnly,
		blnAddAllKeyFieldValues,
		blnSubQuery
	)
	values
	(	@idflSubQuery,
		@strFunctionName,
		@idflSubQueryDescription,
		0,
		0,
		1
	)

	-- Create root search object
	execute	spsysGetNewID	@idfSubQuerySearchObject output

	insert into	tasQuerySearchObject
	(
		idfQuerySearchObject,
		idflQuery,
		idfsSearchObject,
		intOrder,
		idfsReportType,
		idfParentQuerySearchObject
	)
	values
	(
		@idfSubQuerySearchObject,
		@idflSubQuery,
		@idfsSearchObject,
		0,
		null,
		null
	)
	
end
else begin
	
	if	not exists	(
				select	*
				from	locBaseReference lbr
				where	lbr.idflBaseReference = @idflSubQueryDescription
					)
	begin
		-- Generate new ID for query description
		execute	spsysGetNewID	@idflSubQueryDescription output

		-- Save local BR related to description
		insert into	locBaseReference
		(	idflBaseReference
		)
		values
		(	@idflSubQueryDescription
		)
	end

	-- Delete incorrect (not root) search objects of the query and related info (without sub-queries, folders, layouts, views, etc.)
	delete		qsfc
	from		tasQuerySearchFieldCondition qsfc
	inner join	tasQuerySearchField qsf
	on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
				and qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is not null

	delete		qsfc
	from		tasQuerySearchFieldCondition qsfc
	inner join	tasQueryConditionGroup qcg
	on			qcg.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
				and qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is not null

	delete		qcg
	from		tasQueryConditionGroup qcg
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
				and qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is not null

	delete		qsf
	from		tasQuerySearchField qsf
	inner join	tasQuerySearchObject qso
	on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
				and qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is not null

	delete		qso
	from		tasQuerySearchObject qso
	where		qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is not null


	-- Create or update root search object
	if	not exists	(
				select	*
				from	tasQuerySearchObject qso
				where	qso.idflQuery = @idflSubQuery
						and qso.idfParentQuerySearchObject is null
					)
		and (	@idfSubQuerySearchObject <= 0
				or exists	(
						select	*
						from	tasQuerySearchObject qso
						where	qso.idfQuerySearchObject = @idfSubQuerySearchObject
								and qso.idflQuery <> @idflSubQuery
							)
			)
	begin
		execute	spsysGetNewID	@idfSubQuerySearchObject output
	end
	
	if	exists	(
			select	*
			from	tasQuerySearchObject qso
			where	qso.idflQuery = @idflSubQuery
					and qso.idfParentQuerySearchObject is null
				)
	begin
		select	@idfSubQuerySearchObject = qso.idfParentQuerySearchObject
		from	tasQuerySearchObject qso
		where	qso.idflQuery = @idflSubQuery
				and qso.idfParentQuerySearchObject is null
	end
	
	if not exists	(
				select	*
				from	tasQuerySearchObject qso
				where	qso.idfQuerySearchObject = @idfSubQuerySearchObject
					)
	begin

		insert into	tasQuerySearchObject
		(
			idfQuerySearchObject,
			idflQuery,
			idfsSearchObject,
			intOrder,
			idfsReportType,
			idfParentQuerySearchObject
		)
		values
		(
			@idfSubQuerySearchObject,
			@idflSubQuery,
			@idfsSearchObject,
			0,
			null,
			null
		)
		
	end
	else begin

		declare	@idfsExistingSearchObject	bigint

		select	@idfsExistingSearchObject = qso.idfsSearchObject
		from	tasQuerySearchObject qso
		where	qso.idfQuerySearchObject = @idfSubQuerySearchObject

		-- Delete fields, condition groups and fields' conditions in case of modification of search object
		if	(@idfsExistingSearchObject <> @idfsSearchObject)
		begin
			delete		qsfc
			from		tasQuerySearchFieldCondition qsfc
			inner join	tasQuerySearchField qsf
			on			qsf.idfQuerySearchField = qsfc.idfQuerySearchField
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
						and qso.idflQuery = @idflSubQuery
						and qso.idfQuerySearchObject = @idfSubQuerySearchObject

			delete		qsfc
			from		tasQuerySearchFieldCondition qsfc
			inner join	tasQueryConditionGroup qcg
			on			qcg.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
						and qso.idflQuery = @idflSubQuery
						and qso.idfQuerySearchObject = @idfSubQuerySearchObject

			delete		qcg
			from		tasQueryConditionGroup qcg
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qcg.idfQuerySearchObject
						and qso.idflQuery = @idflSubQuery
						and qso.idfQuerySearchObject = @idfSubQuerySearchObject

			delete		qsf
			from		tasQuerySearchField qsf
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
						and qso.idflQuery = @idflSubQuery
						and qso.idfQuerySearchObject = @idfSubQuerySearchObject
		end

		update	tasQuerySearchObject
		set		idfsSearchObject = @idfsSearchObject,
				intOrder = 0,
				idfsReportType = null,
				idfParentQuerySearchObject = null
		where	idfQuerySearchObject = @idfSubQuerySearchObject
				and	idflQuery = @idflSubQuery
				and (	idfsSearchObject <> @idfsSearchObject
						or	intOrder <> 0
						or	idfsReportType is not null
						or	idfParentQuerySearchObject is not null
					)

	end

	-- Select output parameters
	select	@strFunctionName = q.strFunctionName,
			@idflSubQueryDescription = q.idflDescription,
			@idfSubQuerySearchObject = qso.idfQuerySearchObject
	from		tasQuery q
	inner join	tasQuerySearchObject qso
	on			qso.idflQuery = q.idflQuery
				and qso.idfParentQuerySearchObject is null
	where		q.idflQuery = @idflSubQuery

end

return 0


