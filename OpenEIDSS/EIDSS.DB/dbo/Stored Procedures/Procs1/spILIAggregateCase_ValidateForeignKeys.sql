
--##SUMMARY Checks foreign keys for BasicSyndromicSurveillanceAggregateHeader object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spILIAggregateCase_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spILIAggregateCase_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - BasicSyndromicSurveillanceAggregateHeader ID
AS
	EXEC spValidateForeignKeys 'tlbBasicSyndromicSurveillanceAggregateHeader', @RootId, 'ILI Aggregate Case'
