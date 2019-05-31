

--##SUMMARY This procedure publish of specified query

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 21.08.2010

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 21.11.2013

--##RETURNS Don't use


/*
--Example of a call of procedure:
begin tran 

declare @idflQuery bigint
set @idflQuery = 12929650000870

declare @idfsQuery bigint

execute	spAsQueryPublish_test @idflQuery, @idfsQuery output

select @idfsQuery
	 
	 ROLLBACK TRAN
	 
	 
IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO	 
*/ 


create procedure	[dbo].[spAsQueryPublish]
(
	@idflQuery	bigint,
	@idfsQuery	bigint output
)
as

	if	not exists	(	
					select	*
					from	tasQuery
					where	idflQuery = @idflQuery
					)
	begin
		Raiserror (N'Query with ID=%I64d doesn''t exist.', 15, 1,  @idflQuery)
		return 1
	end
	begin try
		declare @idfsDescription	bigint
		declare @idflDescription	bigint
		declare @strFunctionName	nvarchar(2000)
		declare @blnAddAllKeyFieldValues bit
		declare @blnSubQuery bit
		declare @idfsSubQuery bigint
		declare @idflSubQuery bigint
	
		select		 @idfsQuery = idfsGlobalQuery
					,@strFunctionName = strFunctionName
					,@idflDescription = idflDescription
					,@blnAddAllKeyFieldValues = blnAddAllKeyFieldValues
					,@blnSubQuery = tQuery.blnSubQuery
				
		from		tasQuery				as tQuery
		 
		where		idflQuery = @idflQuery 
		
			
		-- if local query contains reference to global query - return
		if (@idfsQuery is not null)
			return


						
		

		-- get new ID for global queries
		exec spsysGetNewID @idfsQuery out
		
		-- insert base reference and english translation
		--query
		insert into trtBaseReference (idfsBaseReference, idfsReferenceType, strDefault)
		select @idfsQuery, 19000075, lsnt.strTextString
		from locBaseReference as lbr
			left join locStringNameTranslation as lsnt	
			on lbr.idflBaseReference = lsnt.idflBaseReference 
			and lsnt.idfsLanguage = dbo.fnGetLanguageCode('en')
		where lbr.idflBaseReference = @idflQuery 
		
		-- translations
		insert into trtStringNameTranslation(idfsBaseReference,idfsLanguage,strTextString)
		select @idfsQuery, a.idfsLanguage, a.strTextString
		from locStringNameTranslation as a
		where idflBaseReference = @idflQuery	
		
		--- Description
		if (@idflDescription is not null)
		begin
			-- get new ID for Description
			exec spsysGetNewID @idfsDescription out

			insert into trtBaseReference (idfsBaseReference, idfsReferenceType, strDefault)
			select @idfsDescription, 19000121, lsnt.strTextString
			from locBaseReference as lbr
				left join locStringNameTranslation as lsnt
				on lbr.idflBaseReference = lsnt.idflBaseReference 
				and lsnt.idfsLanguage = dbo.fnGetLanguageCode('en')
			where lbr.idflBaseReference = @idflDescription 
			
			-- translations
			insert into trtStringNameTranslation(idfsBaseReference,idfsLanguage,strTextString)
			select @idfsDescription,a.idfsLanguage, a.strTextString
			from locStringNameTranslation as a
			where idflBaseReference = @idflDescription
		end
		
		
		insert into tasglQuery
				(idfsQuery
				,strFunctionName
				,idfsDescription
				,blnReadOnly
				,blnAddAllKeyFieldValues
				,blnSubQuery
				)
		values	(@idfsQuery
				,@strFunctionName
				,@idfsDescription
				,1
				,@blnAddAllKeyFieldValues
				,@blnSubQuery
				)

		update	tasQuery
		set		 idfsGlobalQuery = @idfsQuery
				,blnReadOnly = 1
		where	idflQuery = @idflQuery	
		
		
		-- QuerySearchObject
		declare @idfRootQuerySearchObject		bigint
		declare @idfRootQuerySearchObject_old	bigint
		
		exec spsysGetNewID @idfRootQuerySearchObject out
	
		-- insert root query search object
		insert into tasglQuerySearchObject
			   (idfQuerySearchObject
			   ,idfsQuery
			   ,idfsSearchObject
			   ,idfParentQuerySearchObject
			   ,intOrder
			   ,idfsReportType)
		select	@idfRootQuerySearchObject
			   ,@idfsQuery
			   ,idfsSearchObject
			   ,null
			   ,intOrder
			   ,idfsReportType
		from	tasQuerySearchObject 	
		where   idflQuery = @idflQuery
		and		idfParentQuerySearchObject is NULL
	    
		select	@idfRootQuerySearchObject_old = idfQuerySearchObject
		from	tasQuerySearchObject
		where	idflQuery = @idflQuery
		and		idfParentQuerySearchObject is NULL
		
		declare @QuerySearchObject table(
			idfQuerySearchObject_old bigint primary key,
			idfQuerySearchObject_new bigint			
		)
		
		insert into @QuerySearchObject (idfQuerySearchObject_old, idfQuerySearchObject_new)
		select	@idfRootQuerySearchObject_old , @idfRootQuerySearchObject
		union
		select	idfQuerySearchObject, null
		from	tasQuerySearchObject 	
		where	idflQuery = @idflQuery
		and		idfParentQuerySearchObject = @idfRootQuerySearchObject_old
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574290000000, --	tasglQuerySearchObject
				  tt.idfQuerySearchObject_old
		from	@QuerySearchObject  tt
		WHERE tt.idfQuerySearchObject_new is null

		update		tt
		set			tt.idfQuerySearchObject_new = nID.[NewID]
		from		@QuerySearchObject  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfQuerySearchObject_old
		WHERE idfQuerySearchObject_new IS NULL 

		delete from	tstNewID
		
		
		-- insert child query search object
		insert into tasglQuerySearchObject
			   (idfQuerySearchObject
			   ,idfsQuery
			   ,idfsSearchObject
			   ,idfParentQuerySearchObject
			   ,intOrder
			   ,idfsReportType)
		select	qso.idfQuerySearchObject_new
			   ,@idfsQuery
			   ,tqso.idfsSearchObject
			   ,@idfRootQuerySearchObject
			   ,tqso.intOrder
			   ,tqso.idfsReportType
		from	tasQuerySearchObject tqso
				inner join @QuerySearchObject qso
				on qso.idfQuerySearchObject_old = tqso.idfQuerySearchObject 	
		where	tqso.idflQuery = @idflQuery
		and		tqso.idfParentQuerySearchObject = @idfRootQuerySearchObject_old
		
		

		--insert Query search field
		declare @QuerySearchField table (
			idfQuerySearchField_old bigint primary key,
			idfQuerySearchField_new bigint		
		)
		
		insert into @QuerySearchField (idfQuerySearchField_old)
		select
				qsf.idfQuerySearchField
		from	tasQuerySearchField qsf
		inner join	tasQuerySearchObject	qso
		on			qsf.idfQuerySearchObject = qso.idfQuerySearchObject
		where		qso.idflQuery = @idflQuery			
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574140000000, --	tasglQuerySearchField
				  tt.idfQuerySearchField_old
		from	@QuerySearchField  tt
		WHERE tt.idfQuerySearchField_new is null

		update		tt
		set			tt.idfQuerySearchField_new = nID.[NewID]
		from		@QuerySearchField  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfQuerySearchField_old
		WHERE idfQuerySearchField_new IS NULL 

		delete from	tstNewID		
		
		
		insert into tasglQuerySearchField
			   (idfQuerySearchField
			   ,idfQuerySearchObject
			   ,blnShow
			   ,idfsSearchField
			   ,idfsParameter
			   )
		select
				tqsf.idfQuerySearchField_new
			   ,tqso.idfQuerySearchObject_new
			   ,qsf.blnShow
			   ,qsf.idfsSearchField
			   ,qsf.idfsParameter
		from	tasQuerySearchField qsf
		inner join	tasQuerySearchObject	qso
			on	qsf.idfQuerySearchObject = qso.idfQuerySearchObject
		inner join @QuerySearchObject tqso
			on	tqso.idfQuerySearchObject_old = qso.idfQuerySearchObject
		inner join @QuerySearchField tqsf
			on	tqsf.idfQuerySearchField_old = qsf.idfQuerySearchField
		where	qso.idflQuery = @idflQuery	
		

		--insert Query Condition Group
		declare @QueryConditionGroup table (
			idfQueryConditionGroup_old bigint primary key,
			idfQueryConditionGroup_new bigint
		)
		
		--select	qcg.idfQueryConditionGroup
		--from		tasQueryConditionGroup qcg	
		--inner join	tasQuerySearchObject qso
		--on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		--where		qso.idflQuery = @idflQuery
		
		
		insert into @QueryConditionGroup (idfQueryConditionGroup_old)
		select	qcg.idfQueryConditionGroup
		from		tasQueryConditionGroup qcg	
		inner join	tasQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		where		qso.idflQuery = @idflQuery
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574070000000, --	tasglQueryConditionGroup
				  tt.idfQueryConditionGroup_old
		from	@QueryConditionGroup  tt
		WHERE tt.idfQueryConditionGroup_new is null

		update		tt
		set			tt.idfQueryConditionGroup_new = nID.[NewID]
		from		@QueryConditionGroup  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfQueryConditionGroup_old
		WHERE idfQueryConditionGroup_new IS NULL 

		delete from	tstNewID		
		
		--select * from @QueryConditionGroup
		
		declare @SubQuery table (
			idflSubQuery bigint,
			idfsSubQuery bigint			
		)
		
		--select sub_tq.idflQuery
		--from tasQueryConditionGroup qcg	
		--inner join	tasQuerySearchObject qso
		--on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		--inner join tasQuery tq
		--on tq.idflQuery = qso.idflQuery
		--inner join tasQuerySearchObject sub_qso
		--on sub_qso.idfQuerySearchObject = qcg.idfSubQuerySearchObject
		--inner join tasQuery sub_tq
		--on sub_tq.idflQuery = sub_qso.idflQuery
		--where		qso.idflQuery = @idflQuery
		
		insert into @SubQuery (idflSubQuery)
		select sub_tq.idflQuery
		from tasQueryConditionGroup qcg	
		inner join	tasQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		inner join tasQuery tq
		on tq.idflQuery = qso.idflQuery
		
		inner join tasQuerySearchObject sub_qso
		on sub_qso.idfQuerySearchObject = qcg.idfSubQuerySearchObject
		inner join tasQuery sub_tq
		on sub_tq.idflQuery = sub_qso.idflQuery
		where		qso.idflQuery = @idflQuery
		
		declare cur cursor local read_only for
		select idflSubQuery from @SubQuery
		
		open cur
		fetch next from cur into @idflSubQuery
		while @@fetch_status = 0 
		begin
			exec [spAsQueryPublish]	@idflSubQuery,	@idfsSubQuery out
			update @SubQuery set idfsSubQuery = @idfsSubQuery where idflSubQuery = @idflSubQuery
			fetch next from cur into @idflSubQuery
		end
		
		close cur
		deallocate cur
		
		--select * from @SubQuery
		
		insert into tasglQueryConditionGroup
			   (idfQueryConditionGroup
			   ,idfQuerySearchObject
			   ,idfParentQueryConditionGroup
			   ,intOrder
			   ,blnJoinByOr
			   ,blnUseNot
			   ,idfSubQuerySearchObject)
		select	tqcg.idfQueryConditionGroup_new
			   ,tqso.idfQuerySearchObject_new
			   ,pqcg.idfQueryConditionGroup_new
			   ,qcg.intOrder
			   ,qcg.blnJoinByOr
			   ,qcg.blnUseNot
			   ,tqso2.idfQuerySearchObject
		from		tasQueryConditionGroup qcg	
		inner join	tasQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		
		inner join @QueryConditionGroup tqcg
		on	tqcg.idfQueryConditionGroup_old = qcg.idfQueryConditionGroup
		
		inner join @QuerySearchObject tqso
		on	tqso.idfQuerySearchObject_old = qso.idfQuerySearchObject
		
		left join @QueryConditionGroup pqcg
		on	pqcg.idfQueryConditionGroup_old = qcg.idfParentQueryConditionGroup
		
		left join tasQuerySearchObject sub_qso
			inner join @SubQuery sq
			on sq.idflSubQuery = sub_qso.idflQuery
			inner join tasglQuerySearchObject tqso2
			on tqso2.idfsQuery = sq.idfsSubQuery
		on sub_qso.idfQuerySearchObject = qcg.idfSubQuerySearchObject

		left join tasglQueryConditionGroup qcg_new
		on qcg_new.idfQueryConditionGroup = tqcg.idfQueryConditionGroup_new
		
		where		qso.idflQuery = @idflQuery
					and qcg.idfParentQueryConditionGroup is null
					and qcg_new.idfQueryConditionGroup is null
					
		declare	@RowCount	int
		set	@RowCount = 1
		
		
		while	@RowCount > 0
		begin
			insert into tasglQueryConditionGroup
				   (idfQueryConditionGroup
				   ,idfQuerySearchObject
				   ,idfParentQueryConditionGroup
				   ,intOrder
				   ,blnJoinByOr
				   ,blnUseNot
				   ,idfSubQuerySearchObject)
			select	tqcg.idfQueryConditionGroup_new
				   ,tqso.idfQuerySearchObject_new
				   ,pqcg.idfQueryConditionGroup_new
				   ,qcg.intOrder
				   ,qcg.blnJoinByOr
				   ,qcg.blnUseNot
				   ,tqso2.idfQuerySearchObject
			from		tasQueryConditionGroup qcg	
			inner join	tasQuerySearchObject qso
			on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
			
			inner join @QueryConditionGroup tqcg
			on	tqcg.idfQueryConditionGroup_old = qcg.idfQueryConditionGroup
			
			inner join @QuerySearchObject tqso
			on	tqso.idfQuerySearchObject_old = qso.idfQuerySearchObject
			
			left join @QueryConditionGroup pqcg
			on	pqcg.idfQueryConditionGroup_old = qcg.idfParentQueryConditionGroup
			
			left join tasQuerySearchObject sub_qso
				inner join @SubQuery sq
				on sq.idflSubQuery = sub_qso.idflQuery
				inner join tasglQuerySearchObject tqso2
				on tqso2.idfsQuery = sq.idfsSubQuery
			on sub_qso.idfQuerySearchObject = qcg.idfSubQuerySearchObject

			left join tasglQueryConditionGroup qcg_new
			on qcg_new.idfQueryConditionGroup = tqcg.idfQueryConditionGroup_new
			
			where		qso.idflQuery = @idflQuery
						and qcg_new.idfQueryConditionGroup is null
						and (pqcg.idfQueryConditionGroup_old is not null or @blnSubQuery = 1)

			set	@RowCount = @@rowcount
		end

		
		--update ParentConditionGroups for SubQuery
		update  tqcg set
			tqcg.idfParentQueryConditionGroup = parent_tqcg.idfQueryConditionGroup
		from @SubQuery sq
			inner join tasglQuerySearchObject tqso
			on tqso.idfsQuery = sq.idfsSubQuery
			
			inner join tasglQueryConditionGroup tqcg
			on tqcg.idfQuerySearchObject = tqso.idfQuerySearchObject
			and tqcg.idfParentQueryConditionGroup is null
			
			inner join tasglQueryConditionGroup parent_tqcg
			on tqcg.idfQuerySearchObject = parent_tqcg.idfSubQuerySearchObject
	
			 
		
		--insert Query search field condition
		declare @QuerySearchFieldCondition table (
				idfQuerySearchFieldCondition_old bigint primary key,
				idfQuerySearchFieldCondition_new bigint	
		)
		insert into @QuerySearchFieldCondition (idfQuerySearchFieldCondition_old)
		select	qsfc.idfQuerySearchFieldCondition
		from		tasQuerySearchFieldCondition qsfc
		inner join	tasQueryConditionGroup qcg	
		on			qsfc.idfQueryConditionGroup = qcg.idfQueryConditionGroup
		inner join	tasQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		where		qso.idflQuery = @idflQuery
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574200000000,--	tasglQuerySearchFieldCondition
				  tt.idfQuerySearchFieldCondition_old
		from	@QuerySearchFieldCondition  tt
		WHERE tt.idfQuerySearchFieldCondition_new is null

		update		tt
		set			tt.idfQuerySearchFieldCondition_new = nID.[NewID]
		from		@QuerySearchFieldCondition  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfQuerySearchFieldCondition_old
		WHERE idfQuerySearchFieldCondition_new IS NULL 

		delete from	tstNewID	
		
		
		insert into tasglQuerySearchFieldCondition
			   (idfQuerySearchFieldCondition
			   ,idfQueryConditionGroup
			   ,idfQuerySearchField
			   ,strOperator
			   ,intOrder
			   ,intOperatorType
			   ,blnUseNot
			   ,varValue)
		select
				tqsfc.idfQuerySearchFieldCondition_new
			   ,tqcg.idfQueryConditionGroup_new
			   ,tqsf.idfQuerySearchField_new
			   ,qsfc.strOperator
			   ,qsfc.intOrder
			   ,qsfc.intOperatorType
			   ,qsfc.blnUseNot
			   ,qsfc.varValue
		from		tasQuerySearchFieldCondition qsfc
		inner join	tasQueryConditionGroup qcg	
		on			qsfc.idfQueryConditionGroup = qcg.idfQueryConditionGroup
		inner join	tasQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		
		inner join @QuerySearchFieldCondition tqsfc
		on tqsfc.idfQuerySearchFieldCondition_old = qsfc.idfQuerySearchFieldCondition
		
		inner join @QueryConditionGroup tqcg
		on tqcg.idfQueryConditionGroup_old = qcg.idfQueryConditionGroup
		
		inner join @QuerySearchField tqsf
		on tqsf.idfQuerySearchField_old = qsfc.idfQuerySearchField
		
		where		qso.idflQuery = @idflQuery     
		
		
		-- write check sum for global query
		update tasglQuery
		set
			strReservedAttribute = dbo.fnGetQueryGlobalCheckSumString (@idfsQuery) 
		where idfsQuery = @idfsQuery
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while publishing query: %s', 15, 1, @error)
		return 1
	end catch



