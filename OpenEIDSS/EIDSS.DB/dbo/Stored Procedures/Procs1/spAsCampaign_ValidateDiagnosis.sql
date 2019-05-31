

--##SUMMARY Compares list of diagnosis records in campaign and all child sessions.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.03.2012


--##RETURNS Returns 1 all child session daignosis lists are valid
--##RETURNS Returns 0 in other case



/*
--Example of procedure call:

DECLARE @idfCampaign bigint



EXECUTE spAsCampaign_ValidateDiagnosis
   @idfCampaign


*/
CREATE PROCEDURE [dbo].[spAsCampaign_ValidateDiagnosis]
	@idfCampaign bigint

AS
DECLARE @idfMonitoringSession bigint
DECLARE @Result int

DECLARE crCampaignSession CURSOR FOR 
	SELECT	idfMonitoringSession
	FROM	tlbMonitoringSession
	WHERE	idfCampaign = @idfCampaign
			AND intRowStatus = 0
OPEN crCampaignSession
   FETCH NEXT FROM crCampaignSession INTO @idfMonitoringSession;
    WHILE @@FETCH_STATUS = 0
    BEGIN
		EXEC @Result =  spAsSession_ValidateDiagnosis  @idfMonitoringSession, @idfCampaign
		IF @Result = 0
		BEGIN
			CLOSE crCampaignSession
			DEALLOCATE crCampaignSession
			RAISERROR ('errInvalidCampaignDiagnosis', 16, 1)
			RETURN 0
		END
		FETCH NEXT FROM crCampaignSession INTO @idfMonitoringSession;
    END
CLOSE crCampaignSession;
DEALLOCATE crCampaignSession;

RETURN 1
