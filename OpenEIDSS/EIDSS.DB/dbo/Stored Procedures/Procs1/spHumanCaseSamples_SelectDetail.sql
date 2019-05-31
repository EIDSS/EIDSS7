

--##SUMMARY Load list of tests required for Samples panel in Human Case
--##SUMMARY This procedure load only part of information.
--##SUMMARY Information about materials loaded using spCaseSamples_SelectDetail

--##REMARKS Author: Kletkin
--##REMARKS Create date: 9.02.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

--##RETURNS list of tests associated with samples from specified case

-- exec [dbo].[spHumanCaseSamples_SelectDetail] 0, 'en'
CREATE PROCEDURE [dbo].[spHumanCaseSamples_SelectDetail]
	@idfCase AS bigint,
	@LangID NVARCHAR(50)
AS

select
				Material.idfMaterial,
				Material.idfsSampleType,
				Material.idfRootMaterial,
				COALESCE(Material.idfHuman, Material.idfSpecies, Material.idfAnimal, Material.idfVector) as idfParty,
				Animal.AnimalName,
				Animal.strAnimalCode,
				Animal.SpeciesName,
				Animal.strFarmCode,
				Animal.idfsSpeciesType,
				Material.idfFieldCollectedByPerson,
				dbo.fnConcatFullName(Person.strFamilyName, Person.strFirstName, Person.strSecondName) as strFieldCollectedByPerson,
				Material.idfFieldCollectedByOffice,
				Office.[name] as strFieldCollectedByOffice,
				Material.idfSendToOffice,
				OfficeSendTo.[name] as strSendToOffice,
				Material.idfMainTest,
				Material.datFieldCollectionDate,
				Material.datFieldSentDate,
				Material.strFieldBarcode,
				Material.idfHumanCase AS idfCase,
				Material.idfMonitoringSession,
				SampleType.name as strSampleName,
				--tlbAccessionIN.idfsSite,
				Material.datAccession,
				Material.strCondition,
				Material.idfsAccessionCondition,
				Material.idfAccesionByPerson,
				Material.blnAccessioned as Used
				,Material.idfVectorSurveillanceSession
				,Material.idfVector
				,Material.strNote
				,Vector.idfsVectorType
				,Vector.idfsVectorSubType
				,Vector.intQuantity
				,Vector.datCollectionDateTime
				,Vector.idfLocation
				,Material.strBarcode
				,Vector.strVectorID
				,vt.[name] as strVectorType
				,vst.[name] as strVectorSpecies
				,cast(null as bigint)as idfsTestName
		                ,cast(null as bigint)as idfsTestResult
		                ,cast(null as datetime) as datPerformedDate
			        ,CASE WHEN Material.idfsSampleType = 10320001/*unknown*/ THEN 1 ELSE 0 END AS intOrder
			        ,Material.idfsSampleStatus
				,convert(uniqueidentifier, Material.strReservedAttribute) as uidOfflineCaseID

	from	tlbMaterial as	Material 

	left join	dbo.fnReferenceRepair(@LangID,19000087) SampleType
	on			SampleType.idfsReference = Material.idfsSampleType
	
	left join	dbo.tlbVector Vector
		inner join	fnReference(@LangID, 19000140)	vt	-- Vector Type
		on			vt.idfsReference = Vector.idfsVectorType
		inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
		on			vst.idfsReference = Vector.idfsVectorSubType	 
	on			Material.idfVector = Vector.idfVector
	left join	tlbPerson as Person
	on			Person.idfPerson = Material.idfFieldCollectedByPerson
	left join	dbo.fnInstitution(@LangID) as Office
	on			Office.idfOffice = Material.idfFieldCollectedByOffice
	left join	dbo.fnInstitution(@LangID) as OfficeSendTo
	on			OfficeSendTo.idfOffice = Material.idfSendToOffice
	left join	fnAnimalList(@LangID) Animal
	on			Material.idfAnimal = Animal.idfParty

	where		Material.idfHumanCase=@idfCase
				and Material.blnShowInCaseOrSession = 1
				and not (IsNull(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Material.idfsSampleStatus,0) = 10015002 or IsNull(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)



select		
      Tests.idfTesting,
			Tests.idfsTestName,
			TestName.name as TestName,
			Material.idfMaterial,
			Material.idfRootMaterial,
			Tests.idfsTestResult,
			TestResult.name as TestResult,
			isnull(Tests.datConcludedDate,tlbBatchTest.datValidatedDate) as datPerformedDate

from		tlbTesting Tests

inner join	tlbMaterial as Material
on			Material.idfMaterial = Tests.idfMaterial
        and Material.intRowStatus = 0

inner join	dbo.fnReferenceRepair(@LangID, 19000097 ) TestName --rftTestName
on			TestName.idfsReference = Tests.idfsTestName

left join	fnReferenceRepair(@LangID, 19000096 ) TestResult --rftTestResult
on			TestResult.idfsReference = Tests.idfsTestResult

left join	tlbBatchTest
on			Tests.idfBatchTest = tlbBatchTest.idfBatchTest

where	Material.idfHumanCase = @idfCase and
		  Tests.idfsTestStatus in (10001001, 10001006) and --completed or amended
		  Tests.intRowStatus = 0


select
		idfVetCase as idfVetCase,
		strSampleNotes
from	tlbVetCase
where	idfVetCase=@idfCase
UNION ALL
select
		idfHumanCase as idfVetCase,
		strSampleNotes
from	tlbHumanCase
where	idfHumanCase=@idfCase

SELECT 
				idfMaterialForDisease,
				idfsSampleType AS idfsReference,
				idfsDiagnosis,
				Names.name
	FROM		trtMaterialForDisease
	LEFT JOIN	fnReference(@LangID,19000087) Names--specimen Type
	ON			Names.idfsReference=trtMaterialForDisease.idfsSampleType
	WHERE		intRowStatus=0

