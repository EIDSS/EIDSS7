

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating tlbFarmActual deleted
--##REMARKS Date: 24.07.2012

CREATE    Proc	[dbo].[spLivestockFarmProduction_Post]
	@idfFarm bigint,
	@idfRootFarm bigint,
	@idfsOwnershipStructure bigint,
	@idfsLivestockProductionType bigint,
	@idfsGrazingPattern bigint,
	@idfsMovementPattern bigint
As

--This procedure can be called from Root Farm form (in this case @idfRootFarm = NULL and root farm only should be updated)
--and from Vet Case form (in this case we should @idfFarm points to tlbFarm and root fam should be updated additionally)
IF @idfRootFarm IS NOT NULL
BEGIN
	UPDATE tlbFarm
	SET
		idfsOwnershipStructure=@idfsOwnershipStructure,
		idfsLivestockProductionType=@idfsLivestockProductionType,
		idfsGrazingPattern=@idfsGrazingPattern,
		idfsMovementPattern=@idfsMovementPattern
	WHERE
		idfFarm=@idfFarm
		AND intRowStatus = 0
END




