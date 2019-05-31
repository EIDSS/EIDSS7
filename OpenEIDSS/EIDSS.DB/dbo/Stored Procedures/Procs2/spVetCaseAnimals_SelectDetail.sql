

--##SUMMARY Selects list of animals related with specific case.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 21.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Zolotareva N.
--##REMARKS Date: 14.07.2011

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @ID BIGINT 
SET @ID = 1
exec spVetCaseAnimals_SelectDetail @ID, 'en'
*/

CREATE            PROC	[dbo].[spVetCaseAnimals_SelectDetail]
		@idfCase	BIGINT  --##PARAM @idfCase - case ID for wich the animals are selected
		,@LangID		NVARCHAR(50)  --##PARAM @LangID - language ID
AS
-- 0 Animal
SELECT  	 
	tlbAnimal.idfAnimal,  
	tlbHerd.idfHerd, 
	tlbHerd.strHerdCode, 
	tvc.idfVetCase as idfCase,
	tlbAnimal.idfsAnimalAge,
	tlbAnimal.idfsAnimalGender, 
	tlbAnimal.strAnimalCode, 
	tlbAnimal.strDescription, 
	tlbAnimal.idfsAnimalCondition, 
	tlbAnimal.idfSpecies, 
	tlbSpecies.idfsSpeciesType,
	tlbAnimal.idfObservation,
	tlbObservation.idfsFormTemplate,
	Gender.[name] AS strGender,
	Species.[name] AS strSpecies,
	convert(uniqueidentifier, tlbAnimal.strReservedAttribute) as uidOfflineCaseID


FROM tlbAnimal
INNER JOIN tlbSpecies ON 
	tlbSpecies.idfSpecies=tlbAnimal.idfSpecies 
	AND tlbSpecies.intRowStatus = 0
INNER JOIN tlbHerd ON
	tlbHerd.idfHerd=tlbSpecies.idfHerd 
	AND tlbHerd.intRowStatus = 0
JOIN tlbFarm tf ON
	tf.idfFarm = tlbHerd.idfFarm
	AND tf.intRowStatus = 0
JOIN tlbVetCase tvc ON
	tvc.idfFarm = tf.idfFarm
	AND tvc.idfVetCase = @idfCase
LEFT OUTER JOIN fnReference(@LangID,19000007/*rftAnimalGenderList*/) Gender ON
	Gender.idfsReference=tlbAnimal.idfsAnimalGender
LEFT OUTER JOIN fnReference(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpecies.idfsSpeciesType
LEFT OUTER JOIN tlbObservation ON
	tlbObservation.idfObservation = tlbAnimal.idfObservation
	AND tlbObservation.intRowStatus = 0
WHERE tlbAnimal.intRowStatus = 0





