







CREATE       function fnDepartment(@LangID nvarchar(50))
returns table
as
return(
 
select			tlbDepartment.idfDepartment,
				tlbDepartment.idfOrganization as idfInstitution,
				trtBaseReference.strDefault as DefaultName,
				IsNull(trtStringNameTranslation.strTextString, trtBaseReference.strDefault) as [name],
				trtBaseReference.intHACode,
				trtBaseReference.strDefault,
				trtBaseReference.intRowStatus

from		tlbDepartment

left join	dbo.trtBaseReference
on			tlbDepartment.idfsDepartmentName = trtBaseReference.idfsBaseReference
			--and trtBaseReference.intRowStatus = 0

left join	dbo.trtStringNameTranslation
on			tlbDepartment.idfsDepartmentName = trtStringNameTranslation.idfsBaseReference
			and trtStringNameTranslation.idfsLanguage = dbo.fnGetLanguageCode(@LangID)

where		tlbDepartment.intRowStatus = 0
)


