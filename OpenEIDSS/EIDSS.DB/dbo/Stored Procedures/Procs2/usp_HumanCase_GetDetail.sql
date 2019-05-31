
--=====================================================================================================
-- Created by:				Joan Li
-- Last modified date:		06/19/2017
-- Last modified by:		Joan Li
-- Description:				06/19/2017: Created based on V6 spHumanCase_SelectDetail :  V7 USP66
--                          select list of records from the following tables:
--                          checking from tlbTesting;tlbMaterial;
--                          electing from tlbHumanCase;tlbHuman;tlbObservation;tlbPerson;tlbOutbreak;tstSite 
--                          and fnConcatFullName;fnInstitution 
--                          10001001: completed 
--                          10001006: amended
/*
----testing code:
execute	usp_HumanCase_GetDetail  2320000870, 'en'
----related fact data from
select * from tlbHumanCase  -- where idfHumanCase=@idfCase
*/

--=====================================================================================================

CREATE procedure	[dbo].[usp_HumanCase_GetDetail]
(		@idfCase	bigint,				--##PARAM @idfCase Case Id
		@LangID		nvarchar(50) = 'en' --##PARAM @LangID - language ID
)
as
declare @blnEnableTestsConducted bit

if (exists (select * from tlbTesting t --all tests are completed
	inner join tlbMaterial m on 
		t.idfMaterial = m.idfMaterial
	where 
		(t.idfsTestStatus in (10001001, 10001006)) --completed or amended
		and t.intRowStatus = 0
		--and isnull(t.blnNonLaboratoryTest,0) = 0
		and m.idfHumanCase = @idfCase
	))
	SET @blnEnableTestsConducted = 0
else
	SET @blnEnableTestsConducted = 1


-- 0 tlbHumanCase
select		tlbHumanCase.idfHumanCase AS idfCase,
			tlbHumanCase.idfOutbreak,
			tlbOutbreak.strOutbreakID,
			tlbHumanCase.datEnteredDate,
			tlbHumanCase.strCaseID,
			tlbHumanCase.idfsCaseProgressStatus,
			tlbHumanCase.uidOfflineCaseID,
			tlbHumanCase.idfsFinalState,
			tlbHumanCase.idfsHospitalizationStatus,
			tlbHumanCase.idfsHumanAgeType,
			tlbHumanCase.idfsYNAntimicrobialTherapy,
			tlbHumanCase.idfsYNHospitalization,
			tlbHumanCase.idfsYNSpecimenCollected,
			tlbHumanCase.idfsYNRelatedToOutbreak,
			tlbHumanCase.idfsYNTestsConducted,
			@blnEnableTestsConducted as blnEnableTestsConducted,
			tlbHumanCase.idfsOutcome,
			tlbHumanCase.idfsTentativeDiagnosis,
			tlbHumanCase.idfsFinalDiagnosis,
			tlbHumanCase.idfsInitialCaseStatus,
			tlbHumanCase.idfSentByOffice,
			tlbSentByOffice.[name] as strSentByOffice,
			tlbHumanCase.idfSentByPerson,
			dbo.fnConcatFullName(tlbSentByPerson.strFamilyName, tlbSentByPerson.strFirstName,tlbSentByPerson.strSecondName) as strSentByPerson,
			tlbHumanCase.idfReceivedByOffice,
			tlbReceivedByOffice.[name] as strReceivedByOffice,
			tlbHumanCase.idfReceivedByPerson,
			dbo.fnConcatFullName(tlbReceivedByPerson.strFamilyName, tlbReceivedByPerson.strFirstName, tlbReceivedByPerson.strSecondName) as strReceivedByPerson,
			tlbHumanCase.idfInvestigatedByOffice,
			tlbInvestigatedByOffice.[name] as strInvestigatedByOffice,
			tlbHumanCase.idfInvestigatedByPerson,
			dbo.fnConcatFullName(tlbInvestigatedByPerson.strFamilyName, tlbInvestigatedByPerson.strFirstName, tlbInvestigatedByPerson.strSecondName) as strInvestigatedByPerson,
			tlbHumanCase.idfPointGeoLocation,
			tlbHumanCase.idfEpiObservation,
			tlbEpiObservation.idfsFormTemplate as idfsEPIFormTemplate,
			tlbHumanCase.idfCSObservation,
			tlbCSObservation.idfsFormTemplate as idfsCSFormTemplate,
			tlbHumanCase.datNotificationDate,
			tlbHumanCase.datCompletionPaperFormDate,
			tlbHumanCase.datFirstSoughtCareDate,
			tlbHumanCase.datModificationDate,
			tlbHumanCase.datHospitalizationDate,
			tlbHumanCase.datFacilityLastVisit,
			tlbHumanCase.datExposureDate,
			tlbHumanCase.datDischargeDate,
			tlbHumanCase.datOnSetDate,
			tlbHumanCase.datInvestigationStartDate,
			tlbHumanCase.datTentativeDiagnosisDate,
			tlbHumanCase.datFinalDiagnosisDate,
			tlbHumanCase.strNote,
			tlbHumanCase.strCurrentLocation,
			tlbHumanCase.strHospitalizationPlace,
			tlbHumanCase.strLocalIdentifier,
			tlbHumanCase.idfSoughtCareFacility,
			tlbSoughtCareFacility.[name] as strSoughtCareFacility,
			tlbHumanCase.strSentByFirstName,
			tlbHumanCase.strSentByPatronymicName,
			tlbHumanCase.strSentByLastName,
			tlbHumanCase.strReceivedByFirstName,
			tlbHumanCase.strReceivedByPatronymicName,
			tlbHumanCase.strReceivedByLastName,
			tlbHumanCase.strEpidemiologistsName,
			tlbHumanCase.idfsNotCollectedReason,
			tlbHumanCase.idfsNonNotifiableDiagnosis,
			tlbHumanCase.intPatientAge,
			tlbHumanCase.blnClinicalDiagBasis,
			tlbHumanCase.blnLabDiagBasis,
			tlbHumanCase.blnEpiDiagBasis,
			tlbHumanCase.strClinicalNotes,
			tlbHumanCase.strSummaryNotes,
			tlbHumanCase.idfsFinalCaseStatus,
			tlbHumanCase.idfPersonEnteredBy,
			dbo.fnConcatFullName( tlbPersonEnteredBy.strFamilyName
								,tlbPersonEnteredBy.strFirstName
								,tlbPersonEnteredBy.strSecondName) AS strPersonEnteredBy,			
			tlbHuman.idfHuman,
			tlbHuman.idfsOccupationType,
			tlbHuman.idfRegistrationAddress,
			tlbHuman.datDateOfDeath,
			tlbHuman.strRegistrationPhone,
			tlbHuman.strWorkPhone,
			tlbHuman.blnPermantentAddressAsCurrent,
			tlbHumanCase.idfsSite,
			tlbHumanCase.strSampleNotes,
			tlbEnteredByOffice.name as strOfficeEnteredBy
			,tlbEnteredByOffice.idfOffice as idfOfficeEnteredBy
			,datFinalCaseClassificationDate
			,idfHospital
			,tlbHumanCase.datModificationForArchiveDate
from		tlbHumanCase
LEFT JOIN tlbHuman ON
	tlbHuman.idfHuman = tlbHumanCase.idfHuman
	AND tlbHuman.intRowStatus = 0
left join	tlbObservation as tlbCSObservation
on			tlbCSObservation.idfObservation = tlbHumanCase.idfCSObservation
			and tlbCSObservation.intRowStatus = 0
left join	tlbObservation as tlbEpiObservation
on			tlbEpiObservation.idfObservation = tlbHumanCase.idfEpiObservation
			and tlbEpiObservation.intRowStatus = 0
left join	dbo.fnInstitution(@LangID) as tlbSentByOffice 
on			tlbSentByOffice.idfOffice = tlbHumanCase.idfSentByOffice
left join	dbo.fnInstitution(@LangID) as tlbReceivedByOffice
on			tlbReceivedByOffice.idfOffice = tlbHumanCase.idfReceivedByOffice
left join	dbo.fnInstitution(@LangID) as tlbInvestigatedByOffice
on			tlbInvestigatedByOffice.idfOffice = tlbHumanCase.idfInvestigatedByOffice
left join	dbo.fnInstitution(@LangID) as tlbSoughtCareFacility
on			tlbSoughtCareFacility.idfOffice = tlbHumanCase.idfSoughtCareFacility
left join	tlbPerson as tlbSentByPerson
on			tlbSentByPerson.idfPerson = tlbHumanCase.idfSentByPerson
left join	tlbPerson as tlbReceivedByPerson
on			tlbReceivedByPerson.idfPerson = tlbHumanCase.idfReceivedByPerson
left join	tlbPerson as tlbInvestigatedByPerson
on			tlbInvestigatedByPerson.idfPerson = tlbHumanCase.idfInvestigatedByPerson
left join	tlbPerson as tlbPersonEnteredBy
on			tlbPersonEnteredBy.idfPerson = tlbHumanCase.idfPersonEnteredBy
left join	tlbOutbreak as tlbOutbreak
on			tlbOutbreak.idfOutbreak = tlbHumanCase.idfOutbreak
left join	tstSite 
on			tstSite.idfsSite = tlbHumanCase.idfsSite
left join	dbo.fnInstitution(@LangID) as tlbEnteredByOffice
on			tlbEnteredByOffice.idfOffice = tstSite.idfOffice

where		tlbHumanCase.idfHumanCase = @idfCase
			and tlbHumanCase.intRowStatus = 0


