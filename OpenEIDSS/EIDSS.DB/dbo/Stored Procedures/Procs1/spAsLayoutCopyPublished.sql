

--##SUMMARY copies published layout to local table
--##SUMMARY it is assumed that layout is copied inside outer transaction created by client 
--##SUMMARY and all changes that are made inside procedure will be rollbacked if procedure returns 0
--##SUMMARY or if error occur during procedure execution
 
--##REMARKS Author: Romasheva S.
--##REMARKS Create date: 25.11.2013

--##RETURNS 0 if layout is fully copied
--##RETURNS 1 in other case

/*

--Example of a call of procedure: 
begin tran 

declare @idfsLayout bigint, 
@idflLayout bigint

set @idfsLayout=12904170000870

exec spAsLayoutCopyPublished @idfsLayout, @idflLayout out
print @idflLayout

ROLLBACK TRAN


IF @@ERROR <> 0
	ROLLBACK TRAN
ELSE
	COMMIT TRAN
GO
*/ 

create PROCEDURE [dbo].[spAsLayoutCopyPublished]
	 @idfsLayout				bigint,	--##PARAM @idfsLayout - Id of global layout that should be copied
	 @idflLayout				bigint = null out	--##PARAM @idfsLayout - Id of local layout 
AS
begin
	declare @idflQuery		bigint
	declare @idfsQuery		bigint
	
	declare @idflLayoutFolder	bigint
	declare @idfsLayoutFolder		bigint
	

	if	not exists	(	
					select	*
					from	tasglLayout
					where	idfsLayout = @idfsLayout
					)
	begin
		Raiserror (N'Global Layout with ID=%I64d doesn''t exist.', 15, 1,  @idfsLayout)
		return 1
	end
	
	declare @strLayoutCheckSum nvarchar(max)
	declare @strLayoutCheckSum_real nvarchar(max)
	
	select @strLayoutCheckSum = isnull(tl.strReservedAttribute, ''), @strLayoutCheckSum_real = dbo.fnGetLayoutGlobalCheckSumString (tl.idfsLayout) 
	from tasglLayout tl
	where tl.idfsLayout = @idfsLayout
	
	if	@strLayoutCheckSum <> @strLayoutCheckSum_real
	begin
		Raiserror (N'Global Layout with ID=%I64d  is not complete.', 15, 1,  @idfsLayout)
		return 2
	end
	
	-- if global layout has reference to local - nothing should be done
	select @idflLayout = idflLayout
	from	 tasLayout 
	where	 idfsGlobalLayout = @idfsLayout

	if @idflLayout is not null
		return 0 
   
    begin try

		-- let local layout has the same id as global	
		set @idflLayout	 = @idfsLayout
			
		-- if local layout exists - nothing should be done
		if exists	(	
			select	*
			from	tasLayout
			where	idflLayout = @idflLayout
		)	return 0 
			

		select @idfsLayoutFolder = tl.idfsLayoutFolder, @idfsQuery = tl.idfsQuery
		from tasglLayout tl
		where tl.idfsLayout = @idfsLayout
		
		--if need create local folder and get local ID  
		if (@idfsLayoutFolder is not null)
			exec spAsFolderCopyPublished @idfsLayoutFolder, @idflLayoutFolder output

		--if need create local query and get local ID
		exec spAsQueryCopyPublished @idfsQuery, @idflQuery output
		
		-- AVR Layout Name
		insert into	locBaseReference
		(	idflBaseReference
		)
		select		l.idfsLayout
		from		tasglLayout l
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = l.idfsLayout
					and br_l.idfsReferenceType = 19000050	-- AVR Layout Name
					and br_l.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = l.idfsLayout
		left join	tasLayout l_loc
		on			l_loc.idfsGlobalLayout = l.idfsLayout
		where		l.idfsLayout = @idfsLayout
					and l_loc.idflLayout is null
					and lbr.idflBaseReference is null

		-- AVR Layout Description
		insert into	locBaseReference
		(	idflBaseReference
		)
		select		l.idfsDescription
		from		tasglLayout l
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = l.idfsDescription
					and br_l.idfsReferenceType = 19000122	-- AVR Layout Description
					and br_l.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = l.idfsDescription
		left join	tasLayout l_loc
		on			l_loc.idfsGlobalLayout = l.idfsLayout
		where		l.idfsLayout = @idfsLayout
					and l_loc.idflLayout is null
					and lbr.idflBaseReference is null
		
		-- AVR Layout Field Name	
		insert into	locBaseReference
		(	idflBaseReference
		)
		select		lsf.idfsLayoutSearchFieldName
		from		tasglLayout l
		inner join	tasglLayoutSearchField lsf
		on			lsf.idfsLayout = l.idfsLayout
		inner join	trtBaseReference br_l
		on			br_l.idfsBaseReference = lsf.idfsLayoutSearchFieldName
					and br_l.idfsReferenceType = 19000143	-- AVR Layout Field Name
					and br_l.intRowStatus = 0
		left join	locBaseReference lbr
		on			lbr.idflBaseReference = lsf.idfsLayoutSearchFieldName
		left join	tasLayout l_loc
		on			l_loc.idfsGlobalLayout = l.idfsLayout
		where		l.idfsLayout = @idfsLayout
					and l_loc.idflLayout is null
					and lbr.idflBaseReference is null		
		
		-- AVR Layout Name	
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
					and br.idfsReferenceType = 19000050	-- AVR Layout Name
					and br.intRowStatus = 0
		inner join tasglLayout tl
		on			tl.idfsLayout = br.idfsBaseReference
					and tl.idfsLayout = @idfsLayout
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null
								
		-- AVR Layout Description
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
					and br.idfsReferenceType = 19000122	-- AVR Layout Description
					and br.intRowStatus = 0
		inner join tasglLayout tl
		on			tl.idfsDescription = br.idfsBaseReference
					and tl.idfsLayout = @idfsLayout					
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null			
			
		-- AVR Layout Field Name	
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
					and br.idfsReferenceType = 19000143	-- AVR Layout Field Name
		inner join	tasglLayoutSearchField lsf
		on			lsf.idfsLayout = @idfsLayout
					and lsf.idfsLayoutSearchFieldName = br.idfsBaseReference		
		inner join	locBaseReference lbr
		on			lbr.idflBaseReference = br.idfsBaseReference
		left join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = lbr.idflBaseReference
					and lsnt.idfsLanguage = snt.idfsLanguage
		where		snt.intRowStatus = 0
					and lsnt.idflBaseReference is null			
			
		
		insert into tasLayout
		(	 idflLayout
			,idfsGlobalLayout
			,idflQuery
			,idflLayoutFolder
			,idfPerson
			,idflDescription
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
			,blnShowDataInPivotGrid
		)
		select		 gl.idfsLayout
					,gl.idfsLayout
					,q.idflQuery
					,lf.idflLayoutFolder
					,null
					,gl.idfsDescription
					,1
					,gl.idfsDefaultGroupDate
					,gl.blnShowColsTotals
					,gl.blnShowRowsTotals
					,gl.blnShowColGrandTotals
					,gl.blnShowRowGrandTotals
					,gl.blnShowForSingleTotals
					,gl.blnApplyPivotGridFilter
					,1
					,gl.blbPivotGridSettings
					,gl.blbChartGeneralSettings
					,gl.intPivotGridXmlVersion
					,gl.blnCompactPivotGrid
					,gl.blnFreezeRowHeaders
					,gl.blnUseArchivedData
					,gl.blnShowMissedValuesInPivotGrid
					,gl.blbGisLayerGeneralSettings
					,gl.blbGisMapGeneralSettings
					,gl.intGisLayerPosition
					,gl.strReservedAttribute
					,1

		from		tasglLayout gl
		inner join	tasQuery q
		on			q.idfsGlobalQuery = gl.idfsQuery
		left join	tasLayoutFolder lf
		on			lf.idflQuery = q.idflQuery
					and lf.idfsGlobalLayoutFolder = gl.idfsLayoutFolder
		left join	tasLayout l
		on			l.idflLayout = gl.idfsLayout
		left join	tasLayout l_original
		on			l_original.idfsGlobalLayout = gl.idfsLayout
		where		gl.idfsLayout = @idfsLayout
					and l_original.idflLayout is null
					and l.idflLayout is null
			
			
		declare	@LayoutNameConflicts	table
		(	idflLayout	bigint not null,
			idfsLanguage		bigint not null,
			idflQuery			bigint not null,
			strLayoutName	nvarchar(2000) collate database_default null,
			intIndex			int null,
			primary key	(
				idflLayout asc,
				idfsLanguage asc
						)
		)
		
	
		insert into	@LayoutNameConflicts
		(	idflLayout,
			idfsLanguage,
			idflQuery,
			strLayoutName,
			intIndex
		)
		select		l.idflLayout,
					lsnt.idfsLanguage,
					l.idflQuery,
					lsnt.strTextString,
					null
		from		tasLayout l
		inner join	locStringNameTranslation lsnt
		on			lsnt.idflBaseReference = l.idflLayout
		
		inner join tasLayout tl_new
		on tl_new.idflLayout = @idfsLayout
		and tl_new.idflQuery = l.idflQuery
		
		where l.idflLayout <> @idflLayout


		update layout_conflicts set
			layout_conflicts.intIndex = s.intIndex
		from @LayoutNameConflicts as layout_conflicts
			inner join (
					select 
						max(cast(substring(lfnc.strLayoutName, len(lsnt_new.strTextString) + 2, len(lfnc.strLayoutName)) as int)) + 1 as intIndex,
						lsnt_new.strTextString as strTextString,
						lfnc.idfsLanguage as idfsLanguage
					from @LayoutNameConflicts lfnc
						inner join locStringNameTranslation lsnt_new  
						on lfnc.idfsLanguage = lsnt_new.idfsLanguage
						and 
						(lsnt_new.strTextString = lfnc.strLayoutName collate database_default
						or (lsnt_new.strTextString = substring(lfnc.strLayoutName, 1, len(lsnt_new.strTextString)) collate database_default
							and isnumeric (substring(lfnc.strLayoutName, len(lsnt_new.strTextString) + 2, len(lfnc.strLayoutName))) = 1 
							) 
						)
						inner join tasLayout f_new
						on f_new.idflLayout = lsnt_new.idflBaseReference
						and f_new.idflLayout = @idflLayout

					group by lsnt_new.strTextString, lfnc.idfsLanguage
			) as s
			on	layout_conflicts.idfsLanguage = s.idfsLanguage  
			and layout_conflicts.strLayoutName = s.strTextString collate database_default

		
		update		lsnt
		set			lsnt.strTextString = IsNull(lnc.strLayoutName, N'') + N'_' + 
											cast(lnc.intIndex as nvarchar(20))
		from		locStringNameTranslation lsnt
		inner join	@LayoutNameConflicts lnc
		on			lnc.idflLayout = lsnt.idflBaseReference
					and lnc.idfsLanguage = lsnt.idfsLanguage
					and IsNull(lnc.intIndex, 0) > 0
		inner join tasLayout tl
		on tl.idflLayout = lnc.idflLayout
		and tl.idfsGlobalLayout is null
			

				
					
		insert into	tasLayoutSearchField
		(	idfLayoutSearchField,
			idflLayoutSearchFieldName,
			idflLayout,
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
		select		gllsf.idfLayoutSearchField,
					gllsf.idfsLayoutSearchFieldName,
					l.idflLayout,
					gllsf.idfsAggregateFunction,
					loc_qsf.idfQuerySearchField,
					null,--gllsf.idfUnitLayoutSearchField,
					null,--gllsf.idfDateLayoutSearchField,
					gllsf.idfsGroupDate,
					gllsf.blnShowMissedValue,
					gllsf.datDiapasonStartDate,
					gllsf.datDiapasonEndDate,
					gllsf.intPrecision,
					gllsf.intFieldCollectionIndex,
					gllsf.intPivotGridAreaType,
					gllsf.intFieldPivotGridAreaIndex,
					gllsf.blnVisible,
					gllsf.blnHiddenFilterField,
					gllsf.intFieldColumnWidth,
					gllsf.blnSortAcsending,
					gllsf.strFieldFilterValues,
					gllsf.strReservedAttribute
		from		tasglLayoutSearchField gllsf
		inner join	tasLayout l
		on			l.idfsGlobalLayout = gllsf.idfsLayout
					and l.idflLayout = gllsf.idfsLayout
		
		inner join dbo.tasglQuerySearchField gl_qsf
					inner join tasglQuerySearchObject ql_qso
					on ql_qso.idfQuerySearchObject = gl_qsf.idfQuerySearchObject
					
					inner join tasglQuery gl_g
					on gl_g.idfsQuery = ql_qso.idfsQuery
					
					inner join tasQuery loc_q
					on loc_q.idfsGlobalQuery = gl_g.idfsQuery
					
					inner join tasQuerySearchObject loc_qso
					on loc_qso.idflQuery = loc_q.idflQuery and
					loc_qso.idfsSearchObject = ql_qso.idfsSearchObject
					
					inner join tasQuerySearchField loc_qsf
					on loc_qsf.idfQuerySearchObject = loc_qso.idfQuerySearchObject
					and loc_qsf.idfsSearchField = gl_qsf.idfsSearchField 
					and (isnull(loc_qsf.idfsParameter, 0) = isnull(gl_qsf.idfsParameter, 0)) 
		on gl_qsf.idfQuerySearchField = gllsf.idfQuerySearchField
		
		left join	tasLayoutSearchField lsf
		on			lsf.idfLayoutSearchField = gllsf.idfLayoutSearchField

		where	l.idflLayout = @idfsLayout
				and lsf.idfLayoutSearchField is null			
		print '--------111111111111'

		update		lsf
		set			lsf.idfUnitLayoutSearchField = lsf_unit.idfLayoutSearchField,
					lsf.idfDateLayoutSearchField = lsf_date.idfLayoutSearchField
		from		tasglLayoutSearchField gllsf
		inner join	tasLayout l
		on			l.idfsGlobalLayout = gllsf.idfsLayout
					and l.idflLayout = gllsf.idfsLayout
		inner join	tasLayoutSearchField lsf
		on			lsf.idfLayoutSearchField = gllsf.idfLayoutSearchField
		left join	tasLayoutSearchField lsf_unit
		on			lsf_unit.idfLayoutSearchField = gllsf.idfUnitLayoutSearchField
					and lsf_unit.idflLayout = l.idflLayout
		left join	tasLayoutSearchField lsf_date
		on			lsf_date.idfLayoutSearchField = gllsf.idfDateLayoutSearchField
					and lsf_date.idflLayout = l.idflLayout
		where		l.idflLayout = @idfsLayout
					and (	gllsf.idfUnitLayoutSearchField is not null
							or	gllsf.idfDateLayoutSearchField is not null
						)
		print '--------222222222222222222'	

		insert into	tasMapImage
		(	idfMapImage,
			idfGlobalMapImage,
			blbMapImage
		)
		select		gmi.idfMapImage,
					gmi.idfMapImage,
					gmi.blbMapImage
		from		tasglMapImage gmi
		inner join	tasglLayoutToMapImage ltmi
		on ltmi.idfMapImage = gmi.idfMapImage
		and ltmi.idfsLayout = @idfsLayout
		left join	tasMapImage mi
		on			mi.idfMapImage = gmi.idfMapImage
		left join	tasMapImage mi_original
		on			mi_original.idfGlobalMapImage = gmi.idfMapImage
		where		mi_original.idfMapImage is null
					and	mi.idfMapImage is null
				
		insert into	tasLayoutToMapImage
		(	idfLayoutToMapImage,
			idflLayout,
			idfMapImage
		)
		select		gl_to_gmi.idfLayoutToMapImage,
					l.idflLayout,
					mi.idfMapImage
		from		tasglLayoutToMapImage gl_to_gmi
		inner join	tasLayout l
		on			l.idfsGlobalLayout = gl_to_gmi.idfsLayout
					and l.idflLayout = gl_to_gmi.idfsLayout
					and l.idflLayout = @idfsLayout
		inner join	tasMapImage mi
		on			mi.idfGlobalMapImage = gl_to_gmi.idfMapImage
					and mi.idfMapImage = gl_to_gmi.idfMapImage
		left join	tasLayoutToMapImage l_to_mi
		on			l_to_mi.idfLayoutToMapImage = gl_to_gmi.idfLayoutToMapImage
		left join	tasLayoutToMapImage l_to_mi_dupl
		on			l_to_mi_dupl.idflLayout = l.idflLayout
					and	l_to_mi_dupl.idfMapImage = mi.idfMapImage
		where		l_to_mi.idfLayoutToMapImage is null
					and l_to_mi_dupl.idfLayoutToMapImage is null	
			
		insert into	tasView
		(	idfView,
			idfsLanguage,
			idflLayout,
			idfChartXAxisViewColumn,
			idfMapAdminUnitViewColumn,
			blbChartLocalSettings,
			blbGisLayerLocalSettings,
			blbGisMapLocalSettings,
			blbViewSettings,
			strReservedAttribute
		)
		select		gv.idfView,
					gv.idfsLanguage,
					l.idflLayout,
					null,--gv.idfChartXAxisViewColumn,
					null,--gv.idfMapAdminUnitViewColumn,
					gv.blbChartLocalSettings,
					gv.blbGisLayerLocalSettings,
					gv.blbGisMapLocalSettings,
					gv.blbViewSettings,
					gv.strReservedAttribute
		from		tasglView gv
		inner join	tasLayout l
		on			l.idfsGlobalLayout = gv.idfsLayout
					and l.idflLayout = gv.idfsLayout
		left join	tasView v
		on			v.idfView = gv.idfView
					and v.idfsLanguage = gv.idfsLanguage
		where		gv.idfsLayout = @idfsLayout
					and v.idfView is null
	
		insert into	tasViewBand
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
		select		gvb.idfViewBand,
					v.idfView,
					v.idfsLanguage,
					gvb.strOriginalName,
					gvb.strDisplayName,
					gvb.blnVisible,
					gvb.intOrder,
					gvb.idfParentViewBand,
					gvb.blnFreeze,
					gvb.idfLayoutSearchField,
					gvb.strReservedAttribute
		from		tasglViewBand gvb
		inner join	tasView v
		on			v.idfView = gvb.idfView
					and v.idfsLanguage = gvb.idfsLanguage
		inner join	tasLayout l
		on			l.idfsGlobalLayout = v.idflLayout
					and l.idflLayout = v.idflLayout
		left join	tasViewBand vb
		on			vb.idfViewBand = gvb.idfViewBand
		where		v.idflLayout = @idfsLayout
					and gvb.idfParentViewBand is null
					and vb.idfViewBand is null

		declare	@RowCount int
		set	@RowCount = 1

		while	@RowCount > 0
		begin

			insert into	tasViewBand
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
			select		gvb.idfViewBand,
						v.idfView,
						v.idfsLanguage,
						gvb.strOriginalName,
						gvb.strDisplayName,
						gvb.blnVisible,
						gvb.intOrder,
						vb_parent.idfViewBand,
						gvb.blnFreeze,
						gvb.idfLayoutSearchField,
						gvb.strReservedAttribute
			from		tasglViewBand gvb
			inner join	tasView v
			on			v.idfView = gvb.idfView
						and v.idfsLanguage = gvb.idfsLanguage
			inner join	tasLayout l
			on			l.idfsGlobalLayout = v.idflLayout
						and l.idflLayout = v.idflLayout
			inner join	tasViewBand vb_parent
			on			vb_parent.idfView = v.idfView
						and vb_parent.idfsLanguage = v.idfsLanguage
						and vb_parent.idfViewBand = gvb.idfParentViewBand
			left join	tasViewBand vb
			on			vb.idfViewBand = gvb.idfViewBand
			where		v.idflLayout = @idfsLayout
						and vb.idfViewBand is null

			set	@RowCount = @@rowcount
		end

		insert into	tasViewColumn
		(	idfViewColumn,
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
			idfSourceViewColumn,
			idfDenominatorViewColumn,
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
		select		gvc.idfViewColumn,
					v.idfView,
					v.idfsLanguage,
					gvc.idfViewBand,
					gvc.idfLayoutSearchField,
					gvc.strOriginalName,
					gvc.strDisplayName,
					gvc.blnAggregateColumn,
					gvc.idfsAggregateFunction,
					gvc.intPrecision,
					gvc.blnChartSeries,
					gvc.blnMapDiagramSeries,
					gvc.blnMapGradientSeries,
					gvc.idfSourceViewColumn,
					gvc.idfDenominatorViewColumn,
					gvc.blnVisible,
					gvc.intSortOrder,
					gvc.blnSortAscending,
					gvc.intOrder,
					gvc.strColumnFilter,
					gvc.intColumnWidth,
					gvc.blnFreeze,
					gvc.blbChartLocalSeries,
					gvc.strReservedAttribute
		from		tasglViewColumn gvc
		inner join	tasView v
		on			v.idfView = gvc.idfView
					and v.idfsLanguage = gvc.idfsLanguage
		inner join	tasLayout l
		on			l.idfsGlobalLayout = v.idflLayout
					and l.idflLayout = v.idflLayout
		left join	tasViewBand vb
		on			vb.idfView = v.idfView
					and vb.idfsLanguage = v.idfsLanguage
					and vb.idfViewBand = gvc.idfViewBand
		left join	tasViewColumn vc
		on			vc.idfViewColumn = gvc.idfViewColumn
		where		l.idflLayout = @idfsLayout
					and (vb.idfViewBand is not null or gvc.idfViewBand is null)
					and	vc.idfViewColumn is null

		update		v
		set			v.idfChartXAxisViewColumn = vc_Xaxis.idfViewColumn,
					v.idfMapAdminUnitViewColumn = vc_MapUnit.idfViewColumn
		from		tasglView gv
		inner join	tasLayout l
		on			l.idfsGlobalLayout = gv.idfsLayout
					and l.idflLayout = gv.idfsLayout
		inner join	tasView v
		on			v.idfView = gv.idfView
					and v.idfsLanguage = gv.idfsLanguage
		left join	tasViewColumn vc_Xaxis
		on			vc_Xaxis.idfView = v.idfView
					and vc_Xaxis.idfsLanguage = v.idfsLanguage
					and vc_Xaxis.idfViewColumn = gv.idfChartXAxisViewColumn
		left join	tasViewColumn vc_MapUnit
		on			vc_MapUnit.idfView = v.idfView
					and vc_MapUnit.idfsLanguage = v.idfsLanguage
					and vc_MapUnit.idfViewColumn = gv.idfMapAdminUnitViewColumn
		where		l.idflLayout = @idfsLayout
					and (	gv.idfChartXAxisViewColumn is not null
							or	gv.idfMapAdminUnitViewColumn is not null
						)


	end try
	begin catch
		declare @error nvarchar(max)
		set @error = ERROR_PROCEDURE() +': '+ ERROR_MESSAGE()
		Raiserror (N'Error while making local layout: %s', 15, 1, @error)
		return 1
	end catch
	
	return 0 --dummy return that assumes that operation performed successfully
END


