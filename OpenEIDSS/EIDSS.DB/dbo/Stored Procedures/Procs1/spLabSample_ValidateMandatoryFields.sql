
--##SUMMARY Checks for not null for LabSample object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 09.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spLabSample_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spLabSample_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbMaterial', 
		'Lab Section', 
		'datEnteringDate',
		'datSampleStatusDate',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd
