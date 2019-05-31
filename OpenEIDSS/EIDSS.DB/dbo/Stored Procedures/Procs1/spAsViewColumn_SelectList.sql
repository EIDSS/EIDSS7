

--##SUMMARY Selects data for AVR View form

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

declare	@ID	bigint
EXECUTE spAsViewColumn_SelectList @ID, 'en'

*/
--0 View
create  PROCEDURE dbo.spAsViewColumn_SelectList
	@ID		bigint,
	@LangID		nvarchar(50)
AS
begin

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
	select		vws.idfViewColumnOrBand,
				vws.idfsLanguage,
				vws.intLevelParent,
				vws.idfView,
				vws.idfLevelParentViewBand,
				vws.blnIsColumn,
				vws.idfLayoutSearchField,
				vws.strSearchFieldAlias,
				vws.strOriginalName,
				vws.strLevelOriginalNamePath
	from		dbo.fnAsGetUniquePathOfViewContent(@ID, @LangID) vws
	where		vws.blnIsColumn = 1


	--Select table tasViewColumn
	SELECT 
	   v.idfViewColumn
	  ,v.idfView
	  ,v.idfsLanguage
	  ,v.idfViewBand
	  ,v.idfLayoutSearchField
	  ,v.strOriginalName
	  ,v.strDisplayName
	  ,v.blnAggregateColumn
	  ,v.idfsAggregateFunction
	  ,v.intPrecision
	  ,v.blnChartSeries
	  ,v.blnMapDiagramSeries
	  ,v.blnMapGradientSeries
	  ,IsNull(numr.strLevelOriginalNamePath, N'') as SourceViewColumn
	  ,IsNull(denr.strLevelOriginalNamePath, N'') as DenominatorViewColumn
	  ,v.blnVisible
	  ,v.blnFreeze
	  ,v.intSortOrder
	  ,v.blnSortAscending
	  ,v.intOrder
	  ,v.strColumnFilter
	  ,v.intColumnWidth
	  ,	case
			when	v.blnAggregateColumn = 1
				then	N'AggregateColumn' + N'__' + cast(v.idfViewColumn as nvarchar(20))
			else	IsNull(vws.strLevelOriginalNamePath, N'') 
		end as UniquePath
	FROM tasViewColumn v
	Left OUTER JOIN @vwStructure numr on numr.idfViewColumnOrBand =  v.idfSourceViewColumn
	Left OUTER JOIN @vwStructure denr on denr.idfViewColumnOrBand =  v.idfDenominatorViewColumn
	left join	@vwStructure vws
	on			vws.idfView = v.idfView
				and vws.idfViewColumnOrBand = v.idfViewColumn
				and vws.idfsLanguage = v.idfsLanguage
	
	WHERE   v.idfView = @ID
	AND v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
end

