
--##SUMMARY Checks foreign keys for AggrCase object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spHumanAggregateCase_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spHumanAggregateCase_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - AggrCase ID
AS
	EXEC spValidateForeignKeys 'tlbAggrCase', @RootId, 'Human Aggregate Case'

