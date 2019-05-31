

--##SUMMARY Selects list of animals related with specific monitoring session.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 08.07.2010

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 22.04.2013

--##RETURNS Doesn't use


/*
--Example of a call of procedure:
DECLARE @ID BIGINT 
SET @ID = 1
exec spASSessionAnimals_SelectDetail @ID
*/

CREATE            PROC	[dbo].[spASSessionAnimals_SelectDetail]
		@idfMonitoringSession	BIGINT  --##PARAM @idfMonitoringSession -  ID of monitoring session for wich the animals are listed
		--,@LangID		NVARCHAR(50)  --##PARAM @LangID - language ID
AS
-- 0 Animal
SELECT  	 
	tlbAnimal.idfAnimal,  
	tlbAnimal.idfsAnimalAge,
	tlbAnimal.idfsAnimalGender, 
	tlbAnimal.strAnimalCode, 
	tlbAnimal.idfSpecies,
	tlbAnimal.strName,
	tlbAnimal.strColor,
	tlbAnimal.strDescription,
	tlbSpecies.idfsSpeciesType,  
	tlbFarm.idfMonitoringSession,
	tlbFarm.strFarmCode

FROM tlbAnimal
INNER JOIN tlbSpecies ON 
	tlbSpecies.idfSpecies=tlbAnimal.idfSpecies 
	and tlbSpecies.intRowStatus=0 
inner join tlbHerd on
  tlbHerd.idfHerd = tlbSpecies.idfHerd
  and tlbHerd.intRowStatus = 0
inner join tlbFarm on
  tlbFarm.idfFarm = tlbHerd.idfFarm
  and tlbFarm.intRowStatus = 0
left outer join tlbVetCase     
  on tlbVetCase.idfFarm = tlbFarm.idfFarm
	AND tlbVetCase.intRowStatus = 0

  	

WHERE	tlbFarm.idfMonitoringSession=@idfMonitoringSession 
		and tlbVetCase.idfVetCase IS NULL
		and NOT @idfMonitoringSession IS NULL
		and tlbAnimal.intRowStatus = 0





