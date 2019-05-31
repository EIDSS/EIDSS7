

--##SUMMARY This procedure selects the tree of related query search objects.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 21.04.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 11.11.2011

--##RETURNS Don't use

/*
--Example of a call of procedure:

declare	@ID	bigint
exec spAsQuery_SelectObjectTree @ID, 'en'
*/ 


CREATE procedure	[dbo].[spAsQuery_SelectObjectTree]
	@ID	bigint,
	@LangID		nvarchar(50)
as

select		rootObj.idflQuery,
			case
				when	childObj.idfQuerySearchObject = rootObj.idfQuerySearchObject
					then	null
				else		rootObj.idfQuerySearchObject
			end as idfParentQuerySearchObject,
			childObj.idfQuerySearchObject,
			childObj.idfsSearchObject,
			childObj.intOrder

from		tasQuerySearchObject rootObj

inner join	(
	tasSearchObject rootSOB
	inner join	trtBaseReference rootBR_SOB
	on			rootBR_SOB.idfsBaseReference = rootSOB.idfsSearchObject
				and rootBR_SOB.intRowStatus = 0
			)
on			rootSOB.idfsSearchObject = rootObj.idfsSearchObject
			and rootSOB.blnPrimary = 1
 
inner join	tasQuerySearchObject childObj
on			(	(childObj.idfParentQuerySearchObject = rootObj.idfQuerySearchObject)
				or (childObj.idfQuerySearchObject = rootObj.idfQuerySearchObject))
			and childObj.idflQuery = rootObj.idflQuery

where		rootObj.idflQuery = @ID
			and rootObj.idfParentQuerySearchObject is NULL

order by	idfParentQuerySearchObject, childObj.intOrder, childObj.idfsSearchObject



