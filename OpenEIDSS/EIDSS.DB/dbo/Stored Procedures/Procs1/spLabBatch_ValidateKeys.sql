
--##SUMMARY Checks foreign keys for LabBatch object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabBatch_Validate @ID
*/

CREATE PROCEDURE [dbo].[spLabBatch_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabBatch ID
AS
	EXEC spValidateKeys 'tlbBatchTest', @RootId, 'Lab Batch'
