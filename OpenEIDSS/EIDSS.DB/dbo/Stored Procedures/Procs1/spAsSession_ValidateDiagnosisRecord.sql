

--##SUMMARY Compares session diagnosis parameters with diagnosis records in parent campaign.

--##REMARKS Author: Zurin M.
--##REMARKS Create date: 30.03.2012


--##RETURNS Returns 1 if session is not linked to any campaign or if diagnosis record with passed parameters is presented in campaign diagnosis.
--##RETURNS Returns 0 in other case



/*
--Example of procedure call:

@idfMonitoringSession bigint
DECLARE @idfsDiagnosis BIGINT
DECLARE @idfsSpeciesType BIGINT
DECLARE @idfCampaign BIGINT



EXECUTE spAsSession_ValidateDiagnosisRecord
	@idfsDiagnosis
	,@idfsSpeciesType
	,@idfCampaign


*/
CREATE PROCEDURE [dbo].[spAsSession_ValidateDiagnosisRecord]
	@idfsDiagnosis BIGINT,
	@idfsSpeciesType BIGINT,
	@idfsSampleType BIGINT,
	@idfCampaign BIGINT= null	
AS
DECLARE @cnt INT
DECLARE @cnt1 INT

--if session is not related with any campaign, it can have any list of diagnosis
IF @idfCampaign IS NULL
	RETURN 1

IF EXISTS(
			SELECT idfCampaignToDiagnosis
			FROM tlbCampaignToDiagnosis
			WHERE
				idfsDiagnosis = @idfsDiagnosis
				AND (idfsSpeciesType IS NULL OR idfsSpeciesType = ISNULL(@idfsSpeciesType,0))
				AND (idfsSampleType IS NULL OR idfsSampleType = ISNULL(@idfsSampleType,0))
				AND idfCampaign = @idfCampaign
				AND intRowStatus = 0
				)
	RETURN 1

RETURN 0
