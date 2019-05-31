





--##SUMMARY Copies data from normal farm (tlbFarm) to another normal farm (tlbFarm).
--##SUMMARY This is needed when we create case for AS Session farm
--##SUMMARY If target farm doesn't exist, new farm is created.



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.12.2011

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013


--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @RC int
DECLARE @idfSourceFarm bigint
DECLARE @idfTargetFarm bigint

-- TODO: Set parameter values here.

EXECUTE @RC = [EIDSS_version4].[dbo].[spFarm_CopyNormalToNormal] 
   @idfSourceFarm
  ,@idfTargetFarm OUTPUT
*/


CREATE             PROCEDURE [dbo].[spFarm_CopyNormalToNormal]
	@idfSourceFarm bigint,--##PARAM @idfSourceFarm - root farm ID
	@idfTargetFarm bigint OUTPUT--##PARAM @@idfTargetFarm - ID of attached farm
AS


--Print '@idfFarm='+CAST(ISNULL(@idfTargetFarm,'NULL') AS VARCHAR)+'@idfTargetFarm='+CAST(ISNULL(@idfRootFarm,'NULL') AS VARCHAR)+'@idfMonitoringSession='+CAST(ISNULL(@idfMonitoringSession,'NULL') AS VARCHAR)

--Select root farm data
DECLARE @idfSourceFarmAddress bigint
DECLARE	@idfSourceOwner bigint
DECLARE	@idfSourceRootOwner bigint
DECLARE	@strOwnerLastName NVARCHAR(200)
DECLARE	@strOwnerFirstName NVARCHAR(200)
DECLARE	@strOwnerMiddleName NVARCHAR(200)

Select
	@idfSourceFarmAddress = idfFarmAddress,
	@idfSourceOwner = tlbHuman.idfHuman,
	@idfSourceRootOwner = tlbHuman.idfHumanActual,
	@strOwnerLastName = tlbHuman.strLastName,
	@strOwnerFirstName = tlbHuman.strFirstName,
	@strOwnerMiddleName = tlbHuman.strSecondName  
FROM tlbFarm
LEFT OUTER JOIN tlbHuman
	on tlbHuman.idfHuman=tlbFarm.idfHuman
	AND tlbHuman.intRowStatus = 0
WHERE 
	idfFarm = @idfSourceFarm
	AND tlbFarm.intRowStatus = 0

IF @@ROWCOUNT=0 --no root farm is found, do nothing
	RETURN -1

DECLARE @idfTargetFarmAddress bigint
DECLARE @idfTargetOwner bigint
	
IF  ISNULL(@idfTargetFarm,-1)<0 
BEGIN
	EXEC dbo.spsysGetNewID @idfTargetFarm OUTPUT
END

--Check if target farm exists
DECLARE @TargetAction int
SELECT 
	@idfTargetFarmAddress = idfFarmAddress
	,@idfTargetOwner = idfHuman
FROM tlbFarm 
WHERE idfFarm = @idfTargetFarm
	
IF @@ROWCOUNT>0
	SET @TargetAction = 16
ELSE
	SET @TargetAction = 4

IF @idfTargetFarmAddress IS NULL
	EXEC dbo.spsysGetNewID @idfTargetFarmAddress OUTPUT
IF @idfTargetOwner IS NULL
	EXEC dbo.spsysGetNewID @idfTargetOwner OUTPUT

--copy root farm locations
EXEC spGeoLocation_CreateCopy	@idfSourceFarmAddress, @idfTargetFarmAddress, 0

--post owner data
DECLARE @blnRootFarm bit
SET @blnRootFarm = 0
EXEC spFarmPanel_PostOwnerData	@idfTargetOwner,
								@idfSourceRootOwner OUTPUT,
								@strOwnerLastName,
								@strOwnerFirstName,
								@strOwnerMiddleName,
								@blnRootFarm
-- post farm data
IF @TargetAction=16 --Modified
UPDATE tlbFarm 
   SET 
	   tlbFarm.idfFarmActual = sourceFarm .idfFarmActual
      ,tlbFarm.idfsAvianFarmType = sourceFarm .idfsAvianFarmType
      ,tlbFarm.idfsAvianProductionType = sourceFarm .idfsAvianProductionType
      ,tlbFarm.idfsFarmCategory = sourceFarm .idfsFarmCategory
      ,tlbFarm.idfsOwnershipStructure = sourceFarm .idfsOwnershipStructure
      ,tlbFarm.idfsMovementPattern = sourceFarm .idfsMovementPattern
      ,tlbFarm.idfsIntendedUse = sourceFarm .idfsIntendedUse
      ,tlbFarm.idfsGrazingPattern = sourceFarm .idfsGrazingPattern
      ,tlbFarm.idfsLivestockProductionType = sourceFarm .idfsLivestockProductionType
      ,tlbFarm.idfHuman = @idfTargetOwner
      ,tlbFarm.idfFarmAddress = @idfTargetFarmAddress
      ,tlbFarm.strInternationalName = sourceFarm .strInternationalName
      ,tlbFarm.strNationalName = sourceFarm .strNationalName
      ,tlbFarm.strFarmCode = sourceFarm .strFarmCode
      ,tlbFarm.strFax = sourceFarm .strFax
      ,tlbFarm.strEmail = sourceFarm .strEmail
      ,tlbFarm.strContactPhone = sourceFarm .strContactPhone
      ,tlbFarm.strNote = sourceFarm .strNote
      ,tlbFarm.intBuidings = sourceFarm .intBuidings
      ,tlbFarm.intBirdsPerBuilding = sourceFarm .intBirdsPerBuilding
	  ,tlbFarm.intHACode = sourceFarm.intHACode
	  ,tlbFarm.datModificationDate = GETDATE()
	FROM tlbFarm AS sourceFarm 
		INNER JOIN tlbFarm ON
			sourceFarm .idfFarm = @idfSourceFarm
	WHERE 
		tlbFarm.idfFarm=@idfTargetFarm
		
IF @TargetAction=4 --Added
BEGIN
	
	--Print 'inserting party idfParty = ' + CAST(@idfTargetFarm as VARCHAR)+', idfRootParty = ' +  ISNULL(CAST(@idfSourceFarm as VARCHAR),'NULL')
	INSERT INTO tlbFarm (
			idfFarm
			,idfFarmActual
			,idfsAvianFarmType
			,idfsAvianProductionType
			,idfsFarmCategory
			,idfsOwnershipStructure
			,idfsMovementPattern
			,idfsIntendedUse
			,idfsGrazingPattern
			,idfsLivestockProductionType
			,idfHuman
			,idfFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			,strNote
			,intBuidings
			,intBirdsPerBuilding
			,intHACode
			,datModificationDate
		)

	SELECT @idfTargetFarm
			,idfFarmActual
			,idfsAvianFarmType
			,idfsAvianProductionType
			,idfsFarmCategory
			,idfsOwnershipStructure
			,idfsMovementPattern
			,idfsIntendedUse
			,idfsGrazingPattern
			,idfsLivestockProductionType
			,@idfTargetOwner--idfHuman
			,@idfTargetFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			,strNote
			,intBuidings
			,intBirdsPerBuilding
			,intHACode
			,GETDATE()
	  FROM tlbFarm
	WHERE 
		idfFarm = @idfSourceFarm
		
EXECUTE spFarmTree_CopyToNormal
   @idfSourceFarm
  ,@idfTargetFarm
  ,96



END



