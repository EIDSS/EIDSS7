
--##SUMMARY Checks for not null for VetAggregateAction object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spVetAggregateAction_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spVetAggregateAction_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbAggrCase', 
		'Vet Aggregate Action', 
		'datEnteredByDate',
		'datModificationForArchiveDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd
