
--##SUMMARY Checks for not null for Organization object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 07.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spOrganization_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spOrganization_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbOffice', 
		'Organization',
		NULL,
		NULL,
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

