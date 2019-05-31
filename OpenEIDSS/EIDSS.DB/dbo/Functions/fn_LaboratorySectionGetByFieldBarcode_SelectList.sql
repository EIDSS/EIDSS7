

create	function	[dbo].[fn_LaboratorySectionGetByFieldBarcode_SelectList]
(
	@LangID as nvarchar(50) --##PARAM @LangID  - language ID
)
returns table
as
return
select 
	--smp.idfMaterial as ID,
	--cast(null as bigint) as idfTesting,
	smp.idfMaterial,
	/*isnull(smp.idfHumanCase, isnull(smp.idfVector, isnull(smp.idfAnimal, smp.idfSpecies))) as idfSpeciesVectorInfo,
	isnull(smp.idfHumanCase, isnull(smp.idfVetCase, isnull(smp.idfMonitoringSession, smp.idfVectorSurveillanceSession))) as idfCaseOrSession,
	isnull(smp.idfsSampleStatus,-1) as idfsSampleStatus,
	smp.idfsSampleType,
	
	smp.idfsShowDiagnosis as idfsDiagnosis,
	smp.DiagnosisName as strDiagnosisName,
	smp.idfRootMaterial,	
	smp.idfParentMaterial,
	smp.strParentMaterial,
	smp.idfHuman,
	smp.idfSpecies,
	smp.idfAnimal,
	smp.idfHumanCase,
	smp.idfVetCase,
	smp.idfMonitoringSession,
	smp.idfMainTest,
	smp.idfVectorSurveillanceSession,
	smp.idfVector,
	smp.idfDestroyedByPerson,
	smp.strBarcode,*/
	smp.strFieldBarcode,
	smp.datFieldCollectionDate,
	/*smp.datFieldSentDate,*/
	smp.strCalculatedCaseID, 
	smp.strCalculatedHumanName, 
	/*smp.idfAccesionByPerson,
	smp.idfsAccessionCondition,
	smp.datAccession,
	smp.datEnteringDate,
	smp.datDestructionDate,*/
	smp.idfSendToOffice,
	smp.strSendToOrganization,
	/*smp.idfSubdivision,
	smp.idfInDepartment,
	smp.idfsCaseType,
	smp.intCaseHACode,
	smp.idfFieldCollectedByOffice,
	smp.idfFieldCollectedByPerson,
	smp.idfsDestructionMethod,
	smp.strSampleNote,
	smp.idfsSampleKind,
	smp.intTestCount,*/

	st.[name] as strSampleName,
	/*act.[name] as strSampleConditionReceivedStatus,*/

	smp.strCalculatedHumanName as HumanName/*, 
	CASE WHEN smp.idfHumanCase IS NOT NULL THEN smp.strCalculatedHumanName ELSE NULL END as strPatientName,
	CASE WHEN smp.idfHumanCase IS NULL THEN smp.strCalculatedHumanName ELSE NULL END as strFarmOwner,
	smp.idfsCountry,
	smp.idfsRegion,
	CAST('' as nvarchar(64)) as strRegion,
	smp.idfsRayon,
	CAST('' as nvarchar(64)) as strRayon,
	smp.idfsSettlement,

	ISNULL(CAST(-1 as bigint),0) AS idfsLaboratorySection
	*/
	
from (
	select 
		tlbMaterial.idfMaterial,
		/*tlbMaterial.idfRootMaterial,
		tlbMaterial.idfParentMaterial,
		tlbMaterialParent.strBarcode as strParentMaterial,
		tlbMaterial.idfHuman,
		tlbMaterial.idfSpecies,
		tlbMaterial.idfAnimal,
		tlbMaterial.idfHumanCase,
		tlbMaterial.idfVetCase,
		tlbMaterial.idfMonitoringSession,
		tlbMaterial.idfMainTest,
		tlbMaterial.idfVectorSurveillanceSession,
		tlbMaterial.idfVector,
		tlbMaterial.idfDestroyedByPerson,
		tlbMaterial.idfsSampleStatus,
		tlbMaterial.idfsAccessionCondition,*/
		tlbMaterial.idfsSampleType,
		/*tlbMaterial.strBarcode,*/
		tlbMaterial.strFieldBarcode,
		tlbMaterial.strCalculatedCaseID,
		tlbMaterial.strCalculatedHumanName,
		tlbMaterial.datFieldCollectionDate,
		/*tlbMaterial.datFieldSentDate,
		tlbMaterial.datAccession,
		tlbMaterial.datEnteringDate,
		tlbMaterial.datDestructionDate,
		tlbMaterial.idfAccesionByPerson,*/
		tlbMaterial.idfSendToOffice,
		OfficeSendTo.[name] as strSendToOrganization/*,
		tlbMaterial.idfSubdivision,
		tlbMaterial.idfInDepartment,
		tlbMaterial.idfFieldCollectedByOffice,
		tlbMaterial.idfFieldCollectedByPerson,
		tlbMaterial.idfsDestructionMethod,
		tlbMaterial.strNote as strSampleNote,
		tlbMaterial.idfsSampleKind,
		--cast((select COUNT(*) from tlbTesting where tlbTesting.idfMaterial = tlbMaterial.idfMaterial and tlbTesting.intRowStatus = 0) as int)
		--	AS intTestCount,
		cast(0 as int) AS intTestCount,
			
		CASE 
			WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 10012001
			WHEN tlbVectorSurveillanceSession.idfVectorSurveillanceSession IS NOT NULL THEN 10012006
			WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN 10012003
			ELSE tlbVetCase.idfsCaseType
		END AS idfsCaseType,

		CAST(CASE 
			when	tlbHumanCase.idfHumanCase IS NOT NULL	-- Human
				then	2
			when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012003	-- Livestock
				then	32
			when	IsNull(tlbVetCase.idfsCaseType, 0) = 10012004	-- Avian
				then	64
			when	tlbMonitoringSession.idfMonitoringSession is not null	-- Livestock	/*Active Surveillance*/
				then	32
			when	tlbVectorSurveillanceSession.idfVectorSurveillanceSession is not null	-- Vector
				then	128
			else		0
		END as int) AS intCaseHACode,
		
		COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) AS idfsShowDiagnosis,
		(CASE 
			WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN ''/*AsDiagnosis.name*/ COLLATE DATABASE_DEFAULT 
			WHEN tlbVetCase.idfVetCase IS NOT NULL THEN ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) COLLATE DATABASE_DEFAULT 
			ELSE Diagnosis.name COLLATE DATABASE_DEFAULT 
		END)  as DiagnosisName,

		tlbGeoLocation.idfsCountry,
		tlbGeoLocation.idfsRegion,
		tlbGeoLocation.idfsRayon,
		tlbGeoLocation.idfsSettlement*/
		
		
	from tlbMaterial
		/*left join	tlbMonitoringSession
		on			tlbMonitoringSession.idfMonitoringSession=tlbMaterial.idfMonitoringSession
		left join	tlbVetCase 
		on			tlbVetCase.idfVetCase = tlbMaterial.idfVetCase
					AND tlbVetCase.intRowStatus = 0
		left join	tlbHumanCase
		on			tlbHumanCase.idfHumanCase = tlbMaterial.idfHumanCase
					AND tlbHumanCase.intRowStatus = 0
		left join	tlbHuman HumanFromCase
		on			HumanFromCase.idfHuman = tlbHumanCase.idfHuman
					
		left join	tlbVectorSurveillanceSession
		on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = tlbMaterial.idfVectorSurveillanceSession
		left join	tlbVector
			inner join	fnReferenceRepair(@LangID, 19000140)	vt	-- Vector Type
			on			vt.idfsReference = tlbVector.idfsVectorType
			inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
			on			vst.idfsReference = tlbVector.idfsVectorSubType
		on			tlbVector.idfVector = tlbMaterial.idfVector
					and tlbVector.intRowStatus = 0
		
		--left join	fnAnimalList(@LangID) Animal
		--on			tlbMaterial.idfAnimal = Animal.idfParty
		--left join	tlbSpecies
		--ON			tlbSpecies.idfSpecies = tlbMaterial.idfSpecies
		
		left join	tlbAnimal
		on			tlbMaterial.idfAnimal = tlbAnimal.idfAnimal
		left join	tlbSpecies
		ON			tlbSpecies.idfSpecies = isnull(tlbMaterial.idfSpecies, tlbAnimal.idfSpecies)
		left join	tlbHerd
		on			tlbHerd.idfHerd = tlbSpecies.idfHerd
					AND tlbHerd.intRowStatus = 0
		LEFT JOIN	tlbFarm 
		ON			tlbFarm.idfFarm = tlbHerd.idfFarm			   
					AND tlbFarm.intRowStatus = 0
		left join	tlbGeoLocation
		on			isnull(HumanFromCase.idfCurrentResidenceAddress, tlbFarm.idfFarmAddress) = tlbGeoLocation.idfGeoLocation
		
		left join	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
		ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
		
		left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis 
		on			Diagnosis.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis)

		left join   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
		on tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  

		--left join 	dbo.vwAsSessionDiagnosis AsDiagnosis
		--ON AsDiagnosis.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession and dbo.fnGetLanguageCode(@LangID) = AsDiagnosis.idfsLanguage

		left join	tlbMaterial tlbMaterialParent
		ON			tlbMaterial.idfParentMaterial = tlbMaterialParent.idfMaterial
		*/
		left join	dbo.fnInstitution(@LangID) as OfficeSendTo
		on			OfficeSendTo.idfOffice = tlbMaterial.idfSendToOffice
		
			where
		tlbMaterial.intRowStatus = 0
		--and tlbMaterial.strFieldBarcode = @strFieldBarcode
		--and isnull(tlbMaterial.idfSendToOffice,0) = isnull(nullif(@idfSendToOffice,0), isnull(tlbMaterial.idfSendToOffice,0))
		and isnull(tlbMaterial.idfsSampleStatus,0) = 0 -- not accessioned
		and isnull(tlbMaterial.idfsAccessionCondition,0) = 0 -- not accessioned
	) smp
	
/*
left join	fnReference(@LangID, 19000110)	act	-- Accession Condition
on			act.idfsReference = smp.idfsAccessionCondition
*/
inner join	dbo.fnReferenceRepair(@LangID,19000087) st --rftSampleType
on			st.idfsReference = smp.idfsSampleType


