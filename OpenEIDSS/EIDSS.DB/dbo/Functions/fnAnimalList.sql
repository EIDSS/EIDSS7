

/*
select * from fnAnimalList('en')
*/

--##SUMMARY Returns the list of species and possibly associated animals.

--##REMARKS Author: KLETKIN.
--##REMARKS Create date: 16.02.2010

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Zolotareva N. added idfObservation and idfsFormTemplate
--##REMARKS Date: 20.10.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 26.10.2011

--##RETURNS Doesn't use

CREATE FUNCTION [dbo].[fnAnimalList]
(	
	@LangID nvarchar(20)
)
RETURNS TABLE 
AS
RETURN 

SELECT		
	idfAnimal AS idfParty,
	tvc.idfVetCase AS idfCase,
	tf.idfMonitoringSession,
	tf.strFarmCode,
	tf.strNationalName,
	tf.idfHuman as idfFarmOwner,
	
	tlbAnimal.idfAnimal,
	tlbAnimal.strAnimalCode,
	tlbAnimal.idfsAnimalGender,
	tlbAnimal.idfsAnimalAge,
	tlbAnimal.idfsAnimalCondition,

	tlbSpecies.idfSpecies,
	tlbSpecies.idfsSpeciesType,
	SpeciesName.name AS SpeciesName,
	th.strHerdCode,

	tlbAnimal.strAnimalCode as AnimalName,
	obs.idfObservation,
	obs.idfsFormTemplate,
	th.idfFarm
FROM tlbAnimal
LEFT JOIN tlbObservation obs
ON tlbAnimal.idfObservation = obs.idfObservation
LEFT JOIN	tlbSpecies ON			
	tlbSpecies.idfSpecies=tlbAnimal.idfSpecies
	AND tlbSpecies.intRowStatus = 0
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
LEFT JOIN tlbHerd th ON
	th.idfHerd = tlbSpecies.idfHerd
	AND th.intRowStatus = 0
LEFT JOIN tlbFarm tf ON
	tf.idfFarm = th.idfFarm
	AND tf.intRowStatus = 0
LEFT JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
WHERE		tlbAnimal.intRowStatus = 0

UNION ALL

SELECT		
	tlbSpecies.idfSpecies AS idfParty,
	tvc.idfVetCase AS idfCase,
	tf.idfMonitoringSession,
	tf.strFarmCode,
	tf.strNationalName,
	tf.idfHuman as idfFarmOwner,
	
	NULL AS idfAnimal,
	NULL AS strAnimalCode,
	NULL AS idfsAnimalGender,
	NULL AS idfsAnimalAge,
	NULL AS idfsAnimalCondition,

	tlbSpecies.idfSpecies,
	tlbSpecies.idfsSpeciesType,
	SpeciesName.name as SpeciesName,
	th.strHerdCode,

	SpeciesName.name as AnimalName,
	obs.idfObservation,
	obs.idfsFormTemplate, 
	th.idfFarm
FROM tlbSpecies
LEFT JOIN tlbObservation obs
ON tlbSpecies.idfObservation = obs.idfObservation
LEFT JOIN	fnReferenceRepair(@LangID,19000086) SpeciesName --rftSpeciesList
ON			SpeciesName.idfsReference=tlbSpecies.idfsSpeciesType
LEFT JOIN tlbHerd th ON
	th.idfHerd = tlbSpecies.idfHerd
	AND th.intRowStatus = 0
LEFT JOIN tlbFarm tf ON
	tf.idfFarm = th.idfFarm
	AND tf.intRowStatus = 0
LEFT JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
WHERE tlbSpecies.intRowStatus = 0


