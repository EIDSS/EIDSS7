

--##SUMMARY Posts Active Surveillance Monitoring Session diagnosis

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 17.06.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:

*/


CREATE         PROCEDURE dbo.spASSessionDiagnosis_Post(
			@Action INT  --##PARAM @Action - posting action,  4 - add record, 8 - delete record, 16 - modify record
           ,@idfMonitoringSessionToDiagnosis bigint OUTPUT
           ,@idfMonitoringSession bigint
           ,@idfsDiagnosis bigint
		   ,@idfsSpeciesType bigint
           ,@intOrder int
           ,@idfsSampleType bigint
)
AS

IF @Action = 8
BEGIN
	DELETE FROM tlbMonitoringSessionToDiagnosis
    WHERE 
	idfMonitoringSessionToDiagnosis = @idfMonitoringSessionToDiagnosis
	AND idfsDiagnosis = @idfsDiagnosis
END

ELSE IF @Action = 16
BEGIN
	BEGIN
		UPDATE tlbMonitoringSessionToDiagnosis
		   SET idfsDiagnosis = @idfsDiagnosis
			  ,idfMonitoringSession = @idfMonitoringSession
			  ,idfsSpeciesType = @idfsSpeciesType
			  ,intOrder = @intOrder
			  ,idfsSampleType = @idfsSampleType
		 WHERE 
			idfMonitoringSessionToDiagnosis = @idfMonitoringSessionToDiagnosis			
	END
END
ELSE IF @Action = 4
BEGIN
	BEGIN
		IF (ISNULL(@idfMonitoringSessionToDiagnosis,0) <= 0)
			EXEC spsysGetNewID @idfMonitoringSessionToDiagnosis OUTPUT
		
		INSERT INTO tlbMonitoringSessionToDiagnosis
			   (
				idfMonitoringSessionToDiagnosis
			   ,idfMonitoringSession
			   ,idfsDiagnosis
			   ,intOrder
			   ,idfsSpeciesType
			   ,idfsSampleType  
			   )
		 VALUES
			   (@idfMonitoringSessionToDiagnosis
				,@idfMonitoringSession
			   ,@idfsDiagnosis
			   ,@intOrder
			   ,@idfsSpeciesType
			   ,@idfsSampleType
			   )
	END
END

RETURN 0


