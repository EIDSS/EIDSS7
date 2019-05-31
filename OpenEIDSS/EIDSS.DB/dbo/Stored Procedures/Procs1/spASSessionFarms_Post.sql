

--##SUMMARY Posts Active Surveillance Monitoring Session farms list

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 28.06.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:

*/


CREATE         PROCEDURE [dbo].[spASSessionFarms_Post](
			@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
           ,@idfFarm bigint OUTPUT
           ,@idfRootFarm bigint
           ,@idfMonitoringSession bigint
)
AS
--Print '@idfFarm='+CAST(ISNULL(@idfFarm,'NULL') AS VARCHAR)+'@idfRootFarm='+CAST(ISNULL(@idfRootFarm,'NULL') AS VARCHAR)+'@idfMonitoringSession='+CAST(ISNULL(@idfMonitoringSession,'NULL') AS VARCHAR)
if @Action = 8
BEGIN
	EXEC spASFarm_Unlink @idfFarm
	RETURN 0
END
IF ISNULL(@idfFarm, -1)<0 OR NOT EXISTS(SELECT * FROM tlbFarm WHERE idfFarm = @idfFarm and intRowStatus = 0)
BEGIN

	EXECUTE spFarm_CopyRootToNormal
		   @idfRootFarm
		  ,@idfFarm OUTPUT --@idfTargetFarm
		  ,@idfMonitoringSession

END
ELSE
	UPDATE tlbFarm 
	SET 
		idfMonitoringSession = @idfMonitoringSession
		,idfFarmActual = @idfRootFarm
		,intHACode = ISNULL(intHACode, 0) | 32
	WHERE idfFarm=@idfFarm 
			--and (ISNULL(idfMonitoringSession,0) <> @idfMonitoringSession
			--	or ISNULL(idfFarmActual,0) <> @idfRootFarm)






