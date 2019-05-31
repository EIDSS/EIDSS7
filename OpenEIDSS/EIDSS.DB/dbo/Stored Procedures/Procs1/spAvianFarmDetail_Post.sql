






--##SUMMARY Posts AvianFarmDetail control data.
--##SUMMARY The main posting is performed in spFarmPanel_Post procedure that is called before this one,
--##SUMMARY so it just updates several fields that belongs to AvianFarmDetail control only.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.11.2009

--##REMARKS UPDATED BY: Vorobiev E.
--##REMARKS Date: 08.07.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating animals fields of tlbFarmActual deleted
--##REMARKS Date: 24.07.2012

--##RETURNS Doesn't use


/*
--Example of procedure call:

DECLARE @idfFarm bigint
DECLARE @intBuidings int
DECLARE @intBirdsPerBuilding int

EXECUTE spAvianFarmDetail_Post
   @idfFarm
  ,@intBuidings
  ,@intBirdsPerBuilding

*/



CREATE             PROCEDURE [dbo].[spAvianFarmDetail_Post]
	@idfFarm bigint,			--##PARAM @idfFarm - farm ID
	@intBuidings int,			--##PARAM @intBuidings - number of farm buildings
	@intBirdsPerBuilding int	--##PARAM @intBirdsPerBuilding - number of birds per building


AS

	UPDATE tlbFarm
	SET
		intBuidings=@intBuidings,
		intBirdsPerBuilding=@intBirdsPerBuilding
	WHERE 
		idfFarm=@idfFarm
		AND intRowStatus = 0

