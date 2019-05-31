
--##SUMMARY Checks for not null for LabTest object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 09.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spLabTest_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spLabTest_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbTesting', 
		'Lab Section', 
		'datStartedDate', 
		'datConcludedDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

