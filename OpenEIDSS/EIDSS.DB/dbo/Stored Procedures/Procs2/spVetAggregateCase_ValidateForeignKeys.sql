
--##SUMMARY Checks foreign keys for AggrCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spVetAggregateCase_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spVetAggregateCase_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AggrCase ID
AS
	EXEC spValidateForeignKeys 'tlbAggrCase', @RootId, 'Vet Aggregate Case'

