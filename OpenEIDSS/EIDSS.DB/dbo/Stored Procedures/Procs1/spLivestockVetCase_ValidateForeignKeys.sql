
--##SUMMARY Checks foreign keys for LivestockVetCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLivestockVetCase_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spLivestockVetCase_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LivestockVetCase ID
AS
	EXEC spValidateForeignKeys 'tlbVetCase', @RootId, 'Livestock Vet Case'

