

--##SUMMARY This procedure creates copy of specified local layout and connected objects.
--##SUMMARY A copied layout will have a specific name (if it is not specified as a parameter, then it will be a combination of 
--##SUMMARY Prefix "Copy of" and name of original layout).

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.04.2014
--##REMARKS Update date: 27.05.2014

--##RETURNS Identifier of the copy of original layout

/*
--Example of a call of procedure:

declare	@idflOriginalLayout	bigint
declare	@xmlLayoutName		nvarchar(MAX)
declare	@idflLayoutCopy		bigint
declare	@errorCode			int

set	@idflOriginalLayout = 44510001100
set	@xmlLayoutName = N'<?xml version="1.0" encoding="UTF-16"?><ROOT><LayoutName LanguageId="en"  Translation="Copy of Cumulative Percent Test" /><LayoutName LanguageId="ru"  Translation="Копия Cumulative Percent Test" /></ROOT>'

execute	spAsLayout_CreateCopy
		 @idflOriginalLayout
		,@idflLayoutCopy output
		,@xmlLayoutName
		,@errorCode output

select	@idflLayoutCopy, @errorCode

*/ 


create procedure	[dbo].[spAsLayout_CreateCopy]
(
	@idflOriginalLayout	bigint, --##PARAM @idflOriginalLayout Identifier of original layout to copy, input parameter
	@idflLayoutCopy		bigint output, --##PARAM @idflLayoutCopy Identifier of created copy of original layout, output parameter
	@xmlLayoutName		nvarchar(MAX), --##PARAM @xmlLayoutName Xml containing translations of layout name for the copy, input parameter
	@errorCode			int output --##PARAM @errorCode code of error occured during the process of creating layout copy, output parameter
)
as

set	@idflLayoutCopy = null
set	@errorCode = 0

-- Check if original layout exists
if	not exists	(
		select	*
		from	tasLayout
		where	idflLayout = @idflOriginalLayout
				)
begin
	set	@errorCode = 1	-- Original layout to copy does not exist.
	return	@errorCode;
end

-- Retrieve translations of the name of copied layout
declare	@LayoutNameTranslation	table
(	idfID		bigint not null identity (1, 1) primary key,
	LanguageId	nvarchar(50) collate database_default null,
	Translation	nvarchar(2000) collate database_default null
)

BEGIN TRY
	declare @idoc int

	exec sp_xml_preparedocument @idoc OUTPUT, @xmlLayoutName

	insert into @LayoutNameTranslation(LanguageId, Translation)
	select	LanguageId, Translation
	from	OPENXML (@idoc, '/ROOT/LayoutName')
			WITH (LanguageId  nvarchar(50), Translation nvarchar(2000))

	exec sp_xml_removedocument @idoc
END TRY
BEGIN CATCH
	set	@errorCode = 2 -- Incorrect xml with translations of the name of copied layout
	return	@errorCode;
END CATCH
;

-- Delete incorrect translations of the name of copied layout - start

-- Blank text
delete from	@LayoutNameTranslation
where		rtrim(ltrim(isnull(Translation, N''))) = N''

-- Incorrect language
delete		lnt
from		@LayoutNameTranslation lnt
where		dbo.fnGetLanguageCode(lnt.LanguageId) = 10049003	-- English
			and lnt.LanguageId <> N'en'

-- Translation duplicates
delete		lnt
from		@LayoutNameTranslation lnt
where		exists	(
				select	*
				from	@LayoutNameTranslation lnt_min
				where	dbo.fnGetLanguageCode(lnt_min.LanguageId) = dbo.fnGetLanguageCode(lnt.LanguageId)
						and lnt_min.idfID < lnt.idfID
					)

-- Delete incorrect translations of the name of copied layout - end

-- Check if English name of copied layout is specified
if	not exists
		(	select	*
			from	@LayoutNameTranslation
			where	LanguageId = N'en'
		)
begin
	set	@errorCode = 3	-- English name of copied layout is not specified.
	return @errorCode;
end


-- Create a copy of original layout

-- Get new identifier of copied layout
if	exists	(
		select	*
		from	locBaseReference l
		where	l.idflBaseReference = @idflLayoutCopy
			)
	or @idflLayoutCopy is null
begin
	execute	spsysGetNewID @idflLayoutCopy output
end

-- Insert local Base Reference record of copied layout
insert into	locBaseReference (idflBaseReference)
values (@idflLayoutCopy)

-- Insert translations of the name of copied layout
insert into	locStringNameTranslation
(	idflBaseReference, 
	idfsLanguage, 
	strTextString
)
select		lbr.idflBaseReference,
			dbo.fnGetLanguageCode(lnt.LanguageId),
			lnt.Translation
from		@LayoutNameTranslation lnt
inner join	locBaseReference lbr
on			lbr.idflBaseReference = @idflLayoutCopy
left join	locStringNameTranslation lsnt
on			lsnt.idflBaseReference = lbr.idflBaseReference
			and lsnt.idfsLanguage = dbo.fnGetLanguageCode(lnt.LanguageId)
where		lsnt.idflBaseReference is null



-- Get new identifier of the description of copied layout
declare	@idflLayoutCopyDescription	bigint
execute	spsysGetNewID @idflLayoutCopyDescription output

-- Insert local Base Reference record of the description of copied layout
insert into	locBaseReference (idflBaseReference)
values (@idflLayoutCopyDescription)

-- Copy translations of the description of original layout
insert into	locStringNameTranslation
(	idflBaseReference, 
	idfsLanguage, 
	strTextString
)
select		lbr.idflBaseReference,
			l_original_descr_tran.idfsLanguage,
			l_original_descr_tran.strTextString
from		tasLayout l_original
inner join	locStringNameTranslation l_original_descr_tran
on			l_original_descr_tran.idflBaseReference = l_original.idflDescription
inner join	locBaseReference lbr
on			lbr.idflBaseReference = @idflLayoutCopyDescription
left join	locStringNameTranslation lsnt
on			lsnt.idflBaseReference = lbr.idflBaseReference
			and lsnt.idfsLanguage = l_original_descr_tran.idfsLanguage
where		l_original.idflLayout = @idflOriginalLayout
			and lsnt.idflBaseReference is null



-- Copy layout attributes
insert into	tasLayout
(	idflLayout,
	idfsGlobalLayout,
	idflQuery,
	idflLayoutFolder,
	idfPerson,
	idflDescription,
	blnReadOnly,
	idfsDefaultGroupDate,
	blnShowColsTotals,
	blnShowRowsTotals,
	blnShowColGrandTotals,
	blnShowRowGrandTotals,
	blnShowForSingleTotals,
	blnApplyPivotGridFilter,
	blnShareLayout,
	blbPivotGridSettings,
	blbChartGeneralSettings,
	intPivotGridXmlVersion,
	blnCompactPivotGrid,
	blnFreezeRowHeaders,
	blnUseArchivedData,
	blnShowMissedValuesInPivotGrid,
	blbGisLayerGeneralSettings,
	blbGisMapGeneralSettings,
	intGisLayerPosition,
	strReservedAttribute
)
select		lbr_name.idflBaseReference,
			null,						-- Not published
			l_original.idflQuery,
			l_original.idflLayoutFolder,
			l_original.idfPerson,
			lbr_description.idflBaseReference,
			0,							-- Not published
			l_original.idfsDefaultGroupDate,
			l_original.blnShowColsTotals,
			l_original.blnShowRowsTotals,
			l_original.blnShowColGrandTotals,
			l_original.blnShowRowGrandTotals,
			l_original.blnShowForSingleTotals,
			l_original.blnApplyPivotGridFilter,
			l_original.blnShareLayout,
			l_original.blbPivotGridSettings,
			l_original.blbChartGeneralSettings,
			l_original.intPivotGridXmlVersion,
			l_original.blnCompactPivotGrid,
			l_original.blnFreezeRowHeaders,
			l_original.blnUseArchivedData,
			l_original.blnShowMissedValuesInPivotGrid,
			l_original.blbGisLayerGeneralSettings,
			l_original.blbGisMapGeneralSettings,
			l_original.intGisLayerPosition,
			l_original.strReservedAttribute
from		tasLayout l_original
inner join	locBaseReference lbr_name
on			lbr_name.idflBaseReference = @idflLayoutCopy
inner join	locBaseReference lbr_description
on			lbr_description.idflBaseReference = @idflLayoutCopyDescription
left join	tasLayout l_copy
on			l_copy.idflLayout = lbr_name.idflBaseReference
where		l_original.idflLayout = @idflOriginalLayout
			and l_copy.idflLayout is null


-- Copy layout search fields

-- Get new identifiers of layout search fields - start
declare	@LayoutSearchField	table
(	idfID								bigint not null identity(1, 2),
	idfOriginalLayoutSearchField		bigint not null primary key,
	idfOriginalLayoutSearchFieldName	bigint null,
	idfCopyLayoutSearchField			bigint null,
	idfCopyLayoutSearchFieldName		bigint null
)

insert into	@LayoutSearchField
(	idfOriginalLayoutSearchField,
	idfOriginalLayoutSearchFieldName
)
select		lsf_original.idfLayoutSearchField,
			lsf_original.idflLayoutSearchFieldName
from		tasLayoutSearchField lsf_original
where		lsf_original.idflLayout = @idflOriginalLayout


delete from	tstNewID	where	idfTable = -1234	-- Layout objects

insert into	tstNewID
(	idfTable,
	idfKey1
)
select	-1234,										-- Layout objects
		idfID
from	@LayoutSearchField

insert into	tstNewID
(	idfTable,
	idfKey1
)
select	-1234,										-- Layout objects
		idfID + 1
from	@LayoutSearchField
where	idfOriginalLayoutSearchFieldName is not null

update		lsf_to_copy
set			lsf_to_copy.idfCopyLayoutSearchField = nID.[NewID],
			lsf_to_copy.idfCopyLayoutSearchFieldName = nID_name.[NewID]
from		@LayoutSearchField lsf_to_copy
inner join	tstNewID nID
on			nID.idfTable = -1234					-- Layout objects
			and nID.idfKey1 = lsf_to_copy.idfID
left join	tstNewID nID_name
on			nID_name.idfTable = -1234				-- Layout objects
			and nID_name.idfKey1 = lsf_to_copy.idfID + 1

delete from	tstNewID	where	idfTable = -1234	-- Layout objects
-- Get new identifiers of layout search fields - end

-- Create names of layout search fields and copy their translations
insert into	locBaseReference (idflBaseReference)
select		lsf_to_copy.idfCopyLayoutSearchFieldName
from		@LayoutSearchField lsf_to_copy
left join	locBaseReference lbr
on			lbr.idflBaseReference = lsf_to_copy.idfCopyLayoutSearchFieldName
where		lsf_to_copy.idfCopyLayoutSearchFieldName is not null
			and lbr.idflBaseReference is null

insert into	locStringNameTranslation
(	idflBaseReference, 
	idfsLanguage, 
	strTextString
)
select		lbr_copy.idflBaseReference,
			lsf_original_tran.idfsLanguage,
			lsf_original_tran.strTextString
from		tasLayoutSearchField lsf_original
inner join	locStringNameTranslation lsf_original_tran
on			lsf_original_tran.idflBaseReference = lsf_original.idflLayoutSearchFieldName
inner join	@LayoutSearchField lsf_to_copy
on			lsf_to_copy.idfOriginalLayoutSearchFieldName = lsf_original.idflLayoutSearchFieldName
inner join	locBaseReference lbr_copy
on			lbr_copy.idflBaseReference = lsf_to_copy.idfCopyLayoutSearchFieldName
left join	locStringNameTranslation lsnt
on			lsnt.idflBaseReference = lbr_copy.idflBaseReference
			and lsnt.idfsLanguage = lsf_original_tran.idfsLanguage
where		lsf_original.idflLayout = @idflOriginalLayout
			and lsnt.idflBaseReference is null

-- Copy layout search fields with blank Administrative Unit and Date function parameters
declare	@RowsAffected	bigint

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
select		lsf_to_copy.idfCopyLayoutSearchField,
			lsf_name_copy.idflBaseReference,
			l_copy.idflLayout,
			lsf_original.idfsAggregateFunction,
			lsf_original.idfQuerySearchField,
			null,
			null,
			lsf_original.idfsGroupDate,
			lsf_original.blnShowMissedValue,
			lsf_original.datDiapasonStartDate,
			lsf_original.datDiapasonEndDate,
			lsf_original.intPrecision,
			lsf_original.intFieldCollectionIndex,
			lsf_original.intPivotGridAreaType,
			lsf_original.intFieldPivotGridAreaIndex,
			lsf_original.blnVisible,
			lsf_original.blnHiddenFilterField,
			lsf_original.intFieldColumnWidth,
			lsf_original.blnSortAcsending,
			lsf_original.strFieldFilterValues, 
			lsf_original.strReservedAttribute
			
			
from		@LayoutSearchField lsf_to_copy
inner join	tasLayoutSearchField lsf_original
on			lsf_original.idfLayoutSearchField = lsf_to_copy.idfOriginalLayoutSearchField
left join	locBaseReference lsf_name_copy
on			lsf_name_copy.idflBaseReference = lsf_to_copy.idfCopyLayoutSearchFieldName
inner join	tasLayout l_copy
on			l_copy.idflLayout = @idflLayoutCopy
left join	tasLayoutSearchField lsf_copy
on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
where		lsf_original.idflLayout = @idflOriginalLayout
			and lsf_original.idfUnitLayoutSearchField is null
			and lsf_original.idfDateLayoutSearchField is null
			and lsf_copy.idfLayoutSearchField is null
set	@RowsAffected = @@rowcount

-------------------------------------------------------------------------------------------
-- update Layout - blbPivotGridSettings - replace old LayoutField id's to new into filters
declare @filter as nvarchar(max)

select 
      @filter = convert(nvarchar(max), convert(varbinary(max), blbPivotGridSettings))
from tasLayout
where idflLayout = @idflLayoutCopy

select
	@filter = CONVERT(VARBINARY(MAX),
								 replace( convert(nvarchar(max), convert(varbinary(max), @filter)), 
											N'idfLayoutSearchField_' + cast(lsf.idfOriginalLayoutSearchField as nvarchar(200)),
											N'idfLayoutSearchField_' + cast(lsf.idfCopyLayoutSearchField as nvarchar(200))
										), 0)
from tasLayout l
	cross join @LayoutSearchField lsf
where l.idflLayout = @idflLayoutCopy


update      tasLayout
set         blbPivotGridSettings = CONVERT(VARBINARY(MAX), @filter, 0)
where idflLayout = @idflLayoutCopy

-- END update Layout - blbPivotGridSettings - replace old LayoutField id's to new into filters
-------------------------------------------------------------------------------------------




-- Copy layout search fields with not blank Administrative Unit or Date function parameters
while @RowsAffected > 0
begin
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
	select		lsf_to_copy.idfCopyLayoutSearchField,
				lsf_name_copy.idflBaseReference,
				l_copy.idflLayout,
				lsf_original.idfsAggregateFunction,
				lsf_original.idfQuerySearchField,
				lsf_unit_copy.idfLayoutSearchField,
				lsf_date_copy.idfLayoutSearchField,
				lsf_original.idfsGroupDate,
				lsf_original.blnShowMissedValue,
				lsf_original.datDiapasonStartDate,
				lsf_original.datDiapasonEndDate,
				lsf_original.intPrecision,
				lsf_original.intFieldCollectionIndex,
				lsf_original.intPivotGridAreaType,
				lsf_original.intFieldPivotGridAreaIndex,
				lsf_original.blnVisible,
				lsf_original.blnHiddenFilterField,
				lsf_original.intFieldColumnWidth,
				lsf_original.blnSortAcsending,
				lsf_original.strFieldFilterValues, 
				lsf_original.strReservedAttribute
	from		@LayoutSearchField lsf_to_copy
	inner join	tasLayoutSearchField lsf_original
	on			lsf_original.idfLayoutSearchField = lsf_to_copy.idfOriginalLayoutSearchField
	left join	locBaseReference lsf_name_copy
	on			lsf_name_copy.idflBaseReference = lsf_to_copy.idfCopyLayoutSearchFieldName
	inner join	tasLayout l_copy
	on			l_copy.idflLayout = @idflLayoutCopy
	left join	tasLayoutSearchField lsf_unit_original
		inner join	@LayoutSearchField lsf_unit_to_copy
		on			lsf_unit_to_copy.idfOriginalLayoutSearchField = lsf_unit_original.idfLayoutSearchField
		inner join	tasLayoutSearchField lsf_unit_copy
		on			lsf_unit_copy.idfLayoutSearchField = lsf_unit_to_copy.idfCopyLayoutSearchField
	on			lsf_unit_original.idfLayoutSearchField = lsf_original.idfUnitLayoutSearchField
	left join	tasLayoutSearchField lsf_date_original
		inner join	@LayoutSearchField lsf_date_to_copy
		on			lsf_date_to_copy.idfOriginalLayoutSearchField = lsf_date_original.idfLayoutSearchField
		inner join	tasLayoutSearchField lsf_date_copy
		on			lsf_date_copy.idfLayoutSearchField = lsf_date_to_copy.idfCopyLayoutSearchField
	on			lsf_date_original.idfLayoutSearchField = lsf_original.idfDateLayoutSearchField
	left join	tasLayoutSearchField lsf_copy
	on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
	where		lsf_original.idflLayout = @idflOriginalLayout
				and (	lsf_original.idfUnitLayoutSearchField is null
						or lsf_unit_copy.idfLayoutSearchField is not null
					)
				and (	lsf_original.idfDateLayoutSearchField is null
						or lsf_date_copy.idfLayoutSearchField is not null
					)
				and lsf_copy.idfLayoutSearchField is null
	set	@RowsAffected = @@rowcount	
end


-- Copy view associated with original layout (without Chart X-axis and Map Administrative Unit attributes)
-- Get identifier of the view associated with copied layout
declare	@idfViewCopy				bigint
set	@idfViewCopy = @idflLayoutCopy

if	exists	(
		select		*
		from		tasView v
		where		v.idfView = @idfViewCopy
			)
begin
	execute	spsysGetNewID @idfViewCopy output
end

insert into	tasView
(	idfView,
	idfsLanguage,
	idflLayout,
	idfChartXAxisViewColumn,
	idfMapAdminUnitViewColumn,
	blbChartLocalSettings,
	blbGisLayerLocalSettings,
	blbGisMapLocalSettings,
	idfGlobalView,
	blbViewSettings,
	strReservedAttribute
)
select		@idfViewCopy,
			v_original.idfsLanguage,
			l_copy.idflLayout,
			null,						-- Will be updated after all view column are copied
			null,						-- Will be updated after all view column are copied
			v_original.blbChartLocalSettings,
			v_original.blbGisLayerLocalSettings,
			v_original.blbGisMapLocalSettings,
			null,						-- Not published
			v_original.blbViewSettings,
			v_original.strReservedAttribute
from		tasView v_original
inner join	tasLayout l_copy
on			l_copy.idflLayout = @idflLayoutCopy
left join	tasView v_copy
on			v_copy.idfView = @idfViewCopy
			and v_copy.idfsLanguage = v_original.idfsLanguage
where		v_original.idflLayout = @idflOriginalLayout
			and v_copy.idfView is null



-- Copy view bands

-- Get new identifiers of view bands - start
declare	@ViewBand			table
(	idfOriginalViewBand	bigint not null primary key,
	idfCopyViewBand		bigint null
)

insert into	@ViewBand (idfOriginalViewBand)
select		vb_original.idfViewBand
from		tasViewBand vb_original
inner join	tasView v_original
on			v_original.idfView = vb_original.idfView
			and v_original.idfsLanguage = vb_original.idfsLanguage
where		v_original.idflLayout = @idflOriginalLayout


delete from	tstNewID	where	idfTable = -1234	-- Layout objects

insert into	tstNewID
(	idfTable,
	idfKey1
)
select	-1234,										-- Layout objects
		idfOriginalViewBand
from	@ViewBand

update		vb_to_copy
set			vb_to_copy.idfCopyViewBand = nID.[NewID]
from		@ViewBand vb_to_copy
inner join	tstNewID nID
on			nID.idfTable = -1234					-- Layout objects
			and nID.idfKey1 = vb_to_copy.idfOriginalViewBand

delete from	tstNewID	where	idfTable = -1234	-- Layout objects
-- Get new identifiers of view bands - end

-- Copy root view bands (without parent view bands)
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
select		vb_to_copy.idfCopyViewBand,
			v_copy.idfView,
			v_copy.idfsLanguage,
			vb_original.strOriginalName,
			vb_original.strDisplayName,
			vb_original.blnVisible,
			vb_original.intOrder,
			null,
			vb_original.blnFreeze,
			lsf_copy.idfLayoutSearchField,
			vb_original.strReservedAttribute
from		@ViewBand vb_to_copy
inner join	tasViewBand vb_original
on			vb_original.idfViewBand = vb_to_copy.idfOriginalViewBand
inner join	tasView v_original
on			v_original.idfView = vb_original.idfView
			and v_original.idfsLanguage = vb_original.idfsLanguage
inner join	tasView v_copy
on			v_copy.idfView = @idfViewCopy
			and v_copy.idfsLanguage = v_copy.idfsLanguage
			and v_copy.idflLayout = @idflLayoutCopy
left join	tasViewBand vb_copy
on			vb_copy.idfViewBand = vb_to_copy.idfCopyViewBand
left join	@LayoutSearchField lsf_to_copy
	inner join	tasLayoutSearchField lsf_copy
	on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
				and lsf_copy.idflLayout = @idflLayoutCopy
on			lsf_to_copy.idfOriginalLayoutSearchField = vb_original.idfLayoutSearchField
where		v_original.idflLayout = @idflOriginalLayout
			and vb_original.idfParentViewBand is null
			and vb_copy.idfViewBand is null
set	@RowsAffected = @@rowcount	

-- Copy sub-bands
while @RowsAffected > 0
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
	select		vb_to_copy.idfCopyViewBand,
				v_copy.idfView,
				v_copy.idfsLanguage,
				vb_original.strOriginalName,
				vb_original.strDisplayName,
				vb_original.blnVisible,
				vb_original.intOrder,
				vb_parent_copy.idfViewBand,
				vb_original.blnFreeze,
				lsf_copy.idfLayoutSearchField,
				vb_original.strReservedAttribute
	from		@ViewBand vb_to_copy
	inner join	tasViewBand vb_original
	on			vb_original.idfViewBand = vb_to_copy.idfOriginalViewBand
	inner join	tasView v_original
	on			v_original.idfView = vb_original.idfView
				and v_original.idfsLanguage = vb_original.idfsLanguage
	inner join	tasView v_copy
	on			v_copy.idfView = @idfViewCopy
				and v_copy.idfsLanguage = v_copy.idfsLanguage
				and v_copy.idflLayout = @idflLayoutCopy
	inner join	tasViewBand vb_parent_original
		inner join	@ViewBand vb_parent_to_copy
		on			vb_parent_to_copy.idfOriginalViewBand = vb_parent_original.idfViewBand
		inner join	tasViewBand vb_parent_copy
		on			vb_parent_copy.idfViewBand = vb_parent_to_copy.idfCopyViewBand
	on			vb_parent_original.idfViewBand = vb_original.idfParentViewBand	
	left join	tasViewBand vb_copy
	on			vb_copy.idfViewBand = vb_to_copy.idfCopyViewBand
	left join	@LayoutSearchField lsf_to_copy
		inner join	tasLayoutSearchField lsf_copy
		on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
					and lsf_copy.idflLayout = @idflLayoutCopy
	on			lsf_to_copy.idfOriginalLayoutSearchField = vb_original.idfLayoutSearchField
	where		v_original.idflLayout = @idflOriginalLayout
				and vb_copy.idfViewBand is null
	set	@RowsAffected = @@rowcount	
end


-- Copy view columns

-- Get new identifiers of view columns - start
declare	@ViewColumn			table
(	idfOriginalViewColumn	bigint not null primary key,
	idfCopyViewColumn		bigint null
)

insert into	@ViewColumn (idfOriginalViewColumn)
select		vc_original.idfViewColumn
from		tasViewColumn vc_original
inner join	tasView v_original
on			v_original.idfView = vc_original.idfView
			and v_original.idfsLanguage = vc_original.idfsLanguage
where		v_original.idflLayout = @idflOriginalLayout


delete from	tstNewID	where	idfTable = -1234	-- Layout objects

insert into	tstNewID
(	idfTable,
	idfKey1
)
select	-1234,										-- Layout objects
		idfOriginalViewColumn
from	@ViewColumn

update		vc_to_copy
set			vc_to_copy.idfCopyViewColumn = nID.[NewID]
from		@ViewColumn vc_to_copy
inner join	tstNewID nID
on			nID.idfTable = -1234					-- Layout objects
			and nID.idfKey1 = vc_to_copy.idfOriginalViewColumn

delete from	tstNewID	where	idfTable = -1234	-- Layout objects
-- Get new identifiers of view columns - end

-- Copy view columns with blank Source, Nominator and Denominator function parameters
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
	strReservedAttribute
)
select		vc_to_copy.idfCopyViewColumn,
			v_copy.idfView,
			v_copy.idfsLanguage,
			vb_copy.idfViewBand,
			lsf_copy.idfLayoutSearchField,
			vc_original.strOriginalName,
			vc_original.strDisplayName,
			vc_original.blnAggregateColumn,
			vc_original.idfsAggregateFunction,
			vc_original.intPrecision,
			vc_original.blnChartSeries,
			vc_original.blnMapDiagramSeries,
			vc_original.blnMapGradientSeries,
			null,
			null,
			vc_original.blnVisible,
			vc_original.intSortOrder,
			vc_original.blnSortAscending,
			vc_original.intOrder,
			vc_original.strColumnFilter,
			vc_original.intColumnWidth,
			vc_original.blnFreeze,
			vc_original.strReservedAttribute
from		@ViewColumn vc_to_copy
inner join	tasViewColumn vc_original
on			vc_original.idfViewColumn = vc_to_copy.idfOriginalViewColumn
inner join	tasView v_original
on			v_original.idfView = vc_original.idfView
			and v_original.idfsLanguage = vc_original.idfsLanguage
inner join	tasView v_copy
on			v_copy.idfView = @idfViewCopy
			and v_copy.idfsLanguage = v_original.idfsLanguage
			and v_copy.idflLayout = @idflLayoutCopy
left join	@ViewBand vb_to_copy
	inner join	tasViewBand vb_copy
	on			vb_copy.idfViewBand = vb_to_copy.idfCopyViewBand
on			vb_to_copy.idfOriginalViewBand = vc_original.idfViewBand
			and vb_copy.idfView = v_copy.idfView
			and vb_copy.idfsLanguage = v_copy.idfsLanguage
left join	@LayoutSearchField lsf_to_copy
	inner join	tasLayoutSearchField lsf_copy
	on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
				and lsf_copy.idflLayout = @idflLayoutCopy
on			lsf_to_copy.idfOriginalLayoutSearchField = vc_original.idfLayoutSearchField
left join	tasViewColumn vc_copy
on			vc_copy.idfViewColumn = vc_to_copy.idfCopyViewColumn
where		v_original.idflLayout = @idflOriginalLayout
			and (	vc_original.idfViewBand is null
					or	vb_copy.idfView is not null
				)
			and (	vc_original.idfLayoutSearchField is null
					or	lsf_copy.idfLayoutSearchField is not null
				)
			and vc_original.idfSourceViewColumn is null
			and vc_original.idfDenominatorViewColumn is null
			and vc_copy.idfViewColumn is null
set	@RowsAffected = @@rowcount

-- Copy view columns with specified Source, or Nominator, or Denominator function parameters
while	@RowsAffected > 0
begin
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
		strReservedAttribute
	)
	select		vc_to_copy.idfCopyViewColumn,
				v_copy.idfView,
				v_copy.idfsLanguage,
				vb_copy.idfViewBand,
				lsf_copy.idfLayoutSearchField,
				vc_original.strOriginalName,
				vc_original.strDisplayName,
				vc_original.blnAggregateColumn,
				vc_original.idfsAggregateFunction,
				vc_original.intPrecision,
				vc_original.blnChartSeries,
				vc_original.blnMapDiagramSeries,
				vc_original.blnMapGradientSeries,
				vc_source_copy.idfViewColumn,
				vc_denominator_copy.idfViewColumn,
				vc_original.blnVisible,
				vc_original.intSortOrder,
				vc_original.blnSortAscending,
				vc_original.intOrder,
				vc_original.strColumnFilter,
				vc_original.intColumnWidth,
				vc_original.blnFreeze,
				vc_original.strReservedAttribute
	from		@ViewColumn vc_to_copy
	inner join	tasViewColumn vc_original
	on			vc_original.idfViewColumn = vc_to_copy.idfOriginalViewColumn
	inner join	tasView v_original
	on			v_original.idfView = vc_original.idfView
				and v_original.idfsLanguage = vc_original.idfsLanguage
	inner join	tasView v_copy
	on			v_copy.idfView = @idfViewCopy
				and v_copy.idfsLanguage = v_original.idfsLanguage
				and v_copy.idflLayout = @idflLayoutCopy
	left join	@ViewBand vb_to_copy
		inner join	tasViewBand vb_copy
		on			vb_copy.idfViewBand = vb_to_copy.idfCopyViewBand
	on			vb_to_copy.idfOriginalViewBand = vc_original.idfViewBand
				and vb_copy.idfView = v_copy.idfView
				and vb_copy.idfsLanguage = v_copy.idfsLanguage
	left join	@LayoutSearchField lsf_to_copy
		inner join	tasLayoutSearchField lsf_copy
		on			lsf_copy.idfLayoutSearchField = lsf_to_copy.idfCopyLayoutSearchField
					and lsf_copy.idflLayout = @idflLayoutCopy
	on			lsf_to_copy.idfOriginalLayoutSearchField = vc_original.idfLayoutSearchField
	left join	tasViewColumn vc_source_original
		inner join	@ViewColumn vc_source_to_copy
		on			vc_source_to_copy.idfOriginalViewColumn = vc_source_original.idfViewColumn
		inner join	tasViewColumn vc_source_copy
		on			vc_source_copy.idfViewColumn = vc_source_to_copy.idfCopyViewColumn
	on			vc_source_original.idfViewColumn = vc_original.idfSourceViewColumn
	left join	tasViewColumn vc_denominator_original
		inner join	@ViewColumn vc_denominator_to_copy
		on			vc_denominator_to_copy.idfOriginalViewColumn = vc_denominator_original.idfViewColumn
		inner join	tasViewColumn vc_denominator_copy
		on			vc_denominator_copy.idfViewColumn = vc_denominator_to_copy.idfCopyViewColumn
	on			vc_denominator_original.idfViewColumn = vc_original.idfDenominatorViewColumn
	left join	tasViewColumn vc_copy
	on			vc_copy.idfViewColumn = vc_to_copy.idfCopyViewColumn
	where		v_original.idflLayout = @idflOriginalLayout
				and (	vc_original.idfViewBand is null
						or	vb_copy.idfView is not null
					)
				and (	vc_original.idfLayoutSearchField is null
						or	lsf_copy.idfLayoutSearchField is not null
					)
				and (	vc_original.idfSourceViewColumn is null
						or	vc_source_copy.idfViewColumn is not null
					)
				and (	vc_original.idfDenominatorViewColumn is null
						or	vc_denominator_copy.idfViewColumn is not null
					)
				and vc_copy.idfViewColumn is null
	set	@RowsAffected = @@rowcount
end



-- Copy Chart X-axis and Map Administrative Unit attributes of original view
update		v_copy
set			v_copy.idfChartXAxisViewColumn = vc_chartXaxis_copy.idfViewColumn,
			v_copy.idfMapAdminUnitViewColumn = vc_mapAdminUnit_copy.idfViewColumn
from		tasView v_copy
inner join	tasView v_original
on			v_original.idflLayout = @idflOriginalLayout
			and v_original.idfsLanguage = v_copy.idfsLanguage
left join	tasViewColumn vc_chartXaxis_original
	inner join	@ViewColumn vc_chartXaxis_to_copy
	on			vc_chartXaxis_to_copy.idfOriginalViewColumn = vc_chartXaxis_original.idfViewColumn
	inner join	tasViewColumn vc_chartXaxis_copy
	on			vc_chartXaxis_copy.idfViewColumn = vc_chartXaxis_to_copy.idfCopyViewColumn
on			vc_chartXaxis_original.idfViewColumn = v_original.idfChartXAxisViewColumn
			and vc_chartXaxis_original.idfView = v_original.idfView
			and vc_chartXaxis_original.idfsLanguage = v_original.idfsLanguage
			and vc_chartXaxis_copy.idfView = v_copy.idfView
			and vc_chartXaxis_copy.idfsLanguage = v_copy.idfsLanguage
left join	tasViewColumn vc_mapAdminUnit_original
	inner join	@ViewColumn vc_mapAdminUnit_to_copy
	on			vc_mapAdminUnit_to_copy.idfOriginalViewColumn = vc_mapAdminUnit_original.idfViewColumn
	inner join	tasViewColumn vc_mapAdminUnit_copy
	on			vc_mapAdminUnit_copy.idfViewColumn = vc_mapAdminUnit_to_copy.idfCopyViewColumn
on			vc_mapAdminUnit_original.idfViewColumn = v_original.idfMapAdminUnitViewColumn
			and vc_mapAdminUnit_original.idfView = v_original.idfView
			and vc_mapAdminUnit_original.idfsLanguage = v_original.idfsLanguage
			and vc_mapAdminUnit_copy.idfView = v_copy.idfView
			and vc_mapAdminUnit_copy.idfsLanguage = v_copy.idfsLanguage
where		v_copy.idfView = @idfViewCopy
			and v_copy.idflLayout = @idflLayoutCopy
			and	(	v_original.idfChartXAxisViewColumn is null
					or	vc_chartXaxis_copy.idfViewColumn is not null
				)
			and	(	v_original.idfMapAdminUnitViewColumn is null
					or	vc_mapAdminUnit_copy.idfViewColumn is not null
				)
			and	(	v_original.idfChartXAxisViewColumn is not null
					or	v_original.idfMapAdminUnitViewColumn is not null
				)



-- Copy connections between layout and map images

-- Get new identifiers of connections between layout and map images - start
declare	@LayoutToMapImage	table
(	idfOriginalLayoutToMapImage	bigint not null primary key,
	idfCopyLayoutToMapImage		bigint null
)

insert into	@LayoutToMapImage (idfOriginalLayoutToMapImage)
select		l_to_mi_original.idfLayoutToMapImage
from		tasLayoutToMapImage l_to_mi_original
where		l_to_mi_original.idflLayout = @idflOriginalLayout


delete from	tstNewID	where	idfTable = -1234	-- Layout objects

insert into	tstNewID
(	idfTable,
	idfKey1
)
select	-1234,										-- Layout objects
		idfOriginalLayoutToMapImage
from	@LayoutToMapImage

update		l_to_mi_to_copy
set			l_to_mi_to_copy.idfCopyLayoutToMapImage = nID.[NewID]
from		@LayoutToMapImage l_to_mi_to_copy
inner join	tstNewID nID
on			nID.idfTable = -1234					-- Layout objects
			and nID.idfKey1 = l_to_mi_to_copy.idfOriginalLayoutToMapImage

delete from	tstNewID	where	idfTable = -1234	-- Layout objects
-- Get new identifiers of connections between layout and map images - end

insert into	tasLayoutToMapImage
(	idfLayoutToMapImage,
	idflLayout,
	idfMapImage
)
select		l_to_mi_to_copy.idfCopyLayoutToMapImage,
			l_copy.idflLayout,
			l_to_mi_original.idfMapImage
from		@LayoutToMapImage l_to_mi_to_copy
inner join	tasLayoutToMapImage l_to_mi_original
on			l_to_mi_original.idfLayoutToMapImage = l_to_mi_to_copy.idfOriginalLayoutToMapImage
inner join	tasLayout l_copy
on			l_copy.idflLayout = @idflLayoutCopy
left join	tasLayoutToMapImage l_to_mi_copy
on			l_to_mi_copy.idfLayoutToMapImage = l_to_mi_to_copy.idfCopyLayoutToMapImage
where		l_to_mi_original.idflLayout = @idflOriginalLayout
			and l_to_mi_copy.idfLayoutToMapImage is null



-- Exit in case of success
return @errorCode


