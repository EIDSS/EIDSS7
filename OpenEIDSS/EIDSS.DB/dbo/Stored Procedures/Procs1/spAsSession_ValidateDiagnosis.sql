

--##SUMMARY Compares list of diagnosis records in campaign and its specific child session.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 16.04.2012


--##RETURNS Returns 1 child session daignosis list is valid
--##RETURNS Returns 0 in other case



/*
--Example of procedure call:

DECLARE @idfCampaign bigint
DECLARE @idfMonitoringSession bigint



EXECUTE spAsSession_ValidateDiagnosis
   @idfMonitoringSession, @idfCampaign


*/
CREATE PROCEDURE [dbo].[spAsSession_ValidateDiagnosis]
	@idfMonitoringSession bigint, 
	@idfCampaign bigint
AS

DECLARE @Result int
DECLARE @idfsDiagnosis BIGINT
DECLARE @idfsSpeciesType BIGINT
DECLARE @idfsSampleType BIGINT

DECLARE crSession CURSOR FOR 
	SELECT	idfsDiagnosis,
			idfsSpeciesType,
			idfsSampleType
	FROM	tlbMonitoringSessionToDiagnosis
	WHERE	idfMonitoringSession = @idfMonitoringSession
			AND intRowStatus = 0
OPEN crSession
   FETCH NEXT FROM crSession INTO @idfsDiagnosis,@idfsSpeciesType,@idfsSampleType;
    WHILE @@FETCH_STATUS = 0
    BEGIN
		EXEC @Result =  spAsSession_ValidateDiagnosisRecord  @idfsDiagnosis, @idfsSpeciesType,@idfsSampleType, @idfCampaign
		IF @Result = 0
		BEGIN
			CLOSE crSession;
			DEALLOCATE crSession;
			RETURN 0
		END
		FETCH NEXT FROM crSession INTO @idfsDiagnosis,@idfsSpeciesType,@idfsSampleType;
    END
CLOSE crSession;
DEALLOCATE crSession;

RETURN  1
