
--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 17.04.2013

CREATE PROCEDURE spAnimalList_SelectDetail
@idfCase bigint,
@LangID nvarchar(50)
AS
SELECT	
	fnAnimalList.idfAnimal,
	fnAnimalList.idfCase,
	fnAnimalList.idfParty,
	fnAnimalList.idfMonitoringSession,	
	fnAnimalList.strAnimalCode,
	fnAnimalList.idfsAnimalGender,
	fnAnimalList.idfSpecies,
	fnAnimalList.idfsSpeciesType,
	fnAnimalList.SpeciesName,
	fnAnimalList.AnimalName,
	fnAnimalList.idfsAnimalAge,
	fnAnimalList.idfsAnimalCondition,
	fnAnimalList.strHerdCode ,
	fnAnimalList.idfObservation,
	fnAnimalList.idfsFormTemplate    
FROM fnAnimalList(@LangID) 
WHERE idfCase = @idfCase

