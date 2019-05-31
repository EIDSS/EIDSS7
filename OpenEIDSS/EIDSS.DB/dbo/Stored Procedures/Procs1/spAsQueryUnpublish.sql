

--##SUMMARY unpublish Query for analytical module

--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:
begin tran 

declare @idfsQuery bigint
declare @idflQuery	bigint

set @idfsQuery  = 13103640000870
EXEC	[spAsQueryUnpublish] 	@idfsQuery, @idflQuery output

print @idflQuery

ROLLBACK TRAN



IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO

*/ 

create PROCEDURE [dbo].[spAsQueryUnpublish]
	@idfsQuery	bigint
	,@idflQuery	bigint output
AS
BEGIN

	if	not exists	(	
					select	*
					from	tasglQuery
					where	idfsQuery = @idfsQuery
					)
	begin
		Raiserror (N'Global Query with ID=%I64d doesn''t exist.', 15, 1,  @idfsQuery)
		return 1
	end

	begin try
	
		-- unpublish layouts
		declare @idfsLayout bigint
		declare @idflLayout bigint
		declare cur_layouts cursor forward_only read_only local for
		select tl.idfsLayout
		from tasglLayout tl
		where tl.idfsQuery = @idfsQuery
			and tl.idfsLayoutFolder is null
		
		open cur_layouts
		
		fetch next from cur_layouts into @idfsLayout
		
		while @@FETCH_STATUS = 0  
		begin
			exec [dbo].[spAsLayoutUnpublish] @idfsLayout, @idflLayout out
			fetch next from cur_layouts into @idfsLayout
		end
		
		close cur_layouts
		deallocate cur_layouts
	
	
		-- unpublish  folders
		declare @idfsFolder bigint
		declare @idflFolder bigint
		
		declare cur_folders cursor forward_only read_only local for
		select tlf.idfsLayoutFolder
		from tasglLayoutFolder tlf
		where tlf.idfsQuery = @idfsQuery
			and tlf.idfsParentLayoutFolder is null		
		
		open cur_folders
		
		fetch next from cur_folders into @idfsFolder
		
		while @@FETCH_STATUS  = 0
		begin
			exec [dbo].[spAsFolderUnpublish] @idfsFolder, @idflFolder out
			fetch next from cur_folders into @idfsFolder
		end
		
		close cur_folders
		deallocate cur_folders	
	

		update br_q
		set intRowStatus = 1
		from		tasglQuery q
		inner join	trtBaseReference br_q
		on			br_q.idfsBaseReference = q.idfsQuery
					and br_q.idfsReferenceType = 19000075	-- AVR Query Name
		where		q.idfsQuery = @idfsQuery

		update br_q
		set intRowStatus = 1
		from		tasglQuery q
		inner join	trtBaseReference br_q
		on			br_q.idfsBaseReference = q.idfsDescription
					and br_q.idfsReferenceType = 19000121	-- AVR Query Description
		where		q.idfsQuery = @idfsQuery	
		
		
		update snt
		set intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000075-- AVR Query Name
		inner join	tasglQuery q
		on			q.idfsQuery = br.idfsBaseReference					
		where		q.idfsQuery = @idfsQuery		
		
		update snt
		set intRowStatus = 1
		from		trtStringNameTranslation snt
		inner join	trtBaseReference br
		on			br.idfsBaseReference = snt.idfsBaseReference
					and br.idfsReferenceType = 19000121	-- AVR Query Description
		inner join	tasglQuery q
		on			q.idfsQuery = br.idfsBaseReference
		where		q.idfsQuery = @idfsQuery			
						
	
		select top 1 @idflQuery = idflQuery
		from tasQuery 
		where		idfsGlobalQuery = @idfsQuery	
		update tasQuery
		set
			idfsGlobalQuery = null,
			blnReadOnly = 0
		where		idfsGlobalQuery = @idfsQuery	
	
		--update qcg set
		--	qcg.idfParentQueryConditionGroup = null
		--from tasglQueryConditionGroup qcg
		--	inner join tasglQuerySearchObject qso
		--	on		qso.idfQuerySearchObject = qcg.idfQuerySearchObject
		--	and		qso.idfsQuery = @idfsQuery
		
		
		-- delete subqueries											
		declare @SubQuery table (idfsSubQuery bigint	primary key)
		declare @idfsSubQuery bigint
		
		insert into @SubQuery (idfsSubQuery)
		select sub_tq.idfsQuery
		from tasglQueryConditionGroup qcg	
		inner join	tasglQuerySearchObject qso
		on			qcg.idfQuerySearchObject = qso.idfQuerySearchObject
		inner join tasglQuery tq
		on tq.idfsQuery = qso.idfsQuery
		
		inner join tasglQuerySearchObject sub_qso
		on sub_qso.idfQuerySearchObject = qcg.idfSubQuerySearchObject
		inner join tasglQuery sub_tq
		on sub_tq.idfsQuery = sub_qso.idfsQuery
		where		qso.idfsQuery = @idfsQuery
		
		
		update qcg
		set
			qcg.idfSubQuerySearchObject = null
		from 	tasglQueryConditionGroup qcg
			inner join tasglQuerySearchObject qso
			on		qso.idfQuerySearchObject = qcg.idfQuerySearchObject
			and		qso.idfsQuery = @idfsQuery			
		
		update qcg set
			qcg.idfParentQueryConditionGroup = null
		from tasglQueryConditionGroup qcg
			inner join tasglQuerySearchObject qso
			on		qso.idfQuerySearchObject = qcg.idfQuerySearchObject
			
			inner join @SubQuery sq
			on		qso.idfsQuery = sq.idfsSubQuery
		
		declare @idflSubQuery bigint
		declare cur cursor local read_only for
		select idfsSubQuery from @SubQuery
		
		open cur
		fetch next from cur into @idfsSubQuery
		while @@fetch_status = 0 
		begin

			exec [spAsQueryUnpublish]	@idfsSubQuery , @idflSubQuery out
			update @SubQuery set idfsSubQuery = @idfsSubQuery where idfsSubQuery = @idfsSubQuery

			fetch next from cur into @idfsSubQuery
		end
		close cur
		deallocate cur
		-- end delete subqueries													
		
		delete from tasglQuerySearchFieldCondition where exists 
											(
												select * from tasglQuerySearchFieldCondition qsfc
													inner join tasglQueryConditionGroup qcg
													on qcg.idfQueryConditionGroup = qsfc.idfQueryConditionGroup
													inner join tasglQuerySearchObject qso
													on		qso.idfQuerySearchObject = qcg.idfQuerySearchObject
													and		qso.idfsQuery = @idfsQuery
												where qsfc.idfQuerySearchFieldCondition = tasglQuerySearchFieldCondition.idfQuerySearchFieldCondition
											)	
											
											
		delete from tasglQueryConditionGroup where exists 
											(
												select * from tasglQueryConditionGroup qcg
													inner join tasglQuerySearchObject qso
													on		qso.idfQuerySearchObject = qcg.idfQuerySearchObject
													and		qso.idfsQuery = @idfsQuery
												where qcg.idfQueryConditionGroup = tasglQueryConditionGroup.idfQueryConditionGroup
											)
	

		delete from tasglQuerySearchField 	where exists 
											(
												select * from tasglQuerySearchField qsf
													inner join	tasglQuerySearchObject	qso
													on		qsf.idfQuerySearchObject = qso.idfQuerySearchObject	
													and		qso.idfsQuery = @idfsQuery											
												where qsf.idfQuerySearchField = tasglQuerySearchField.idfQuerySearchField
											)	
		
	
		delete from tasglQuerySearchObject 	where  exists
											(
												select * from tasglQuerySearchObject qso
												where qso.idfQuerySearchObject = tasglQuerySearchObject.idfQuerySearchObject
												and qso.idfsQuery = @idfsQuery
											)


		delete from tasglQuery where idfsQuery = @idfsQuery
		
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while unpublishing query object: %s', 15, 1, @error)
		return 1
	end catch


	return 0		
end	
	
