

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsLayoutSelectLookup 'en'
exec spAsLayoutSelectLookup 'en', 147490000000


*/ 
 
CREATE PROCEDURE [dbo].[spAsLayoutSelectLookup]
	@LangID	as nvarchar(50),
	@LayoutID	as bigint = null,
	@QueryID	as bigint = null
AS
BEGIN

		select	lay.idflLayout				as idflLayout,
				lay.idflLayoutFolder		as idflFolder,
				lay.idfsGlobalLayout		as idfsGlobalLayout,
				refLayout.strEnglishName	as strDefaultLayoutName,
				refLayout.strName			as strLayoutName,
				lay.idflDescription			as idflDescription,
				-1							as idflDescriptionNational,
				refDescription.strName		as strDescription,
				refDescription.strEnglishName	as strDescriptionEnglish,
				lay.idflQuery				as idflQuery,
				lay.idfPerson				as idfPerson,
				lay.blnReadOnly				as blnReadOnly,
				lay.blnShareLayout			as blnShareLayout,
				lay.blnUseArchivedData		as blnUseArchivedData,
				lay.intPivotGridXmlVersion	as intPivotGridXmlVersion,
				isnull(brLayout.intOrder,0)	as intOrder,
				dbo.fnConcatFullName(p.strFamilyName, p.strFirstName, p.strSecondName) as strAuthor,
				qso.idfsSearchObject, --this field is needed for filtration by user access rigths
				lay.blnUseArchivedData      as blnUseArchivedData
				
		  from	dbo.tasLayout					as lay
	inner join	dbo.fnLocalReference(@LangID)	as refLayout
			on	lay.idflLayout = refLayout.idflBaseReference
	left join	tasQuerySearchObject as qso
			on	lay.idflQuery = qso.idflQuery and qso.idfParentQuerySearchObject is null
	 left join tlbPerson p 
			on p.idfPerson = lay.idfPerson
	 left join	dbo.fnLocalReference(@LangID)	as refDescription
			on	lay.idflDescription = refDescription.idflBaseReference			
	 left join	trtBaseReference brLayout
			on	brLayout.idfsBaseReference = lay.idfsGlobalLayout
		 where	(@QueryID  is null or @QueryID  = lay.idflQuery)
		   and	(@LayoutID is null or @LayoutID = lay.idflLayout)
	  order by	lay.idflQuery, intOrder, refLayout.strName 

END

