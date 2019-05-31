



--##REMARKS Gorodentseva T. : as soon as no herds are assosiated with root farm - this procedure is useless now
--##REMARKS Date: 24.07.2012




--##SUMMARY Creates farm tree copy from tlbFarm to tlbFarmActual.
--##SUMMARY This procedure is called from [spFarmTree_CreateCopy] if we create root copy 
--##SUMMARY						during farm tree savin in vet case or in monitoring session 
--##SUMMARY The next copying rules are implemented in this procedure
--##SUMMARY 1. If new farm is created inside case or session and at the moment of case/session 
--##SUMMARY    saving root farm has no herds, the entire herds structure is copied to root farm
--##SUMMARY 2. When we change herds structure in the session/case farm, we copy to the root farm new nodes only and update Totals for exisiting ones.
--##SUMMARY    No nodes are deleted during farm copying.
--##SUMMARY 3. After updating species nodes in the target farm the Totals on the herd/farm level are recalcualted.

--##REMARKS Author: Zhdanova A.
--##REMARKS Create date: 20.07.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @idfSourceFarm bigint
DECLARE @idfTargetFarm bigint


EXECUTE spFarmTree_CopyToRoot
   @idfSourceFarm
  ,@idfTargetFarm OUTPUT
  ,32
*/







CREATE             PROCEDURE [dbo].[spFarmTree_CopyToRoot]
	@idfSourceFarm bigint,--##PARAM @idfSourceFarm - source farm ID
	@idfTargetFarm bigint OUTPUT,--##PARAM @idfTargetFarm - target farm ID
	@HACode int --##PARAM @HACode - HA Code of copied structure, can be 32(LiveStock) or 64(avian)
AS



-- Insert new values
-- to Herds

DECLARE @idfHerd bigint
DECLARE @idfTargetHerd bigint
DECLARE @idfTargetSpecies bigint
DECLARE @idfSpecies bigint
DECLARE @idfsSpeciesType bigint
DECLARE @intTotalAnimalQty int
DECLARE @strHerdCode NVARCHAR(200)

IF @idfTargetFarm IS NULL
BEGIN
	SELECT @idfTargetFarm = idfFarmActual
	From		tlbFarm
	WHERE idfFarm = @idfSourceFarm
END

IF @idfTargetFarm IS NULL
EXEC spsysGetNewID @idfTargetFarm OUTPUT

DECLARE crHerd CURSOR Local Forward_only Static For
Select	Distinct	
	tlbHerd.idfHerd,
	tlbHerd.strHerdCode
From	tlbHerd 
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	and tlbSpecies.intRowStatus = 0
INNER JOIN trtBaseReference ON
	tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
	and trtBaseReference.intRowStatus = 0
	and (trtBaseReference.intHACode & @HACode)<>0
Where	    
	tlbHerd.idfFarm = @idfSourceFarm
	AND tlbHerd.intRowStatus = 0

OPEN crHerd
Fetch Next From crHerd into @idfHerd,@strHerdCode

While @@FETCH_STATUS = 0 Begin
	SET @idfTargetHerd = NULL
	Select	@idfTargetHerd = tlbHerdActual.idfHerdActual 
		From tlbHerdActual 
		Where
			tlbHerdActual.strHerdCode = @strHerdCode	    
			and tlbHerdActual.idfFarmActual = @idfTargetFarm
			and tlbHerdActual.intRowStatus = 0 --Check if the herd doesn't exist in the target farm

	IF(@idfTargetHerd is NULL)
	BEGIN -- herd is new BEGIN
		EXEC spsysGetNewID @idfTargetHerd OUTPUT
		print 'insert new actual herd ' + CASt(ISNULL(@idfTargetHerd,0) as varchar)

		INSERT INTO tlbHerdActual
				   (
					idfHerdActual
				   ,idfFarmActual
				   ,strHerdCode
				   )
			 VALUES
				   (
					@idfTargetHerd
				   ,@idfTargetFarm
				   ,@strHerdCode
				   )
				   
		update tlbHerd
		set idfHerdActual = @idfTargetHerd
		where idfHerd = @idfHerd
		
	END-- herd is new END

		--Cursor for source species in the current source herd
		DECLARE  crSpecies cursor Local Forward_only Static For
			Select		
				tlbSpecies.idfSpecies,
				idfsSpeciesType,
				tlbSpecies.intTotalAnimalQty
			From		tlbSpecies 
			INNER JOIN tlbHerd ON
				tlbHerd.idfHerd = tlbSpecies.idfHerd
			Where	    
				tlbHerd.idfHerd = @idfHerd
				AND tlbHerd.intRowStatus = 0
		OPEN crSpecies
		Fetch Next From crSpecies into @idfSpecies, @idfsSpeciesType, @intTotalAnimalQty
		While @@FETCH_STATUS = 0 Begin --species cursor start
			SET @idfTargetSpecies = NULL
			Select	@idfTargetSpecies = tlbSpeciesActual.idfSpeciesActual 
				From	tlbSpeciesActual 
				INNER JOIN tlbHerdActual ON
					tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
				Where
					tlbHerdActual.strHerdCode = @strHerdCode	    
					and tlbHerdActual.idfFarmActual = @idfTargetFarm
					and tlbSpeciesActual.idfsSpeciesType = @idfsSpeciesType
					and tlbHerdActual.intRowStatus = 0
					and tlbSpeciesActual.intRowStatus = 0 --Check if the species doesn't exist in the target herd

			IF @idfTargetSpecies  IS NULL
			BEGIN --new species BEGIN
				EXEC spsysGetNewID @idfTargetSpecies OUTPUT
				--Species itself
				INSERT INTO tlbSpeciesActual
						   (idfSpeciesActual
						   ,idfsSpeciesType
						   ,idfHerdActual
						   ,intTotalAnimalQty
							)
					 VALUES
						   (@idfTargetSpecies
						   ,@idfsSpeciesType
						   ,@idfTargetHerd
						   ,@intTotalAnimalQty
						   )
						   	
				update tlbSpecies
				set idfSpeciesActual = @idfTargetSpecies
				where idfSpecies = @idfSpecies
			END --new species end
			ELSE
			BEGIN
				Update tlbSpeciesActual 
					set tlbSpeciesActual.intTotalAnimalQty = @intTotalAnimalQty
				WHERE 
					tlbSpeciesActual.idfSpeciesActual = @idfTargetSpecies
			END								
	
			Fetch Next From crSpecies into @idfSpecies, @idfsSpeciesType, @intTotalAnimalQty
		END --species cursor end 
	Close crSpecies
	Deallocate crSpecies

	-- we updated totals for target herd species.
	-- now update total for herd itslef
	DECLARE @herdTotal int
	SET @herdTotal = (SELECT SUM (ISNULL(intTotalAnimalQty,0) )
									FROM tlbSpeciesActual 
									Where idfHerdActual = @idfTargetHerd 
										and tlbSpeciesActual.intRowStatus = 0)
	Print 'Herd Total = ' + CAST(ISNULL(@herdTotal,0) as varchar) + ' for herd '+ Cast(ISNULL(@idfTargetHerd,0) as varchar)
	Update tlbHerdActual
	SET 
		tlbHerdActual.intTotalAnimalQty = @herdTotal
	WHERE 
		idfHerdActual = @idfTargetHerd
	Fetch Next From crHerd into  @idfHerd,@strHerdCode
End --herd cursor end

Close crHerd
Deallocate crHerd


DECLARE @farmTotal int
SET @farmTotal = (SELECT SUM (ISNULL(tlbSpeciesActual.intTotalAnimalQty,0) )
					FROM tlbHerdActual
					INNER JOIN tlbSpeciesActual ON
						tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
						and tlbSpeciesActual.intRowStatus = 0
					INNER JOIN trtBaseReference ON
						tlbSpeciesActual.idfsSpeciesType = trtBaseReference.idfsBaseReference
						and trtBaseReference.intRowStatus = 0
						and (trtBaseReference.intHACode & @HACode)<>0
					Where tlbHerdActual.idfFarmActual =@idfTargetFarm
						and tlbHerdActual.intRowStatus = 0)
	Print 'Farm Total = ' + CAST(@farmTotal as varchar) + ' for farm '+ Cast(@idfTargetFarm as varchar)
	
----Update farm records
/*UPDATE [tlbFarmActual] 
   SET 
       [tlbFarmActual].intLivestockTotalAnimalQty = CASE WHEN (@HACode & 32)<>0 THEN @farmTotal ELSE intLivestockTotalAnimalQty END
      ,[tlbFarmActual].intAvianTotalAnimalQty =  CASE WHEN (@HACode & 64)<>0 THEN @farmTotal ELSE intAvianTotalAnimalQty END
	WHERE 
		[tlbFarmActual].idfFarmActual=@idfTargetFarm*/
