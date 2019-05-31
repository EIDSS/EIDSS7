

--##SUMMARY This procedure create a copy of published query

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 22.11.2013

--##RETURNS Don't use

/*
--Example of a call of procedure:
begin tran 

declare @idflQuery bigint,
@idfsQuery bigint

set @idfsQuery = 463210002271

execute	spAsQueryCopyPublished @idfsQuery, @idflQuery output

select @idflQuery
		
			ROLLBACK TRAN
			 
IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO		 
*/ 


create procedure	spAsQueryCopyPublished
(
	@idfsQuery	bigint,
	@idflQuery	bigint = null output
)
as

	if	not exists	(	
					select	*
					from	tasglQuery
					where	idfsQuery = @idfsQuery
					)
	begin
		Raiserror (N'Global Query with ID=%I64d doesn''t exist.', 15, 1,  @idfsQuery)
		return 1
	end
	
	select @idflQuery = idflQuery
	from	tasQuery
	where	idfsGlobalQuery = @idfsQuery
	
	if @idflQuery is not null
		return 0

	declare @strQueryCheckSum nvarchar(max)
	declare @strQueryCheckSum_real nvarchar(max)
	
	select @strQueryCheckSum = isnull(tq.strReservedAttribute, ''), @strQueryCheckSum_real = dbo.fnGetQueryGlobalCheckSumString (tq.idfsQuery) 
	from tasglQuery tq
	where tq.idfsQuery = @idfsQuery
	
	if	@strQueryCheckSum <> @strQueryCheckSum_real 
	begin
		Raiserror (N'Global Query with ID=%I64d  is not complete.', 15, 1,  @idfsQuery)
		return 2
	end
	
	begin try
		-- let local query has the same id as global	
		set @idflQuery = @idfsQuery
		
		-- if local query exists - nothing should be done
		if exists	(	
				select	*
				from	tasQuery
				where	idflQuery = @idflQuery
				)
		begin
			update tasQuery 
			set idfsGlobalQuery = @idfsQuery
			where idflQuery = @idflQuery and idfsGlobalQuery is null
			return 0
		end
		declare @Query table (
			idfsQuery bigint primary key,
			idfsDescription bigint null
		)
		
		insert into @Query (idfsQuery, idfsDescription)
		select tq.idfsQuery, tq.idfsDescription
		from tasglQuery tq
		where tq.idfsQuery = @idfsQuery -- query
		union
		select tq_sub.idfsQuery, tq_sub.idfsDescription -- + subQueries
		from tasglQuery tq
			inner join tasglQuerySearchObject tqso
			on tqso.idfsQuery = tq.idfsQuery
			
			inner join tasglQueryConditionGroup tqcg
			on tqcg.idfQuerySearchObject = tqso.idfQuerySearchObject
			
			inner join tasglQuerySearchObject tqso_subq
			on tqso_subq.idfQuerySearchObject = tqcg.idfSubQuerySearchObject
			
			inner join tasglQuery tq_sub
			on tq_sub.idfsQuery = tqso_subq.idfsQuery
		where tq.idfsQuery = @idfsQuery
		
		
		
		insert into	locBaseReference
		(	idflBaseReference
		)
		select		q.idfsQuery
		from		tasglQuery q
		inner join	@Query tq
		on			tq.idfsQuery = q.idfsQuery
		inner join	trtBaseReference br_q
		on			br_q.idfsBaseReference = q.idfsQuery
					and br_q.idfsReferenceType = 19000075	-- AVR Query Name
					and br_q.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = q.idfsQuery
		left join	tasQuery q_loc
		on			q_loc.idfsGlobalQuery = q.idfsQuery
		where		q_loc.idflQuery is null
					and lbr.idflBaseReference is null

		insert into	locBaseReference
		(	idflBaseReference
		)
		select		q.idfsDescription
		from		tasglQuery q
		inner join	@Query tq
		on			tq.idfsQuery = q.idfsQuery
		inner join	trtBaseReference br_q
		on			br_q.idfsBaseReference = q.idfsDescription
					and br_q.idfsReferenceType = 19000121	-- AVR Query Description
					and br_q.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = q.idfsDescription
		left join	tasQuery q_loc
		on			q_loc.idfsGlobalQuery = q.idfsQuery
		where		q_loc.idflQuery is null
					and lbr.idflBaseReference is null		
		
		insert into	locStringNameTranslation
		(	idflBaseReference,
			idfsLanguage,
			strTextString
		)
		select		lbr.idflBaseReference,
					snt.idfsLanguage,
					snt.strTextString
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000075-- AVR Query Name
					and br.intRowStatus = 0
		inner join @Query tq
		on tq.idfsQuery = br.idfsBaseReference					
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null		
		
		insert into	locStringNameTranslation
		(	idflBaseReference,
			idfsLanguage,
			strTextString
		)
		select		lbr.idflBaseReference,
					snt.idfsLanguage,
					snt.strTextString
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000121	-- AVR Query Description
					and br.intRowStatus = 0
		inner join @Query tq
		on tq.idfsDescription = br.idfsBaseReference					
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null				
		
		
		
		insert into	tasQuery
		(	idflQuery,
			idfsGlobalQuery,
			strFunctionName,
			idflDescription,
			blnReadOnly,
			blnAddAllKeyFieldValues,
			blnSubQuery
		)
		select		gq.idfsQuery,
					gq.idfsQuery,
					gq.strFunctionName + cast(gq.idfsQuery as nvarchar(20)),
					gq.idfsDescription,
					1,
					gq.blnAddAllKeyFieldValues,
					gq.blnSubQuery
		from		tasglQuery gq
		inner join	@Query tq
		on tq.idfsQuery = gq.idfsQuery
		left join	tasQuery q
		on			q.idflQuery = gq.idfsQuery
		left join	tasQuery q_original
		on			q_original.idfsGlobalQuery = gq.idfsQuery
		where		q_original.idflQuery is null
					and q.idflQuery is null
					
					
		declare	@QueryNameConflicts	table
		(	idflQuery		bigint not null,
			idfsLanguage	bigint not null,
			strQueryName	nvarchar(2000) collate database_default null,
			intIndex		int null,
			primary key	(
				idflQuery asc,
				idfsLanguage asc
						)
		)
		
		
		insert into	@QueryNameConflicts
		(	idflQuery,
			idfsLanguage,
			strQueryName,
			intIndex
		)
		select		q.idflQuery,
					lsnt.idfsLanguage,
					lsnt.strTextString,
					null
		from		tasQuery q
		inner join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = q.idflQuery		
		where q.blnSubQuery = 0
		and q.idflQuery <> @idflQuery
		

		update query_conflicts set
			query_conflicts.intIndex = s.intIndex
		from @QueryNameConflicts as query_conflicts
			inner join (
					select 
						max(cast(substring(lfnc.strQueryName, len(lsnt_new.strTextString) + 2, len(lfnc.strQueryName)) as int)) + 1 as intIndex,
						lsnt_new.strTextString as strTextString,
						lfnc.idfsLanguage as idfsLanguage
					from @QueryNameConflicts lfnc
						inner join locStringNameTranslation lsnt_new  
						on lfnc.idfsLanguage = lsnt_new.idfsLanguage
						and 
						(lsnt_new.strTextString = lfnc.strQueryName collate database_default
						or (lsnt_new.strTextString = substring(lfnc.strQueryName, 1, len(lsnt_new.strTextString)) collate database_default
							and isnumeric (substring(lfnc.strQueryName, len(lsnt_new.strTextString) + 2, len(lfnc.strQueryName))) = 1 
							) 
						)
						inner join tasQuery  f_new
						on f_new.idflQuery = lsnt_new.idflBaseReference
						and f_new.idflQuery = @idflQuery

					group by lsnt_new.strTextString, lfnc.idfsLanguage
			) as s
			on	query_conflicts.idfsLanguage = s.idfsLanguage  
			and query_conflicts.strQueryName = s.strTextString collate database_default		
		

		update		lsnt
		set			lsnt.strTextString = IsNull(lnc.strQueryName, N'') + N'_' + 
											cast(lnc.intIndex as nvarchar(20))
		from		locStringNameTranslation lsnt
		inner join	@QueryNameConflicts lnc
		on			lnc.idflQuery = lsnt.idflBaseReference
					and lnc.idfsLanguage = lsnt.idfsLanguage
					and IsNull(lnc.intIndex, 0) > 0
		inner join tasQuery tl
		on tl.idflQuery = lnc.idflQuery
		and tl.idfsGlobalQuery is null

		

		--insert into	@QueryNameConflicts
		--(	idflQuery,
		--	idfsLanguage,
		--	strQueryName,
		--	intIndex
		--)
		--select		q.idflQuery,
		--			lsnt.idfsLanguage,
		--			lsnt.strTextString,
		--			null
		--from		tasQuery q
		--inner join	@Query tq
		--on tq.idfsQuery = q.idflQuery
		--inner join	locStringNameTranslation lsnt
		--on			lsnt.idflBaseReference = q.idflQuery
		
		--declare	@RowsUpdated	bigint
		--set	@RowsUpdated = 1
		--while	@RowsUpdated > 0
		--begin

		--	update		qnc
		--	set			qnc.intIndex = IsNull(qnc.intIndex, 0) + 1
		--	from		@QueryNameConflicts qnc
		--	where		exists	(
		--					select		*
		--					from		tasQuery q_published_conflict_name
		--					inner join	locStringNameTranslation lsnt_published_conflict_name
		--					on			lsnt_published_conflict_name.idflBaseReference = 
		--									q_published_conflict_name.idflQuery
		--								and lsnt_published_conflict_name.idfsLanguage = qnc.idfsLanguage
		--					where		q_published_conflict_name.blnReadOnly = 1
		--								and IsNull(lsnt_published_conflict_name.strTextString, N'')collate database_default = 
		--										IsNull(qnc.strQueryName, N'') + 
		--										IsNull(N' ' + cast(qnc.intIndex as nvarchar(20)), N'')collate database_default
		--								--and q_published_conflict_name.idflQuery <> qnc.idflQuery	
		--						)

		--	set	@RowsUpdated = @@rowcount

		--	update		qnc
		--	set			qnc.intIndex = IsNull(qnc.intIndex, 0) + 1
		--	from		@QueryNameConflicts qnc
		--	where		exists	(
		--					select		*
		--					from		tasQuery q_published_conflict_name
		--					inner join	locStringNameTranslation lsnt_published_conflict_name
		--					on			lsnt_published_conflict_name.idflBaseReference = 
		--									q_published_conflict_name.idflQuery
		--								and lsnt_published_conflict_name.idfsLanguage = qnc.idfsLanguage
		--					where		q_published_conflict_name.blnReadOnly = 1
		--								and IsNull(lsnt_published_conflict_name.strTextString, N'')collate database_default = 
		--										IsNull(qnc.strQueryName, N'')collate database_default
		--								--and q_published_conflict_name.idflQuery <> qnc.idflQuery			
		--						)
		--				and exists	(
		--						select		*
		--						from		tasQuery q_local_conflict_name
		--						inner join	locStringNameTranslation lsnt_local_conflict_name
		--						on			lsnt_local_conflict_name.idflBaseReference = q_local_conflict_name.idflQuery
		--									and lsnt_local_conflict_name.idfsLanguage = qnc.idfsLanguage
		--						inner join	@QueryNameConflicts qnc_local
		--						on			qnc_local.idflQuery = q_local_conflict_name.idflQuery
		--									and qnc_local.idfsLanguage = qnc.idfsLanguage
		--						where		q_local_conflict_name.blnReadOnly = 0
		--									and IsNull(lsnt_local_conflict_name.strTextString, N'') collate database_default= 
		--											IsNull(qnc.strQueryName, N'') + 
		--											IsNull(N' ' + cast(qnc.intIndex as nvarchar(20)), N'')collate database_default
		--									and (	IsNull(qnc_local.intIndex, 0) < 
		--												IsNull(qnc.intIndex, 0)
		--											or	(	IsNull(qnc_local.intIndex, 0) = 
		--														IsNull(qnc.intIndex, 0)
		--													and	q_local_conflict_name.idflQuery < qnc.idflQuery
		--												)
		--									)
		--									--and q_local_conflict_name.idflQuery <> qnc.idflQuery
		--							)
			

		--	set	@RowsUpdated = @RowsUpdated + @@rowcount

		--end

	
		--update		lsnt
		--set			lsnt.strTextString = IsNull(qnc.strQueryName, N'') + N' ' + cast(qnc.intIndex - 1 as nvarchar(20))
		--from		locStringNameTranslation lsnt
		--inner join	@QueryNameConflicts qnc
		--on			qnc.idflQuery = lsnt.idflBaseReference
		--			and qnc.idfsLanguage = lsnt.idfsLanguage
		--			and IsNull(qnc.intIndex, 0) > 1					








		-- Search Objects
		insert into	tasQuerySearchObject
		(	idfQuerySearchObject,
			idflQuery,
			idfsSearchObject,
			idfParentQuerySearchObject,
			intOrder,
			idfsReportType
		)
		select		gqso.idfQuerySearchObject,
					q.idflQuery,
					gqso.idfsSearchObject,
					null,
					gqso.intOrder,
					gqso.idfsReportType
		from		tasglQuerySearchObject gqso
		inner join	tasQuery q
		on			q.idfsGlobalQuery = gqso.idfsQuery
					and q.idflQuery = gqso.idfsQuery
		inner join @Query tq
		on tq.idfsQuery = q.idfsGlobalQuery
		left join	tasQuerySearchObject qso
		on			qso.idfQuerySearchObject = gqso.idfQuerySearchObject
		where		gqso.idfParentQuerySearchObject is null
					and qso.idfQuerySearchObject is null


		insert into	tasQuerySearchObject
		(	idfQuerySearchObject,
			idflQuery,
			idfsSearchObject,
			idfParentQuerySearchObject,
			intOrder,
			idfsReportType
		)
		select		gqso.idfQuerySearchObject,
					q.idflQuery,
					gqso.idfsSearchObject,
					qso_parent.idfQuerySearchObject,
					gqso.intOrder,
					gqso.idfsReportType
		from		tasglQuerySearchObject gqso
		inner join	tasQuery q
		on			q.idfsGlobalQuery = gqso.idfsQuery
					and q.idflQuery = gqso.idfsQuery
		inner join @Query tq
		on tq.idfsQuery = q.idfsGlobalQuery
		inner join	tasglQuerySearchObject gqso_parent
		on			gqso_parent.idfQuerySearchObject = gqso.idfParentQuerySearchObject
		inner join	tasQuerySearchObject qso_parent
		on			qso_parent.idflQuery = q.idflQuery
					and qso_parent.idfsSearchObject = gqso_parent.idfsSearchObject
					and qso_parent.idfParentQuerySearchObject is null
		left join	tasQuerySearchObject qso
		on			qso.idfQuerySearchObject = gqso.idfQuerySearchObject
		where		qso.idfQuerySearchObject is null

		
		
		insert into	tasQuerySearchField
		(	idfQuerySearchField,
			idfQuerySearchObject,
			blnShow,
			idfsSearchField,
			idfsParameter
		)
		select		gqsf.idfQuerySearchField,
					gqsf.idfQuerySearchObject,
					gqsf.blnShow,
					gqsf.idfsSearchField,
					gqsf.idfsParameter
		from		tasglQuerySearchField gqsf
		inner join	tasQuerySearchObject qso
		on			qso.idfQuerySearchObject = gqsf.idfQuerySearchObject
		inner join	tasQuery q
		on			q.idfsGlobalQuery = qso.idflQuery
					and q.idflQuery = qso.idflQuery
		inner join @Query tq
		on tq.idfsQuery = q.idfsGlobalQuery	
		left join	tasQuerySearchField qsf
		on			qsf.idfQuerySearchField = gqsf.idfQuerySearchField
		where		qsf.idfQuerySearchField is null		
				
		
		insert into	tasQueryConditionGroup
		(	idfQueryConditionGroup,
			idfQuerySearchObject,
			idfParentQueryConditionGroup,
			intOrder,
			blnJoinByOr,
			blnUseNot,
			idfSubQuerySearchObject
		)
		select		gqcg.idfQueryConditionGroup,
					gqcg.idfQuerySearchObject,
					null,
					gqcg.intOrder,
					gqcg.blnJoinByOr,
					gqcg.blnUseNot,
					gqcg.idfSubQuerySearchObject
		from		tasglQueryConditionGroup gqcg
		inner join	tasQuerySearchObject qso
		on			qso.idfQuerySearchObject = gqcg.idfQuerySearchObject
		inner join	tasQuery q
		on			q.idfsGlobalQuery = qso.idflQuery
					and q.idflQuery = qso.idflQuery
		inner join @Query tq
		on tq.idfsQuery = q.idfsGlobalQuery						
		left join	tasQueryConditionGroup qcg
		on			qcg.idfQueryConditionGroup = gqcg.idfQueryConditionGroup
		where		gqcg.idfParentQueryConditionGroup is null
					and qcg.idfQueryConditionGroup is null

		declare	@RowCount	int
		set	@RowCount = 1

		while	@RowCount > 0
		begin

			insert into	tasQueryConditionGroup
			(	idfQueryConditionGroup,
				idfQuerySearchObject,
				idfParentQueryConditionGroup,
				intOrder,
				blnJoinByOr,
				blnUseNot,
				idfSubQuerySearchObject
			)
			select		gqcg.idfQueryConditionGroup,
						gqcg.idfQuerySearchObject,
						qcg_parent.idfQueryConditionGroup,
						gqcg.intOrder,
						gqcg.blnJoinByOr,
						gqcg.blnUseNot,
						gqcg.idfSubQuerySearchObject
			from		tasglQueryConditionGroup gqcg
			inner join	tasQuerySearchObject qso
			on			qso.idfQuerySearchObject = gqcg.idfQuerySearchObject
			inner join	tasQuery q
			on			q.idfsGlobalQuery = qso.idflQuery
						and q.idflQuery = qso.idflQuery
			inner join @Query tq
			on tq.idfsQuery = q.idfsGlobalQuery						
			inner join	tasQueryConditionGroup qcg_parent
			on			qcg_parent.idfQueryConditionGroup = gqcg.idfParentQueryConditionGroup
			left join	tasQueryConditionGroup qcg
			on			qcg.idfQueryConditionGroup = gqcg.idfQueryConditionGroup
			where		qcg.idfQueryConditionGroup is null

			set	@RowCount = @@rowcount
		end

		
		insert into	tasQuerySearchFieldCondition
		(	idfQuerySearchFieldCondition,
			idfQueryConditionGroup,
			idfQuerySearchField,
			strOperator,
			intOrder,
			intOperatorType,
			blnUseNot,
			varValue
		)
		select		gqsfc.idfQuerySearchFieldCondition,
					gqsfc.idfQueryConditionGroup,
					gqsfc.idfQuerySearchField,
					gqsfc.strOperator,
					gqsfc.intOrder,
					gqsfc.intOperatorType,
					gqsfc.blnUseNot,
					gqsfc.varValue
		from		tasglQuerySearchFieldCondition gqsfc
		inner join	tasQuerySearchField qsf
		on			qsf.idfQuerySearchField = gqsfc.idfQuerySearchField
		inner join	tasQuerySearchObject qso
		on			qso.idfQuerySearchObject = qsf.idfQuerySearchObject
		inner join	tasQuery q
		on			q.idfsGlobalQuery = qso.idflQuery
					and q.idflQuery = qso.idflQuery
		inner join @Query tq
		on tq.idfsQuery = q.idfsGlobalQuery							
		inner join	tasQueryConditionGroup qcg
		on			qcg.idfQueryConditionGroup = gqsfc.idfQueryConditionGroup
					and qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		left join	tasQuerySearchFieldCondition qsfc
		on			qsfc.idfQuerySearchFieldCondition = gqsfc.idfQuerySearchFieldCondition
		where		qsfc.idfQuerySearchFieldCondition is null		
		
		
		declare	@idflQuery_post	bigint
		declare	QueryCursor	cursor local read_only forward_only for
			select		idflQuery
			from		tasQuery
			order by	idflQuery
		open QueryCursor
		fetch next from	QueryCursor into @idflQuery_post
		while @@fetch_status <> -1
		begin

			execute	spAsQueryFunction_Post @idflQuery_post
			fetch next from	QueryCursor into @idflQuery_post

		end
			
		close QueryCursor
		deallocate QueryCursor		
		

	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while making local query: %s', 15, 1, @error)
		return 1
	end catch
	


