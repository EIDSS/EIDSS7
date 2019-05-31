

--##SUMMARY Selects data for AVR View form

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

declare	@ID	bigint
EXECUTE spAsView_SelectDetail @ID, 'en'

*/
--0 View
create  PROCEDURE dbo.spAsView_SelectDetail
	@ID			bigint,
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

	declare	@viewId	bigint
	declare	ViewCursor	cursor local read_only forward_only for
		select		v.idfView
		from		tasView v
		where		v.idflLayout = @ID
					and v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
	open ViewCursor
	fetch next from	ViewCursor into	@viewId

	while @@fetch_status <> -1
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
		from		dbo.fnAsGetUniquePathOfViewContent(@viewId, @LangID) vws
		left join	@vwStructure vws_ex
		on			vws_ex.idfViewColumnOrBand = vws.idfViewColumnOrBand
					and vws_ex.idfsLanguage = vws.idfsLanguage
		where		vws.blnIsColumn = 1
					and vws_ex.idfViewColumnOrBand is null

		fetch next from	ViewCursor into	@viewId

	end
		
	close ViewCursor
	deallocate ViewCursor


--tasView
	SELECT 
	   v.idfView
	  ,v.idfsLanguage
	  ,v.idflLayout
	  ,IsNull(xax.strLevelOriginalNamePath, N'') as ChartXAxisViewColumn
	  ,IsNull(adu.strLevelOriginalNamePath, N'') as MapAdminUnitViewColumn
	  ,v.idfGlobalView
	  ,v.blbChartLocalSettings
	  ,v.blbGisLayerLocalSettings
	  ,v.blbGisMapLocalSettings
	  ,v.blbViewSettings
	  ,l.intGisLayerPosition
	  ,l.blnReadOnly
	  ,l.idflQuery
	FROM tasView v
	Inner JOIN tasLayout l on v.idflLayout = l.idflLayout
	Left OUTER JOIN @vwStructure xax on xax.idfViewColumnOrBand = v.idfChartXAxisViewColumn
	Left OUTER JOIN @vwStructure adu on adu.idfViewColumnOrBand = v.idfMapAdminUnitViewColumn
	WHERE v.idflLayout = @ID
	AND v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
 

	select		@viewId=v.idfView
	from		tasView v
	where		v.idflLayout = @ID
				and v.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

	-- tasViewBand
	execute spAsViewBand_SelectList @viewId, @LangID

	-- tasViewColumn
	exec spAsViewColumn_SelectList @viewId, @LangID


end


