

--##SUMMARY Selects data for AVR View form

--##REMARKS Author: Gorodentseva T.
--##REMARKS Create date: 10.10.2013

--##RETURNS Doesn't use

/*
Example of procedure call:

declare	@ID	bigint
EXECUTE spAsViewBand_SelectList @ID, 'en'

*/
--0 View
create  PROCEDURE dbo.spAsViewBand_SelectList
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
	where		vws.blnIsColumn = 0


	--Select table tasViewBand
	SELECT 
	   vwb.idfViewBand
	  ,vwb.idfView
	  ,vwb.idfsLanguage
	  ,vwb.strOriginalName
	  ,vwb.strDisplayName
	  ,vwb.idfLayoutSearchField
	  ,vwb.blnVisible
	  ,vwb.blnFreeze
	  ,vwb.intOrder
	  ,vwb.idfParentViewBand
	  ,IsNull(vws.strLevelOriginalNamePath, N'') as UniquePath
	FROM		tasViewBand vwb
	left join	@vwStructure vws
	on			vws.idfView = vwb.idfView
				and vws.idfViewColumnOrBand = vwb.idfViewBand
				and vws.idfsLanguage = vwb.idfsLanguage
	
	WHERE   vwb.idfView = @ID
			AND vwb.idfsLanguage = dbo.fnGetLanguageCode(@LangID)
end




