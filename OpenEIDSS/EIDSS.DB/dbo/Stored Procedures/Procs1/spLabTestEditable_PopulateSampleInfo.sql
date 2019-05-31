
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013	

--exec spLabTestEditable_PopulateSampleInfo 4753330000000, 'en'


CREATE PROCEDURE [dbo].[spLabTestEditable_PopulateSampleInfo](
	@idfMaterial as bigint,
	@LangID as nvarchar(50)
)
as

select
	Material.idfMaterial,
	Material.strBarcode,
	dbo.fnReferenceRepair.name AS strSampleName,
	Material.datFieldCollectionDate,
	dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName)
				as HumanName, 
	COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID) as SpeciesName,
	Animal.AnimalName,
	Animal.strAnimalCode,
	Vector.strVectorCode,
	tlbMonitoringSession.idfMonitoringSession,
	tlbMonitoringSession.strMonitoringSessionID,
	ISNULL(tlbHumanCase.idfHumanCase, tlbVetCase.idfVetCase) AS idfCase,
	ISNULL(tlbHumanCase.strCaseID, tlbVetCase.strCaseID) AS strCaseID,
	COALESCE (tlbMonitoringSession.strMonitoringSessionID, tlbVectorSurveillanceSession.strSessionID) as SessionID,
	Material.idfVectorSurveillanceSession,
	Department.name as DepartmentName,
	COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis) AS idfsDefaultDiagnosis,
	CASE WHEN(NOT Material.idfHuman IS NULL) THEN dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName)
	WHEN (NOT Material.idfSpecies IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)
	WHEN (NOT Material.idfAnimal IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)+ISNULL(N', '+ Animal.strAnimalCode,N'')
	WHEN (NOT Material.idfVector IS NULL) THEN COALESCE (Animal.SpeciesName, SpeciesName.name, vt.[name] + IsNull(N' ' + vst.[name], N'') + N', ' + tlbVector.strVectorID)
	ELSE N'' END as strPartyName,
		CASE WHEN NOT tlbMonitoringSession.strMonitoringSessionID IS NULL THEN 32  --Livestock
		WHEN NOT  tlbVectorSurveillanceSession.strSessionID IS NULL THEN 128 --Vector
		WHEN tlbHumanCase.idfHumanCase IS NOT NULL THEN 2 --Human
		WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012003 THEN 32 --Livestock
		WHEN ISNULL(tlbVetCase.idfsCaseType,0) = 10012004 THEN 64 --Avian
		ELSE 0 END as intHACode

from	tlbMaterial Material 
left join	dbo.fnReferenceRepair(@LangID,19000087) --rftSpecimenType
on			dbo.fnReferenceRepair.idfsReference = Material.idfsSampleType
left join	tlbMonitoringSession
on			tlbMonitoringSession.idfMonitoringSession = Material.idfMonitoringSession
left join	tlbVectorSurveillanceSession
on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = Material.idfVectorSurveillanceSession

left join	tlbHumanCase
on			tlbHumanCase.idfHumanCase = Material.idfHumanCase
left join	tlbVetCase
on			tlbVetCase.idfVetCase = Material.idfVetCase

left join	fnAnimalList(@LangID) Animal
on			Material.idfAnimal=Animal.idfParty
LEFT JOIN	tlbSpecies
ON			tlbSpecies.idfSpecies = Material.idfSpecies
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
left join	tlbHuman HumanFromCase
on			HumanFromCase.idfHuman=Animal.idfFarmOwner or
			HumanFromCase.idfHuman=tlbHumanCase.idfHuman
left join	tlbVector
	inner join	fnReference(@LangID, 19000140)	vt	-- Vector Type
	on			vt.idfsReference = tlbVector.idfsVectorType
	inner join	fnReference(@LangID, 19000141)	vst	-- Vector Sub Type
	on			vst.idfsReference = tlbVector.idfsVectorSubType
on			tlbVector.idfVector = Material.idfVector
			and tlbVector.intRowStatus = 0			
left join	fnDepartment(@LangID) Department
on			Department.idfDepartment = Material.idfInDepartment	
left join	fnVectorList(@LangID) Vector
on			Material.idfVector = Vector.idfVector
		
WHERE 	Material.idfMaterial = @idfMaterial
        and Material.intRowStatus = 0
        
        
EXEC spLabTestEditable_GetSampleDiagnosis @idfMaterial, @LangID

