


--##SUMMARY Returns table with farm data for Active Surveillance Monitoring Session form

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.07.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:
DECLARE @idfMonitoringSession bigint
SET @idfMonitoringSession=706800000000
EXECUTE spASSession_PopulateFarmData 
	@idfMonitoringSession

*/




CREATE         PROCEDURE [dbo].[spASSession_PopulateFarmData](
	@idfFarm AS bigint--##PARAM @idfFarm - farm ID
)
AS

SELECT idfFarm
	  ,tlbFarm.idfFarmActual as idfRootFarm
    ,tlbFarm.strFarmCode
    ,tlbFarm.strNationalName
	  ,dbo.fnConcatFullName(tlbHuman.strLastName, tlbHuman.strFirstName, tlbHuman.strSecondName) as strOwnerName
    ,tlbFarm.idfsOwnershipStructure
    ,tlbFarm.idfsLivestockProductionType
	  ,tlbFarm.idfMonitoringSession
FROM tlbFarm
LEFT OUTER JOIN tlbHuman 
	on tlbHuman.idfHuman=tlbFarm.idfHuman and
	   tlbHuman.intRowStatus = 0

WHERE
	tlbFarm.idfFarm = @idfFarm
	and tlbFarm.intRowStatus = 0
	
UNION ALL

SELECT idfFarmActual as idfFarm
	  ,NULL as idfRootFarm
    ,strFarmCode
    ,strNationalName
	,dbo.fnConcatFullName(tlbHumanActual.strLastName ,tlbHumanActual.strFirstName ,tlbHumanActual.strSecondName) as strOwnerName
    ,NULL idfsOwnershipStructure
    ,NULL idfsLivestockProductionType
	,NULL idfMonitoringSession
FROM tlbFarmActual
LEFT OUTER JOIN tlbHumanActual 
	on tlbHumanActual.idfHumanActual=tlbFarmActual.idfHumanActual and
	   tlbHumanActual.intRowStatus = 0

WHERE
	tlbFarmActual.idfFarmActual = @idfFarm
	and tlbFarmActual.intRowStatus = 0

