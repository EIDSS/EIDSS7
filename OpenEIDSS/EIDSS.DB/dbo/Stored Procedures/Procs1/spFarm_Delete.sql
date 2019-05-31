


--##SUMMARY Deletes farm object.
--##SUMMARY When called from FarmList/FarmDetail forms it deletes only farm object. In this case spFarm_CanDelete
--##SUMMARY procedure should enable farm deleting only if there is no case related farms that refer given farm as root farm.
--##SUMMARY Also can be called from spVetCase_Delete procedure. In this case it deletes only case related farm, root farm object left in the system

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 15.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 13.07.2011

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 15.04.2013


--##RETURNS Doesn't use

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spFarm_Delete @ID

*/


CREATE   procedure [dbo].[spFarm_Delete]
	@ID as bigint --##PARAM @ID - farm ID
as
IF EXISTS (SELECT * FROM tlbFarm WHERE idfFarm = @ID and intRowStatus = 0)
BEGIN

---------------------------------------------------------
---- DELETE Farm from tlbFarm
---------------------------------------------------------
	DECLARE @idfFarmAddress bigint
	DECLARE @idfHuman bigint
	--Store farm links for futher deleting
	SELECT
		@idfFarmAddress = idfFarmAddress
		,@idfHuman = idfHuman
	FROM tlbFarm
	WHERE
		tlbFarm.idfFarm = @ID
		
	--Store  observations that should be deleted into temporary table
	DECLARE @Observation Table
	(
		idfObservation bigint
	)
	--Farm observation
	insert into @Observation
	(
	idfObservation
	)
	SELECT
		idfObservation
	FROM tlbFarm
	WHERE
		tlbFarm.idfFarm = @ID

	--Species observations
	insert into @Observation
	(
	idfObservation
	)
	SELECT
		idfObservation
	FROM tlbSpecies
	inner join tlbHerd on
			tlbSpecies.idfHerd = tlbHerd.idfHerd
	where	tlbHerd.idfFarm = @ID

	--Animal observations
	insert into @Observation
	(
	idfObservation
	)
	SELECT
		tlbAnimal.idfObservation
	FROM tlbAnimal
	inner join tlbSpecies on
			tlbSpecies.idfSpecies = tlbAnimal.idfSpecies
	inner join tlbHerd on
			tlbSpecies.idfHerd = tlbHerd.idfHerd
	where	tlbHerd.idfFarm = @ID
			AND tlbAnimal.intRowStatus = 0

	-- Delete animal information
	delete	tlbAnimal
	from	tlbAnimal
	inner join tlbSpecies on
			tlbSpecies.idfSpecies = tlbAnimal.idfSpecies
	inner join tlbHerd on
			tlbSpecies.idfHerd = tlbHerd.idfHerd
	where	tlbHerd.idfFarm = @ID
			AND tlbAnimal.intRowStatus = 0

	delete	tlbSpecies
	from	tlbSpecies
	inner join tlbHerd on
			tlbSpecies.idfHerd = tlbHerd.idfHerd
	where	tlbHerd.idfFarm = @ID


	delete	tlbHerd
	where	idfFarm = @ID

	exec spPatient_Delete @idfHuman

	--delete farm itself
	delete tflFarmFiltered
	where	idfFarm = @ID
	delete	tlbFarm
	where	idfFarm = @ID

	--Delete farm address
	exec spGeoLocation_Delete @idfFarmAddress

	exec spPatient_Delete @idfHuman

	-- Delete farm observation
	DELETE dbo.tlbActivityParameters
	WHERE 	idfObservation in (Select idfObservation from @Observation)

	delete	tflObservationFiltered
	where	idfObservation in (Select idfObservation from @Observation)
	delete	tlbObservation
	where	idfObservation in (Select idfObservation from @Observation)
END
ELSE IF EXISTS (SELECT * FROM tlbFarmActual WHERE idfFarmActual = @ID and intRowStatus = 0)
BEGIN

---------------------------------------------------------
---- DELETE Farm from tlbFarmActual
---------------------------------------------------------
	--Store farm links for futher deleting
	DECLARE @idfFarmActualAddress bigint
	SELECT
		@idfFarmActualAddress = idfFarmAddress
	FROM tlbFarmActual
	WHERE
		tlbFarmActual.idfFarmActual = @ID

	delete	tlbSpeciesActual
	from	tlbSpeciesActual
	inner join tlbHerdActual on
			tlbSpeciesActual.idfHerdActual = tlbHerdActual.idfHerdActual
	where	tlbHerdActual.idfFarmActual = @ID

	delete	tlbHerdActual
	where	idfFarmActual = @ID

	delete	tlbHumanActual
	from	tlbHumanActual
	inner join tlbFarmActual on
			tlbHumanActual.idfHumanActual = tlbFarmActual.idfHumanActual
	where	tlbFarmActual.idfHumanActual = @ID
			AND tlbFarmActual.intRowStatus = 0

	--delete farm itself
	delete	tlbFarmActual
	where	idfFarmActual = @ID

	--Delete farm address
	delete	tlbGeoLocationShared
	where	idfGeoLocationShared=@idfFarmActualAddress

	DECLARE crFarm CURSOR FOR
	SELECT idfFarm FROM tlbFarm WHERE idfFarmActual = @ID AND intRowStatus = 0
	DECLARE @idfFarm bigint
	OPEN crFarm;
    FETCH NEXT FROM crFarm INTO @idfFarm;

    WHILE @@FETCH_STATUS = 0
    BEGIN
		EXEc spFarm_Delete @idfFarm
		FETCH NEXT FROM crFarm INTO @idfFarm;
    END;
    
    CLOSE crFarm;
    DEALLOCATE crFarm;

END


