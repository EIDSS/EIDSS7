
--##SUMMARY Checks foreign keys for ASCampaign object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spASCampaign_Validate @ID
*/

CREATE PROCEDURE [dbo].[spASCampaign_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - ASCampaign ID
AS
	EXEC spValidateKeys 'tlbCampaign', @RootId, 'AS Campaign'

