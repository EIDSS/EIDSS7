
--##SUMMARY Checks for not null for Person object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 07.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spPerson_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spPerson_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbPerson', 
		'Employee',
		NULL,
		NULL,
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

