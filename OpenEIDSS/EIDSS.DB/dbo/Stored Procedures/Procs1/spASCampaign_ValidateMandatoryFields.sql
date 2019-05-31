
--##SUMMARY Checks for not null for ASCampaign object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spASCampaign_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spASCampaign_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbCampaign', 
		'AS Campaign',
		'datCampaignDateStart',
		'datModificationForArchiveDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

