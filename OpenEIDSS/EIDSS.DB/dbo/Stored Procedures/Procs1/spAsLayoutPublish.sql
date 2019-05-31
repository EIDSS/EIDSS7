

--##SUMMARY perform layout publishing

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 19.11.2013

--##RETURNS Don't use

/*

--Example of a call of procedure:

-- exec sp


begin tran 

declare 
	@idflLayout				bigint,  
	 @idfsLayout bigint
	 
set 	@idflLayout =  56347720000000

--SELECT  tasViewColumn.*


--   tasLayout.idflLayout, tasLayout.idfsGlobalLayout, tasViewColumn.idfLayoutSearchField, tasViewColumn.strOriginalName, tasViewColumn.strDisplayName, 
--                      tasView.idfChartXAxisViewColumn, tasView.idfMapAdminUnitViewColumn
--FROM         tasLayout INNER JOIN
--                      tasView ON tasLayout.idflLayout = tasView.idflLayout INNER JOIN
--                      tasViewColumn ON tasView.idfView = tasViewColumn.idfView AND tasView.idfsLanguage = tasViewColumn.idfsLanguage
--WHERE     (tasLayout.idfsGlobalLayout IS NULL) AND (tasLayout.idflLayout = @idflLayout)



exec [spAsLayoutPublish] @idflLayout



--SELECT    tasViewColumn.*

-- tasLayout.idfsLayout, tasViewColumn.idfLayoutSearchField, tasViewColumn.strOriginalName, tasViewColumn.strDisplayName, 
--                      tasView.idfChartXAxisViewColumn, tasView.idfMapAdminUnitViewColumn
--FROM         tasglLayout as tasLayout INNER JOIN
--                      tasglView as tasView ON tasLayout.idfsLayout = tasView.idfsLayout INNER JOIN
--                      tasglViewColumn as tasViewColumn ON tasView.idfView = tasViewColumn.idfView AND tasView.idfsLanguage = tasViewColumn.idfsLanguage



--WHERE      (tasLayout.idfsLayout = @idfsLayout )


	
ROLLBACK TRAN

IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO	

*/ 

--select * from tasLayout

create PROCEDURE [dbo].[spAsLayoutPublish]
	 @idflLayout		bigint  --##PARAM @idflLayout - existed local layout id
	 
AS
BEGIN

	declare @idfsQuery			bigint
	declare @idflQuery			bigint
	
	declare @idfsLayout			bigint
	
	declare @idfsLayoutFolder	bigint
	declare @idflLayoutFolder	bigint
    
    declare @idfsDescription	bigint
    declare @idflDescription	bigint
   
	if	not exists	(	
					select	*
					from	tasLayout
					where	idflLayout = @idflLayout
					)
	begin
		Raiserror (N'Layout with ID=%I64d doesn''t exist.', 15, 1,  @idflLayout)
		return 1
	end
	

	begin try
		select	 @idfsLayout = idfsGlobalLayout 
				,@idflQuery = idflQuery
				,@idflLayoutFolder = idflLayoutFolder
				,@idflDescription = idflDescription
		from	tasLayout	
		where	idflLayout = @idflLayout
		
		-- if local layout contains reference to global layout - return
		if (@idfsLayout is not null)
		begin
			Raiserror (N'Layout with ID=%I64d already published.', 15, 1,  @idflLayout)
			return 0
		end
		

		select	@idfsQuery = idfsGlobalQuery 
		from	tasQuery 
		where	idflQuery = @idflQuery
		
		--publish query and get global query id if needed
		if (@idfsQuery is null)
			exec spAsQueryPublish @idflQuery, @idfsQuery output
		
		--publish folder and get global folder id if needed	
		if (@idflLayoutFolder is not null)
			exec spAsFolderPublish 	@idflLayoutFolder, @idfsLayoutFolder output

     	-- publish names
	   	
	   	-- get new ID for Global Layout
		exec spsysGetNewID @idfsLayout out
		
		-- get new ID for Description
		exec spsysGetNewID @idfsDescription out
		
	   	--Layout
		insert into trtBaseReference (idfsBaseReference, idfsReferenceType, strDefault)
		select @idfsLayout, 19000050, lsnt.strTextString
		from locBaseReference as lbr
			left join locStringNameTranslation as lsnt	
			on lbr.idflBaseReference = lsnt.idflBaseReference 
			and lsnt.idfsLanguage = dbo.fnGetLanguageCode('en')
		where lbr.idflBaseReference = @idflLayout 
		
		-- translations
		insert into trtStringNameTranslation(idfsBaseReference,idfsLanguage,strTextString)
		select @idfsLayout, a.idfsLanguage, a.strTextString
		from locStringNameTranslation as a
		where idflBaseReference = @idflLayout		
		
		--- Description
		insert into trtBaseReference (idfsBaseReference, idfsReferenceType, strDefault)
		select @idfsDescription, 19000122, lsnt.strTextString
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
		
	
		-- publish layout (dosn't exists, just checked)
		insert into	tasglLayout
				(idfsLayout
				,idfsQuery
				,idfsLayoutFolder
				,idfPerson
				,idfsDescription
				,blnReadOnly
				,idfsDefaultGroupDate
				,blnShowColsTotals
				,blnShowRowsTotals
				,blnShowColGrandTotals
				,blnShowRowGrandTotals
				,blnShowForSingleTotals
				,blnApplyPivotGridFilter
				,blnShareLayout
				,blbPivotGridSettings
				
				,blbChartGeneralSettings
				,intPivotGridXmlVersion
				,blnCompactPivotGrid
				,blnFreezeRowHeaders
				,blnUseArchivedData
				,blnShowMissedValuesInPivotGrid
				,blbGisLayerGeneralSettings
				,blbGisMapGeneralSettings
				,intGisLayerPosition
				,strReservedAttribute
			   )
		select 
				 @idfsLayout		
				,@idfsQuery		
				,@idfsLayoutFolder
				,a.idfPerson
				,@idfsDescription	
				,1
				,a.idfsDefaultGroupDate
				,a.blnShowColsTotals
				,a.blnShowRowsTotals
				,a.blnShowColGrandTotals
				,a.blnShowRowGrandTotals
				,a.blnShowForSingleTotals
				,a.blnApplyPivotGridFilter
				,1
				,a.blbPivotGridSettings
				
				,a.blbChartGeneralSettings
				,a.intPivotGridXmlVersion
				,a.blnCompactPivotGrid
				,a.blnFreezeRowHeaders
				,a.blnUseArchivedData
				,a.blnShowMissedValuesInPivotGrid
				,a.blbGisLayerGeneralSettings
				,a.blbGisMapGeneralSettings
				,a.intGisLayerPosition	
				,a.strReservedAttribute			
		from	tasLayout  as a
		where	idflLayout = @idflLayout
		
		update	tasLayout
		set		 idfsGlobalLayout = @idfsLayout
				,blnShareLayout = 1
				,blnReadOnly = 1
				,blnShowDataInPivotGrid = 1
		where	idflLayout = @idflLayout	
		
		
		-- idflLayoutSearchFieldName
		declare @LayoutSearchField table (
			idfLayoutSearchField_old bigint primary key,
			idfLayoutSearchField_new bigint			
		)
		
		declare @LayoutSearchFieldName table (
			idflLayoutSearchFieldName bigint primary key,
			idfsLayoutSearchFieldName bigint			
		)
		
		insert into @LayoutSearchField (idfLayoutSearchField_old)
		select idfLayoutSearchField
		from tasLayoutSearchField 
		where idflLayout = @idflLayout
		
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		75820000000,--	trtBaseReference
				  tt.idfLayoutSearchField_old
		from	@LayoutSearchField  tt
		WHERE tt.idfLayoutSearchField_new is null

		update		tt
		set			tt.idfLayoutSearchField_new = nID.[NewID]
		from		@LayoutSearchField  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfLayoutSearchField_old
		WHERE idfLayoutSearchField_new IS NULL 

		delete from	tstNewID
		
	
		
		insert into @LayoutSearchFieldName (idflLayoutSearchFieldName)
		select idflLayoutSearchFieldName
		from tasLayoutSearchField 
		where idflLayout = @idflLayout
		and idflLayoutSearchFieldName is not null
		
		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		75820000000,--	trtBaseReference
				  tt.idflLayoutSearchFieldName
		from	@LayoutSearchFieldName  tt
		WHERE tt.idfsLayoutSearchFieldName is null

		update		tt
		set			tt.idfsLayoutSearchFieldName = nID.[NewID]
		from		@LayoutSearchFieldName  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idflLayoutSearchFieldName
		WHERE idfsLayoutSearchFieldName IS NULL 

		delete from	tstNewID
				
		insert into trtBaseReference (idfsBaseReference, idfsReferenceType, strDefault)
		select tlsf.idfsLayoutSearchFieldName, 19000143, b.strTextString
		from locBaseReference as a
			left join locStringNameTranslation as b	
			on a.idflBaseReference = b.idflBaseReference 
			and b.idfsLanguage = dbo.fnGetLanguageCode('en')
			
			inner join tasLayoutSearchField as c 
			on a.idflBaseReference = c.idflLayoutSearchFieldName
			
			inner join @LayoutSearchFieldName tlsf
			on tlsf.idflLayoutSearchFieldName = c.idflLayoutSearchFieldName
			
		where c.idflLayout = @idflLayout 


		insert into trtStringNameTranslation(idfsBaseReference,idfsLanguage,strTextString)
		select tlsf.idfsLayoutSearchFieldName, b.idfsLanguage, b.strTextString
		from locBaseReference as a
			left join locStringNameTranslation as b	
			on a.idflBaseReference = b.idflBaseReference
			 
			inner join tasLayoutSearchField as c 
			on a.idflBaseReference = c.idflLayoutSearchFieldName
			
			inner join @LayoutSearchFieldName tlsf
			on tlsf.idflLayoutSearchFieldName = c.idflLayoutSearchFieldName			

		where c.idflLayout = @idflLayout 


		-- insert Layout Search Field 
		insert into tasglLayoutSearchField
			   (
			   idfLayoutSearchField, 
			   idfsLayoutSearchFieldName, 
			   idfsLayout, 
			   idfsAggregateFunction, 
			   idfQuerySearchField, 
			   idfUnitLayoutSearchField, 
			   idfDateLayoutSearchField,
			   
			   idfsGroupDate,
			   blnShowMissedValue, 
			   datDiapasonStartDate, 
			   datDiapasonEndDate, 
			   intPrecision, 
			   intFieldCollectionIndex, 
			   intPivotGridAreaType, 
			   intFieldPivotGridAreaIndex, 
			   blnVisible, 
			   blnHiddenFilterField, 
			   intFieldColumnWidth, 
			   blnSortAcsending,
			   strFieldFilterValues,
			   strReservedAttribute
			   )
		 select
			   tlsf.idfLayoutSearchField_new, 
			   tlsfn.idfsLayoutSearchFieldName , 
			   @idfsLayout, 
			   lsf.idfsAggregateFunction, 
			   gtqsf.idfQuerySearchField, 
			   null,--tlsf_u.idfLayoutSearchField_new, 
			   null,--tlsf_d.idfLayoutSearchField_new,
			   
			   lsf.idfsGroupDate,
			   lsf.blnShowMissedValue, 
			   lsf.datDiapasonStartDate, 
			   lsf.datDiapasonEndDate, 
			   lsf.intPrecision, 
			   lsf.intFieldCollectionIndex, 
			   lsf.intPivotGridAreaType, 
			   lsf.intFieldPivotGridAreaIndex, 
			   lsf.blnVisible, 
			   lsf.blnHiddenFilterField, 
			   lsf.intFieldColumnWidth, 
			   lsf.blnSortAcsending,
			   lsf.strFieldFilterValues,
			   lsf.strReservedAttribute
		 from	tasLayoutSearchField as lsf
			inner join @LayoutSearchField tlsf
			on tlsf.idfLayoutSearchField_old = lsf.idfLayoutSearchField		
			
			left join @LayoutSearchFieldName tlsfn
			on tlsfn.idflLayoutSearchFieldName = lsf.idflLayoutSearchFieldName
			
			--left join @LayoutSearchField tlsf_u
			--on tlsf_u.idfLayoutSearchField_old = lsf.idfUnitLayoutSearchField	
			
			--left join @LayoutSearchField tlsf_d
			--on tlsf_d.idfLayoutSearchField_old = lsf.idfDateLayoutSearchField	
			
			inner join dbo.tasQuerySearchField qsf
					inner join tasQuerySearchObject tqso
					on tqso.idfQuerySearchObject = qsf.idfQuerySearchObject
					
					inner join tasQuery tq
					on tq.idflQuery = tqso.idflQuery
					
					inner join tasglQuery gtq
					on gtq.idfsQuery = tq.idfsGlobalQuery
					
					inner join tasglQuerySearchObject gtqso
					on gtqso.idfsQuery = gtq.idfsQuery and
					gtqso.idfsSearchObject = tqso.idfsSearchObject
					
					inner join tasglQuerySearchField gtqsf
					on gtqsf.idfQuerySearchObject = gtqso.idfQuerySearchObject
					and gtqsf.idfsSearchField = qsf.idfsSearchField 
					and (isnull(gtqsf.idfsParameter, 0) = isnull(qsf.idfsParameter, 0)) 
			on qsf.idfQuerySearchField = lsf.idfQuerySearchField
		 where	lsf.idflLayout = @idflLayout


		update		gllsf
		set			gllsf.idfUnitLayoutSearchField = tlsf_u.idfLayoutSearchField_new,
					gllsf.idfDateLayoutSearchField = tlsf_d.idfLayoutSearchField_new

		from		tasglLayoutSearchField gllsf
		inner join	@LayoutSearchField tlsf
		on tlsf.idfLayoutSearchField_new = gllsf.idfLayoutSearchField
		inner join	tasLayoutSearchField lsf
		on lsf.idfLayoutSearchField = tlsf.idfLayoutSearchField_old

		left join	@LayoutSearchField tlsf_u
			inner join	tasglLayoutSearchField gllsf_u
			on gllsf_u.idfLayoutSearchField = tlsf_u.idfLayoutSearchField_new
		on tlsf_u.idfLayoutSearchField_old = lsf.idfUnitLayoutSearchField	

		left join	@LayoutSearchField tlsf_d
			inner join	tasglLayoutSearchField gllsf_d
			on gllsf_d.idfLayoutSearchField = tlsf_d.idfLayoutSearchField_new
		on tlsf_d.idfLayoutSearchField_old = lsf.idfDateLayoutSearchField	

		where		lsf.idflLayout = @idflLayout
					and (	lsf.idfUnitLayoutSearchField is not null
							or	lsf.idfDateLayoutSearchField is not null
						)


-------------------------------------------------------------------------------------------
-- update Layout - blbPivotGridSettings - replace old LayoutField id's to new into filters
declare @filter as nvarchar(max)

select 
      @filter = convert(nvarchar(max), convert(varbinary(max), blbPivotGridSettings))
from tasglLayout
where idfsLayout = @idfsLayout

select
	@filter = CONVERT(VARBINARY(MAX),
								 replace( convert(nvarchar(max), convert(varbinary(max), @filter)), 
											N'idfLayoutSearchField_' + cast(lsf.idfLayoutSearchField_old as nvarchar(200)),
											N'idfLayoutSearchField_' + cast(lsf.idfLayoutSearchField_new as nvarchar(200))
										), 0)
from tasglLayout l
	cross join @LayoutSearchField lsf
where l.idfsLayout = @idfsLayout


update      tasglLayout
set         blbPivotGridSettings = CONVERT(VARBINARY(MAX), @filter, 0)
where idfsLayout = @idfsLayout

-- END update Layout - blbPivotGridSettings - replace old LayoutField id's to new into filters
-------------------------------------------------------------------------------------------



		-------------------------------------------------
		--map images
		-------------------------------------------------
		declare @MapImage table (
			idfMapImage_old bigint primary key,
			idfMapImage_new bigint
		)
		
		insert into @MapImage (idfMapImage_old, idfMapImage_new)
		select tmi.idfMapImage, tmi.idfGlobalMapImage
		from tasMapImage tmi
			inner join tasLayoutToMapImage tltmi
			on tltmi.idfMapImage = tmi.idfMapImage
		where tltmi.idflLayout = @idflLayout
		
		delete from	tstNewID
	
		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		75820000000,--	trtBaseReference
				  tt.idfMapImage_old
		from	@MapImage  tt
		WHERE tt.idfMapImage_new is null

		update		tt
		set			tt.idfMapImage_new = nID.[NewID]
		from		@MapImage  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfMapImage_old
		WHERE idfMapImage_new IS NULL 

		delete from	tstNewID
		
		insert into tasglMapImage (idfMapImage,	blbMapImage)
		select mi.idfMapImage_new, tmi.blbMapImage
		from tasMapImage tmi
			inner join tasLayoutToMapImage tltmi
			on tltmi.idfMapImage = tmi.idfMapImage
			
			inner join @MapImage mi 
			on mi.idfMapImage_old = tmi.idfMapImage
			
			left join tasglMapImage gtmi
			on gtmi.idfMapImage = tmi.idfGlobalMapImage
			
		where tltmi.idflLayout = @idflLayout
		and gtmi.idfMapImage is null
		
		
		declare @LayoutToMapImage table (
			idfLayoutToMapImage_old bigint primary key,
			idfLayoutToMapImage_new bigint
		)

		insert into @LayoutToMapImage (idfLayoutToMapImage_old)
		select idfLayoutToMapImage
		from tasLayoutToMapImage tltmi
		where tltmi.idflLayout = @idflLayout
		
		delete from	tstNewID
	
		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		75820000000,--	trtBaseReference
				  tt.idfLayoutToMapImage_old
		from	@LayoutToMapImage  tt
		WHERE tt.idfLayoutToMapImage_new is null

		update		tt
		set			tt.idfLayoutToMapImage_new = nID.[NewID]
		from		@LayoutToMapImage  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfLayoutToMapImage_old
		WHERE idfLayoutToMapImage_new IS NULL 

		delete from	tstNewID

		insert into tasglLayoutToMapImage
		(
			idfLayoutToMapImage,
			idfsLayout,
			idfMapImage
		)
		select 
			ltmi.idfLayoutToMapImage_new,
			@idfsLayout,
			tltmi.idfMapImage
		from tasLayoutToMapImage tltmi
			inner join @LayoutToMapImage ltmi
			on ltmi.idfLayoutToMapImage_old = tltmi.idfLayoutToMapImage
			
		where tltmi.idflLayout = @idflLayout

		update tmi
			set tmi.idfGlobalMapImage = mi.idfMapImage_new
		from tasMapImage tmi
			inner join @MapImage mi
			on mi.idfMapImage_old = tmi.idfMapImage
			
			inner join tasLayoutToMapImage tltmi
			on tltmi.idfMapImage = tmi.idfMapImage
		where tltmi.idflLayout = @idflLayout		
		
		-------------------------------------------------
		-- views
		-------------------------------------------------
		declare @View table (
			idfView_old bigint primary key,
			idfView_new bigint		
		)
		
		insert into @View (idfView_old, idfView_new)
		select distinct	v.idfView, @idfsLayout
		from tasView v
		where v.idflLayout = @idflLayout
		
--select * from @View
		--delete from	tstNewID

		--insert into	tstNewID
		--(	idfTable,
		--	idfKey1
		--)
		--select		4574290000000, --	tasglQuerySearchObject
		--		  tt.idfView_old
		--from	@View  tt
		--WHERE tt.idfView_new is null

		--update		tt
		--set			tt.idfView_new = nID.[NewID]
		--from		@View  tt
		--inner join	tstNewID nID
		--on			nID.idfKey1 = tt.idfView_old
		--WHERE idfView_new IS NULL 

		--delete from	tstNewID

		insert into tasglView
		(
			idfView,
			idfsLanguage,
			idfsLayout,
			idfChartXAxisViewColumn,
			idfMapAdminUnitViewColumn,
			blbChartLocalSettings,
			blbGisLayerLocalSettings,
			blbGisMapLocalSettings,
			blbViewSettings,
			strReservedAttribute
		)
		select 
			v.idfView_new,
			tv.idfsLanguage,
			@idfsLayout,
			null, -- will be updated later
			null, -- will be updated later
			tv.blbChartLocalSettings,
			tv.blbGisLayerLocalSettings,
			tv.blbGisMapLocalSettings,
			tv.blbViewSettings,
			tv.strReservedAttribute
		from tasView tv
			inner join @View v
			on v.idfView_old = tv.idfView
		where tv.idflLayout = @idflLayout
		
		update tv
			set tv.idfGlobalView =	v.idfView_new	
		from tasView tv
			inner join @View v
			on v.idfView_old = tv.idfView
		where tv.idflLayout = @idflLayout

--select * from tasView tv
--where tv.idfView = @idflLayout
		
		-- view bands
		declare @ViewBand table (
			idfViewBand_old bigint primary key,
			idfViewBand_new bigint		
		)
		
		insert into @ViewBand (idfViewBand_old)
		select distinct	vb.idfViewBand
		from tasViewBand vb
			inner join tasView tv
			on tv.idfView = vb.idfView 
			and tv.idfsLanguage = vb.idfsLanguage
		where tv.idflLayout = @idflLayout
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574290000000, --	tasglQuerySearchObject
				  tt.idfViewBand_old
		from	@ViewBand  tt
		WHERE tt.idfViewBand_new is null

		update		tt
		set			tt.idfViewBand_new = nID.[NewID]
		from		@ViewBand  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfViewBand_old
		WHERE idfViewBand_new IS NULL 

		delete from	tstNewID
		
--select * from @ViewBand

		insert into	tasglViewBand
		(	idfViewBand,
			idfView,
			idfsLanguage,
			strOriginalName,
			strDisplayName,
			blnVisible,
			intOrder,
			idfParentViewBand,
			blnFreeze,
			idfLayoutSearchField,
			strReservedAttribute
		)
		select		tvb.idfViewBand_new,
					tv.idfGlobalView,
					tv.idfsLanguage,
					vb.strOriginalName,
					vb.strDisplayName,
					vb.blnVisible,
					vb.intOrder,
					null,
					vb.blnFreeze,
					tlsf.idfLayoutSearchField_new,
					vb.strReservedAttribute
		from tasViewBand vb
			inner join @ViewBand tvb
			on tvb.idfViewBand_old = vb.idfViewBand
			
			inner join tasView tv
				inner join @View v
				on v.idfView_old = tv.idfView
			on tv.idfView = vb.idfView 
			and tv.idfsLanguage = vb.idfsLanguage
			
			left join	@LayoutSearchField tlsf
				inner join	tasLayoutSearchField lsf
				on lsf.idfLayoutSearchField = tlsf.idfLayoutSearchField_old
				inner join	tasglLayoutSearchField gllsf
				on gllsf.idfLayoutSearchField = tlsf.idfLayoutSearchField_new
			on			tlsf.idfLayoutSearchField_old = vb.idfLayoutSearchField
						and lsf.idflLayout = tv.idflLayout
			
		where	tv.idflLayout = @idflLayout
				and vb.idfParentViewBand is null

		declare	@RowCount int
		set	@RowCount = 1

		while	@RowCount > 0
		begin

			insert into	tasglViewBand
			(	idfViewBand,
			idfView,
			idfsLanguage,
			strOriginalName,
			strDisplayName,
			blnVisible,
			intOrder,
			idfParentViewBand,
			blnFreeze,
			idfLayoutSearchField,
			strReservedAttribute
		)
			select		
			tvb.idfViewBand_new,
			tv.idfGlobalView,
			tv.idfsLanguage,
			vb.strOriginalName,
			vb.strDisplayName,
			vb.blnVisible,
			vb.intOrder,
			ptvb.idfViewBand_new,
			vb.blnFreeze,
			tlsf.idfLayoutSearchField_new,
			vb.strReservedAttribute
		from tasViewBand vb
			inner join @ViewBand tvb
			on tvb.idfViewBand_old = vb.idfViewBand
			
			inner join tasView tv
				inner join @View v
				on v.idfView_old = tv.idfView
			on tv.idfView = vb.idfView 
			and tv.idfsLanguage = vb.idfsLanguage

			inner join @ViewBand ptvb
				inner join	tasglViewBand pglvb
				on	pglvb.idfViewBand = ptvb.idfViewBand_new
			on ptvb.idfViewBand_old = vb.idfParentViewBand
				and pglvb.idfView = tv.idfGlobalView
				and pglvb.idfsLanguage = tv.idfsLanguage

			left join	@LayoutSearchField tlsf
				inner join	tasLayoutSearchField lsf
				on lsf.idfLayoutSearchField = tlsf.idfLayoutSearchField_old
				inner join	tasglLayoutSearchField gllsf
				on gllsf.idfLayoutSearchField = tlsf.idfLayoutSearchField_new
			on			tlsf.idfLayoutSearchField_old = vb.idfLayoutSearchField
						and lsf.idflLayout = tv.idflLayout
			
			left join tasglViewBand vb_new
			on vb_new.idfViewBand = tvb.idfViewBand_new
			
			where	tv.idflLayout = @idflLayout
			and vb_new.idfViewBand is null

			set	@RowCount = @@rowcount
		end

		
		-- view columns
		declare @ViewColumn table (
			idfViewColumn_old bigint primary key,
			idfViewColumn_new bigint	
		)
		
		insert into @ViewColumn (idfViewColumn_old)
		select distinct tvc.idfViewColumn
		from tasViewColumn tvc
			inner join tasView tv
			on tv.idfView = tvc.idfView 
			and tv.idfsLanguage = tvc.idfsLanguage
		where tv.idflLayout = @idflLayout
		
		delete from	tstNewID

		insert into	tstNewID
		(	idfTable,
			idfKey1
		)
		select		4574290000000, --	tasglQuerySearchObject
				  tt.idfViewColumn_old
		from	@ViewColumn  tt
		WHERE tt.idfViewColumn_new is null

		update		tt
		set			tt.idfViewColumn_new = nID.[NewID]
		from		@ViewColumn  tt
		inner join	tstNewID nID
		on			nID.idfKey1 = tt.idfViewColumn_old
		WHERE idfViewColumn_new IS NULL 

		delete from	tstNewID
		
--select * from @ViewColumn
			
--select 
--	--tvc.idfViewColumn,
--	vc.idfViewColumn_new,
--	tv.idfGlobalView,
--	tvc.idfsLanguage,
--	vb.idfViewBand_new,
--	tlsf.idfLayoutSearchField_new,
--	tvc.strOriginalName,
--	tvc.strDisplayName,
--	tvc.blnAggregateColumn,
--	tvc.idfsAggregateFunction,
--	tvc.intPrecision,
--	tvc.blnChartSeries,
--	tvc.blnMapDiagramSeries,
--	tvc.blnMapGradientSeries,
--	--vc_source.idfViewColumn_new,
--	--vc_den.idfViewColumn_new,
--	tvc.blnVisible,
--	tvc.intSortOrder,
--	tvc.blnSortAscending,
--	tvc.intOrder,
--	tvc.strColumnFilter,
--	tvc.intColumnWidth,
--	tvc.blnFreeze,
--	tvc.blbChartLocalSeries
--from tasViewColumn tvc
--	left join tasViewBand tvb
--		inner join @ViewBand vb
--		on vb.idfViewBand_old = tvb.idfViewBand
--	on tvb.idfViewBand = tvc.idfViewBand

--	inner join tasView tv
--	on tv.idfView = tvc.idfView 
--	and tv.idfsLanguage = tvc.idfsLanguage
	
--	inner join @ViewColumn vc
--	on vc.idfViewColumn_old = tvc.idfViewColumn
	
--	left join @ViewColumn vc_source
--	on vc_source.idfViewColumn_old = tvc.idfSourceViewColumn
	
--	left join @ViewColumn vc_den
--	on vc_den.idfViewColumn_old = tvc.idfDenominatorViewColumn
	
--	left join @LayoutSearchField tlsf
--	on tlsf.idfLayoutSearchField_old = tvc.idfLayoutSearchField	
--where tv.idflLayout = @idflLayout
						
		insert into tasglViewColumn
		(
			idfViewColumn,
			idfView,
			idfsLanguage,
			idfViewBand,
			idfLayoutSearchField,
			strOriginalName,
			strDisplayName,
			blnAggregateColumn,
			idfsAggregateFunction,
			intPrecision,
			blnChartSeries,
			blnMapDiagramSeries,
			blnMapGradientSeries,
			--idfSourceViewColumn,
			--idfDenominatorViewColumn,
			blnVisible,
			intSortOrder,
			blnSortAscending,
			intOrder,
			strColumnFilter,
			intColumnWidth,
			blnFreeze,
			blbChartLocalSeries,
			strReservedAttribute
		)
		select 
			--tvc.idfViewColumn,
			vc.idfViewColumn_new,
			tv.idfGlobalView,
			tvc.idfsLanguage,
			vb.idfViewBand_new,
			tlsf.idfLayoutSearchField_new,
			tvc.strOriginalName,
			tvc.strDisplayName,
			tvc.blnAggregateColumn,
			tvc.idfsAggregateFunction,
			tvc.intPrecision,
			tvc.blnChartSeries,
			tvc.blnMapDiagramSeries,
			tvc.blnMapGradientSeries,
			--vc_source.idfViewColumn_new,
			--vc_den.idfViewColumn_new,
			tvc.blnVisible,
			tvc.intSortOrder,
			tvc.blnSortAscending,
			tvc.intOrder,
			tvc.strColumnFilter,
			tvc.intColumnWidth,
			tvc.blnFreeze,
			tvc.blbChartLocalSeries,
			tvc.strReservedAttribute
		from tasViewColumn tvc
			left join tasViewBand tvb
				inner join @ViewBand vb
				on vb.idfViewBand_old = tvb.idfViewBand
			on tvb.idfViewBand = tvc.idfViewBand
		
			inner join tasView tv
			on tv.idfView = tvc.idfView 
			and tv.idfsLanguage = tvc.idfsLanguage
			
			inner join @ViewColumn vc
			on vc.idfViewColumn_old = tvc.idfViewColumn
			
			left join @ViewColumn vc_source
			on vc_source.idfViewColumn_old = tvc.idfSourceViewColumn
			
			left join @ViewColumn vc_den
			on vc_den.idfViewColumn_old = tvc.idfDenominatorViewColumn
			
			left join @LayoutSearchField tlsf
			on tlsf.idfLayoutSearchField_old = tvc.idfLayoutSearchField	
		where tv.idflLayout = @idflLayout		
	
		
		update glvc set
			glvc.idfSourceViewColumn = vc_source.idfViewColumn_new
		from tasglViewColumn glvc
			inner join @ViewColumn vc
			on vc.idfViewColumn_new = glvc.idfViewColumn
		
			inner join tasViewColumn tvc
			on tvc.idfViewColumn = vc.idfViewColumn_old
			
			inner join @ViewColumn vc_source
			on vc_source.idfViewColumn_old = tvc.idfSourceViewColumn
		where tvc.idfSourceViewColumn is not null	


		update glvc set
			glvc.idfDenominatorViewColumn = vc_den.idfViewColumn_new		
		from tasglViewColumn glvc
			inner join @ViewColumn vc
			on vc.idfViewColumn_new = glvc.idfViewColumn
		
			inner join tasViewColumn tvc
			on tvc.idfViewColumn = vc.idfViewColumn_old
			
			inner join @ViewColumn vc_den
			on vc_den.idfViewColumn_old = tvc.idfDenominatorViewColumn
		where tvc.idfDenominatorViewColumn is not null	
	
		
		update tv  set
			tv.idfChartXAxisViewColumn = vc.idfViewColumn_new
		from tasglView tv
			inner join tasView tv_old
			on tv_old.idfsLanguage = tv.idfsLanguage 
			and tv_old.idfGlobalView = tv.idfView
		
			inner join tasglViewColumn tvc
			on tvc.idfView = tv.idfView 
			and tvc.idfsLanguage = tv.idfsLanguage 

			inner join @ViewColumn vc
			on vc.idfViewColumn_new = tvc.idfViewColumn
			and vc.idfViewColumn_old = tv_old.idfChartXAxisViewColumn			
		where tv_old.idflLayout = @idflLayout	
	
		
		update tv  set
			tv.idfMapAdminUnitViewColumn = vc.idfViewColumn_new
		from tasglView tv
			inner join tasView tv_old
			on tv_old.idfsLanguage = tv.idfsLanguage 
			and tv_old.idfGlobalView = tv.idfView

			inner join tasglViewColumn tvc
			on tvc.idfView = tv.idfView 
			and tvc.idfsLanguage = tv.idfsLanguage 
			
			inner join @ViewColumn vc
			on vc.idfViewColumn_new = tvc.idfViewColumn
			and vc.idfViewColumn_old = tv_old.idfMapAdminUnitViewColumn			
		where tv_old.idflLayout = @idflLayout	

		
		-- write check sum for global layout
		update tasglLayout
		set
			strReservedAttribute = dbo.fnGetLayoutGlobalCheckSumString (@idfsLayout) 
		where idfsLayout = @idfsLayout



		select 
			@idflLayout	as idfOld,
			@idfsLayout	as idfNew
		union all
		select 
			@idflDescription	as idfOld,
			@idfsDescription	as idfNew
		union all
		select 
			idfLayoutSearchField_old as idfOld,
			idfLayoutSearchField_new as idfNew
		from @LayoutSearchField
			
		
		
		
	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while publishing layout object: %s', 15, 1, @error)
		return 1
	end catch


	return 0
END


