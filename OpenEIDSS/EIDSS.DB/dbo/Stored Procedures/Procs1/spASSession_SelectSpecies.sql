
--##SUMMARY Selects all species data for AS session 

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSession_SelectSpecies 4584260000000, 'en'
*/

Create PROCEDURE [dbo].[spASSession_SelectSpecies]
	@idfMonitoringSession bigint
	,@idfFarm bigint = null
	,@LangID nvarchar(50)
AS


SELECT
	 tlbSpecies.idfSpecies
	,tlbFarm.idfFarm
	,tlbSpecies.idfsSpeciesType as idfsReference
	,Species.name as strSpeciesName
	,tlbHerd.strHerdCode
  FROM tlbMonitoringSessionSummary
INNER JOIN tlbFarm ON
	tlbFarm.idfFarm = tlbMonitoringSessionSummary.idfFarm
	AND tlbFarm.intRowStatus = 0
INNER JOIN tlbHerd ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbHerd.intRowStatus = 0
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	AND tlbSpecies.intRowStatus = 0
INNER JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpecies.idfsSpeciesType
	AND ISNULL(Species.intHACode,32) & 32 <>0
WHERE	tlbMonitoringSessionSummary.idfMonitoringSession = @idfMonitoringSession
		AND tlbMonitoringSessionSummary.intRowStatus = 0
UNION

SELECT
	 tlbSpecies.idfSpecies
	,tlbFarm.idfFarm
	,tlbSpecies.idfsSpeciesType as idfsReference
	,Species.name as strSpeciesName
	,tlbHerd.strHerdCode
FROM tlbFarm 
INNER JOIN tlbHerd ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbHerd.intRowStatus = 0
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	AND tlbSpecies.intRowStatus = 0
INNER JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpecies.idfsSpeciesType
	AND ISNULL(Species.intHACode,32) & 32 <>0
WHERE	tlbFarm.idfMonitoringSession = @idfMonitoringSession OR tlbFarm.idfFarm = @idfFarm
		AND tlbFarm.intRowStatus = 0
	

 

RETURN 0

RETURN 0
