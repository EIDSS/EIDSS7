
--##SUMMARY Checks foreign keys for LabTest object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabTest_ValidateForeignKeys @ID
*/

CREATE PROCEDURE [dbo].[spLabTest_ValidateForeignKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabTest ID
AS
	EXEC spValidateForeignKeys 'tlbTesting', @RootId, 'Test'

