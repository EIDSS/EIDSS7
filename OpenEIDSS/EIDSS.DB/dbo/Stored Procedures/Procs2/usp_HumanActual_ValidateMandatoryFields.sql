

--##SUMMARY Checks for not null for HumanActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC usp_HumanActual_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[usp_HumanActual_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC usp_ValidateMandatoryFields 
		'tlbHumanActual', 
		'Patient/Contact/Farm Owner',
		'datEnteredDate',
		'datModificationDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd


