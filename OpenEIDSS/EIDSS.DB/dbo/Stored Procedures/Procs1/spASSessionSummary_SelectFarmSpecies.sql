
--##SUMMARY Selects data for AS session summary

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
EXEC spASSessionSummary_SelectFarmSpecies 4584260000000, 'en'
*/

create PROCEDURE [dbo].[spASSessionSummary_SelectFarmSpecies]
	@idfFarm bigint
	,@LangID nvarchar(50)
AS


SELECT
	 tlbSpecies.idfSpecies
	,tlbFarm.idfFarm
	,tlbSpecies.idfsSpeciesType as idfsReference
	,Species.name
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
WHERE	tlbFarm.idfFarm = @idfFarm
		AND tlbFarm.intRowStatus = 0
/*
UNION ALL
	
SELECT
	 tlbSpeciesActual.idfSpeciesActual as idfSpecies
	,tlbFarmActual.idfFarmActual as idfFarm
	,tlbSpeciesActual.idfsSpeciesType as idfsReference
	,Species.name
FROM tlbFarmActual 
INNER JOIN tlbHerdActual ON
	tlbHerdActual.idfFarmActual = tlbFarmActual.idfFarmActual
	AND tlbHerdActual.intRowStatus = 0
INNER JOIN tlbSpeciesActual ON
	tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
	AND tlbSpeciesActual.intRowStatus = 0
INNER JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpeciesActual.idfsSpeciesType
	AND ISNULL(Species.intHACode,32) & 32 <>0
WHERE	tlbFarmActual.idfFarmActual = @idfFarm
		AND tlbFarmActual.intRowStatus = 0
*/
 

RETURN 0
