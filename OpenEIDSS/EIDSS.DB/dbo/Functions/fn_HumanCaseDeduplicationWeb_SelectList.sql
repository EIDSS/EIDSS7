


--##SUMMARY Returns the list of human cases.
--##SUMMARY Used by HumanCaseDeduplicationList form.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 26.02.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns the list of human cases for selection


/*
--Example of a call of function:
select * from fn_HumanCaseDeduplication_SelectList ('en')

*/


CREATE	function	[dbo].[fn_HumanCaseDeduplicationWeb_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
as
return
select			tlbHumanCase.idfHumanCase AS idfCase,
				tlbHumanCase.idfsTentativeDiagnosis,
				TentativeDiagnosis.[name] as TentativeDiagnosisName,
				tlbHumanCase.idfsFinalDiagnosis,
				FinalDiagnosis.[name] as FinalDiagnosisName,
				tlbHumanCase.datEnteredDate,
				tlbHumanCase.strCaseID,
				tlbHumanCase.strLocalIdentifier,
				tlbHuman.strLastName,
				tlbHuman.strFirstName,
				tlbHuman.strSecondName,
				dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as PatientName,
				tlbHumanCase.intPatientAge,
				tlbHumanCase.idfsHumanAgeType,
				HumanAgeType.[name] as HumanAgeTypeName,
				IsNull(	str(tlbHumanCase.intPatientAge) + 
						' (' + HumanAgeType.[name] + ')', '') as Age

from			(
	tlbHumanCase
	left join	dbo.fnReferenceRepair(@LangID, 19000042) as HumanAgeType
	on			HumanAgeType.idfsReference = tlbHumanCase.idfsHumanAgeType
	left join	dbo.fnReferenceRepair(@LangID, 19000019) as TentativeDiagnosis		--'rftDiagnosis'
	on			TentativeDiagnosis.idfsReference = tlbHumanCase.idfsTentativeDiagnosis
	left join	dbo.fnReferenceRepair(@LangID, 19000019) as FinalDiagnosis		--'rftDiagnosis'
	on			FinalDiagnosis.idfsReference = tlbHumanCase.idfsFinalDiagnosis
				)

JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0

JOIN fnGetPermissionOnHumanCase(NULL, NULL) GetPermission ON
	GetPermission.idfHumanCase = tlbHumanCase.idfHumanCase
	AND GetPermission.intPermission = 2

WHERE tlbHumanCase.intRowStatus = 0
