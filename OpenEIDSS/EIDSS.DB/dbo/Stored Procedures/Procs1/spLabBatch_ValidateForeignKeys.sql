
--##SUMMARY Checks foreign keys for LabBatch object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabBatch_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spLabBatch_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabBatch ID
AS
	EXEC spValidateForeignKeys 'tlbBatchTest', @RootId, 'Lab Batch'
