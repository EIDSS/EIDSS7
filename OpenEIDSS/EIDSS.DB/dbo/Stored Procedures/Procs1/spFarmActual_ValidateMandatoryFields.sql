
--##SUMMARY Checks for not null for FarmActual object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 08.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spFarmActual_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spFarmActual_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbFarmActual', 
		'Farm',
		NULL,
		'datModificationDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

