

--##SUMMARY Returns the list of human cases.
--##SUMMARY Used by HumanCaseList form.

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 25.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Function returns the list of human cases


/*
--Example of a call of function:
select * from dbo.fn_HumanCase_SelectListWithDeleted('en')

*/


create	function	[dbo].[fn_HumanCase_SelectListWithDeleted]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
--returns @res table	(
--	idfCase		uniqueidentifier,
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
return
select			tlbHumanCase.idfHumanCase AS idfCase,
				ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) as idfsDiagnosis,
				Diagnosis.[name] as DiagnosisName,
				ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus) AS idfsCaseStatus,
				tlbHumanCase.idfsCaseProgressStatus,
				CaseStatus.[name] as CaseStatusName,
				CaseProgressStatus.[name] as CaseProgressStatusName,
				tlbHumanCase.datEnteredDate,
				tlbHumanCase.strCaseID,
				tlbHumanCase.idfsSite,
				tlbHumanCase.datCompletionPaperFormDate,
				tlbHumanCase.strLocalIdentifier,
				tlbHumanCase.idfPersonEnteredBy,
				tlbHumanCase.idfHuman,
				tlbHuman.strLastName,
				tlbHuman.strFirstName,
				tlbHuman.strSecondName,
				dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as PatientName,
				tlbHuman.datDateofBirth,
				tlbHumanCase.intPatientAge,
				tlbHumanCase.idfsHumanAgeType,
				IsNull(	str(tlbHumanCase.intPatientAge) + 
						' (' + HumanAgeType.[name] + ')', '') as Age,
				tlbHuman.idfCurrentResidenceAddress as idfAddress, --needed for OutbreakDetail form
				tlbHumanCase.idfPointGeoLocation as idfGeoLocation,
				ISNULL(CurrentResidenceAddress.name, CurrentResidenceAddress.strDefault) AS GeoLocationName,
				tlbHumanCase.idfEpiObservation,
				tlbHumanCase.idfCSObservation,
			    tlbHumanCase.idfsTentativeDiagnosis,
			    tlbHumanCase.idfsInitialCaseStatus,
				CRA.idfsSettlement, 
				CRA.idfsRegion, 
				CRA.idfsRayon, 
				CRA.idfsCountry,
				location.idfsRayon as idfsLocationOfExposureRayon,
				location.idfsRegion as idfsLocationOfExposureRegion,
				tlbHumanCase.datFinalCaseClassificationDate,
				
				tlbHumanCase.intRowStatus

from			(
	tlbHumanCase
	left join	dbo.fnReferenceRepair(@LangID, 19000042) as HumanAgeType
	on			HumanAgeType.idfsReference = tlbHumanCase.idfsHumanAgeType
	left join	dbo.fnReferenceRepair(@LangID, 19000019) as Diagnosis		--'rftDiagnosis'
	on			Diagnosis.idfsReference = ISNULL(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis)
	left join	dbo.fnReferenceRepair(@LangID,19000111) as CaseProgressStatus --'rftCaseProgressStatus'
	on			CaseProgressStatus.idfsReference = tlbHumanCase.idfsCaseProgressStatus
	left join	dbo.fnReferenceRepair(@LangID, 19000011) as CaseStatus	--'rftCaseStatus'
	on			CaseStatus.idfsReference = ISNULL(tlbHumanCase.idfsFinalCaseStatus, tlbHumanCase.idfsInitialCaseStatus)
				)
JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman

LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) CurrentResidenceAddress ON
	CurrentResidenceAddress.idfGeoLocation = tlbHuman.idfCurrentResidenceAddress

LEFT JOIN dbo.tlbGeoLocation CRA ON
   tlbHuman.idfCurrentResidenceAddress  = CRA.idfGeoLocation
LEFT JOIN dbo.tlbGeoLocation location ON
   tlbHumanCase.idfPointGeoLocation  = location.idfGeoLocation

