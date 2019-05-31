





CREATE    Function dbo.fn_RepositoryScheme_SelectList(@LangID as nvarchar(50))
returns table
as
return
select		tlbFreezer.idfFreezer,
			tlbFreezer.strFreezerName,
			tlbFreezer.strNote,
			tlbFreezer.idfsStorageType,
			ST.[name] as 'StorageType'

from		tlbFreezer
left join	fnReferenceRepair(@LangID, 19000092) as ST --rftStorageType
on			ST.idfsReference = tlbFreezer.idfsStorageType 

where		
			tlbFreezer.intRowStatus = 0 and
			tlbFreezer.idfsSite=dbo.fnSiteID()




