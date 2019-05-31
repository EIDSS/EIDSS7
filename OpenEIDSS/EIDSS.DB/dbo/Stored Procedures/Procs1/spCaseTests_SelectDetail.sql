

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 18.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013


CREATE       PROCEDURE [dbo].[spCaseTests_SelectDetail]
	@idfCase AS bigint,
	@LangID NVARCHAR(50)
AS


select 
	tlbTesting.idfTesting,
	tlbTesting.idfObservation,
	obs.idfsFormTemplate,
	tlbTesting.idfsTestStatus,
	tlbTesting.idfsTestResult,
	tlbTesting.idfsTestCategory,
	Material.strBarcode,
	IsNull(Original.strFieldBarcode, Material.strFieldBarcode) as strFieldBarcode,
	IsNull(Original.strFieldBarcode, Material.strFieldBarcode) as strFieldBarcode2,
	IsNull(Original.datFieldCollectionDate, Material.datFieldCollectionDate) as datFieldCollectionDate,
	SampleType.name as strSampleName,
	tlbTesting.idfsTestName,
	TestName.name as TestName,
	TestCategory.name as TestCategoryName,
	tlbBatchTest.strBarcode as strBatchCode,
	isnull(tlbTesting.datConcludedDate,tlbBatchTest.datValidatedDate) as datPerformedDate,
	tlbBatchTest.datValidatedDate,
	--tlbBatchTest.idfsBatchStatus,
	TestResult.name as TestResult,
	ActivityStatus.name as TestStatus,
	Department.name as DepartmentName,
	ISNULL(Animal.AnimalName, Species.[name]) as AnimalName,
	Species.[name] as Species,
	Animal.strFarmCode,
	Animal.idfFarm,
	tlbTesting.idfsDiagnosis,
	isnull(tlbTesting.datStartedDate, tlbBatchTest.datPerformedDate) as datStartedDate,
	tlbTesting.datConcludedDate,
	Diagnosis.name as DiagnosisName,
	COALESCE(Material.idfHumanCase, Material.idfVetCase, Material.idfMonitoringSession) as idfCase,
	Material.idfMaterial,
	Material.datAccession,
	tlbTesting.blnNonLaboratoryTest,
	tlbTesting.blnReadOnly,
	tlbTesting.strNote,
	tlbTesting.idfTestedByOffice,
	tlbTesting.idfTestedByPerson,
	tlbTesting.idfResultEnteredByOffice,
	tlbTesting.idfResultEnteredByPerson,
	tlbTesting.idfValidatedByOffice,
	tlbTesting.idfValidatedByPerson,
	CONVERT(bigint, null) as idfMaterialHuman,
	CONVERT(bigint, null) as idfMaterialVet,
	CONVERT(bigint, null) as idfMaterialAsSession,
    CAST(CASE WHEN History.idfTesting IS NULL THEN 0 ELSE 1 END AS int) AS intHasAmendment,
	tlbTesting.blnExternalTest,
	tlbTesting.datReceivedDate,
	tlbTesting.idfPerformedByOffice,
	tlbTesting.strContactPerson,
	CONVERT(bit, NULL) as blnIsMainSampleTest
	
from		tlbTesting

inner join tlbMaterial Material
    left join	fnDepartment(@LangID) Department
    on			Department.idfDepartment = idfInDepartment
    left join	fnAnimalList(@LangID) Animal
    on			Material.idfAnimal = Animal.idfParty
    left join	tlbSpecies
    on			Material.idfSpecies = tlbSpecies.idfSpecies
	left join	fnReferenceRepair(@LangID, 19000086) Species --Species list
	on			isnull(Animal.idfsSpeciesType,tlbSpecies.idfsSpeciesType) = Species.idfsReference
on  tlbTesting.idfMaterial = Material.idfMaterial and 
    tlbTesting.intRowStatus = 0 and
    Material.intRowStatus = 0 
	and not (IsNull(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Material.idfsSampleStatus,0) = 10015002 or IsNull(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)

left join	tlbMaterial Original
on			Original.idfMaterial=Material.idfRootMaterial
			AND Original.intRowStatus = 0 and Material.blnShowInCaseOrSession = 0
left join	fnReference(@LangID, 19000087) SampleType --rftSampleType
on			SampleType.idfsReference = IsNull(Original.idfsSampleType, Material.idfsSampleType)
LEFT JOIN tlbObservation obs
ON tlbTesting.idfObservation = obs.idfObservation

left join	fnReference(@LangID,19000019) Diagnosis
on			tlbTesting.idfsDiagnosis=Diagnosis.idfsReference
left join	tlbBatchTest
on			tlbBatchTest.idfBatchTest=tlbTesting.idfBatchTest
left join	fnReference(@LangID,19000001) ActivityStatus 
on			tlbTesting.idfsTestStatus=ActivityStatus.idfsReference
left join	fnReference(@LangID,19000097) TestName
on			tlbTesting.idfsTestName=TestName.idfsReference
left join	fnReference(@LangID,19000096) TestResult 
on			tlbTesting.idfsTestResult=TestResult.idfsReference
left join	fnReference(@LangID,19000095) TestCategory
on			tlbTesting.idfsTestCategory=TestCategory.idfsReference

left join (
SELECT DISTINCT idfTesting FROM tlbTestAmendmentHistory where intRowStatus = 0) History 
on			tlbTesting.idfTesting = History.idfTesting 


WHERE		tlbTesting.intRowStatus = 0		
			AND (Material.idfHumanCase = @idfCase
			OR Material.idfVetCase = @idfCase
			OR Material.idfMonitoringSession = @idfCase)

exec spCaseTestsValidation_SelectDetail @idfCase, @LangID


