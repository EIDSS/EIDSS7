





--##SUMMARY Copies data from  normal farm (tlbFarm) to root farm (tlbFarmActual).
--##SUMMARY If target farm doesn't exist, new farm is created.



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.12.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @RC int
DECLARE @idfRootFarm bigint
DECLARE @idfTargetFarm bigint

-- TODO: Set parameter values here.

EXECUTE @RC = [EIDSS_version4].[dbo].[spFarm_CopyNormalToRoot] 
   @idfFarm
  ,@idfTargetRootFarm OUTPUT
*/


CREATE             PROCEDURE [dbo].[spFarm_CopyNormalToRoot]
	@idfFarm bigint--##PARAM @idfFarm - normal farm ID
	,@idfTargetRootFarm bigint OUTPUT--##PARAM @idfTargetRootFarm - ID of target root farm
	--,@isLivestock bit --##PARAM @isLivestock - normal farm can be or livestock or avian. Depending on this parameter, only avian/livestock farm info is copied to the root farm
AS


--Print '@idfFarm='+CAST(ISNULL(@idfTargetFarm,'NULL') AS VARCHAR)+'@idfTargetFarm='+CAST(ISNULL(@idfRootFarm,'NULL') AS VARCHAR)+'@idfMonitoringSession='+CAST(ISNULL(@idfMonitoringSession,'NULL') AS VARCHAR)

--Select root farm data
DECLARE @idfFarmAddress bigint
DECLARE	@idfOwner bigint
DECLARE	@strOwnerLastName NVARCHAR(200)
DECLARE	@strOwnerFirstName NVARCHAR(200)
DECLARE	@strOwnerMiddleName NVARCHAR(200)

Select  
		@idfFarmAddress = idfFarmAddress
		,@idfOwner = tlbFarm.idfHuman
		,@strOwnerLastName = strLastName
		,@strOwnerFirstName = strFirstName
		,@strOwnerMiddleName = strSecondName 
		
FROM tlbFarm
LEFT OUTER JOIN tlbHuman
	on tlbHuman.idfHuman=tlbFarm.idfHuman 
	AND tlbHuman.intRowStatus = 0
WHERE 
	idfFarm = @idfFarm
	AND tlbFarm.intRowStatus = 0

IF @@ROWCOUNT=0 --no farm is found, do nothing
	RETURN -1

DECLARE @idfTargetFarmAddress bigint
DECLARE @idfTargetOwner bigint
	
IF  ISNULL(@idfTargetRootFarm,-1)<0 
BEGIN
	EXEC dbo.spsysGetNewID @idfTargetRootFarm OUTPUT
END

--Check if target farm exists
DECLARE @TargetAction int
SELECT 
	 @idfTargetFarmAddress = idfFarmAddress
	,@idfTargetOwner = idfHumanActual
FROM tlbFarmActual 
WHERE idfFarmActual = @idfTargetRootFarm
	
IF @@ROWCOUNT>0
	SET @TargetAction = 16
ELSE
	SET @TargetAction = 4

IF @idfTargetFarmAddress IS NULL
	EXEC dbo.spsysGetNewID @idfTargetFarmAddress OUTPUT
IF @idfTargetOwner IS NULL
	EXEC dbo.spsysGetNewID @idfTargetOwner OUTPUT

--copy farm locations
EXEC spGeoLocation_CreateCopy	@idfFarmAddress, @idfTargetFarmAddress, 1

--post owner data
DECLARE @idfRootOwner bigint
EXEC spFarmPanel_PostOwnerData	@idfTargetOwner,
								@idfRootOwner OUTPUT,
								@strOwnerLastName,
								@strOwnerFirstName,
								@strOwnerMiddleName
								,1
-- post farm data
IF @TargetAction=16 --Modified
UPDATE tlbFarmActual 
   SET 
		--general farm information
      --tlbFarmActual.idfsFarmCategory = farm.idfsFarmCategory,
      tlbFarmActual.idfHumanActual = @idfTargetOwner
      ,tlbFarmActual.idfFarmAddress = @idfTargetFarmAddress
      ,tlbFarmActual.strInternationalName = farm.strInternationalName
      ,tlbFarmActual.strNationalName = farm.strNationalName
      ,tlbFarmActual.strFarmCode = farm.strFarmCode
      ,tlbFarmActual.strFax = farm.strFax
      ,tlbFarmActual.strEmail = farm.strEmail
      ,tlbFarmActual.strContactPhone = farm.strContactPhone
      ,tlbFarmActual.strNote = farm.strNote
      --copy avian values if normal farm is avian
      --,tlbFarmActual.idfsAvianFarmType = NULL--CASE @isLivestock WHEN 0 THEN farm.idfsAvianFarmType ELSE tlbFarmActual.idfsAvianFarmType END
      --,tlbFarmActual.idfsAvianProductionType = NULL--CASE @isLivestock WHEN 0 THEN farm.idfsAvianProductionType ELSE tlbFarmActual.idfsAvianProductionType END
      --,tlbFarmActual.idfsIntendedUse = NULL--CASE @isLivestock WHEN 0 THEN farm.idfsIntendedUse ELSE tlbFarmActual.idfsIntendedUse END
      --,tlbFarmActual.intBuidings = NULL--CASE @isLivestock WHEN 0 THEN farm.intBuidings ELSE tlbFarmActual.intBuidings END
      --,tlbFarmActual.intBirdsPerBuilding = NULL--CASE @isLivestock WHEN 0 THEN farm.intBirdsPerBuilding ELSE tlbFarmActual.intBirdsPerBuilding END
      --copy livestock values if normal farm is livestock
      --,tlbFarmActual.idfsOwnershipStructure = NULL--CASE @isLivestock WHEN 1 THEN farm.idfsOwnershipStructure ELSE tlbFarmActual.idfsOwnershipStructure END
      --,tlbFarmActual.idfsMovementPattern = NULL--CASE @isLivestock WHEN 1 THEN farm.idfsMovementPattern ELSE tlbFarmActual.idfsMovementPattern END
      --,tlbFarmActual.idfsGrazingPattern = NULL--CASE @isLivestock WHEN 1 THEN farm.idfsGrazingPattern ELSE tlbFarmActual.idfsGrazingPattern END
      --,tlbFarmActual.idfsLivestockProductionType = NULL--CASE @isLivestock WHEN 1 THEN farm.idfsLivestockProductionType ELSE tlbFarmActual.idfsLivestockProductionType END
	  ,tlbFarmActual.intHACode = ISNULL(tlbFarmActual.intHACode,0) | farm.intHACode 
	  ,tlbFarmActual.datModificationDate = GETDATE()
	FROM tlbFarm AS farm
		INNER JOIN tlbFarmActual ON
			farm.idfFarm = @idfFarm
	WHERE 
		tlbFarmActual.idfFarmActual=@idfTargetRootFarm
		
IF @TargetAction=4 --Added
BEGIN
	
	--Print 'inserting party idfParty = ' + CAST(@idfTargetFarm as VARCHAR)+', idfRootParty = ' +  ISNULL(CAST(@idfRootFarm as VARCHAR),'NULL')
	INSERT INTO tlbFarmActual (
			 idfFarmActual
			--,idfsAvianFarmType
			--,idfsAvianProductionType
			--,idfsFarmCategory
			--,idfsOwnershipStructure
			--,idfsMovementPattern
			--,idfsIntendedUse
			--,idfsGrazingPattern
			--,idfsLivestockProductionType
			,idfHumanActual
			,idfFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			,strNote
			,intHACode
			,datModificationDate
			--,intBuidings
			--,intBirdsPerBuilding
		)

	SELECT 
			@idfTargetRootFarm
			--,idfsAvianFarmType
			--,idfsAvianProductionType
			--,idfsFarmCategory
			--,idfsOwnershipStructure
			--,idfsMovementPattern
			--,idfsIntendedUse
			--,idfsGrazingPattern
			--,idfsLivestockProductionType
			,@idfTargetOwner--idfHuman
			,@idfTargetFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			,strNote
			,intHACode
			,GETDATE()
			--,intBuidings
			--,intBirdsPerBuilding
	FROM tlbFarm AS farm
	WHERE
		farm.idfFarm = @idfFarm
		
END
/*DECLARE @HACode int
SET @HACode = CASE @isLivestock WHEN 1 THEN 32 ELSE 64 END
EXECUTE spFarmTree_CopyToRoot
   @idfFarm
  ,@idfTargetRootFarm
  ,@HACode
*/

