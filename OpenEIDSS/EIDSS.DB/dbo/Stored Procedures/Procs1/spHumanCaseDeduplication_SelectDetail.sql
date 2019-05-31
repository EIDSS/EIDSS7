

--##SUMMARY Selects data for two specified human cases (one of them is marked as survivor, 
--##SUMMARY and another case is marked as superseded).

--##REMARKS Author: Mirnaya O.
--##REMARKS Create date: 01.03.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:
declare	@SurvivorID		bigint
declare	@SupersededID	bigint
declare	@LangID			varchar(36)

execute	spHumanCaseDeduplication_SelectDetail
	@SurvivorID,
	@SupersededID,
	@LangID
*/



CREATE procedure	[dbo].[spHumanCaseDeduplication_SelectDetail]
(		 @SurvivorID	bigint		--##PARAM @SurvivorID Id of the survivor case
		,@SupersededID	bigint		--##PARAM @SupersededID Id of the superseded case
		,@LangID		varchar(36)	--##PARAM @LangID Language Id
)
as

-- 0 tlbHumanCase
select		case tlbHumanCase.idfHumanCase
				when @SurvivorID
					then 'Survivor'
				when @SupersededID
					then 'Superseded'
				else 'None'
			end as rowType,
			tlbHumanCase.idfHumanCase AS idfCase,
			tlbHumanCase.strCaseID,
			tlbHumanCase.strLocalIdentifier,
			tlbHumanCase.idfsTentativeDiagnosis,
			TentativeDiagnosis.[name] as TentativeDiagnosis_Name,
			tlbHumanCase.datTentativeDiagnosisDate,

			tlbHuman.idfHuman,
			tlbHuman.strLastName,
			tlbHuman.strSecondName,
			tlbHuman.strFirstName,
			tlbHuman.datDateofBirth,
			tHumanAct.idfsPersonIDType,
			tHumanAct.strPersonID as strPersonID,
			rfPersonIDType.[name] as strPersonIDType,
			tlbHumanCase.intPatientAge,
			tlbHumanCase.idfsHumanAgeType,
			HumanAgeType.[name] as HumanAgeType_Name,
			tlbHuman.idfsHumanGender,
			HumanGender.[name] as HumanGender_Name,
			tlbHuman.idfCurrentResidenceAddress,
			tlbCurrentResidenceAddress.Region,
			tlbCurrentResidenceAddress.Rayon,
			tlbCurrentResidenceAddress.Settlement,
			tlbCurrentResidenceAddress.Street,
			tlbCurrentResidenceAddress.PostalCode,
			tlbCurrentResidenceAddress.House,
			tlbCurrentResidenceAddress.Building,
			tlbCurrentResidenceAddress.Appartment,
			tlbHuman.strHomePhone,
			tlbHuman.idfsNationality,
			Nationality.[name] as Nationality_Name,
			tlbHuman.strEmployerName,
			tlbHuman.idfEmployerAddress,

			ISNULL(tlbEmployerAddress.name, tlbEmployerAddress.strDefault) AS EmployerAddress_Name,

			tlbHumanCase.datOnSetDate,
			tlbHumanCase.idfsFinalState,
			FinalState.[name] as FinalState_Name,
			tlbHumanCase.idfsFinalDiagnosis,
			FinalDiagnosis.[name] as FinalDiagnosis_Name,
			tlbHumanCase.datFinalDiagnosisDate,
			tlbHumanCase.idfsHospitalizationStatus,
			HospitalizationStatus.[name] as HospitalizationStatus_Name,
			CASE	WHEN tlbHumanCase.idfsHospitalizationStatus = 5350000000 THEN rfHospital.name --Hospital
					WHEN tlbHumanCase.idfsHospitalizationStatus = 5360000000 THEN tlbHumanCase.strCurrentLocation --Other
					ELSE N'' END							as strCurrentLocation,
			tlbHumanCase.strNote,

			tlbHumanCase.idfEpiObservation,
			tlbHumanCase.idfCSObservation
from		(
	tlbHumanCase
	left join	fnReference(@LangID, 19000019) TentativeDiagnosis		-- rftDiagnosis
	on			TentativeDiagnosis.idfsReference = tlbHumanCase.idfsTentativeDiagnosis
	left join	fnReference(@LangID, 19000042) HumanAgeType				-- rftHumanAgeType
	on			HumanAgeType.idfsReference = tlbHumanCase.idfsHumanAgeType
	left join	fnReference(@LangID, 19000035) FinalState				-- rftFinalState
	on			FinalState.idfsReference = tlbHumanCase.idfsFinalState
	left join	fnReference(@LangID, 19000019) FinalDiagnosis			-- rftDiagnosis
	on			FinalDiagnosis.idfsReference = tlbHumanCase.idfsFinalDiagnosis
	left join	fnReference(@LangID, 19000041) HospitalizationStatus	-- rftHospStatus
	on			HospitalizationStatus.idfsReference = tlbHumanCase.idfsHospitalizationStatus
	left join  fnInstitution(@LangID) rfHospital
	on			rfHospital.idfOffice = tlbHumanCase.idfHospital
			)
			
INNER JOIN tlbHuman
ON			tlbHuman.idfHuman = tlbHumanCase.idfHuman
			AND tlbHuman.intRowStatus = 0

left join	fnAddressAsRow(@LangID) tlbCurrentResidenceAddress
on			tlbCurrentResidenceAddress.idfGeoLocation = tlbHuman.idfCurrentResidenceAddress
LEFT JOIN dbo.fnGeoLocationTranslation(@LangID) tlbEmployerAddress ON
	tlbEmployerAddress.idfGeoLocation = tlbHuman.idfEmployerAddress
left join	fnReference(@LangID, 19000043) HumanGender				-- rftHumanGender
on			HumanGender.idfsReference = tlbHuman.idfsHumanGender
left join	fnReference(@LangID, 19000054) Nationality				-- rftNationality
on			Nationality.idfsReference = tlbHuman.idfsNationality
			-- Get patient person id type
left join	dbo.tlbHumanActual as tHumanAct
on			tHumanAct.idfHumanActual = tlbHuman.idfHumanActual 
left join	dbo.fnReferenceRepair(@LangID, 19000148) rfPersonIDType ON
	rfPersonIDType.idfsReference = tHumanAct.idfsPersonIDType
	
where		(	tlbHumanCase.idfHumanCase = @SurvivorID
				or tlbHumanCase.idfHumanCase = @SupersededID)
				
			AND tlbHumanCase.intRowStatus = 0

