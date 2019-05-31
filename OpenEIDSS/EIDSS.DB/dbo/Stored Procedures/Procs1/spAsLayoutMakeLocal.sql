

--##SUMMARY copies published layout to local table
--##SUMMARY it is assumed that layout is copied inside outer transaction created by client 
--##SUMMARY and all changes that are made inside procedure will be rollbacked if procedure returns 0
--##SUMMARY or if error occur during procedure execution
 
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.08.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS 0 if layout is fully copied
--##RETURNS 1 in other case

/*

--Example of a call of procedure: 


exec spAsLayoutMakeLocal @idfsLayout=721500000000
*/ 

create PROCEDURE [dbo].[spAsLayoutMakeLocal]
	 @idfsLayout				bigint	--##PARAM @idfsLayout - Id of global layout that should be copied

AS
BEGIN
	if	not exists	(	
					select	*
					from	tasglLayout
					where	idfsLayout = @idfsLayout
					)
	begin
		Raiserror (N'Global Layout with ID=%I64d doesn''t exist.', 15, 1,  @idfsLayout)
		return 1
	end
	
	declare @idflQuery		bigint
	declare @idfsQuery		bigint
	declare @idflLayout		bigint
	declare @idflFolder		bigint
	declare @idfsFolder		bigint
	declare	@bitNewQuery	bit
    declare @idflDescription	bigint
    --declare @idflMapName		bigint
    --declare @idflPivotName		bigint
   -- declare @idflChartName		bigint
    declare @idfsRFT			bigint
    declare @strBaseReferenceCode	varchar(36)
	
	declare @strENLayoutName		nvarchar(2000)
	declare @strENPivotName			nvarchar(2000)
	declare @strENDescription		nvarchar(2000)
	declare @strENMapName			nvarchar(2000)
	declare @strENChartName			nvarchar(2000)
    declare @strLocalLayoutName		nvarchar(2000)
	declare @strLocalPivotName		nvarchar(2000)
	declare @strLocalDescription	nvarchar(2000)
	declare @strLocalMapName		nvarchar(2000)
	declare @strLocalChartName		nvarchar(2000)

    
    begin try
		begin tran
		
		--get @idfsQuery, @idfsFolder
			select	@idfsQuery = idfsQuery,
					@idfsFolder = idfsLayoutFolder,
					@idflDescription = idfsDescription
					--@idflMapName	=idfsMapName,
					--@idflPivotName	=idfsPivotName,
					--@idflChartName	=idfsChartName
			
			from	tasglLayout 
			where	idfsLayout = @idfsLayout
			
		--get @idflQuery
			select	@idflQuery = idflQuery 
			from	tasQuery 
			where	idfsGlobalQuery = @idfsQuery	

		--get @idflLayout
			select	 @idflLayout = idflLayout
			from	 tasLayout 
			where	 idfsGlobalLayout = @idfsLayout

		-- if global layout has reference to local - nothing should be done
			if (@idflLayout is not null)
			begin
				rollback tran
				return 0 
			end
			
		-- let local layout has the same id as global	
			set @idflLayout	 = @idfsLayout
			
		-- if local layout exists - nothing should be done
			if exists	(	
					select	*
					from	tasLayout
					where	idflLayout = @idflLayout
					)
			begin
				rollback tran
				return 0 
			end
			

		--create local query if needed
			if (@idflQuery is null)
			begin
				set @bitNewQuery = 1
				exec spAsQueryMakeLocal @idfsQuery, @idflQuery output
			end
			
			 
		--create local folder  
			if (@idfsFolder is not null)
				exec spAsFolderMakeLocal 	@idfsFolder, @idflQuery,  @idflFolder output
			
			

			
			
		select		@strENLayoutName = refENLayout.name
				  --,@strENPivotName = refENPivot.name		
				  ,@strENDescription = refENDescription.name	
				  --,@strENMapName = refENMap.name			
				  --,@strENChartName = refENChart.name		
		from		dbo.tasglLayout	as tLayout
		inner join	dbo.fnReference('en',19000050)	as refENLayout
				on	tLayout.idfsLayout = refENLayout.idfsReference
		 left join	dbo.fnReference('en',19000122)	as refENDescription
				on	tLayout.idfsDescription = refENDescription.idfsReference
		/* left join	dbo.fnReference('en',19000124)	as refENPivot
				on	tLayout.idfsPivotName = refENPivot.idfsReference*/
		/* left join	dbo.fnReference('en',19000126)	as refENMap
				on	tLayout.idfsMapName = refENMap.idfsReference*/
		 /*left join	dbo.fnReference('en',19000125)	as refENChart
				on	tLayout.idfsChartName = refENChart.idfsReference*/
			where	tLayout.idfsLayout = @idfsLayout
			
		exec spAsReferencePost 'en',	@idflLayout, @strENLayoutName	
		/*if (@idflPivotName is not null)		
			exec spAsReferencePost 'en',	@idflPivotName, @strENPivotName*/
		if (@idflDescription is not null)		
			exec spAsReferencePost 'en',	@idflDescription, @strENDescription	
		/*if (@idflMapName is not null)		
			exec spAsReferencePost 'en',	@idflMapName, @strENMapName*/
		/*if (@idflChartName is not null)		
			exec spAsReferencePost 'en',	@idflChartName, @strENChartName	*/
			
			
			
		-- cursor for insert all translation
		declare LocalReferencePostCursor cursor for
		select  strBaseReferenceCode
		from	fnBaseReferenceCode()
		
		open LocalReferencePostCursor
		
		fetch next from LocalReferencePostCursor into @strBaseReferenceCode
		while @@fetch_status = 0
		begin
			select		@strLocalLayoutName = refLocalLayout.name
					  --,@strLocalPivotName = refLocalPivot.name		
					  ,@strLocalDescription = refLocalDescription.name	
					  --,@strLocalMapName = refLocalMap.name			
					  --,@strLocalChartName = refLocalChart.name		
			from		dbo.tasglLayout	as tLayout
			inner join	dbo.fnReference(@strBaseReferenceCode,19000050)	as refLocalLayout
					on	tLayout.idfsLayout = refLocalLayout.idfsReference
			 left join	dbo.fnReference(@strBaseReferenceCode,19000122)	as refLocalDescription
					on	tLayout.idfsDescription = refLocalDescription.idfsReference
			/* left join	dbo.fnReference(@strBaseReferenceCode,19000124)	as refLocalPivot
					on	tLayout.idfsPivotName = refLocalPivot.idfsReference*/
			 /*left join	dbo.fnReference(@strBaseReferenceCode,19000126)	as refLocalMap
					on	tLayout.idfsMapName = refLocalMap.idfsReference*/
			/* left join	dbo.fnReference(@strBaseReferenceCode,19000125)	as refLocalChart
					on	tLayout.idfsChartName = refLocalChart.idfsReference*/
				where	tLayout.idfsLayout = @idfsLayout
				
			-- insert translation if language is not english
			if (@strBaseReferenceCode != 'en')
			begin
				exec spAsReferencePost @strBaseReferenceCode,	@idflLayout, @strLocalLayoutName	
				/*if (@idflPivotName is not null)		
					exec spAsReferencePost @strBaseReferenceCode,	@idflPivotName, @strLocalPivotName*/
				if (@idflDescription is not null)		
					exec spAsReferencePost @strBaseReferenceCode,	@idflDescription, @strLocalDescription	
				/*if (@idflMapName is not null)		
					exec spAsReferencePost @strBaseReferenceCode,	@idflMapName, @strLocalMapName*/
				/*if (@idflChartName is not null)		
					exec spAsReferencePost @strBaseReferenceCode,	@idflChartName, @strLocalChartName*/	
			end

			fetch next from LocalReferencePostCursor into @strBaseReferenceCode
		end
		close LocalReferencePostCursor
		deallocate LocalReferencePostCursor

		insert into	tasLayout
					(idflLayout
					,idfsGlobalLayout
					,idflQuery
					,idflLayoutFolder
					,idfPerson
					,idflDescription
					,blnReadOnly
					--,idflMapName
					--,idflPivotName
					--,idflChartName
					,idfsDefaultGroupDate
					--,idfsChartType
					,blnShowColsTotals
					,blnShowRowsTotals
					,blnShowColGrandTotals
					,blnShowRowGrandTotals
					,blnShowForSingleTotals
					,blnApplyPivotGridFilter
					,blnShareLayout
					--,blnPivotAxis
					--,blnShowXLabels
					--,blnShowPointLabels
					,blbPivotGridSettings
					,blnShowDataInPivotGrid
						
				   )
			select 
					 @idflLayout		
					,@idfsLayout
					,@idflQuery		
					,@idflFolder
					,null
					,@idflDescription	
					,1
					--,@idflMapName		
					--,@idflPivotName	
					--,@idflChartName	
					,idfsDefaultGroupDate
					--,idfsChartType
					,blnShowColsTotals
					,blnShowRowsTotals
					,blnShowColGrandTotals
					,blnShowRowGrandTotals
					,blnShowForSingleTotals
					,blnApplyPivotGridFilter
					,1
					--,blnPivotAxis
					--,blnShowXLabels
					--,blnShowPointLabels
					,blbPivotGridSettings
					,1
			from	tasglLayout 
			where	idfsLayout = @idfsLayout

			-- make local query objects if needed
		
		
			if (@bitNewQuery = 1)
			begin
				exec spAsQuerySearchObjectMakeLocal @idflLayout, @idfsLayout
				exec spAsQueryFunction_Post	@idflQuery
			end
			
			
				
			-- delete old Layout Search Field Aggregation
			delete		loc
			from		tasLayoutSearchField loc
			inner join  tasglLayoutSearchField glb
			on			loc.idfLayoutSearchField = glb.idfLayoutSearchField
			where		glb.idfsLayout = @idfsLayout

		-- idflLayoutSearchFieldName
			insert into locBaseReference 
			select a.idfsBaseReference
			from trtBaseReference as a
			left join trtStringNameTranslation as b	on a.idfsBaseReference = b.idfsBaseReference and b.idfsLanguage = dbo.fnGetLanguageCode('en')
			inner join tasglLayoutSearchField as c on a.idfsBaseReference = c.idfsLayoutSearchFieldName
			left join locBaseReference as d on a.idfsBaseReference = d.idflBaseReference
			where c.idfsLayout = @idfsLayout 
			and d.idflBaseReference is null

			insert into locStringNameTranslation(idflBaseReference,idfsLanguage,strTextString)
			select b.idfsBaseReference, b.idfsLanguage, b.strTextString
			from trtBaseReference as a
			left join trtStringNameTranslation as b	on a.idfsBaseReference = b.idfsBaseReference 
			inner join tasglLayoutSearchField as c on a.idfsBaseReference = c.idfsLayoutSearchFieldName
			left join locStringNameTranslation as d
			on b.idfsBaseReference = d.idflBaseReference and b.idfsLanguage = d.idfsLanguage
			where c.idfsLayout = @idfsLayout 
			and d.idflBaseReference is null
			
			-- insert Layout Search Field Aggregation
			insert into tasLayoutSearchField
				   (
				   idfLayoutSearchField, 
				   idflLayoutSearchFieldName, 
				   idflLayout, 
				   idfsAggregateFunction, 
				   idfQuerySearchField, 
				   idfUnitLayoutSearchField, 
				   --idfDenominatorQuerySearchField, 
				   idfDateLayoutSearchField
				   )
			 select
				   a.idfLayoutSearchField, 
				   a.idfsLayoutSearchFieldName, 
				   a.idfsLayout, 
				   a.idfsAggregateFunction, 
				   a.idfQuerySearchField, 
				   a.idfUnitLayoutSearchField, 
				   --a.idfDenominatorQuerySearchField, 
				   a.idfDateLayoutSearchField
			 from	tasglLayoutSearchField as a
			 left join tasLayoutSearchField as d on a.idfLayoutSearchField = d.idfLayoutSearchField
			 where	a.idfsLayout = @idflLayout
			 and d.idfLayoutSearchField is null  

			select	 *
			from	 tasLayout 
			where	 idflLayout = @idflLayout
		commit tran
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		rollback tran
		Raiserror (N'Error while making local layout: %s', 15, 1, @error)
		return 1
	end catch
	
	return 0 --dummy return that assumes that operation performed successfully
END


