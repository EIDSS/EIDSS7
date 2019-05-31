
  
  
  
  
  
--##SUMMARY Posts data from FarmDetail panel.  
--##SUMMARY FarmDetail panel is used on 2 form types - on FarmDetail form and on Vet Case forms.  
--##SUMMARY In the case FarmDetail form it displays data for root farm object, i.e for farm that is not linked to any case   
--##SUMMARY and contains dat that was entered last time for the farm in any form. If user edits farm data on the FarmDetail form,  
--##SUMMARY the changes are saved for this root farm record only and doesn't affect to case related farms  
--##SUMMARY Vet Case forms displays copy of farm data linked to the case. If user selects farm from existing farms list, the farm copy is created and attached to case.  
--##SUMMARY If user creates new farm for case, the root farm is also created as copy of the new farm.  
--##SUMMARY If farm was changed on the vet case form, the changes are saved for both case farm copy and root farm.  
--##SUMMARY Thus root farm always contains most recently farm data, but case farm copy contains farm data actual at the time of vet case creation.  
  
  
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 15.12.2009  
  
--##REMARKS UPDATED BY: Vorobiev E.  
--##REMARKS Date: 18.08.2011  

--##REMARKS UPDATED BY: Zolotareva N - added parameters for references' values
--##REMARKS Date: 13.10.2011  

--##REMARKS UPDATED BY: Gorodentseva T. updating animals fields of tlbFarmActual commented
--##REMARKS Date: 24.07.2012

--##REMARKS UPDATED BY: Vorobiev E.  - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013  
  
--##RETURNS Doesn't use  
  
  
/*  
--Example of procedure call:  
delete tlbFarmActual  
delete tlbHumanActual  
  
DECLARE @RC int  
DECLARE @Action int  
DECLARE @idfFarm bigint  
DECLARE @idfRootFarm bigint  
DECLARE @idfCase bigint  
DECLARE @idfMonitoringSession bigint  
DECLARE @strContactPhone nvarchar(200)  
DECLARE @strInternationalName nvarchar(200)  
DECLARE @strNationalName nvarchar(200)  
DECLARE @strFarmCode nvarchar(200)  
DECLARE @strFax nvarchar(200)  
DECLARE @strEmail nvarchar(200) 
DECLARE @idfFarmAddress bigint  
DECLARE @idfOwner bigint  
DECLARE @idfRootOwner bigint  
DECLARE @strOwnerLastName nvarchar(200)  
DECLARE @strOwnerFirstName nvarchar(200)  
DECLARE @strOwnerMiddleName nvarchar(200)  
DECLARE @idfsOwnershipStructure bigint    
DECLARE @idfsLivestockProductionType bigint      
DECLARE @idfsGrazingPattern bigint      
DECLARE @idfsMovementPattern bigint    
DECLARE @idfsAvianFarmType bigint    
DECLARE @idfsAvianProductionType bigint    
DECLARE @idfsIntendedUse bigint    
DECLARE @intBirdsPerBuilding bigint    
DECLARE @intBuidings bigint  
-- TODO: Set parameter values	here.  
EXEC dbo.spsysGetNewID @idfFarm OUTPUT  
set @Action = 4  
  
EXECUTE @RC = [spFarmPanel_Post]   
   @Action  
  ,@idfFarm  
  ,@idfRootFarm OUTPUT  
  ,@idfCase  
  ,@idfMonitoringSession  
  ,@strContactPhone  
  ,@strInternationalName  
  ,@strNationalName  
  ,@strFarmCode OUTPUT  
  ,@strFax  
  ,@strEmail  
  ,@idfFarmAddress  
  ,@idfOwner  
  ,@idfRootOwner OUTPUT  
  ,@strOwnerLastName  
  ,@strOwnerFirstName  
  ,@strOwnerMiddleName  
  ,@idfsOwnershipStructure    
  ,@idfsLivestockProductionType
  ,@idfsGrazingPattern       
  ,@idfsMovementPattern    
  ,@idfsAvianFarmType    
  ,@idfsAvianProductionType 
  ,@idfsIntendedUse
  ,@intBirdsPerBuilding 
  ,@intBuidings 
  
*/  
  
  
  
  
  
  
  
CREATE             PROCEDURE [dbo].[spFarmPanel_Post]  
 @Action INT, --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record  
 @idfFarm bigint,--##PARAM @idfFarm - farm ID  
 @idfRootFarm bigint OUTPUT,--##PARAM @idfRootFarm - root farm ID, during posting data for root farm must be NULL  
 @idfCase bigint,--##PARAM @idfCase - case to which farm is attached, during posting data for root farm must be NULL  
 @idfMonitoringSession bigint,--##PARAM @idfMonitoringSession - monitoring to which farm is attached, during posting data for root farm must be NULL  
 @strContactPhone NVARCHAR(200), --##PARAM @strContactPhone - farm phone  
 @strInternationalName NVARCHAR(200), --##PARAM @strInternationalName - farm name in English  
 @strNationalName NVARCHAR(200), --##PARAM @strNationalName - farm name in current national language  
 @strFarmCode NVARCHAR(200) OUTPUT,--##PARAM @strFarmCode - unique human readable farm Code (can be used as farm barcode), if NULL, assigned inside procedure  
 @strFax NVARCHAR(200),--##PARAM @strFax - farm fax  
 @strEmail NVARCHAR(200),--##PARAM @strEmail - farm email  
 @idfFarmAddress bigint,--##PARAM @idfFarmAddress - reference to farm address  
 @idfOwner bigint,--##PARAM @idfOwner - refernece to farm owner  
 @idfRootOwner bigint OUTPUT,--##PARAM @idfRootOwner - refernece to root copy of farm owner  
 @strOwnerLastName NVARCHAR(200),--##PARAM @strOwnerLastName - farm owner last name  
 @strOwnerFirstName NVARCHAR(200),--##PARAM @strOwnerFirstName - farm owner first name  
 @strOwnerMiddleName NVARCHAR(200),--##PARAM @strOwnerMiddleName - farm owner middle name  
 @idfsOwnershipStructure bigint,  --##PARAM   @idfsOwnershipStructure - base reference value for Ownership Structure (Lvstk)
 @idfsLivestockProductionType bigint,     --##PARAM  @idfsLivestockProductionType  base reference value for Production Type (Lvstk)
 @idfsGrazingPattern bigint,     --##PARAM  @idfsGrazingPattern base reference value for Grazing Pattern(Lvstk)
 @idfsMovementPattern bigint,   --##PARAM  @idfsMovementPattern base reference value for Movement Pattern (Lvstk)
 @idfsAvianFarmType bigint,    --##PARAM @idfsAvianFarmType base reference value for Farm Type (Avian)
 @idfsAvianProductionType bigint,    --##PARAM @idfsAvianProductionType base reference value for Production Type  (Avian)
 @idfsIntendedUse bigint,    --##PARAM @idfsIntendedUse base reference value for Intended Use (Avian)
 @intBirdsPerBuilding bigint,    --##PARAM @intBirdsPerBuilding number of birds per building (Avian)
 @intBuidings bigint,   --##PARAM @intBuidings number of buildings (Avian)
 @blnRootFarm bit,   --##PARAM @blnRootFarm - specifies what kind of farm is posted, root or not root
 @intHACode int,
 @datModificationDate datetime = NULL out,
 @datModificationForArchiveDate datetime = NULL,
 @blnUseDebugPrint bit = 0,
 @uidOfflineCaseID uniqueidentifier = NULL
AS  

IF @blnUseDebugPrint = 1  
Print 'posting farm ' + CAST(@idfFarm as VARCHAR) + ' root farm ' +   ISNULL(CAST(@idfRootFarm as VARCHAR),'NULL')  


IF (NOT @idfCase IS NULL 
	OR NOT @idfMonitoringSession IS NULL 
	OR NOT @idfRootFarm IS NULL)  
  SET @blnRootFarm = 0

IF (NOT @idfMonitoringSession IS NULL)
begin
 IF not EXISTS (SELECT * FROM dbo.tlbMonitoringSession WHERE idfMonitoringSession = @idfMonitoringSession AND intRowStatus = 0)  
 SET @idfMonitoringSession = NULL
end
  
IF (@blnRootFarm = 1)  
BEGIN  
  
--- Этот кусок кода добавлен в связи с тем, что таблица GeoLocation была разделена на две независимые таблицы.  
--- В связи с этим в Post процедуры для GeoLocation был добавлен параметр, указывающий в какую из таблиц делать добавление строки.  
--- На время, пока этот параметр не передается через интерфейс, возможно добавление записей не в ту таблицу.  
--- Соответственно мы ниже делаем проверку о наличии строки в некорректной таблице и если находим ее там, то переносим в корректную.  
 IF EXISTS (SELECT * FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfFarmAddress AND intRowStatus = 0)  
 BEGIN  
  INSERT INTO tlbGeoLocationShared  
   (  
    idfGeoLocationShared  
    , idfsGroundType  
    , idfsGeoLocationType  
    , idfsCountry  
    , idfsRegion  
    , idfsRayon  
    , idfsSettlement  
    , idfsSite  
    , strPostCode  
    , strStreetName  
    , strHouse  
    , strBuilding  
    , strApartment  
    , strDescription  
    , dblDistance  
    , dblLatitude  
    , dblLongitude  
    , dblAccuracy  
    , dblAlignment  
    , intRowStatus  
    , rowguid  
   )  
  SELECT  
   tgl.idfGeoLocation  
   , tgl.idfsGroundType  
   , tgl.idfsGeoLocationType  
   , tgl.idfsCountry  
   , tgl.idfsRegion  
   , tgl.idfsRayon  
   , tgl.idfsSettlement  
   , tgl.idfsSite  
   , tgl.strPostCode  
   , tgl.strStreetName  
   , tgl.strHouse  
   , tgl.strBuilding  
   , tgl.strApartment  
   , tgl.strDescription  
   , tgl.dblDistance  
   , tgl.dblLatitude  
   , tgl.dblLongitude  
   , tgl.dblAccuracy  
   , tgl.dblAlignment  
   , tgl.intRowStatus  
   , tgl.rowguid  
  FROM dbo.tlbGeoLocation tgl  
  WHERE tgl.idfGeoLocation = @idfFarmAddress  
   AND tgl.intRowStatus = 0  
     
  DELETE FROM dbo.tlbGeoLocation WHERE idfGeoLocation = @idfFarmAddress AND intRowStatus = 0  
 END   
END  
ELSE  
 BEGIN  
  
  
--- Этот кусок кода добавлен в связи с тем, что таблица GeoLocation была разделена на две независимые таблицы.  
--- В связи с этим в Post процедуры для GeoLocation был добавлен параметр, указывающий в какую из таблиц делать добавление строки.  
--- На время, пока этот параметр не передается через интерфейс, возможно добавление записей не в ту таблицу.  
--- Соответственно мы ниже делаем проверку о наличии строки в некорректной таблице и если находим ее там, то переносим в корректную.   
  IF EXISTS (SELECT * FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfFarmAddress AND intRowStatus = 0)  
  BEGIN  
   INSERT INTO tlbGeoLocation  
    (  
     idfGeoLocation  
     , idfsGroundType  
     , idfsGeoLocationType  
     , idfsCountry  
     , idfsRegion  
     , idfsRayon  
     , idfsSettlement  
     , idfsSite  
     , strPostCode  
     , strStreetName  
     , strHouse  
     , strBuilding  
     , strApartment  
     , strDescription  
     , dblDistance  
     , dblLatitude  
     , dblLongitude  
     , dblAccuracy  
     , dblAlignment  
     , intRowStatus  
     , rowguid  
    )  
   SELECT  
    tgl.idfGeoLocationShared  
    , tgl.idfsGroundType  
    , tgl.idfsGeoLocationType  
    , tgl.idfsCountry  
    , tgl.idfsRegion  
    , tgl.idfsRayon  
    , tgl.idfsSettlement  
    , tgl.idfsSite  
    , tgl.strPostCode  
    , tgl.strStreetName  
    , tgl.strHouse  
    , tgl.strBuilding  
    , tgl.strApartment  
    , tgl.strDescription  
    , tgl.dblDistance  
    , tgl.dblLatitude  
    , tgl.dblLongitude  
    , tgl.dblAccuracy  
    , tgl.dblAlignment  
    , tgl.intRowStatus  
    , tgl.rowguid  
   FROM dbo.tlbGeoLocationShared tgl  
   WHERE tgl.idfGeoLocationShared = @idfFarmAddress  
    AND tgl.intRowStatus = 0  
      
   DELETE FROM dbo.tlbGeoLocationShared WHERE idfGeoLocationShared = @idfFarmAddress AND intRowStatus = 0  
  END   
 END  
  
  
IF ISNULL(@strFarmCode,N'') = N'' OR LEFT(ISNULL(@strFarmCode,N''),4)='(new'  
BEGIN  
 EXEC dbo.spGetNextNumber 10057010, @strFarmCode OUTPUT , NULL --N'nbtFarmNumber'  
END  
  
  
if ISNULL(@blnRootFarm,0) = 0 --this is the case related farm, we should update root farm info  
BEGIN  
	
 IF @blnUseDebugPrint = 1
 PRINT '*'  
 
 DECLARE @idfRootFarmAddress bigint  
   
 if  @idfRootFarm IS NULL   
 BEGIN  
  EXEC dbo.spsysGetNewID @idfRootFarm OUTPUT  
 END  
 DECLARE @dummyID bigint  
 DECLARE @RootAction int  
 DECLARE @idfRootFarmOwner bigint  
 DECLARE @idfRootFarmOwnerAddress bigint  
 SELECT   
  @idfRootFarmAddress = idfFarmAddress  
  ,@idfRootFarmOwner = idfHumanActual  
 FROM tlbFarmActual   
 WHERE idfFarmActual = @idfRootFarm  
 if @@ROWCOUNT>0  
 BEGIN
  SET @RootAction = 16  
 END
 else  
 BEGIN  
  SET @RootAction = 4  
 END  
 IF(ISNULL(@idfRootFarmAddress, -1)<0)
  EXEC dbo.spsysGetNewID @idfRootFarmAddress OUTPUT  

 IF @blnUseDebugPrint = 1
 Print 'posting root farm ' + ISNULL(CAST(@idfRootFarm as VARCHAR),'NULL') + ' Action ' + CAST(@RootAction as varchar)  
 
 EXEC spGeoLocation_CreateCopy @idfFarmAddress, @idfRootFarmAddress, 1 -- create new GeoLocation in tlbGeoLocationShared  
 IF @idfRootFarmOwner IS NULL  
 BEGIN
  EXEC dbo.spsysGetNewID @idfRootFarmOwner OUTPUT
  -- *******  only when creating root farm owner - 
  -- *******  create new GeoLocation in tlbGeoLocationShared for root farm owner
  EXEC dbo.spsysGetNewID @idfRootFarmOwnerAddress OUTPUT  
  EXEC spGeoLocation_CreateCopy @idfFarmAddress, @idfRootFarmOwnerAddress, 1 -- create new GeoLocation in tlbGeoLocationShared
 END
   
 EXEC dbo.spFarmPanel_Post   
   @RootAction,  
   @idfRootFarm, --update root farm data  
   @dummyID output, --@idfRootFarm should be null for root farm  
   null, --@idfCase should be null for root farm  
   null, --@idfMonitoringSession should be null for root farm  
   @strContactPhone,   
   @strInternationalName,   
   @strNationalName,   
   @strFarmCode OUTPUT,  
   @strFax,  
   @strEmail,  
   @idfRootFarmAddress,  
   @idfRootFarmOwner,  
   @idfRootOwner OUTPUT,  
   @strOwnerLastName,  
   @strOwnerFirstName,  
   @strOwnerMiddleName,
   @idfsOwnershipStructure,
   @idfsLivestockProductionType,      
   @idfsGrazingPattern,      
   @idfsMovementPattern,    
   @idfsAvianFarmType,    
   @idfsAvianProductionType,    
   @idfsIntendedUse,    
   @intBirdsPerBuilding,    
   @intBuidings,
   1,
   @intHACode,
   @datModificationForArchiveDate
  
END  
SET @datModificationDate = GETDATE()
IF @Action=16 --Modified  
BEGIN  
 EXEC spFarmPanel_PostOwnerData @idfOwner,  
         @idfRootOwner OUTPUT,  
         @strOwnerLastName,  
         @strOwnerFirstName,  
         @strOwnerMiddleName,
         @blnRootFarm  
         
 if @blnRootFarm = 0  
  UPDATE tlbFarm  
  SET  
   strContactPhone=@strContactPhone,   
   strInternationalName=@strInternationalName,   
   strNationalName=@strNationalName,   
   strFarmCode=@strFarmCode,  
   strFax=@strFax,  
   strEmail=@strEmail,  
   idfFarmAddress=@idfFarmAddress,  
   idfHuman=@idfOwner,  
   --This is the fix for old framework desktop app
   --These data are gathered from other base form we post them in separate procedure
   --so we shold not update them here if they are NULL - in the case when main farm data was changed but these data was not modified
   --main farm control will post NULL for new farm here
   idfsOwnershipStructure = ISNULL(@idfsOwnershipStructure,idfsOwnershipStructure),  
   idfsLivestockProductionType = ISNULL(@idfsLivestockProductionType,idfsLivestockProductionType),      
   idfsGrazingPattern = ISNULL(@idfsGrazingPattern, idfsGrazingPattern),      
   idfsMovementPattern = ISNULL(@idfsMovementPattern, idfsMovementPattern),    
   idfsAvianFarmType = ISNULL(@idfsAvianFarmType,idfsAvianFarmType),    
   idfsAvianProductionType = ISNULL(@idfsAvianProductionType,idfsAvianProductionType),    
   idfsIntendedUse = ISNULL(@idfsIntendedUse,idfsIntendedUse),    
   intBirdsPerBuilding = ISNULL(@intBirdsPerBuilding, intBirdsPerBuilding),    
   intBuidings = ISNULL(@intBuidings, intBuidings),   
   intHACode=@intHACode,
   datModificationDate = @datModificationDate,
   datModificationForArchiveDate = getdate(),
   strReservedAttribute = convert(nvarchar(max),@uidOfflineCaseID)
  WHERE   
   idfFarm=@idfFarm   
 else  
  UPDATE tlbFarmActual  
  SET  
   strContactPhone=@strContactPhone,   
   strInternationalName=@strInternationalName,   
   strNationalName=@strNationalName,   
   strFarmCode=@strFarmCode,  
   strFax=@strFax,  
   strEmail=@strEmail,  
   idfFarmAddress=@idfFarmAddress,  
   idfHumanActual=@idfRootOwner,  
   idfsOwnershipStructure = NULL,--ISNULL(@idfsOwnershipStructure,idfsOwnershipStructure),  
   idfsLivestockProductionType = NULL,--ISNULL(@idfsLivestockProductionType,idfsLivestockProductionType),      
   idfsGrazingPattern = NULL,--ISNULL(@idfsGrazingPattern, idfsGrazingPattern),      
   idfsMovementPattern = NULL,--ISNULL(@idfsMovementPattern, idfsMovementPattern),    
   idfsAvianFarmType = NULL,--ISNULL(@idfsAvianFarmType,idfsAvianFarmType),    
   idfsAvianProductionType = NULL,--ISNULL(@idfsAvianProductionType,idfsAvianProductionType),    
   idfsIntendedUse = NULL,--ISNULL(@idfsIntendedUse,idfsIntendedUse),    
   intBirdsPerBuilding = NULL,--ISNULL(@intBirdsPerBuilding, intBirdsPerBuilding),    
   intBuidings = NULL,--ISNULL(@intBuidings, intBuidings)   
   intHACode=@intHACode,
   datModificationDate = @datModificationDate
  WHERE   
   idfFarmActual=@idfFarm   
  
END  
IF @Action=8 --Deleted  
BEGIN  
 EXEC dbo.spFarm_Delete @idfFarm  
 Return 0  
END  
  
IF @Action=4 --Added  
BEGIN  
 IF @idfOwner IS NULL AND @blnRootFarm = 1  
 EXEC dbo.spsysGetNewID @idfOwner OUTPUT  
   
 EXEC spFarmPanel_PostOwnerData @idfOwner,  
         @idfRootOwner OUTPUT,  
         @strOwnerLastName,  
         @strOwnerFirstName,  
         @strOwnerMiddleName,
         @blnRootFarm  
 
 IF @blnUseDebugPrint = 1
 Print 'inserting HUMAN idfParty = ' + CAST(@idfOwner as VARCHAR)+', idfRootParty = ' +  ISNULL(CAST(@idfRootOwner as VARCHAR),'NULL')  
 
 declare @idfsCountry bigint
 set @idfsCountry = dbo.fnCurrentCountry()
 if @blnRootFarm = 0
 begin

 if not exists (select * from tlbGeoLocation where idfGeoLocation = @idfFarmAddress)
 exec spAddress_Post
 	@idfGeoLocation = @idfFarmAddress,
	@idfsCountry = @idfsCountry,
	@idfsRegion = null,
	@idfsRayon = null,
	@idfsSettlement = null,
	@strApartment = null,
	@strBuilding = null,
	@strStreetName = null,
	@strHouse = null,
	@strPostCode = null,
	@blnForeignAddress = 0,
	@strForeignAddress = null,
	@blnGeoLocationShared = 0

  INSERT INTO tlbFarm(  
   idfFarm,   
   idfFarmActual,   
   strContactPhone,   
   strInternationalName,   
   strNationalName,   
   strFarmCode,  
   strFax,  
   strEmail,  
   idfFarmAddress,  
   idfHuman,  
   idfsOwnershipStructure,
   idfsLivestockProductionType,      
   idfsGrazingPattern,      
   idfsMovementPattern,    
   idfsAvianFarmType,    
   idfsAvianProductionType,    
   idfsIntendedUse,    
   intBirdsPerBuilding,    
   intBuidings,
   intHACode,
   datModificationDate,
   datModificationForArchiveDate,
   strReservedAttribute
  )  
  VALUES (  
   @idfFarm,   
   @idfRootFarm,  
   @strContactPhone,   
   @strInternationalName,   
   @strNationalName,   
   @strFarmCode,  
   @strFax,  
   @strEmail,  
   @idfFarmAddress,  
   @idfOwner,  
   @idfsOwnershipStructure,
   @idfsLivestockProductionType,      
   @idfsGrazingPattern,      
   @idfsMovementPattern,    
   @idfsAvianFarmType,    
   @idfsAvianProductionType,    
   @idfsIntendedUse,    
   @intBirdsPerBuilding,    
   @intBuidings,
   @intHACode,
   @datModificationDate,
   getdate(),
   convert(nvarchar(max),@uidOfflineCaseID)
 )  
 end ELSE  begin

 if not exists (select * from tlbGeoLocationShared where idfGeoLocationShared = @idfFarmAddress)
 exec spAddress_Post
 	@idfGeoLocation = @idfFarmAddress,
	@idfsCountry = @idfsCountry,
	@idfsRegion = null,
	@idfsRayon = null,
	@idfsSettlement = null,
	@strApartment = null,
	@strBuilding = null,
	@strStreetName = null,
	@strHouse = null,
	@strPostCode = null,
	@blnForeignAddress = 0,
	@strForeignAddress = null,
	@blnGeoLocationShared = 1

  INSERT INTO tlbFarmActual(  
   idfFarmActual,   
   strContactPhone,   
   strInternationalName,   
   strNationalName,   
   strFarmCode,  
   strFax,  
   strEmail,  
   idfFarmAddress,  
   idfHumanActual,  
   --idfsOwnershipStructure,
   --idfsLivestockProductionType,      
   --idfsGrazingPattern,      
   --idfsMovementPattern,    
   --idfsAvianFarmType,    
   --idfsAvianProductionType,    
   --idfsIntendedUse,    
   --intBirdsPerBuilding,    
   --intBuidings        
   intHACode,
   datModificationDate   
  )  
  VALUES (  
   @idfFarm,   
   @strContactPhone,   
   @strInternationalName,   
   @strNationalName,   
   @strFarmCode,  
   @strFax,  
   @strEmail,  
   @idfFarmAddress,  
   @idfRootOwner,  
   --@idfsOwnershipStructure, 
   --@idfsLivestockProductionType,      
   --@idfsGrazingPattern,      
   --@idfsMovementPattern,    
   --@idfsAvianFarmType,    
   --@idfsAvianProductionType,    
   --@idfsIntendedUse,    
   --@intBirdsPerBuilding,    
   --@intBuidings 
   @intHACode,
   @datModificationDate
 )  
 end 
END  
  
--- next queries have no effect for root farm  
--- ( @idfCase is null and idfFarm <> @idfFarm)  
Update dbo.tlbFarm      
SET idfFarmActual = @idfRootFarm,      
 idfMonitoringSession = ISNULL(idfMonitoringSession, @idfMonitoringSession)  
where idfFarm = @idfFarm      
 and ( ISNULL(idfFarmActual,0) <> @idfRootFarm or ISNULL(idfMonitoringSession,0) <> @idfMonitoringSession )      

  -- *******  only when creating root farm owner - 
  -- *******  remember location of farm in tlbHumanActual.idfCurrentResidenceAddress for root farm owner
if @idfRootFarmOwnerAddress IS NOT NULL
 Update dbo.tlbHumanActual
 Set idfCurrentResidenceAddress = @idfRootFarmOwnerAddress
 Where idfHumanActual=@idfRootOwner

  
/* 
* 
* update dbo.tlbVetCase  
set idfFarm = @idfFarm  
where idfVetCase = @idfCase  
 and idfFarm <> @idfFarm   */

