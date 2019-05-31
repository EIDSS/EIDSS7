
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

-- select * from dbo.fn_Event_SelectList('ka')


create   FUNCTION dbo.fn_Event_SelectList(@LangID as nvarchar(50))
returns table 
as
return
select			
				tstEvent.idfEventID,
				EventType.[name] as strEventTypeName,  
				tstEvent.idfObjectID, 
				tstEvent.strInformationString, 
				tstEvent.strNote, 
			    tstEvent.idfsEventTypeID,
				tstEvent.datEventDatatime,
				tlbPerson.idfPerson,
				dbo.fnConcatFullName(strFamilyName, strFirstName, strSecondName) as strPersonName,
				CASE 
					WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
					ELSE tlbVetCase.idfsCaseType
				END AS idfsCaseType

from			(
	tstEvent 
	inner join		fnReferenceRepair(@LangID,19000025) as EventType --'rftEventType'
	on				tstEvent.idfsEventTypeID = EventType.idfsReference
				)
left outer join	(
	tstUserTable 
/*
	inner join		Employee 
	on				Employee.idfEmployee = UserTable.idfEmployee
					--and (Employee.intRowStatus = 0 or Employee.intRowStatus is null) 
*/
	inner join		tlbPerson 
	on				tlbPerson.idfPerson = tstUserTable.idfPerson
				)
	on				tstUserTable.idfUserID = tstEvent.idfUserID
	LEFT JOIN		tlbHumanCase
	ON				tlbHumanCase.idfHumanCase = tstEvent.idfObjectID
	LEFT JOIN		tlbVetCase
	ON				tlbVetCase.idfVetCase = tstEvent.idfObjectID

WHERE
	tstEvent.idfsEventTypeID <> 10025001 --'evtLanguageChanged'



