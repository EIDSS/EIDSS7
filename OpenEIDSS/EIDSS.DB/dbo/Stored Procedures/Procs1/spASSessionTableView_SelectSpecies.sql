
  
/************************************************************  
* spASSessionTableView_SelectSpecies.proc  
************************************************************/  
  
  
--##SUMMARY Selects all species of all farms related with monitoring session for detailed session information
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 15.12.2011  
  
--##RETURNS Doesn't use  
  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=4581480000000  
EXECUTE spASSessionTableView_SelectSpecies   
 @idfMonitoringSession  
 ,'en' 
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spASSessionTableView_SelectSpecies](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
 ,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  

SELECT
	tlbSpecies.idfSpecies
	,tlbFarm.idfFarm
	,tlbSpecies.idfsSpeciesType as idfsReference
	,Species.name
FROM tlbFarm 
INNER JOIN tlbHerd ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbHerd.intRowStatus = 0
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	AND tlbSpecies.intRowStatus = 0
INNER JOIN fnReferenceRepair(@LangID,19000086/*'rftSpeciesList'*/) Species ON
	Species.idfsReference=tlbSpecies.idfsSpeciesType

WHERE	tlbFarm.idfMonitoringSession = @idfMonitoringSession
		AND tlbFarm.intRowStatus = 0

  
