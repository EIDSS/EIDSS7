
CREATE PROCEDURE [dbo].[spASSessionFarm_Link]  
@idfFarm bigint,  
@idfMonitoringSession bigint  
AS  
 UPDATE tlbFarm   
 SET   
  idfMonitoringSession = @idfMonitoringSession    
 WHERE idfFarm=@idfFarm   
