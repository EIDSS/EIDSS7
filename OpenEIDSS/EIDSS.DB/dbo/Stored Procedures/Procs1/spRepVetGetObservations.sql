

--##SUMMARY Select observations for Veterinary Case.
--##REMARKS Author: Vasilyev I.
--##REMARKS Create date: 24.12.2009

--##REMARKS UPDATED BY: Vorobiev E. --deleted tlbCase
--##REMARKS Date: 23.04.2013

--##RETURNS Doesn't use

/*
--Example of a call of procedure:

exec spRepVetGetObservations 4970000002, 'ru'

*/

CREATE  Procedure [dbo].[spRepVetGetObservations]
    (
        @ObjID	as bigint,
        @LangID as nvarchar(10)
    )
as
	-- Get Case and Farm observations

	select  	tVetCase.idfVetCase			as idfCase,	
				tVetCase.idfObservation		as idfCaseObservation,
				tFarm.idfObservation		as idfFarmObservation
	from		dbo.tlbVetCase	as tVetCase
	inner join	dbo.tlbFarm		as tFarm
			on	tVetCase.idfFarm = tFarm.idfFarm
		   and  tFarm.intRowStatus = 0
	where	tVetCase.idfVetCase = @ObjID
		and  tVetCase.intRowStatus = 0
		 
		 
	-- Get Species observations 
	select  	tVetCase.idfVetCase			as idfCase,	
				tSpecies.idfObservation		as idfSpeciesObservation,
				fnSpecies.[name]			as strSpeciesName,
				tHerd.strHerdCode			as strHerdCode
	from		dbo.tlbVetCase	as tVetCase
	inner join	dbo.tlbFarm		as tFarm
      inner join tlbHerd	as tHerd
	        inner join	dbo.tlbSpecies	as tSpecies
	           left join	fnReferenceRepair(@LangID, 19000086) as fnSpecies
			          on	tSpecies.idfsSpeciesType = fnSpecies.idfsReference
	        on	tHerd.idfHerd = tSpecies.idfHerd and  
              tSpecies.intRowStatus = 0
      on tHerd.idfFarm = tFarm.idfFarm and
         tHerd.intRowStatus = 0
	on	tVetCase.idfFarm = tFarm.idfFarm and  
      tFarm.intRowStatus = 0
  where	tVetCase.idfVetCase = @ObjID
	and  tVetCase.intRowStatus = 0
		 
		 
	--select * from trtBaseReference where idfsBaseReference = 39110000000
	-- Get Animal observations 
	select  	tVetCase.idfVetCase			as idfCase,	
				tAnimal.idfObservation		as idfAnimalObservation,
				tAnimal.strName				as strAnimalName
	from		dbo.tlbVetCase	as tVetCase
	inner join	dbo.tlbFarm		as tFarm
      inner join tlbHerd	as tHerd
	        inner join	dbo.tlbSpecies	as tSpecies
	            inner join	dbo.tlbAnimal		as tAnimal
			            on	tSpecies.idfSpecies = tAnimal.idfSpecies
		               and  tAnimal.intRowStatus = 0
	        on	tHerd.idfHerd = tSpecies.idfHerd and  
              tSpecies.intRowStatus = 0
      on tHerd.idfFarm = tFarm.idfFarm and
         tHerd.intRowStatus = 0
	on	tVetCase.idfFarm = tFarm.idfFarm and  
      tFarm.intRowStatus = 0			
  where	tVetCase.idfVetCase = @ObjID
	and  tVetCase.intRowStatus = 0
		 
			

