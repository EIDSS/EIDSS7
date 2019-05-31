
  
/************************************************************  
* spASSessionTableView_SelectAnimals.proc  
************************************************************/  
  
  
--##SUMMARY Selects all species of all farms related with monitoring session for detailed session information
  
--##REMARKS Author: Zurin M.  
--##REMARKS Create date: 15.12.2011  
  
--##RETURNS Doesn't use  
  
  
  
/*  
--Example of procedure call:  
DECLARE @idfMonitoringSession bigint  
SET @idfMonitoringSession=4581480000000  
EXECUTE spASSessionTableView_SelectAnimals   
 @idfMonitoringSession  
 ,'en' 
*/  
  
  
  
CREATE         PROCEDURE [dbo].[spASSessionTableView_SelectAnimals](  
 @idfMonitoringSession AS bigint--##PARAM @iidfMonitoringSession - AS session ID  
 ,@LangID AS nvarchar(50)--##PARAM @LangID - language ID  
)  
AS  

SELECT
	a.idfAnimal  
	,tlbFarm.idfFarm
	,a.idfsAnimalAge
	,a.idfsAnimalGender 
	,a.strAnimalCode 
	,a.idfSpecies
	,tlbSpecies.idfsSpeciesType
	,a.strName
	,a.strColor
	,a.strDescription
FROM tlbFarm 
INNER JOIN tlbHerd ON
	tlbHerd.idfFarm = tlbFarm.idfFarm
	AND tlbHerd.intRowStatus = 0
INNER JOIN tlbSpecies ON
	tlbHerd.idfHerd = tlbSpecies.idfHerd
	AND tlbSpecies.intRowStatus = 0
INNER JOIN tlbAnimal a ON
	tlbSpecies.idfSpecies=a.idfSpecies 
	and a.intRowStatus=0 

WHERE	tlbFarm.idfMonitoringSession = @idfMonitoringSession
		AND tlbFarm.intRowStatus = 0

  
