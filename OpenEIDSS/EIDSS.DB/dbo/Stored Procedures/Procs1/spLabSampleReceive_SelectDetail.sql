

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Grigoreva E.
--##REMARKS Date: 29.01.2012

--##REMARKS UPDATED BY: Romasheva S.
--##REMARKS Date: 16.03.2012

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

/*
exec spLabSampleReceive_SelectDetail 7083180000000 ,'en'
exec spLabSampleReceive_SelectDetail 4584960000000 ,'en'
exec spLabSampleReceive_SelectDetail 50865580000000 ,'en'
*/

CREATE PROCEDURE [dbo].[spLabSampleReceive_SelectDetail]
	@CaseID bigint, 
	@LangID varchar(20)
AS

BEGIN
	SET NOCOUNT ON;

--return case information
SELECT 
	isnull(@CaseID + 1, 0) as ID,
	isnull(@CaseID, 0) as IDCase,
	ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
	CASE 
		WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
		ELSE tlbVetCase.idfsCaseType
	END AS idfsCaseType,
	tlbMonitoringSession.idfMonitoringSession,
	tlbMonitoringSession.strMonitoringSessionID,
	tlbCampaign.strCampaignID,
	tlbCampaign.strCampaignName,

	IsNull(SessionStatus.[name], VSSessionStatus.[name]) as SessionStatus,
	CampaignType.name as CampaignType,
	
	ISNULL(tlbHumanCase.strCaseID, tlbVetCase.strCaseID) AS strCaseID,
	tlbHumanCase.datOnSetDate,
	ISNULL(tlbHumanCase.strSampleNotes, tlbVetCase.strSampleNotes) AS strSampleNotes,
	tlbHumanCase.strLocalIdentifier,
	tlbVetCase.strFieldAccessionID,
	dbo.fnGeoLocationString(@LangID,Farm.idfFarmAddress,null) as FarmAddress,
	Farm.strNationalName,
	dbo.fnConcatFullName(FarmOwner.strLastName, FarmOwner.strFirstName, FarmOwner.strSecondName) as FarmOwner,
	dbo.fnConcatFullName(Patient.strLastName, Patient.strFirstName, Patient.strSecondName) as PatientName,
	Patient.idfHuman,
	IsNull(LTrim(Str(tlbHumanCase.intPatientAge)) + ' (' + AgeType.name + ')', '') as Age,
	(CASE 
		WHEN NOT tlbVetCase.idfVetCase IS NULL THEN dbo.fnDiagnosisString(@LangID, @CaseID)
		ELSE N'' END)  as strVetTentativeDiagnoses,--new field for vet accession in
	DiagnosisName.name as idfsInitialDiagnosis,--for compatibility with human accession in
	DiagnosisName.name as strVetFinalDiagnoses,--new field for vet accession in
	dbo.fnGeoLocationString(@LangID,Patient.idfCurrentResidenceAddress,null) as CurrentResidence,
	Patient.datDateofBirth,
	tlbHumanCase.datTentativeDiagnosisDate as datDiagnosisDate,

	tlbVectorSurveillanceSession.idfVectorSurveillanceSession,
	tlbVectorSurveillanceSession.strSessionID,
	Region.name AS strRegion,
	Rayon.name AS strRayon,
	Settlement.name AS strSettlement
FROM		tlbHumanCase
LEFT JOIN	tlbHuman Patient
ON			Patient.idfHuman = tlbHumanCase.idfHuman
			AND Patient.intRowStatus = 0
left join	fnReference(@LangID, 19000042 ) AgeType on AgeType.idfsReference = tlbHumanCase.idfsHumanAgeType 
			
full join
			(
				tlbVetCase
				LEFT JOIN	tlbFarm Farm
				ON			Farm.idfFarm = tlbVetCase.idfFarm
							AND Farm.intRowStatus = 0
				LEFT JOIN	tlbHuman FarmOwner
				ON			FarmOwner.idfHuman = Farm.idfHuman
							AND FarmOwner.intRowStatus = 0
							
				LEFT JOIN   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
				on tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase 
					AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  
			)
on			1=0 --always false

full join
			(
				tlbMonitoringSession
				left join	tlbCampaign
				on			tlbCampaign.idfCampaign=tlbMonitoringSession.idfCampaign
				left join	fnReference(@LangID,19000117)SessionStatus
				on			SessionStatus.idfsReference=tlbMonitoringSession.idfsMonitoringSessionStatus
				left join	fnReference(@LangID,19000116)CampaignType
				on			CampaignType.idfsReference=tlbCampaign.idfsCampaignType
			)
on			1=0 --always false

full join
			(
				tlbVectorSurveillanceSession 
				
				left join	fnReference(@LangID,19000133) VSSessionStatus
				on			VSSessionStatus.idfsReference = tlbVectorSurveillanceSession.idfsVectorSurveillanceStatus

				left join tlbGeoLocation gl
				on gl.idfGeoLocation = tlbVectorSurveillanceSession.idfLocation

				left join fnGisReference(@LangID,19000003) Region
				on	Region.idfsReference = gl.idfsRegion

				left join fnGisReference(@LangID,19000002) Rayon
				on	Rayon.idfsReference = gl.idfsRayon

				left join fnGisReference(@LangID,19000001) Country
				on	Country.idfsReference = gl.idfsCountry  

				left join fnGisReference(@LangID,19000004) Settlement
				on	Settlement.idfsReference = gl.idfsSettlement
			)
on			1=0 --always false


left join	fnReference(@LangID, 19000019 ) DiagnosisName on 
	DiagnosisName.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsFinalDiagnosis)

where	(tlbHumanCase.idfHumanCase=@CaseID AND tlbHumanCase.intRowStatus = 0) 
OR (tlbVetCase.idfVetCase=@CaseID AND tlbVetCase.intRowStatus = 0)
or (tlbMonitoringSession.idfMonitoringSession=@CaseID AND tlbMonitoringSession.intRowStatus = 0)
OR (tlbVectorSurveillanceSession.idfVectorSurveillanceSession =@CaseID AND tlbVectorSurveillanceSession.intRowStatus = 0)

-- returns materials
select 
        tlbMaterial.idfMaterial,
				tlbMaterial.idfsSampleType,
				tlbMaterial.idfRootMaterial,
				--Material.idfParentMaterial,
				COALESCE(tlbMaterial.idfHuman,tlbMaterial.idfSpecies,tlbMaterial.idfAnimal,tlbMaterial.idfVector) as idfParty,
				Animal.AnimalName,
				Animal.strAnimalCode,
				Animal.SpeciesName,
				Animal.strFarmCode,
				Animal.idfsSpeciesType,
				tlbMaterial.idfFieldCollectedByPerson,
				dbo.fnConcatFullName(Person.strFamilyName, Person.strFirstName, Person.strSecondName) as strFieldCollectedByPerson,
				tlbMaterial.idfFieldCollectedByOffice,
				Office.[name] as strFieldCollectedByOffice,
				tlbMaterial.idfSendToOffice,
				OfficeSendTo.[name] as strSendToOffice,
				tlbMaterial.idfMainTest,
				--Material.idfsSite,
				tlbMaterial.datFieldCollectionDate,
				tlbMaterial.datFieldSentDate,
				tlbMaterial.strFieldBarcode,
				ISNULL(tlbMaterial.idfHumanCase, tlbMaterial.idfVetCase) AS idfCase,
				tlbMaterial.idfMonitoringSession,
				dbo.fnReferenceRepair.name AS strSampleName,
				--tlbAccessionIN.idfsSite,
				tlbMaterial.datAccession,
				tlbMaterial.strCondition,
				tlbMaterial.idfsAccessionCondition,
				tlbMaterial.idfAccesionByPerson,
				blnAccessioned  as Used
				,tlbMaterial.idfVectorSurveillanceSession
				,tlbMaterial.idfVector
				,tlbMaterial.strNote
				,Vector.idfsVectorType
				,Vector.idfsVectorSubType
				,Vector.intQuantity
				,Vector.datCollectionDateTime
				,Vector.idfLocation
				,tlbMaterial.strBarcode
				,Vector.strVectorID
				,vt.[name] as strVectorType
				,vst.[name] as strVectorSpecies,
			tlbMaterial.strFieldBarcode as strFieldBarcode2,
			CASE 
					WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
					ELSE tlbVetCase.idfsCaseType
				END AS idfsCaseType,
			tlbMaterial.idfInDepartment,
			tlbMaterial.idfInDepartment as idfDepartment,
			tlbMaterial.idfSubdivision
			,isnull(Tests.TestsCount, 0) as strTests
			,COALESCE(tlbMaterial.idfHumanCase, tlbMaterial.idfVetCase, tlbMaterial.idfMonitoringSession, tvss.idfVectorSurveillanceSession) as ParentID
from	tlbMaterial
	left join	dbo.fnReferenceRepair(@LangID,19000087) --rftSampleType
	on			dbo.fnReferenceRepair.idfsReference = tlbMaterial.idfsSampleType
left join	dbo.tlbVector Vector
	inner join	fnReference(@LangID, 19000140)	vt	-- Vector Type
	on			vt.idfsReference = Vector.idfsVectorType
	inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
	on			vst.idfsReference = Vector.idfsVectorSubType	 
on			tlbMaterial.idfVector = Vector.idfVector
left join	tlbPerson as Person
on			Person.idfPerson = tlbMaterial.idfFieldCollectedByPerson
left join	dbo.fnInstitution(@LangID) as Office
on			Office.idfOffice = tlbMaterial.idfFieldCollectedByOffice
left join	dbo.fnInstitution(@LangID) as OfficeSendTo
on			OfficeSendTo.idfOffice = tlbMaterial.idfSendToOffice
left join	fnAnimalList(@LangID) Animal
on			tlbMaterial.idfAnimal=Animal.idfParty
 			
left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = tlbMaterial.idfHumanCase
left join	tlbVetCase
on			tlbVetCase.idfVetCase = tlbMaterial.idfVetCase

left JOIN tlbMonitoringSession tms
on			tms.idfMonitoringSession = tlbMaterial.idfMonitoringSession

LEFT JOIN tlbVectorSurveillanceSession tvss
ON tvss.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession

left join	(	select		m.idfMaterial, COUNT(*) as TestsCount
				from		tlbTesting
				inner join	tlbMaterial m
				on			m.idfMaterial = tlbTesting.idfMaterial
							and m.intRowStatus = 0
							and IsNull(m.blnReadOnly, 0) <> 1
				where		tlbTesting.intRowStatus = 0
							and IsNull(tlbTesting.blnReadOnly, 0) <> 1
							and IsNull(tlbTesting.blnNonLaboratoryTest, 0) = 0
				group by	m.idfMaterial
			) Tests 
on			Tests.idfMaterial = tlbMaterial.idfMaterial

left join	tlbTransferOutMaterial tOut_M
on			tOut_M.idfMaterial = tlbMaterial.idfMaterial

where		
		tlbMaterial.blnShowInAccessionInForm = 1 
		and tOut_M.idfMaterial is null -- doesn't include transferred materials
        and (tlbMaterial.idfHumanCase=@CaseID 
				OR tlbMaterial.idfVetCase=@CaseID
				or tlbMaterial.idfMonitoringSession=@CaseID
				or tlbMaterial.idfVectorSurveillanceSession = @CaseID)

-- returns animals
select		Animal.idfParty,
			Animal.idfSpecies,
			Animal.idfAnimal,
			Animal.strAnimalCode,
			Animal.SpeciesName as strSpecies,
			Animal.idfsSpeciesType,
			Gender.name as strGender,
			IsNull(Animal.idfCase, Animal.idfMonitoringSession) as ParentID,
			IsNull(Tests.TestsCount, 0) as strTests	

from		fnAnimalList(@LangID) Animal
left join	fnReference(@LangID,19000007) Gender
on			Gender.idfsReference=Animal.idfsAnimalGender
left join	(	select		COALESCE(m.idfHumanCase, m.idfVetCase, m.idfMonitoringSession) as idfParentID, m.idfAnimal, COUNT(*) as TestsCount
				from		tlbTesting
				inner join	tlbMaterial m
				on			m.idfMaterial = tlbTesting.idfMaterial
							and m.intRowStatus = 0
							and IsNull(m.blnReadOnly, 0) <> 1
							and m.idfAnimal is not null
				where		tlbTesting.intRowStatus = 0
							and IsNull(tlbTesting.blnReadOnly, 0) <> 1
							and IsNull(tlbTesting.blnNonLaboratoryTest, 0) = 0
				group by	COALESCE(m.idfHumanCase, m.idfVetCase, m.idfMonitoringSession), m.idfAnimal
			) Tests 
on			Tests.idfAnimal = Animal.idfAnimal
			and Tests.idfParentID = IsNull(Animal.idfCase, Animal.idfMonitoringSession)

where		Animal.idfCase=@CaseID or Animal.idfMonitoringSession=@CaseID

--return antibiotics information

select
		tlbAntimicrobialTherapy.idfAntimicrobialTherapy,
		tlbAntimicrobialTherapy.strAntimicrobialTherapyName,
		tlbAntimicrobialTherapy.idfHumanCase
from	tlbAntimicrobialTherapy
where	tlbAntimicrobialTherapy.idfHumanCase=@CaseID and tlbAntimicrobialTherapy.intRowStatus=0

-- returns vectors
select		v.idfVector as idfParty,
			v.idfVector,
			v.idfsVectorType,
			v.strVectorID,
			vt.[name] as strVectorType,
			vst.[name] as strVectorSpecies,
			v.idfVectorSurveillanceSession as ParentID,
			IsNull(Tests.TestsCount, 0) as strTests,
			left(
				IsNull	(
					cast((	select		IsNull(N'idfsReference = ' + cast(st_for_vt.idfsSampleType as nvarchar(20)) + N' or ', N'')
							from		trtSampleTypeForVectorType st_for_vt
							left join	fnReference(@LangID, 19000087) st	-- Sample Type
							on			st.idfsReference = st_for_vt.idfsSampleType
							where		st_for_vt.intRowStatus = 0
										and st_for_vt.idfsVectorType = v.idfsVectorType
							for xml path('') 
						) as nvarchar(MAX)),
					N''
						),
					IsNull	(
						(	select		sum(len(IsNull(cast(st_for_vt.idfsSampleType as nvarchar(20)), N'')) + 20)
							from		trtSampleTypeForVectorType st_for_vt
							left join	fnReference(@LangID, 19000087) st	-- Sample Type
							on			st.idfsReference = st_for_vt.idfsSampleType
							where		st_for_vt.intRowStatus = 0
										and st_for_vt.idfsVectorType = v.idfsVectorType
						) - 3,
						0
							)
				) as SampleFilter
from		tlbVector v
inner join	fnReference(@LangID, 19000140)	vt	-- Vector Type
on			vt.idfsReference = v.idfsVectorType
inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
on			vst.idfsReference = v.idfsVectorSubType
left join	(	select		m.idfVectorSurveillanceSession, m.idfVector, COUNT(*) as TestsCount
				from		tlbTesting
				inner join	tlbMaterial m
				on			m.idfMaterial = tlbTesting.idfMaterial
							and m.intRowStatus = 0
							and IsNull(m.blnReadOnly, 0) <> 1
							and m.idfVector is not null
				where		tlbTesting.intRowStatus = 0
							and IsNull(tlbTesting.blnReadOnly, 0) <> 1
							and IsNull(tlbTesting.blnNonLaboratoryTest, 0) = 0
				group by	m.idfVectorSurveillanceSession, m.idfVector
			) Tests 
on			Tests.idfVector = v.idfVector
			and Tests.idfVectorSurveillanceSession = v.idfVectorSurveillanceSession

where		v.idfVectorSurveillanceSession=@CaseID

-- returns diagnosis
exec spCase_DiagnosisList @CaseID, @LangID

--Return sample->vector type matrix for vs accession
	SELECT DISTINCT
		sv.idfSampleTypeForVectorType,
		sv.idfsSampleType,
		sv.idfsVectorType
	FROM trtSampleTypeForVectorType sv
	inner join tlbVector v 
	on			sv.idfsVectorType = v.idfsVectorType
	where		v.idfVectorSurveillanceSession = @CaseID
				AND v.intRowStatus = 0
				AND sv.intRowStatus = 0
			


END



