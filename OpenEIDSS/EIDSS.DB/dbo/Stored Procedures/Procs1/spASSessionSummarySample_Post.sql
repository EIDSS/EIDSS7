
--##SUMMARY Posts sample record related with specific AS session summary record.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 29.11.2011

--##RETURNS Doesn't use


/*
--Example of procedure call:
DECLARE @idfMonitoringSessionSummarySample bigint

EXEC spASSessionSummarySample_Post  1, 781200000000, 1
*/

CREATE PROCEDURE [dbo].[spASSessionSummarySample_Post]
            @idfMonitoringSessionSummary bigint
           ,@idfsSampleType bigint
           ,@blnChecked bit
AS
	IF(EXISTS (	SELECT	idfsSampleType
					FROM	tlbMonitoringSessionSummarySample 
					WHERE	idfsSampleType = @idfsSampleType
							AND idfMonitoringSessionSummary = @idfMonitoringSessionSummary
				)
		)
	BEGIN
		UPDATE tlbMonitoringSessionSummarySample
		SET blnChecked = @blnChecked
		WHERE	idfsSampleType = @idfsSampleType
				AND idfMonitoringSessionSummary = @idfMonitoringSessionSummary
				--AND blnChecked <> @blnChecked
	END
	ELSE IF (@blnChecked<>0)
	BEGIN
		INSERT INTO tlbMonitoringSessionSummarySample
				(
				 idfMonitoringSessionSummary
				,idfsSampleType
				,blnChecked
				)
		 VALUES
			   (
				@idfMonitoringSessionSummary
			   ,@idfsSampleType
			   ,@blnChecked
				)
	END


--RETURN 0
