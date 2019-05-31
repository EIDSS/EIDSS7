
--##SUMMARY Checks foreign keys for ASCampaign object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spASCampaign_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spASCampaign_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - ASCampaign ID
AS
	EXEC spValidateForeignKeys 'tlbCampaign', @RootId, 'AS Campaign'

