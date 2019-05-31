
--##SUMMARY Checks foreign keys for AvianVetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spAvianVetCase_Validate @ID
*/

CREATE PROCEDURE [dbo].[spAvianVetCase_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AvianVetCase ID
AS
	EXEC spValidateKeys 'tlbVetCase', @RootId, 'Avian Vet Case'

