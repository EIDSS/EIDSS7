





--##SUMMARY Creates farm tree copy in the tlbFarm table.
--##SUMMARY This procedure is called when create new case from monitoring session and copy session farm ino the case


--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.12.2011


--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @idfSourceFarm bigint
DECLARE @idfTargetFarm bigint


EXECUTE spFarmTree_CreateCopy
   @idfSourceFarm
  ,@idfTargetFarm OUTPUT
  ,32
*/







CREATE             PROCEDURE [dbo].[spFarmTree_CopyToNormal]
	@idfSourceFarm bigint,--##PARAM @idfSourceFarm - source farm ID (can be root or normal)
	@idfTargetFarm bigint output,--##PARAM @idfTargetFarm - target farm ID (always normal)
	@HACode int --##PARAM @HACode - HA Code of copied structure, can be 32(LiveStock) or 64(avian)
AS

DECLARE @idfActualHerd bigint
DECLARE @idfHerd bigint
DECLARE @idfTargetHerd bigint
DECLARE @idfTargetSpecies bigint
DECLARE @idfSpecies bigint
DECLARE @idfsSpeciesType bigint
DECLARE @intTotalAnimalQty int
DECLARE @strHerdCode NVARCHAR(200)

DECLARE crHerd CURSOR Local Forward_only Static For
/*Select	Distinct	
	tlbHerdActual.idfHerdActual,
	tlbHerdActual.strHerdCode
From	tlbHerdActual 
INNER JOIN tlbSpeciesActual ON
	tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
	and tlbSpeciesActual.intRowStatus = 0
INNER JOIN trtBaseReference ON
	tlbSpeciesActual.idfsSpeciesType = trtBaseReference.idfsBaseReference
	and trtBaseReference.intRowStatus = 0
	and (trtBaseReference.intHACode & @HACode)<>0
Where	    
	tlbHerdActual.idfFarmActual = @idfSourceFarm
	AND tlbHerdActual.intRowStatus = 0
UNION ALL*/
Select	Distinct	
	tlbHerd.idfHerdActual,
	tlbHerd.idfHerd,
	tlbHerd.strHerdCode
From	tlbHerd 
--INNER JOIN tlbSpecies ON
--	tlbHerd.idfHerd = tlbSpecies.idfHerd
--	and tlbSpecies.intRowStatus = 0
--INNER JOIN trtBaseReference ON
--	tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
--	and trtBaseReference.intRowStatus = 0
--	and (trtBaseReference.intHACode & @HACode)<>0
Where	    
	tlbHerd.idfFarm = @idfSourceFarm
	AND tlbHerd.intRowStatus = 0

declare @speciesCount int

OPEN crHerd
Fetch Next From crHerd into @idfActualHerd,@idfHerd,@strHerdCode

While @@FETCH_STATUS = 0 Begin
	SET @idfTargetHerd = NULL
	Select	@idfTargetHerd = tlbHerd.idfHerd 
		From tlbHerd 
		Where
			tlbHerd.strHerdCode = @strHerdCode	    
			and tlbHerd.idfFarm = @idfTargetFarm
			and tlbHerd.intRowStatus = 0 --Check if the herd doesn't exist in the target farm

	IF(@idfTargetHerd is NULL)
	BEGIN -- herd is new BEGIN
		EXEC spsysGetNewID @idfTargetHerd OUTPUT
		print 'insert new herd ' + CASt(ISNULL(@idfTargetHerd,0) as varchar)
		--Herd itself
		INSERT INTO tlbHerd
				   (
					idfHerd
					,idfHerdActual
				   ,idfFarm
				   ,strHerdCode
				   )
			 VALUES
				   (
					@idfTargetHerd
					,@idfActualHerd
				   ,@idfTargetFarm
				   ,@strHerdCode
				   )

	END-- herd is new END
	
		--Cursor for source species in the current source herd
		DECLARE  crSpecies cursor Local Forward_only Static For
			/*Select		
				idfSpeciesActual,
				idfsSpeciesType,
				tlbSpeciesActual.intTotalAnimalQty
			From		tlbSpeciesActual 
			INNER JOIN tlbHerdActual ON
				tlbHerdActual.idfHerdActual = tlbSpeciesActual.idfHerdActual
			Where	    
				tlbHerdActual.idfHerdActual = @idfHerd
				AND tlbSpeciesActual.intRowStatus = 0
			UNION ALL*/
			Select		
				idfSpeciesActual,
				idfsSpeciesType,
				tlbSpecies.intTotalAnimalQty
			From		tlbSpecies 
			INNER JOIN tlbHerd ON
				tlbHerd.idfHerd = tlbSpecies.idfHerd
			Where	    
				tlbHerd.idfHerd = @idfHerd
				AND tlbSpecies.intRowStatus = 0
		OPEN crSpecies
		Fetch Next From crSpecies into @idfSpecies, @idfsSpeciesType, @intTotalAnimalQty
		While @@FETCH_STATUS = 0 Begin --species cursor start
			SET @idfTargetSpecies = NULL
			Select	@idfTargetSpecies = tlbSpecies.idfSpecies From	tlbSpecies 
				INNER JOIN tlbHerd ON
					tlbHerd.idfHerd = tlbSpecies.idfHerd
					and tlbHerd.intRowStatus = 0
				Where
					tlbHerd.strHerdCode = @strHerdCode	    
					and tlbHerd.idfFarm = @idfTargetFarm
					and tlbSpecies.idfsSpeciesType = @idfsSpeciesType
					and tlbSpecies.intRowStatus = 0 --Check if the species doesn't exist in the target herd
			IF @idfTargetSpecies  IS NULL
			BEGIN --new species BEGIN
				EXEC spsysGetNewID @idfTargetSpecies OUTPUT
				INSERT INTO tlbSpecies
						   (idfSpecies
						   ,idfSpeciesActual
						   ,idfsSpeciesType
						   ,idfHerd
						   ,intTotalAnimalQty
							)
					 VALUES
						   (@idfTargetSpecies
						   ,@idfSpecies
						   ,@idfsSpeciesType
						   ,@idfTargetHerd
						   ,@intTotalAnimalQty
						   )	
			END --new species end
			ELSE
			BEGIN
				Update tlbSpecies 
					set tlbSpecies.intTotalAnimalQty = @intTotalAnimalQty
				WHERE 
					tlbSpecies.idfSpecies = @idfTargetSpecies
			END								
	
			Fetch Next From crSpecies into @idfSpecies, @idfsSpeciesType, @intTotalAnimalQty
		END --species cursor end 
	Close crSpecies
	Deallocate crSpecies

	-- we updated totals for target herd species.
	-- now update total for herd itslef
	DECLARE @herdTotal int	
	set @speciesCount = (select COUNT(*) FROM tlbSpecies	Where idfHerd = @idfTargetHerd and intRowStatus = 0 and intTotalAnimalQty is not null)
	if @speciesCount > 0
	begin
		SET @herdTotal = (SELECT SUM (ISNULL(intTotalAnimalQty,0) )
										FROM tlbSpecies										
										Where idfHerd = @idfTargetHerd
										and intRowStatus = 0)
	end
	else
	begin
		set @herdTotal = null
	end
	Print 'Herd Total = ' + CAST(ISNULL(@herdTotal,0) as varchar) + ' for herd '+ Cast(ISNULL(@idfTargetHerd,0) as varchar)
	Update tlbHerd
	SET 
		tlbHerd.intTotalAnimalQty = @herdTotal
	WHERE 
		idfHerd = @idfTargetHerd
	Fetch Next From crHerd into  @idfActualHerd,@idfHerd,@strHerdCode
End --herd cursor end

Close crHerd
Deallocate crHerd


DECLARE @farmTotal int

SET @speciesCount = (SELECT COUNT(*)
					FROM tlbHerd
					INNER JOIN tlbSpecies ON
						tlbHerd.idfHerd = tlbSpecies.idfHerd
						and tlbSpecies.intRowStatus = 0
					INNER JOIN trtBaseReference ON
						tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
						and trtBaseReference.intRowStatus = 0
						and (trtBaseReference.intHACode & @HACode)<>0
					Where tlbHerd.idfFarm=@idfTargetFarm
						and tlbHerd.intRowStatus = 0  and tlbSpecies.intTotalAnimalQty is not null)

if @speciesCount > 0
begin
	SET @farmTotal = (SELECT SUM (ISNULL(tlbSpecies.intTotalAnimalQty,0) )
					FROM tlbHerd
					INNER JOIN tlbSpecies ON
						tlbHerd.idfHerd = tlbSpecies.idfHerd
						and tlbSpecies.intRowStatus = 0
					INNER JOIN trtBaseReference ON
						tlbSpecies.idfsSpeciesType = trtBaseReference.idfsBaseReference
						and trtBaseReference.intRowStatus = 0
						and (trtBaseReference.intHACode & @HACode)<>0
					Where tlbHerd.idfFarm=@idfTargetFarm
						and tlbHerd.intRowStatus = 0)
end
else
begin
	set @farmTotal = null
end

Print 'Farm Total = ' + CAST(@farmTotal as varchar) + ' for farm '+ Cast(@idfTargetFarm as varchar)
	
----Update farm records
UPDATE [tlbFarm] 
   SET 
       tlbFarm.intLivestockTotalAnimalQty = CASE WHEN (@HACode & 32)<>0 THEN @farmTotal ELSE intLivestockTotalAnimalQty END
      ,tlbFarm.intAvianTotalAnimalQty =  CASE WHEN (@HACode & 64)<>0 THEN @farmTotal ELSE intAvianTotalAnimalQty END
	WHERE 
		tlbFarm.idfFarm=@idfTargetFarm



