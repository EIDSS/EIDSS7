
--##SUMMARY Checks foreign keys for BasicSyndromicSurveillanceAggregate object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 14.07.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spBasicSyndromicSurveillanceAggregate_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spBasicSyndromicSurveillanceAggregate_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - BasicSyndromicSurveillanceAggregate ID
AS
	EXEC spValidateForeignKeys 'tlbBasicSyndromicSurveillanceAggregateHeader', @RootId, 'ILI Aggregate Case'

