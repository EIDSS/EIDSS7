
--##SUMMARY Checks for not null for ASSession object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 07.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spASSession_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spASSession_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbMonitoringSession', 
		'AS Session', 
		'datEnteredDate',
		'datModificationForArchiveDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd
