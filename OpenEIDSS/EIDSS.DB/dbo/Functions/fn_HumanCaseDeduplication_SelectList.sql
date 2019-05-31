

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


create	function	[dbo].[fn_HumanCaseDeduplication_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
--returns @res table	(
--	idfCase				uniqueidentifier,
--	idfsDiagnosis		bigint,
--	DiagnosisName		nvarchar(300),
--	idfsCaseStatus		bigint,
--	CaseStatusName		nvarchar(300),
--	datEnteredDate		datetime, 
--	strCaseID			nvarchar(200),
--	strLocalIdentifier	nvarchar(200),
--	idfHuman			uniqueidentifier,
--	strLastName			nvarchar(200),
--	strFirstName		nvarchar(200),
--	strSecondName		nvarchar(200),
--	PatientName			nvarchar(1000),
--	datDateofBirth		datetime,
--	intPatientAge		int,
--	idfsHumanAgeType	bigint,	
--	Age					nvarchar(400),
--	idfGeoLocation		uniqueidentifier,
--	GeoLocationName		nvarchar(2000),
--						)
as
--begin

--declare @TypePer int
--set @TypePer = dbo.fn_ObjectTypePermission('objHumanCase', null, 'ObjectOperationRead')
--insert into @res
return
select			tlbHumanCase.idfHumanCase,
				ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsFinalDiagnosis) as idfsDiagnosis,
				Diagnosis.[name] as DiagnosisName,
				ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) AS idfsCaseStatus,
				tlbHumanCase.idfsCaseProgressStatus,
				CaseStatus.[name] as CaseStatusName,
				CaseProgressStatus.[name] as CaseProgressStatusName,
				tlbHumanCase.datEnteredDate,
				tlbHumanCase.strCaseID,
				tlbHumanCase.strLocalIdentifier,
				tlbHuman.idfHuman,
				tlbHuman.strLastName,
				tlbHuman.strFirstName,
				tlbHuman.strSecondName,
				dbo.fnConcatFullName(tlbHuman.strLastName , tlbHuman.strFirstName, tlbHuman.strSecondName) as PatientName,
				tlbHuman.datDateofBirth,
				tlbHumanCase.intPatientAge,
				tlbHumanCase.idfsHumanAgeType,
				IsNull(	str(tlbHumanCase.intPatientAge) + 
						' (' + HumanAgeType.[name] + ')', '') as Age,
				tlbHumanCase.idfPointGeoLocation as idfGeoLocation,
				ISNULL(CurrentResidenceAddress.name, CurrentResidenceAddress.strDefault) AS GeoLocationName,
				tlbHumanCase.idfEpiObservation,
				tlbHumanCase.idfCSObservation

from			(
	tlbHumanCase
	left join	dbo.fnReferenceRepair(@LangID, 19000042) as HumanAgeType
	on			HumanAgeType.idfsReference = tlbHumanCase.idfsHumanAgeType
	left join	dbo.fnReferenceRepair(@LangID, 19000019) as Diagnosis		--'rftDiagnosis'
	on			Diagnosis.idfsReference = ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsFinalDiagnosis)
	left join	dbo.fnReferenceRepair(@LangID,19000111) as CaseProgressStatus --'rftCaseProgressStatus'
	on			tlbHumanCase.idfsCaseProgressStatus = CaseProgressStatus.idfsReference
	left join	dbo.fnReferenceRepair(@LangID, 19000011) as CaseStatus	--'rftCaseStatus'
	on			CaseStatus.idfsReference = ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus)
				)
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0

LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) CurrentResidenceAddress ON
	CurrentResidenceAddress.idfGeoLocation = tlbHuman.idfCurrentResidenceAddress

JOIN fnGetPermissionOnHumanCase(NULL, NULL) GetPermission ON
	GetPermission.idfHumanCase = tlbHumanCase.idfHumanCase
	AND GetPermission.intPermission = 2

WHERE tlbHumanCase.intRowStatus = 0
--left join	dbo.fn_ObjectDirectPermission_HumanCase('ObjectOperationRead', null) op
--on			op.idfActivity = a.idfActivity

--where			(	(op.intPermission in (2, 4))
--						or (op.intPermission is null and @TypePer <> 1))


--return
--end



