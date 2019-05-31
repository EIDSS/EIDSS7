

--##SUMMARY select layouts for analytical module

--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 12.01.2010

--##RETURNS Don't use

/*
--Example of a call of procedure:

exec spAsFolderSelectLookup 'en'
exec spAsFolderSelectLookup 'en', 147490000000


*/ 
 
CREATE PROCEDURE [dbo].[spAsFolderSelectLookup]
	@LangID	as nvarchar(50),
	@FolderID	as bigint = null,
	@QueryID	as bigint = null
AS
BEGIN
		select	tFolder.idflLayoutFolder		as idflFolder,
				tFolder.idflParentLayoutFolder	as idflParentFolder,
				tFolder.idfsGlobalLayoutFolder  as idfsGlobalFolder,
				refFolder.strEnglishName		as strDefaultFolderName,
				refFolder.strName				as strFolderName,
				tFolder.idflQuery				as idflQuery,
				tFolder.blnReadOnly				as blnReadOnly,
				isnull(brFolder.intOrder,0)		as intOrder,
				qso.idfsSearchObject --this field is needed for filtration by user access rigths
		  from	dbo.tasLayoutFolder					as tFolder
	inner join	dbo.fnLocalReference(@LangID)	as refFolder
			on	tFolder.idflLayoutFolder = refFolder.idflBaseReference
	left join	tasQuerySearchObject as qso
			on	tFolder.idflQuery = qso.idflQuery and qso.idfParentQuerySearchObject is null
	 left join	trtBaseReference brFolder
			on	brFolder.idfsBaseReference = tFolder.idfsGlobalLayoutFolder
		 where	(@QueryID  is null or @QueryID  = tFolder.idflQuery)
		   and	(@FolderID is null or @FolderID = tFolder.idflLayoutFolder)
	 order by	tFolder.idflQuery, intOrder, refFolder.strName 
	  
	 --  order by tFolder.idflLayoutFolder 
	  

END

