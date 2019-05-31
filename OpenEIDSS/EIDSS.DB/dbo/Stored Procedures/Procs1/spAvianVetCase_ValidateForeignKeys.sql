
--##SUMMARY Checks foreign keys for AvianVetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAvianVetCase_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spAvianVetCase_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AvianVetCase ID
AS
	EXEC spValidateForeignKeys 'tlbVetCase', @RootId, 'Avian Vet Case'

