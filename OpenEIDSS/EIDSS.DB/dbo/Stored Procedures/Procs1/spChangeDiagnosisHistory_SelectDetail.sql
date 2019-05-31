

--##SUMMARY Selects history of diagnosis changes for a specified human case.

--##REMARKS Author: Mirnaya O.
--##REMARKS Update date: 19.08.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@idfCase	bigint
declare	@LangID		nvarchar(50)

execute	spChangeDiagnosisHistory_SelectDetail
	 @idfCase
	,@LangID
*/



create procedure	spChangeDiagnosisHistory_SelectDetail
(	 @idfCase	bigint			--##PARAM @idfCase Case Id
	,@LangID	nvarchar(50)	--##PARAM @LangID Language Id	
)
as

-- 0 tlbChangeDiagnosisHistory
select		tlbChangeDiagnosisHistory.idfChangeDiagnosisHistory,
			tlbChangeDiagnosisHistory.idfHumanCase,
			tlbChangeDiagnosisHistory.idfsPreviousDiagnosis,
			tlbChangeDiagnosisHistory.idfsCurrentDiagnosis,
			tlbChangeDiagnosisHistory.datChangedDate,
			tlbChangeDiagnosisHistory.idfsChangeDiagnosisReason ,
			ChangeDiagnosisReason.[name] as strReason,
			tlbChangeDiagnosisHistory.idfPerson,
			dbo.fnConcatFullName(tlbPerson.strFamilyName, tlbPerson.strFirstName, tlbPerson.strSecondName) as strPersonName,
			Institution.[name] as Organization,
			PreviousDiagnosis.[name] as PreviousDiagnosisName,
			CurrentDiagnosis.[name] as CurrentDiagnosisName
from		tlbChangeDiagnosisHistory
inner join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = tlbChangeDiagnosisHistory.idfHumanCase
			and tlbHumanCase.intRowStatus = 0
left join	fnReference(@LangID, 19000019) PreviousDiagnosis	-- rftDiagnosis
on			PreviousDiagnosis.idfsReference = tlbChangeDiagnosisHistory.idfsPreviousDiagnosis
left join	fnReference(@LangID, 19000019) CurrentDiagnosis		-- rftDiagnosis
on			CurrentDiagnosis.idfsReference = tlbChangeDiagnosisHistory.idfsCurrentDiagnosis
left join	fnReference(@LangID, 19000147) ChangeDiagnosisReason		-- rftChangeDiagnosisReason
on			ChangeDiagnosisReason.idfsReference = tlbChangeDiagnosisHistory.idfsChangeDiagnosisReason
inner join	(
	tlbPerson
	inner join	tlbEmployee
	on			tlbEmployee.idfEmployee = tlbPerson.idfPerson
				and tlbEmployee.intRowStatus = 0
	left join	dbo.fnInstitution(@LangID) Institution
	on			Institution.idfOffice = tlbPerson.idfInstitution
			)
on			tlbPerson.idfPerson = tlbChangeDiagnosisHistory.idfPerson
			and tlbPerson.intRowStatus = 0
where		tlbChangeDiagnosisHistory.idfHumanCase = @idfCase
			and tlbChangeDiagnosisHistory.intRowStatus = 0

