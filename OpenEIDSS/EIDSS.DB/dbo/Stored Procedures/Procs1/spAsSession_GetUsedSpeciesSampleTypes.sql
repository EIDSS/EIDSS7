
/*
exec spAsSession_GetUsedSpeciesSampleTypes 57118700000000
*/
CREATE PROCEDURE [dbo].[spAsSession_GetUsedSpeciesSampleTypes]
	@idfMonitoringSession bigint
AS
Select Distinct
		sp.idfsSpeciesType
		,cast(NULL as bigint) AS idfsSampleType
  FROM tlbMonitoringSession s
INNER JOIN tlbFarm f ON
	f.idfMonitoringSession = s.idfMonitoringSession
	AND f.intRowStatus = 0
INNER JOIN tlbHerd h ON
	h.idfFarm = f.idfFarm
	AND h.intRowStatus = 0
INNER JOIN tlbSpecies sp ON
	h.idfHerd = sp.idfHerd
	AND sp.intRowStatus = 0
INNER JOIN tlbAnimal a ON
	sp.idfSpecies=a.idfSpecies 
	and a.intRowStatus=0 
LEFT JOIN tlbMaterial Material
	on Material.idfAnimal = a.idfAnimal and Material.intRowStatus = 0
WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND s.intRowStatus = 0
		AND Material.idfMaterial IS NULL
		
UNION 

Select  DISTINCT
		sp.idfsSpeciesType
		,Material.idfsSampleType
  FROM tlbMonitoringSession s
INNER JOIN tlbFarm f ON
	f.idfMonitoringSession = s.idfMonitoringSession
	AND f.intRowStatus = 0
INNER JOIN tlbHerd h ON
	h.idfFarm = f.idfFarm
	AND h.intRowStatus = 0
INNER JOIN tlbSpecies sp ON
	h.idfHerd = sp.idfHerd
	AND sp.intRowStatus = 0
INNER JOIN tlbAnimal a ON
	sp.idfSpecies=a.idfSpecies 
	and a.intRowStatus=0 
INNER JOIN tlbMaterial Material ON
	Material.idfAnimal = a.idfAnimal and Material.intRowStatus = 0
WHERE	s.idfMonitoringSession = @idfMonitoringSession
		AND s.intRowStatus = 0
		AND Material.blnShowInCaseOrSession = 1
		and not (IsNull(Material.idfsSampleKind,0) = 12675420000000/*derivative*/ and (IsNull(Material.idfsSampleStatus,0) = 10015002 or IsNull(Material.idfsSampleStatus,0) = 10015008)/*deleted in lab module*/)
UNION 
Select  DISTINCT
		tlbSpecies.idfsSpeciesType
		,cast(NULL as bigint) AS idfsSampleType
  FROM tlbMonitoringSessionSummary
INNER JOIN tlbFarm ON tlbFarm.idfFarm = tlbMonitoringSessionSummary.idfFarm
		INNER JOIN tlbHerd ON
			tlbHerd.idfFarm = tlbFarm.idfFarm
			AND tlbHerd.intRowStatus = 0
		INNER JOIN tlbSpecies ON
			tlbHerd.idfHerd = tlbSpecies.idfHerd
			AND tlbSpecies.intRowStatus = 0
			AND tlbSpecies.idfSpecies = ISNULL(tlbMonitoringSessionSummary.idfSpecies, tlbSpecies.idfSpecies)
			AND tlbFarm.intRowStatus = 0
WHERE	tlbMonitoringSessionSummary.idfMonitoringSession = @idfMonitoringSession
		AND tlbMonitoringSessionSummary.intRowStatus = 0


RETURN 0

