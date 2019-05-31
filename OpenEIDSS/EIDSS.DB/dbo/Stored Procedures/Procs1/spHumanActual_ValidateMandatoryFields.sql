
--##SUMMARY Checks for not null for HumanActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spHumanActual_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spHumanActual_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbHumanActual', 
		'Patient/Contact/Farm Owner',
		'datEnteredDate',
		'datModificationDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

