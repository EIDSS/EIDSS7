
--##SUMMARY Checks for not null for Outbreak object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spOutbreak_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spOutbreak_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbOutbreak', 
		'Outbreak',
		NULL,
		'datModificationForArchiveDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

