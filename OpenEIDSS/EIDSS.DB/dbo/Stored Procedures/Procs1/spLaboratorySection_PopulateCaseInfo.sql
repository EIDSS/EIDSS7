


/*
--Example of procedure call:

EXECUTE spLaboratorySection_PopulateCaseInfo
   'HGETBTB0130002'
  ,'en'

*/


create PROCEDURE dbo.spLaboratorySection_PopulateCaseInfo
	@CaseSessionID AS NVARCHAR(50),  --##PARAM @CaseSessionID - case/session ID
	@LangID NVARCHAR(50)  --##PARAM @LangID - lanquage ID
as

select	
		cases.idfHumanCase,
		cases.idfVetCase,
		cases.idfMonitoringSession,
		cases.idfVectorSurveillanceSession,
		CASE 
			WHEN cases.idfHumanCase IS NOT NULL THEN 10012001
			WHEN cases.idfVectorSurveillanceSession IS NOT NULL THEN 10012006
			WHEN cases.idfMonitoringSession IS NOT NULL THEN 10012003
			ELSE cases.idfsVetCaseType
		END AS idfsCaseType,
		CAST(CASE 
			when	cases.idfHumanCase IS NOT NULL	-- Human
				then	2
			when	IsNull(cases.idfsVetCaseType, 0) = 10012003	-- Livestock
				then	32
			when	IsNull(cases.idfsVetCaseType, 0) = 10012004	-- Avian
				then	64
			when	cases.idfMonitoringSession is not null	-- Livestock	/*Active Surveillance*/
				then	32
			when	cases.idfVectorSurveillanceSession is not null	-- Vector
				then	128
			else		0
		END as int) AS intCaseHACode,

		tlbHumanCase.idfHumanCase as idfSpeciesVectorInfo,
		isnull(tlbHumanCase.idfHumanCase, isnull(tlbVetCase.idfVetCase, isnull(tlbMonitoringSession.idfMonitoringSession, tlbVectorSurveillanceSession.idfVectorSurveillanceSession))) as idfCaseOrSession,
		
		COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis) AS idfsDiagnosis,
		(CASE 
			WHEN tlbMonitoringSession.idfMonitoringSession IS NOT NULL THEN AsDiagnosis.name COLLATE DATABASE_DEFAULT 
			WHEN tlbVetCase.idfVetCase IS NOT NULL THEN ISNULL(VetDiagnosis.strDisplayDiagnosis,   tlbVetCase.strDefaultDisplayDiagnosis) COLLATE DATABASE_DEFAULT 
			ELSE Diagnosis.name COLLATE DATABASE_DEFAULT 
		END)  as DiagnosisName,

		tlbHumanCase.idfHuman as idfHuman,
		
		dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName, 
		ISNULL(FarmRegion.[name], HumanRegion.[name]) as strRegion,
		ISNULL(FarmRayon.[name], HumanRayon.[name]) as strRayon
	
		
from (
	select
		(select idfHumanCase from dbo.tlbHumanCase where tlbHumanCase.strCaseID = @CaseSessionID and tlbHumanCase.intRowStatus = 0)
			as idfHumanCase,
		(select idfVetCase from dbo.tlbVetCase where tlbVetCase.strCaseID = @CaseSessionID and tlbVetCase.intRowStatus = 0)
			as idfVetCase,
		(select idfsCaseType from dbo.tlbVetCase where tlbVetCase.strCaseID = @CaseSessionID and tlbVetCase.intRowStatus = 0)
			as idfsVetCaseType,
		(select idfMonitoringSession from dbo.tlbMonitoringSession where tlbMonitoringSession.strMonitoringSessionID = @CaseSessionID and tlbMonitoringSession.intRowStatus = 0)
			as idfMonitoringSession,
		(select idfVectorSurveillanceSession from dbo.tlbVectorSurveillanceSession where tlbVectorSurveillanceSession.strSessionID = @CaseSessionID and tlbVectorSurveillanceSession.intRowStatus = 0)
			as idfVectorSurveillanceSession
	) cases
		left join	tlbMonitoringSession
		on			tlbMonitoringSession.idfMonitoringSession=cases.idfMonitoringSession
		left join	tlbVetCase 
		on			tlbVetCase.idfVetCase = cases.idfVetCase
					AND tlbVetCase.intRowStatus = 0

		left join	tlbHumanCase
		on			tlbHumanCase.idfHumanCase = cases.idfHumanCase
					AND tlbHumanCase.intRowStatus = 0
					
		left join	tlbVectorSurveillanceSession
		on			tlbVectorSurveillanceSession.idfVectorSurveillanceSession = cases.idfVectorSurveillanceSession
		
		left join	fnReferenceRepair(@LangID, 19000019 ) Diagnosis 
		on			Diagnosis.idfsReference = COALESCE(tlbHumanCase.idfsFinalDiagnosis, tlbHumanCase.idfsTentativeDiagnosis, tlbVetCase.idfsShowDiagnosis)

		left join   dbo.tlbVetCaseDisplayDiagnosis VetDiagnosis  
		on tlbVetCase.idfVetCase = VetDiagnosis.idfVetCase AND VetDiagnosis.idfsLanguage = dbo.fnGetLanguageCode(@LangID)  

		left join 	dbo.vwAsSessionDiagnosis AsDiagnosis
		ON AsDiagnosis.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession and dbo.fnGetLanguageCode(@LangID) = AsDiagnosis.idfsLanguage

		LEFT JOIN	tlbFarm 
		ON			tlbFarm.idfFarm = tlbVetCase.idfFarm
					AND tlbFarm.intRowStatus = 0
		left join	tlbGeoLocation FarmAddress
		on			tlbFarm.idfFarmAddress = FarmAddress.idfGeoLocation
		left join	fnGisReference(@LangID, 19000003) FarmRegion --'rftRegion'
		on			FarmRegion.idfsReference = FarmAddress.idfsRegion
		left join	fnGisReference(@LangID, 19000002) FarmRayon --'rftRayon'
		on			FarmRayon.idfsReference = FarmAddress.idfsRayon

		left join	tlbHuman HumanFromCase
		on			HumanFromCase.idfHuman = tlbFarm.idfHuman or HumanFromCase.idfHuman = tlbHumanCase.idfHuman
		left join	tlbGeoLocation HumanAddress
		on			HumanFromCase.idfCurrentResidenceAddress = HumanAddress.idfGeoLocation
		left join	fnGisReference(@LangID, 19000003) HumanRegion --'rftRegion'
		on			HumanRegion.idfsReference = HumanAddress.idfsRegion
		left join	fnGisReference(@LangID, 19000002) HumanRayon --'rftRayon'
		on			HumanRayon.idfsReference = HumanAddress.idfsRayon

		/*LEFT JOIN	tlbAnimal 
		ON			tlbAnimal.idfAnimal = a.idfAnimal
		AND tlbAnimal.intRowStatus = 0
		LEFT JOIN tlbSpecies ON
		(
		tlbSpecies.idfSpecies = a.idfSpecies
		OR tlbSpecies.idfSpecies = tlbAnimal.idfSpecies
		)
		AND tlbSpecies.intRowStatus =0
		LEFT JOIN tlbHerd ON
		tlbHerd.idfHerd = tlbSpecies.idfHerd
		AND tlbHerd.intRowStatus = 0
		LEFT JOIN tlbFarm ON
		tlbFarm.idfFarm = tlbHerd.idfFarm
		AND tlbFarm.intRowStatus = 0
		*/
		--left join	tlbHuman HumanFromCase
		--on			HumanFromCase.idfHuman=tlbFarm.idfHuman or
		-- HumanFromCase.idfHuman=a.idfHuman

