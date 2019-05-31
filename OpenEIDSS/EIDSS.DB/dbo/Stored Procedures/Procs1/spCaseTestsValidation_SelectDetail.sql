

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 18.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 24.04.2013

CREATE PROCEDURE [dbo].[spCaseTestsValidation_SelectDetail]
	@idfCase AS bigint,
	@LangID NVARCHAR(50)
AS


select
			tlbTestValidation.idfTestValidation,
			tlbTesting.idfTesting,

			Diagnosis.name as DiagnosisName,
			TestName.name as TestName,
			TestType.name as TestType,
			RuleInOut.name as RuleInOutName,
			
			Validated.strFirstName + ' ' + Validated.strFamilyName as ValidatedName,
			Interpreted.strFirstName + ' ' + Interpreted.strFamilyName as InterpretedName,

			tlbTestValidation.idfsDiagnosis,

			tlbTestValidation.blnValidateStatus,
			tlbTestValidation.idfValidatedByPerson,
			tlbTestValidation.strValidateComment,
			tlbTestValidation.datValidationDate,
			
			tlbTestValidation.idfsInterpretedStatus,
			tlbTestValidation.idfInterpretedByPerson,
			tlbTestValidation.strInterpretedComment,
			tlbTestValidation.datInterpretationDate,
			
			COALESCE(Material.idfHumanCase, Material.idfVetCase, Material.idfMonitoringSession,0) as idfCase,
			
			ISNULL(Animal.AnimalName, Species.[name]) as AnimalID,
			Species.[name] as Species,
			Animal.strFarmCode,
			tlbTestValidation.blnCaseCreated,
			
			Material.strBarcode,
			Material.strFieldBarcode as strFieldBarcode,
			Material.strFieldBarcode as strFieldBarcode2,
			SampleType.name as strSampleName
			

from		tlbTestValidation
inner join	tlbTesting
on			tlbTesting.idfTesting=tlbTestValidation.idfTesting and 
			tlbTesting.intRowStatus=0 and
			tlbTestValidation.intRowStatus=0
inner join	tlbMaterial Material
on			tlbTesting.idfMaterial = Material.idfMaterial and 
        tlbTesting.intRowStatus = 0 and
        Material.intRowStatus = 0
left join	fnReference(@LangID, 19000087) SampleType --rftSampleType
on			SampleType.idfsReference = Material.idfsSampleType

/*inner join	tlbBatchTest
on			tlbBatchTest.idfBatchTest=tlbTesting.idfBatchTest and
			tlbBatchTest.idfsBatchStatus=10001001 and
			tlbTesting.intRowStatus=0 and
			tlbBatchTest.intRowStatus=0*/
left join	tlbPerson Validated
on			tlbTestValidation.idfValidatedByPerson=Validated.idfPerson
left join	tlbPerson Interpreted
on			tlbTestValidation.idfInterpretedByPerson=Interpreted.idfPerson
left join	fnReference(@LangID,19000019) Diagnosis
on			tlbTestValidation.idfsDiagnosis=Diagnosis.idfsReference
left join	fnReference(@LangID,19000097) TestName
on			tlbTesting.idfsTestName=TestName.idfsReference
left join	fnReference(@LangID,19000095) TestType
on			tlbTesting.idfsTestCategory=TestType.idfsReference
left join	fnReference(@LangID,19000106) RuleInOut
on			tlbTestValidation.idfsInterpretedStatus=RuleInOut.idfsReference

left join	fnAnimalList(@LangID) Animal
on			Material.idfAnimal = Animal.idfParty
left join	tlbSpecies
on			Material.idfSpecies = tlbSpecies.idfSpecies
left join	fnReferenceRepair(@LangID, 19000086) Species --Species list
on			isnull(Animal.idfsSpeciesType,tlbSpecies.idfsSpeciesType) = Species.idfsReference

where		Material.idfHumanCase = @idfCase
			OR Material.idfVetCase = @idfCase
			OR Material.idfMonitoringSession = @idfCase



