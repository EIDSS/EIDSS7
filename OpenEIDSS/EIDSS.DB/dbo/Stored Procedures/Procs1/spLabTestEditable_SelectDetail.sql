
	
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--exec spLabTestEditable_SelectDetail 4753330000000, 'en'


CREATE PROCEDURE [dbo].[spLabTestEditable_SelectDetail](
	@idfTesting as bigint,
	@LangID as nvarchar(50)
)
as

-- Test info
select
	tst.idfTesting,
	tst.idfsTestStatus,
	tst.idfsTestName,
	tst.idfsTestResult,
	tst.idfsTestCategory,
	tst.idfsDiagnosis,
	tst.idfMaterial,
	tst.idfObservation,
	tst.strNote,
	tst.idfBatchTest,
	btc.strBarcode as BatchTestCode,
	ISNULL(tst.datStartedDate, btc.datPerformedDate) as datStartedDate,
	tst.idfPerformedByOffice,
	tst.datReceivedDate,
	tst.strContactPerson,
	ISNULL(tst.datConcludedDate, btc.datValidatedDate) as datConcludedDate,
	ISNULL(tst.idfTestedByOffice,btc.idfPerformedByOffice) as idfTestedByOffice,
	ISNULL(tst.idfTestedByPerson, btc.idfPerformedByPerson) as idfTestedByPerson,
	ISNULL(tst.idfResultEnteredByOffice,btc.idfPerformedByOffice) as idfResultEnteredByOffice,
	ISNULL(tst.idfResultEnteredByPerson,btc.idfPerformedByPerson) as idfResultEnteredByPerson,
	ISNULL(tst.idfValidatedByOffice, btc.idfValidatedByOffice) as idfValidatedByOffice,
	ISNULL(tst.idfValidatedByPerson, btc.idfValidatedByPerson) as idfValidatedByPerson,
	tlbMonitoringSession.idfMonitoringSession,
	tlbMonitoringSession.strMonitoringSessionID,
	ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
	CASE 
		WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
		ELSE tlbVetCase.idfsCaseType
	END AS idfsCaseType,
	ISNULL(tlbHumanCase.strCaseID, tlbVetCase.strCaseID) AS strCaseID,
	COALESCE (tlbMonitoringSession.strMonitoringSessionID, tlbVectorSurveillanceSession.strSessionID) as SessionID,
	Material.datAccession, --equals datAccession and more correct then dataAcession, because valid for aliquots/derivatives
	Material.idfVectorSurveillanceSession,
	Material.strBarcode,
	dbo.fnIsSampleTransferred(tst.idfMaterial) as blnSampleTransferred, 
	Department.name as DepartmentName,
	dbo.fnConcatFullName(pen.strFamilyName, pen.strFirstName, pen.strSecondName) as ResultEnteredByPerson,
	obs.idfsFormTemplate,
	tst.blnNonLaboratoryTest,
	tst.blnExternalTest,
	CASE WHEN NOT tlbMonitoringSession.strMonitoringSessionID IS NULL THEN 32  --Livestock
		WHEN NOT  tlbVectorSurveillanceSession.strSessionID IS NULL THEN 128 --Vector
		WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 2 --Human
		WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012003 THEN 32 --Livestock
		WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012004 THEN 64 --Avian
		ELSE 0 END as intHACode
from
	tlbTesting tst
inner join	tlbMaterial as Material
	on			Material.idfMaterial = tst.idfMaterial and
	        Material.intRowStatus = 0
left join	tlbMonitoringSession
on			tlbMonitoringSession.idfMonitoringSession = Material.idfMonitoringSession	
left join	tlbVectorSurveillanceSession
on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = Material.idfVectorSurveillanceSession

left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = Material.idfHumanCase
left join	tlbVetCase
on			tlbVetCase.idfVetCase = Material.idfVetCase

left join	fnDepartment(@LangID) Department
on			Department.idfDepartment = Material.idfInDepartment
	
left join	tlbBatchTest btc
	on			tst.idfBatchTest = btc.idfBatchTest
left join	tlbObservation obs
	on			obs.idfObservation = tst.idfObservation
left join	tlbPerson pen
	on			ISNULL(tst.idfResultEnteredByPerson,btc.idfPerformedByPerson) = pen.idfPerson
where		
	tst.intRowStatus=0
	and tst.idfTesting = @idfTesting

-- sample info
DECLARE @idfMaterial bigint
select
	Material.idfMaterial,
	Material.strBarcode,
	SpecimenType.name as strSampleName,
	Material.datFieldCollectionDate,
	Material.datAccession,
	isnull(SpeciesName.name, dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName)) as HumanName,
	--cnt.SpeciesName,
	Animal.AnimalName,
	Animal.strAnimalCode,
	Vector.strVectorCode,
	CASE WHEN(NOT Material.idfHuman IS NULL) THEN dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName)
	WHEN (NOT Material.idfSpecies IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)
	WHEN (NOT Material.idfAnimal IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)+ISNULL(N', '+ Animal.strAnimalCode,N'')
	WHEN (NOT Material.idfVector IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)
	ELSE N'' END as strPartyName,
	Material.idfsSite,
	Material.idfsCurrentSite

from
	tlbTesting tst
inner join	tlbMaterial Material
	on			Material.idfMaterial = tst.idfMaterial and
	        Material.intRowStatus = 0
left join	dbo.fnReferenceRepair(@LangID,19000087) SpecimenType
on			SpecimenType.idfsReference = Material.idfsSampleType	
left join	fnAnimalList(@LangID) Animal
on			Material.idfAnimal=Animal.idfParty
left join	fnVectorList(@LangID) Vector
on			Material.idfVector=Vector.idfVector	
left join	tlbVector
	inner join	fnReference(@LangID, 19000140)	vt	-- Vector Type
	on			vt.idfsReference = tlbVector.idfsVectorType
	inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
	on			vst.idfsReference = tlbVector.idfsVectorSubType
on			tlbVector.idfVector = Material.idfVector
			and tlbVector.intRowStatus = 0
LEFT JOIN	tlbSpecies
ON			tlbSpecies.idfSpecies = Material.idfSpecies
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = Material.idfHumanCase
left join	tlbHuman HumanFromCase
on			HumanFromCase.idfHuman=Animal.idfFarmOwner or
			HumanFromCase.idfHuman = tlbHumanCase.idfHuman
where		
	tst.intRowStatus=0
	and tst.idfTesting = @idfTesting

-- Amendment history	
EXECUTE spLabTestAmendmentHistory_SelectDetail @idfTesting, @LangID



