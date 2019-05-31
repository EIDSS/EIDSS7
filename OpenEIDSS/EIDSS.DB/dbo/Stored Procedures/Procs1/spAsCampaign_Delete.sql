



--##SUMMARY Deletes Active Surveillance Campaign object.
--##REMARKS Author: Zurin M.
--##REMARKS Create date: 11.06.2010

--##RETURNS Doesn't use



/*
--Example of procedure call:

DECLARE @ID bigint
EXECUTE spASCampaign_Delete 
	@ID

*/




CREATE                                   proc	spAsCampaign_Delete
	@ID AS BIGINT --#PARAM @ID - aggregate case ID
as
UPDATE tlbMonitoringSession 
SET idfCampaign = null
WHERE idfCampaign = @ID

DELETE FROM  dbo.tlbCampaignToDiagnosis WHERE idfCampaign = @ID
DELETE FROM  dbo.tlbCampaign WHERE idfCampaign = @ID


