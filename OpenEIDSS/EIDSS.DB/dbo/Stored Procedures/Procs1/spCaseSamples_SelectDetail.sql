
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 21.06.2013

/*
exec spCaseSamples_SelectDetail '30bd2fe3-2bbe-4ade-988d-f2e1b8f56ba8', 'en'
exec spCaseSamples_SelectDetail 0, 'en'
*/

CREATE             PROCEDURE dbo.spCaseSamples_SelectDetail
	@idfCase as bigint,
	@LangID nvarchar(50)
AS

	select
				Material.idfMaterial,
				Material.idfsSampleType,
				Material.idfRootMaterial,
				COALESCE(Material.idfHuman, Material.idfSpecies, Material.idfAnimal, Material.idfVector) as idfParty,
				isnull(Animal.AnimalName,Species.name) as AnimalName,
				Animal.strAnimalCode,
				isnull(Animal.SpeciesName,Species.name) as SpeciesName,
				Animal.strFarmCode,
				isnull(Animal.idfsSpeciesType,tlbSpecies.idfsSpeciesType) as idfsSpeciesType,
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
				ISNULL(Material.idfHumanCase, Material.idfVetCase) AS idfCase,
				Material.idfMonitoringSession,
				Material.idfsBirdStatus,
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
				,Material.idfsSampleStatus
				,Material.idfSpecies
				,Material.idfAnimal
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
	left join	tlbSpecies
	on			Material.idfSpecies = tlbSpecies.idfSpecies
	left join	fnReferenceRepair(@LangID, 19000086) Species --Species list
	on			tlbSpecies.idfsSpeciesType  = Species.idfsReference

	
	where		(Material.idfHumanCase=@idfCase 
				OR Material.idfVetCase=@idfCase 
				or Material.idfMonitoringSession=@idfCase
				or Material.idfVectorSurveillanceSession = @idfCase)
				and Material.blnShowInCaseOrSession = 1
				and not (IsNull(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Material.idfsSampleStatus,0) = 10015002 or IsNull(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)



	SELECT
			idfVetCase,
			strSampleNotes
	FROM	tlbVetCase
	WHERE	idfVetCase=@idfCase

	SELECT 
				idfMaterialForDisease,
				idfsSampleType AS idfsReference,
				idfsDiagnosis,
				Names.name
	FROM		trtMaterialForDisease
	LEFT JOIN	fnReference(@LangID,19000087) Names--specimen Type
	ON			Names.idfsReference=trtMaterialForDisease.idfsSampleType
	WHERE		intRowStatus=0


	SELECT 
				idfSampleTypeForVectorType,
				idfsSampleType as idfsReference,
				idfsVectorType,
				Names.[name]
	FROM		trtSampleTypeForVectorType
	LEFT JOIN	fnReference(@LangID,19000087) Names--sample Type
	ON			Names.idfsReference=trtSampleTypeForVectorType.idfsSampleType
	WHERE		trtSampleTypeForVectorType.intRowStatus=0

