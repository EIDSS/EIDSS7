


/*
	exec spSpeciesVectorInfo_SelectLookup 51412830000000, 'en'
*/

create PROCEDURE dbo.spSpeciesVectorInfo_SelectLookup
	@idfCaseOrSession bigint,
	@LangID nvarchar(50)
AS
select * from
(
	Select		
		isnull(Animals.idfAnimal, tlbSpecies.idfSpecies) as idfSpeciesVectorInfo,
		tlbSpecies.idfSpecies,
		Animals.idfAnimal,
		CAST(null as bigint) as idfVector,
		tlbVetCase.idfVetCase as idfCaseOrSession,
		SpeciesName.name as SpeciesOrVectorType,
		Animals.strAnimalCode as AnimalOrVectorSpecies,
		SpeciesName.name + '/' + Animals.strAnimalCode as name,
		dbo.fnConcatFullName(HumanFromCase.strLastName,  HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName,
		FarmRegion.[name] as strRegion,
		FarmRayon.[name] as strRayon,
		cast(0 as int) as intRowStatus
	From	
		tlbVetCase with(nolock)
	INNER JOIN tlbHerd with(nolock) ON
		tlbHerd.idfFarm = tlbVetCase.idfFarm
	inner join tlbSpecies with(nolock) on
		tlbHerd.idfHerd = tlbSpecies.idfHerd
	inner join	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
		ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
	inner join tlbAnimal Animals with(nolock) 
		ON Animals.idfSpecies = tlbSpecies.idfSpecies
		AND Animals.intRowStatus = 0
	LEFT JOIN	tlbFarm  with(nolock)
	ON			tlbFarm.idfFarm = tlbVetCase.idfFarm			   
				AND tlbFarm.intRowStatus = 0
	left join	tlbHuman HumanFromCase  with(nolock)
	on			HumanFromCase.idfHuman = tlbFarm.idfHuman
	left join	tlbGeoLocation FarmAddress  with(nolock)
	on			tlbFarm.idfFarmAddress = FarmAddress.idfGeoLocation
	left join	fnGisReference(@LangID, 19000003) FarmRegion --'rftRegion'
	on			FarmRegion.idfsReference = FarmAddress.idfsRegion
	left join	fnGisReference(@LangID, 19000002) FarmRayon --'rftRayon'
	on			FarmRayon.idfsReference = FarmAddress.idfsRayon
	Where	
		tlbVetCase.intRowStatus = 0    
		and tlbVetCase.idfVetCase = @idfCaseOrSession
		--and tlbVetCase.idfsCaseType = 10012003 -- livestock
		and not idfAnimal is null
union all
	Select		
		tlbSpecies.idfSpecies as idfSpeciesVectorInfo,
		tlbSpecies.idfSpecies,
		CAST(null as bigint) as idfAnimal,
		CAST(null as bigint) as idfVector,
		tlbVetCase.idfVetCase as idfCaseOrSession,
		SpeciesName.name as SpeciesOrVectorType,
		null as AnimalOrVectorSpecies,
		SpeciesName.name as name,
		dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName,
		FarmRegion.[name] as strRegion,
		FarmRayon.[name] as strRayon,
		cast(0 as int) as intRowStatus
	From	
		tlbVetCase with(nolock)
	INNER JOIN tlbHerd with(nolock) ON
		tlbHerd.idfFarm = tlbVetCase.idfFarm
	inner join tlbSpecies with(nolock) on
		tlbHerd.idfHerd = tlbSpecies.idfHerd
	inner join	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
		ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
	LEFT JOIN	tlbFarm  with(nolock)
	ON			tlbFarm.idfFarm = tlbVetCase.idfFarm			   
				AND tlbFarm.intRowStatus = 0
	left join	tlbHuman HumanFromCase with(nolock)
	on			HumanFromCase.idfHuman = tlbFarm.idfHuman
	left join	tlbGeoLocation FarmAddress with(nolock)
	on			tlbFarm.idfFarmAddress = FarmAddress.idfGeoLocation
	left join	fnGisReference(@LangID, 19000003) FarmRegion --'rftRegion'
	on			FarmRegion.idfsReference = FarmAddress.idfsRegion
	left join	fnGisReference(@LangID, 19000002) FarmRayon --'rftRayon'
	on			FarmRayon.idfsReference = FarmAddress.idfsRayon
	Where	
		tlbVetCase.intRowStatus = 0    
		and tlbVetCase.idfVetCase = @idfCaseOrSession
		and tlbVetCase.idfsCaseType = 10012004 -- avian
union all
	Select		
		isnull(Animals.idfAnimal, tlbSpecies.idfSpecies) as idfSpeciesVectorInfo,
		tlbSpecies.idfSpecies,
		Animals.idfAnimal,
		null,
		tlbMonitoringSession.idfMonitoringSession as idfCaseOrSession,
		SpeciesName.name,
		Animals.strAnimalCode,
		SpeciesName.name + '/' + Animals.strAnimalCode as name,
		dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName,
		FarmRegion.[name] as strRegion,
		FarmRayon.[name] as strRayon,
		cast(0 as int) as intRowStatus
	From	
		dbo.tlbMonitoringSession with(nolock)
	INNER JOIN tlbFarm with(nolock) ON
		tlbFarm.idfMonitoringSession = tlbMonitoringSession.idfMonitoringSession
	INNER JOIN tlbHerd with(nolock) ON
		tlbHerd.idfFarm = tlbFarm.idfFarm
	inner join tlbSpecies with(nolock) on
		tlbSpecies.idfHerd = tlbHerd.idfHerd
	inner join	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
		ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
	inner join tlbAnimal Animals with(nolock) 
		ON Animals.idfSpecies = tlbSpecies.idfSpecies
		AND Animals.intRowStatus = 0
	left join	tlbHuman HumanFromCase with(nolock)
	on			HumanFromCase.idfHuman = tlbFarm.idfHuman
	left join	tlbGeoLocation FarmAddress with(nolock)
	on			tlbFarm.idfFarmAddress = FarmAddress.idfGeoLocation
	left join	fnGisReference(@LangID, 19000003) FarmRegion --'rftRegion'
	on			FarmRegion.idfsReference = FarmAddress.idfsRegion
	left join	fnGisReference(@LangID, 19000002) FarmRayon --'rftRayon'
	on			FarmRayon.idfsReference = FarmAddress.idfsRayon
	Where	
		tlbMonitoringSession.intRowStatus = 0    
		and tlbMonitoringSession.idfMonitoringSession = @idfCaseOrSession
		and not idfAnimal is null
union all
	Select		
		tlbVector.idfVector as idfSpeciesVectorInfo,
		null,
		null,
		tlbVector.idfVector,
		tlbVectorSurveillanceSession.idfVectorSurveillanceSession as idfCaseOrSession,
		VectorType.name,
		VectorSubType.name,
		VectorType.name + '/' + VectorSubType.name as name,
		'' as HumanName,
		VectorRegion.[name] as strRegion,
		VectorRayon.[name] as strRayon,
		cast(0 as int) as intRowStatus
	From	
		dbo.tlbVectorSurveillanceSession with(nolock)
	INNER JOIN dbo.tlbVector with(nolock) ON
		tlbVector.idfVectorSurveillanceSession = tlbVectorSurveillanceSession.idfVectorSurveillanceSession
	LEFT JOIN		dbo.fnReference(@LangID,19000140) VectorType 	ON			
		VectorType.idfsReference = tlbVector.idfsVectorType
	LEFT JOIN		dbo.fnReference(@LangID,19000141) VectorSubType	ON			
		VectorSubType.idfsReference = tlbVector.idfsVectorSubType
	left join	tlbGeoLocation VectorAddress with(nolock)
	on			tlbVector.idfLocation = VectorAddress.idfGeoLocation
	left join	fnGisReference(@LangID, 19000003) VectorRegion --'rftRegion'
	on			VectorRegion.idfsReference = VectorAddress.idfsRegion
	left join	fnGisReference(@LangID, 19000002) VectorRayon --'rftRayon'
	on			VectorRayon.idfsReference = VectorAddress.idfsRayon
	Where	
		tlbVectorSurveillanceSession.intRowStatus = 0    
		and tlbVectorSurveillanceSession.idfVectorSurveillanceSession = @idfCaseOrSession
union all
	Select		
		tlbHumanCase.idfHumanCase as idfSpeciesVectorInfo,
		null,
		null,
		null,
		tlbHumanCase.idfHumanCase as idfCaseOrSession,
		null,
		null,
		dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as name,
		dbo.fnConcatFullName(HumanFromCase.strLastName, HumanFromCase.strFirstName, HumanFromCase.strSecondName) as HumanName,
		HumanRegion.[name] as strRegion,
		HumanRayon.[name] as strRayon,
		cast(0 as int) as intRowStatus
	From	
		dbo.tlbHumanCase with(nolock)
		inner join	tlbHuman HumanFromCase with(nolock)
		on			HumanFromCase.idfHuman = tlbHumanCase.idfHuman
		left join	tlbGeoLocation HumanAddress with(nolock)
		on			HumanFromCase.idfCurrentResidenceAddress = HumanAddress.idfGeoLocation
		left join	fnGisReference(@LangID, 19000003) HumanRegion --'rftRegion'
		on			HumanRegion.idfsReference = HumanAddress.idfsRegion
		left join	fnGisReference(@LangID, 19000002) HumanRayon --'rftRayon'
		on			HumanRayon.idfsReference = HumanAddress.idfsRayon
	Where	
		tlbHumanCase.intRowStatus = 0    
		and tlbHumanCase.idfHumanCase = @idfCaseOrSession
) i
where 
	idfCaseOrSession = @idfCaseOrSession

