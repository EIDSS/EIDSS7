
--##SUMMARY Checks for not null for BasicSyndromicSurveillance object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 07.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

EXEC spBasicSyndromicSurveillance_ValidateMandatoryFields
*/
CREATE PROCEDURE [dbo].[spBasicSyndromicSurveillance_ValidateMandatoryFields]
	@datCreationDateStart DATETIME = NULL,
	@datCreationDateEnd DATETIME = NULL,
	@datModificationDateStart DATETIME = NULL,
	@datModificationDateEnd DATETIME = NULL
AS
	EXEC spValidateMandatoryFields 
		'tlbBasicSyndromicSurveillance', 
		'BSS', 
		'datDateEntered', 
		'datDateLastSaved',
		@datCreationDateStart, 
		@datCreationDateEnd, 
		@datModificationDateStart, 
		@datModificationDateEnd

