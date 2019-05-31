


 

--##SUMMARY Creates case for specified farm in monitoring session
--##SUMMARY During case creation it 
--##SUMMARY 1. Creates case itslef
--##SUMMARY 2. Links farm (including farm structure tree) to the case
--##SUMMARY 3. Links Animals/samples/tests with positive result to the case
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 02.08.2010

--##RETURNS 0 - if case is created successfully
--##RETURNS 1 - source farm doesn't exists
--##RETURNS 2 - case is already created for this farm and monitoring session
/*
--Example of a call of procedure:
DECLARE @idfFarm bigint

EXECUTE spASSession_AddAnimalToCase 
	@idfFarm
	,@idfCase OUTPUT
Print @idfCase
*/

CREATE            Proc	[dbo].[spASSession_AddAnimalToCase]
		 @idfCase bigint 
		,@idfAnimal bigint
		,@idfsFormTemplate bigint
As

DECLARE @idfsAnimalAge bigint
DECLARE @idfsAnimalGender bigint
DECLARE @strAnimalCode nvarchar(200)
DECLARE @strDescription nvarchar(200)
DECLARE @idfsAnimalCondition bigint
DECLARE @strHerdCode nvarchar(200)
DECLARE @idfsSpeciesType bigint
DECLARE @idfTargetSpecies bigint
DECLARE @idfObservation bigint
DECLARE @idfTargetAnimal bigint
DECLARE @idfTargetHerd bigint


SELECT 
   @idfsAnimalAge = idfsAnimalAge
  ,@idfsAnimalGender = idfsAnimalGender
  ,@strAnimalCode = strAnimalCode
  ,@strDescription = strDescription
  ,@idfsAnimalCondition = idfsAnimalCondition
  ,@strHerdCode = strHerdCode
  ,@idfsSpeciesType = tlbSpecies.idfsSpeciesType
FROM tlbAnimal
	INNER JOIN tlbSpecies ON 
		tlbSpecies.idfSpecies = tlbAnimal.idfSpecies and
		tlbSpecies.intRowStatus=0
	INNER JOIN tlbHerd on 
		tlbSpecies.idfHerd = tlbHerd.idfHerd and
		tlbHerd.intRowStatus=0
WHERE tlbAnimal.idfAnimal = @idfAnimal and
      tlbAnimal.intRowStatus=0


SELECT 
	@idfTargetSpecies = idfSpecies 
	,@idfTargetHerd = tlbHerd.idfHerd 
FROM tlbSpecies
	Inner join tlbHerd on 
		tlbSpecies.idfHerd = tlbHerd.idfHerd and
		tlbHerd.strHerdCode = @strHerdCode and
		tlbHerd.intRowStatus = 0
	inner join tlbFarm on
	  tlbFarm.idfFarm = tlbHerd.idfFarm	
	inner join tlbVetCase on
	  tlbVetCase.idfFarm = tlbFarm.idfFarm and
	  tlbVetCase.idfVetCase = @idfCase
WHERE
	tlbSpecies.idfsSpeciesType = @idfsSpeciesType and 
	tlbSpecies.intRowStatus = 0
	

EXEC spsysGetNewID @idfObservation OUTPUT
EXEC spsysGetNewID @idfTargetAnimal OUTPUT

EXECUTE spVetCaseAnimals_Post
   4 --@Action
  ,@idfTargetAnimal
  ,@idfTargetHerd
  ,@idfsAnimalAge
  ,@idfsAnimalGender
  ,@strAnimalCode  OUTPUT
  ,@strDescription
  ,@idfsAnimalCondition
  ,@idfTargetSpecies
  ,@idfObservation
  ,@idfsFormTemplate
  ,@idfCase

return 0



