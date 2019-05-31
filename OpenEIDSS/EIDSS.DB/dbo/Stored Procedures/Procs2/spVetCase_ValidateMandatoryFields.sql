
--##SUMMARY Checks for not null for VetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 06.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spVetCase_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spVetCase_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbVetCase', 
		'Vet Case', 
		'datEnteredDate',
		'datModificationForArchiveDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd
