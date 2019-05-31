

--##SUMMARY Returns the system identifier of AVR view column or band by Unique Path

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 07.05.2014

--##RETURNS Returns the system identifier of AVR view column or band by Unique Path.


/*
--Example of a call of function:

declare @UniquePath		nvarchar(MAX)
declare	@viewId			bigint
declare	@blnIsColumn	bit

set	@viewId = 44510001100
set @UniquePath = N'140EE9D20D16E28A40645FCE8FFE6D60'
set	@blnIsColumn = 1

select	dbo.fnAsGetColumnOrBandIdByUniquePath(@viewId, @UniquePath, @blnIsColumn)

*/


create	function	fnAsGetColumnOrBandIdByUniquePath
(
	  @viewId			bigint			--##PARAM @viewId Identifier of view, to which AVR view column or band with specified Unique Path belongs
	, @UniquePath		nvarchar(MAX)	--##PARAM @UniquePath Unique Path of AVR view column or band
	, @blnIsColumn			bit = 1		--##PARAM @blnIsColumn Option that specifies whether to find AVR view Column instead of AVR view Band
)
returns bigint
as
begin

	declare	@Id	bigint
	set	@Id = null


	declare	@vwStructureElements	table
	(	idfViewColumnOrBand		bigint not null,
		idfsLanguage			bigint not null,
		idfView					bigint not null,
		idfParentViewBand		bigint null,
		blnIsColumn				bit not null,
		idfLayoutSearchField	bigint null,
		strSearchFieldAlias		varchar(220) collate database_default null,
		strOriginalName			nvarchar(2000) collate database_default not null,
		strDisplayName			nvarchar(2000) collate database_default null,
		primary key	(
			idfViewColumnOrBand asc,
			idfsLanguage asc
					)
	)


	declare	@vwStructure	table
	(	idfViewColumnOrBand			bigint not null,
		idfsLanguage				bigint not null,
		intLevelParent				int not null,
		idfView						bigint not null,
		idfLevelParentViewBand		bigint null,
		blnIsColumn					bit not null,
		idfLayoutSearchField		bigint null,
		strOriginalName				nvarchar(2000) collate database_default not null,
		strSearchFieldAlias			varchar(220) collate database_default null,
		
		strLevelOriginalNamePath	varchar(MAX) collate database_default not null
		primary key	(
			idfViewColumnOrBand asc,
			idfsLanguage asc
					)
	)


	insert into	@vwStructureElements
	(	idfViewColumnOrBand,
		idfsLanguage,
		idfView,
		idfParentViewBand,
		blnIsColumn,
		idfLayoutSearchField,
		strSearchFieldAlias,
		strOriginalName,
		strDisplayName
	)
	select		vwb.idfViewBand,
				vw.idfsLanguage,
				vw.idfView,
				vwb_parent.idfViewBand,
				cast(0 as bit),
				lsf.idfLayoutSearchField,
				sf.strSearchFieldAlias + 
					IsNull(N'__' + cast(p.idfsFormType as varchar(20)) + N'__' + cast(p.idfsParameter as varchar(20)), N''), 
				case 
					when	RTrim(LTrim(IsNull(vwb.strOriginalName, N''))) = N''
						then	N'*'
					else	vwb.strOriginalName
				end,
				IsNull(vwb.strDisplayName, vwb.strOriginalName)
	from		tasViewBand vwb
	inner join	tasView vw
	on			vw.idfView = vwb.idfView
				and vw.idfsLanguage = vwb.idfsLanguage
	left join	tasLayoutSearchField lsf
		inner join	tasQuerySearchField qsf
		on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
		inner join	tasSearchField sf
		on			sf.idfsSearchField = qsf.idfsSearchField
		left join	ffParameter p
		on			p.idfsParameter = qsf.idfsParameter
	on			lsf.idfLayoutSearchField = vwb.idfLayoutSearchField
	left join	tasViewBand vwb_parent
	on			vwb_parent.idfView = vw.idfView
				and vwb_parent.idfsLanguage = vw.idfsLanguage
				and vwb_parent.idfViewBand = vwb.idfParentViewBand
	where		(vw.idfView = @viewId or @viewId is null)
				and (vwb_parent.idfViewBand is not null or vwb.idfParentViewBand is null)
	union all
	select		vwc.idfViewColumn,
				vw.idfsLanguage,
				vw.idfView,
				vwb_parent.idfViewBand,
				cast(1 as bit),
				lsf.idfLayoutSearchField,
				sf.strSearchFieldAlias + 
					IsNull(N'__' + cast(p.idfsFormType as varchar(20)) + N'__' + cast(p.idfsParameter as varchar(20)), N''), 
				case 
					when	RTrim(LTrim(IsNull(vwc.strOriginalName, N''))) = N''
						then	N'*'
					else	vwc.strOriginalName
				end,
				IsNull(vwc.strDisplayName, vwc.strOriginalName)
	from		tasViewColumn vwc
	inner join	tasView vw
	on			vw.idfView = vwc.idfView
				and vw.idfsLanguage = vwc.idfsLanguage
	left join	tasLayoutSearchField lsf
		inner join	tasQuerySearchField qsf
		on			qsf.idfQuerySearchField = lsf.idfQuerySearchField
		inner join	tasSearchField sf
		on			sf.idfsSearchField = qsf.idfsSearchField
		left join	ffParameter p
		on			p.idfsParameter = qsf.idfsParameter
	on			lsf.idfLayoutSearchField = vwc.idfLayoutSearchField
	left join	tasViewBand vwb_parent
	on			vwb_parent.idfView = vw.idfView
				and vwb_parent.idfsLanguage = vw.idfsLanguage
				and vwb_parent.idfViewBand = vwc.idfViewBand
	where		(vw.idfView = @viewId or @viewId is null)
				and (vwb_parent.idfViewBand is not null or vwc.idfViewBand is null)
				and vwc.blnAggregateColumn = 0

	insert into	@vwStructure
	(	idfViewColumnOrBand,
		idfsLanguage,
		intLevelParent,
		idfView,
		idfLevelParentViewBand,
		blnIsColumn,
		idfLayoutSearchField,
		strSearchFieldAlias,
		strOriginalName,
		strLevelOriginalNamePath
	)
	select		vwe.idfViewColumnOrBand,
				vwe.idfsLanguage,
				0 as intLevelParent,
				vwe.idfView,
				vwe.idfParentViewBand as idfLevelParentViewBand,
				vwe.blnIsColumn,
				vwe.idfLayoutSearchField,
				vwe.strSearchFieldAlias,
				vwe.strOriginalName,
				cast((IsNull(vwe.strSearchFieldAlias + N'_' + cast(vwe.idfLayoutSearchField as varchar(20)) + N'__', N'') + 
						CONVERT(varchar(100), hashbytes('MD5', IsNull(vwe.strOriginalName, N'*')), 2)) as varchar(MAX)
					) as strLevelOriginalNamePath
	from		@vwStructureElements vwe
	where		vwe.idfParentViewBand is null

	while exists	(
			select		*
			from		@vwStructureElements vwe
			left join	@vwStructure vws
			on			vws.idfViewColumnOrBand = vwe.idfViewColumnOrBand
						and vws.idfsLanguage = vwe.idfsLanguage
			where		vws.idfViewColumnOrBand is null
					)
	begin
		insert into	@vwStructure
		(	idfViewColumnOrBand,
			idfsLanguage,
			intLevelParent,
			idfView,
			idfLevelParentViewBand,
			blnIsColumn,
			idfLayoutSearchField,
			strSearchFieldAlias,
			strOriginalName,
			strLevelOriginalNamePath
		)
		select		vwe_all.idfViewColumnOrBand,
					vwe_all.idfsLanguage,
					vws.intLevelParent + 1 as intLevelParent,
					vwe_all.idfView,
					vwe_all.idfParentViewBand as idfLevelParentViewBand,
					vwe_all.blnIsColumn,
					vwe_all.idfLayoutSearchField,
					vwe_all.strSearchFieldAlias,
					vwe_all.strOriginalName,
					cast((IsNull(vws.strLevelOriginalNamePath + N'>>', N'') +
							IsNull(vwe_all.strSearchFieldAlias + N'_' + cast(vwe_all.idfLayoutSearchField as varchar(20)) + N'__', N'') + 
							CONVERT(varchar(100), hashbytes('MD5', IsNull(vwe_all.strOriginalName, N'*')), 2)) as varchar(MAX)
						) as strLevelOriginalNamePath
		from		@vwStructureElements vwe_all
		inner join	@vwStructure vws
		on			vws.idfViewColumnOrBand = vwe_all.idfParentViewBand
					and vws.idfView = vwe_all.idfView
					and vws.idfsLanguage = vwe_all.idfsLanguage
		left join	@vwStructure vws_ex
		on			vws_ex.idfViewColumnOrBand = vwe_all.idfViewColumnOrBand
					and vws_ex.idfView = vwe_all.idfView
					and vws_ex.idfsLanguage = vwe_all.idfsLanguage
		where		vws_ex.idfViewColumnOrBand is null
	end

	insert into	@vwStructure
	(	idfViewColumnOrBand,
		idfsLanguage,
		intLevelParent,
		idfView,
		idfLevelParentViewBand,
		blnIsColumn,
		idfLayoutSearchField,
		strSearchFieldAlias,
		strOriginalName,
		strLevelOriginalNamePath
	)
	select		vwc.idfViewColumn,
				vw.idfsLanguage,
				0 as intLevelParent,
				vw.idfView,
				vwc.idfViewBand,
				cast(1 as bit),
				null,
				null,
				vwc.strOriginalName,
				N'AggregateColumn' + N'__' + cast(vwc.idfViewColumn as nvarchar(20))
	from		tasViewColumn vwc
	inner join	tasView vw
	on			vw.idfView = vwc.idfView
				and vw.idfsLanguage = vwc.idfsLanguage
	left join	@vwStructure vws
	on			vws.idfViewColumnOrBand = vwc.idfViewColumn
				and vws.idfsLanguage = vw.idfsLanguage
	where		(vw.idfView = @viewId or @viewId is null)
				and vwc.blnAggregateColumn = 1
				and vws.idfViewColumnOrBand is null

	select		@Id = vws.idfViewColumnOrBand
	from		@vwStructure vws
	where		vws.strLevelOriginalNamePath = @UniquePath
				and (vws.blnIsColumn = @blnIsColumn or @blnIsColumn is null)

return @Id
end



