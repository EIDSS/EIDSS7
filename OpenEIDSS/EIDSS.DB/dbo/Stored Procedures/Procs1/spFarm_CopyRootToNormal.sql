
--##SUMMARY Copies data from root farm (tlbFarmActual) to normal farm (tlbFarm).
--##SUMMARY If target farm doesn't exist, new farm is created.



--##REMARKS Author: Zurin M.
--##REMARKS Create date: 22.12.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating animals fields of tlbFarmActual commented
--##REMARKS Date: 24.07.2012

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @RC int
DECLARE @idfRootFarm bigint
DECLARE @idfTargetFarm bigint

-- TODO: Set parameter values here.

EXECUTE @RC = [EIDSS_version4].[dbo].[spFarm_CopyRootToNormal] 
   @idfRootFarm
  ,@idfTargetFarm OUTPUT
*/


CREATE             PROCEDURE [dbo].[spFarm_CopyRootToNormal]
	@idfRootFarm bigint,--##PARAM @idfRootFarm - root farm ID
	@idfTargetFarm bigint OUTPUT,--##PARAM @idfTargetFarm - ID of attached farm
	@idfMonitoringSession bigint
AS


--Print '@idfFarm='+CAST(ISNULL(@idfTargetFarm,'NULL') AS VARCHAR)+'@idfTargetFarm='+CAST(ISNULL(@idfRootFarm,'NULL') AS VARCHAR)+'@idfMonitoringSession='+CAST(ISNULL(@idfMonitoringSession,'NULL') AS VARCHAR)
IF NOT Exists (Select * from tlbMonitoringSession where idfMonitoringSession = @idfMonitoringSession)
	SET @idfMonitoringSession = null
--Select root farm data
DECLARE @idfRootFarmAddress bigint
DECLARE	@idfRootOwner bigint
DECLARE	@strOwnerLastName NVARCHAR(200)
DECLARE	@strOwnerFirstName NVARCHAR(200)
DECLARE	@strOwnerMiddleName NVARCHAR(200)

Select  
	@idfRootFarmAddress = idfFarmAddress,
	@idfRootOwner = tlbHumanActual.idfHumanActual,
	@strOwnerLastName = tlbHumanActual.strLastName,
	@strOwnerFirstName = tlbHumanActual.strFirstName,
	@strOwnerMiddleName = tlbHumanActual.strSecondName  
FROM tlbFarmActual
LEFT OUTER JOIN tlbHumanActual 
	on tlbHumanActual.idfHumanActual=tlbFarmActual.idfHumanActual 
	AND tlbHumanActual.intRowStatus = 0
WHERE 
	idfFarmActual = @idfRootFarm
	AND tlbFarmActual.intRowStatus = 0

IF @@ROWCOUNT=0 --no root farm is found, do nothing
	RETURN -1
IF	NOT @idfMonitoringSession IS NULL AND 
	NOT EXISTS (SELECT idfMonitoringSession FROM tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession)
	SET @idfMonitoringSession = NULL --session is not posted yet, the link will be set later
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
EXEC spGeoLocation_CreateCopy	@idfRootFarmAddress, @idfTargetFarmAddress, 0

--post owner data
EXEC spFarmPanel_PostOwnerData	@idfTargetOwner,
								@idfRootOwner OUTPUT,
								@strOwnerLastName,
								@strOwnerFirstName,
								@strOwnerMiddleName
								,0
-- post farm data
IF @TargetAction=16 --Modified
BEGIN
UPDATE tlbFarm 
   SET 
	   tlbFarm.idfFarmActual = @idfRootFarm
      --,tlbFarm.idfsAvianFarmType = rootFarm.idfsAvianFarmType
      --,tlbFarm.idfsAvianProductionType = rootFarm.idfsAvianProductionType
      --,tlbFarm.idfsFarmCategory = rootFarm.idfsFarmCategory
      --,tlbFarm.idfsOwnershipStructure = rootFarm.idfsOwnershipStructure
      --,tlbFarm.idfsMovementPattern = rootFarm.idfsMovementPattern
      --,tlbFarm.idfsIntendedUse = rootFarm.idfsIntendedUse
      --,tlbFarm.idfsGrazingPattern = rootFarm.idfsGrazingPattern
      --,tlbFarm.idfsLivestockProductionType = rootFarm.idfsLivestockProductionType
      ,tlbFarm.idfHuman = @idfTargetOwner
      ,tlbFarm.idfFarmAddress = @idfTargetFarmAddress
      ,tlbFarm.strInternationalName = rootFarm.strInternationalName
      ,tlbFarm.strNationalName = rootFarm.strNationalName
      ,tlbFarm.strFarmCode = rootFarm.strFarmCode
      ,tlbFarm.strFax = rootFarm.strFax
      ,tlbFarm.strEmail = rootFarm.strEmail
      ,tlbFarm.strContactPhone = rootFarm.strContactPhone
      --,tlbFarm.strNote = rootFarm.strNote
      --,tlbFarm.blnIsLivestock = 1--rootFarm.blnIsLivestock
      --,tlbFarm.blnIsAvian = rootFarm.blnIsAvian
      --,tlbFarm.intBuidings = rootFarm.intBuidings
      --,tlbFarm.intBirdsPerBuilding = rootFarm.intBirdsPerBuilding
	  ,tlbFarm.datModificationDate = getdate()
	  ,tlbFarm.intHACode = 32
      ,tlbFarm.idfMonitoringSession = @idfMonitoringSession
	FROM tlbFarmActual AS rootFarm
		INNER JOIN tlbFarm ON
			rootFarm.idfFarmActual = @idfRootFarm
	WHERE 
		tlbFarm.idfFarm=@idfTargetFarm

END   		
IF @TargetAction=4 --Added
BEGIN
	
	--Print 'inserting party idfParty = ' + CAST(@idfTargetFarm as VARCHAR)+', idfRootParty = ' +  ISNULL(CAST(@idfRootFarm as VARCHAR),'NULL')
	INSERT INTO tlbFarm (
			idfFarm
			,idfFarmActual
			--,idfsAvianFarmType
			--,idfsAvianProductionType
			--,idfsFarmCategory
			--,idfsOwnershipStructure
			--,idfsMovementPattern
			--,idfsIntendedUse
			--,idfsGrazingPattern
			--,idfsLivestockProductionType
			,idfHuman
			,idfFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			--,strNote
			--,blnIsLivestock
			--,blnIsAvian
			--,intBuidings
			--,intBirdsPerBuilding
			,idfMonitoringSession
			,datModificationDate
			,intHACode
		)

	SELECT @idfTargetFarm
			,idfFarmActual
			--,idfsAvianFarmType
			--,idfsAvianProductionType
			--,idfsFarmCategory
			--,idfsOwnershipStructure
			--,idfsMovementPattern
			--,idfsIntendedUse
			--,idfsGrazingPattern
			--,idfsLivestockProductionType
			,@idfTargetOwner
			,@idfTargetFarmAddress
			,strInternationalName
			,strNationalName
			,strFarmCode
			,strFax
			,strEmail
			,strContactPhone
			--,strNote
			--,1--blnIsLivestock
			--,blnIsAvian
			--,intBuidings
			--,intBirdsPerBuilding
			,@idfMonitoringSession
			,getdate()
			,32
	  FROM tlbFarmActual
	WHERE 
		idfFarmActual = @idfRootFarm


END



