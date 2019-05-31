
--##SUMMARY Posts diagnosis record related with specific AS session summary record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:


*/

CREATE PROCEDURE [dbo].[spASSessionSummaryDiagnosis_Post]
            @idfMonitoringSessionSummary bigint
           ,@idfsDiagnosis bigint
           ,@blnChecked bit
AS
IF(EXISTS (SELECT idfsDiagnosis FROM tlbMonitoringSessionSummaryDiagnosis 
			WHERE idfsDiagnosis = @idfsDiagnosis
			AND idfMonitoringSessionSummary = @idfMonitoringSessionSummary
			)
	)
	UPDATE tlbMonitoringSessionSummaryDiagnosis
	SET blnChecked = @blnChecked
	WHERE	idfsDiagnosis = @idfsDiagnosis
			AND idfMonitoringSessionSummary = @idfMonitoringSessionSummary
ELSE IF (@blnChecked = 1)
	INSERT INTO tlbMonitoringSessionSummaryDiagnosis
			(
			 idfMonitoringSessionSummary
			,idfsDiagnosis
			,blnChecked
			)
	 VALUES
		   (
			@idfMonitoringSessionSummary
		   ,@idfsDiagnosis
		   ,@blnChecked
			)


RETURN 0
