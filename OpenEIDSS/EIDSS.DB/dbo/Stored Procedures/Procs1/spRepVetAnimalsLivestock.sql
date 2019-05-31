

--##SUMMARY Select Avian animal list for avian investigation report.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 22.12.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 01.08.2011

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetAnimalsLivestock 4330000870 , 'en' 
  
*/ 

CREATE  Procedure [dbo].[spRepVetAnimalsLivestock] 
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
AS 

	SELECT  	 
		tlbAnimal.idfAnimal,  
		tlbAnimal.strAnimalCode, 
		tlbHerd.strHerdCode, 
		Species.[name]		AS strSpecies,
		AnimalAge.[name]	AS strAge,
		Gender.[name]		AS strSex,
		tlbAnimal.idfObservation,
		tlbObservation.idfsFormTemplate,
		AnimalCondition.[name] AS strStatus
		

	FROM tlbAnimal
	INNER JOIN tlbSpecies ON 
		tlbSpecies.idfSpecies=tlbAnimal.idfSpecies 
		AND tlbSpecies.intRowStatus = 0
	INNER JOIN tlbHerd ON
		tlbHerd.idfHerd=tlbSpecies.idfHerd 
		AND tlbHerd.intRowStatus = 0
	INNER JOIN tlbFarm tf ON
		tf.idfFarm = tlbHerd.idfFarm
		AND tf.intRowStatus = 0
	INNER JOIN tlbVetCase VetCase ON
		VetCase.idfFarm = tf.idfFarm
		AND VetCase.idfVetCase = @ObjID
	LEFT JOIN fnReferenceRepair(@LangID,19000007/*rftAnimalGenderList*/) Gender ON
		Gender.idfsReference=tlbAnimal.idfsAnimalGender
	LEFT JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
		Species.idfsReference=tlbSpecies.idfsSpeciesType
	LEFT JOIN tlbObservation ON
		tlbObservation.idfObservation = tlbAnimal.idfObservation
		AND tlbObservation.intRowStatus = 0
	LEFT JOIN	dbo.fnReferenceRepair(@LangID,19000005) AnimalAge	ON			
		AnimalAge.idfsReference = tlbAnimal.idfsAnimalAge	
	LEFT JOIN	dbo.fnReferenceRepair(@LangID,19000006) AnimalCondition	ON			
		AnimalCondition.idfsReference = tlbAnimal.idfsAnimalCondition	
	WHERE tlbAnimal.intRowStatus = 0

			

