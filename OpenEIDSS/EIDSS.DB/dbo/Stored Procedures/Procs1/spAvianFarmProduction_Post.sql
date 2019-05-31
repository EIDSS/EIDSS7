




--##SUMMARY Posts Avian farm properties.
--##SUMMARY The main posting is performed in spFarmPanel_Post procedure that is called before this one,
--##SUMMARY so it just updates several fields that belongs to AvianFarmDetail control only.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 07.07.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating animals fields of tlbFarmActual deleted
--##REMARKS Date: 24.07.2012

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @idfFarm bigint
DECLARE @idfRootFarm bigint
DECLARE @idfsAvianFarmType bigint
DECLARE @idfsAvianProductionType bigint
DECLARE @idfsIntendedUse bigint

EXECUTE spAvianFarmDetail_Post
	@idfFarm 
	@idfRootFarm,
	@idfsAvianFarmType,
	@idfsAvianProductionType,
	@idfsIntendedUse 

*/


CREATE    proc	[dbo].[spAvianFarmProduction_Post]
	@idfFarm bigint,
	@idfRootFarm bigint,
	@idfsAvianFarmType bigint,
	@idfsAvianProductionType bigint,
	@idfsIntendedUse bigint
as

--This procedure can be called from Root Farm form (in this case @idfRootFarm = NULL and root farm only should be updated)
--and from Vet Case form (in this case we should @idfFarm points to tlbFarm and root fam should be updated additionally)
IF @idfRootFarm IS NOT NULL
BEGIN
	UPDATE tlbFarm
	SET
		idfsAvianFarmType = @idfsAvianFarmType,
		idfsAvianProductionType = @idfsAvianProductionType,
		idfsIntendedUse = @idfsIntendedUse
	WHERE
		idfFarm=@idfFarm
		AND intRowStatus = 0
END


