
--##SUMMARY Checks for not null for HumanCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.06.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spHumanCase_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spHumanCase_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbHumanCase', 
		'Human Case', 
		'datEnteredDate', 
		'datModificationDate', 
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd
