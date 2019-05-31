
--##SUMMARY Checks foreign keys for LivestockVetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLivestockVetCase_ValidateForeignKeys @ID
*/
CREATE PROCEDURE [dbo].[spLivestockVetCase_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LivestockVetCase ID
AS
	EXEC spValidateForeignKeys 'tlbVetCase', @RootId, 'Livestock Vet Case'
