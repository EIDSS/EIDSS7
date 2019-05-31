

--##SUMMARY Returns data for FarmPanel control.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 011.11.2009

--##REMARKS UPDATED BY: Zolotareva
--##REMARKS Date: 07.09.2011

--##REMARKS UPDATED BY: Gorodentseva T. updating animals fields of tlbFarmActual commented
--##REMARKS Date: 24.07.2012

--##REMARKS UPDATED BY: Vorobiev E. - deleted idfFarmLocation
--##REMARKS Date: 15.04.2013

--##RETURNS Doesn't use



/*
--Example of procedure call:

exec spFarmPanel_SelectDetail 88490000000

*/

CREATE PROCEDURE [dbo].[spFarmPanel_SelectDetail]
	@idfFarm AS bigint			--##PARAM @idfFarm - farm ID
AS

--1 Farm
Select  
	tlbFarm.idfFarm, 
	tlbFarm.idfFarmActual AS idfRootFarm,
	tvc.idfVetCase AS idfCase,
	tlbFarm.idfMonitoringSession,
	tlbFarm.strContactPhone, 
	tlbFarm.strInternationalName, 
	tlbFarm.strNationalName, 
	tlbFarm.strFarmCode,
	tlbFarm.strFax,
	tlbFarm.strEmail,
	tlbFarm.idfFarmAddress,
	tlbFarm.idfsOwnershipStructure,  
	tlbFarm.idfsLivestockProductionType,    
	tlbFarm.idfsGrazingPattern,    
	tlbFarm.idfsMovementPattern, 
	tlbFarm.idfsAvianFarmType,  
	tlbFarm.idfsAvianProductionType,  
	tlbFarm.idfsIntendedUse,  
	tlbFarm.intBirdsPerBuilding,  
	tlbFarm.intBuidings,   
	tlbFarm.idfHuman AS idfOwner,
	tfa.idfHumanActual AS idfRootOwner,
	dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strFullName,
	tlbHuman.strLastName AS strOwnerLastName,
	tlbHuman.strFirstName AS strOwnerFirstName,
	tlbHuman.strSecondName as strOwnerMiddleName,
	tlbFarm.idfObservation,
	tlbObservation.idfsFormTemplate,
	CAST(0 as BIT) AS blnRootFarm,
	tlbFarm.intHACode,
	tlbFarm.datModificationDate,    
	tlbFarm.datModificationForArchiveDate,
	convert(uniqueidentifier, tlbFarm.strReservedAttribute) as uidOfflineCaseID
FROM tlbFarm
LEFT OUTER JOIN tlbHuman 
	on tlbHuman.idfHuman=tlbFarm.idfHuman 
	AND tlbHuman.intRowStatus = 0
LEFT OUTER JOIN tlbFarmActual tfa
	ON tfa.idfFarmActual = tlbFarm.idfFarmActual
	AND tfa.intRowStatus = 0
LEFT OUTER JOIN tlbVetCase tvc ON
	tvc.idfFarm = tlbFarm.idfFarm
LEFT OUTER JOIN tlbObservation ON
 tlbFarm.idfObservation = tlbObservation.idfObservation
Where 
	tlbFarm.idfFarm=@idfFarm
	AND tlbFarm.intRowStatus = 0
	
UNION ALL

--2 FarmActual
Select  
	tlbFarmActual.idfFarmActual AS idfFarm, 
	NULL AS idfRootFarm,
	NULL AS idfCase,
	NULL AS idfMonitoringSession,
	tlbFarmActual.strContactPhone, 
	tlbFarmActual.strInternationalName, 
	tlbFarmActual.strNationalName, 
	tlbFarmActual.strFarmCode,
	tlbFarmActual.strFax,
	tlbFarmActual.strEmail,
	tlbFarmActual.idfFarmAddress,
	NULL AS idfsOwnershipStructure,  
	NULL AS idfsLivestockProductionType,    
	NULL AS idfsGrazingPattern,    
	NULL AS idfsMovementPattern,  
	NULL AS idfsAvianFarmType,  
	NULL AS idfsAvianProductionType,  
	NULL AS idfsIntendedUse,  
	NULL AS intBirdsPerBuilding,  
	NULL AS intBuidings, 
	tlbFarmActual.idfHumanActual AS idfOwner,
	NULL AS idfRootOwner,
	dbo.fnConcatFullName(tlbHumanActual.strLastName, tlbHumanActual.strFirstName, tlbHumanActual.strSecondName) as strFullName,
	tlbHumanActual.strLastName AS strOwnerLastName,
	tlbHumanActual.strFirstName AS strOwnerFirstName,
	tlbHumanActual.strSecondName as strOwnerMiddleName,
	null as idfObservation,
	null as idfsFormTemplate,  
	CAST(1 as BIT) AS blnRootFarm,
	tlbFarmActual.intHACode,
	tlbFarmActual.datModificationDate,
	CAST(NULL as datetime) as datModificationForArchiveDate,
	convert(uniqueidentifier, NULL) as uidOfflineCaseID

FROM tlbFarmActual
LEFT OUTER JOIN tlbHumanActual
	on tlbHumanActual.idfHumanActual=tlbFarmActual.idfHumanActual
	AND tlbHumanActual.intRowStatus = 0
Where 
	tlbFarmActual.idfFarmActual=@idfFarm
	AND tlbFarmActual.intRowStatus = 0



