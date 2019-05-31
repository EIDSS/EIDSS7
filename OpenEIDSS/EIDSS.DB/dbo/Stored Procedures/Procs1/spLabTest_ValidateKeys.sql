
--##SUMMARY Checks foreign keys for LabTest object

--##REMARKS Author: Vorobiev E.
--##REMARKS Create date: 22.05.2015

--##RETURNS table with incorrect records

/*
Example of procedure call:

DECLARE @ID bigint
EXEC spLabTest_Validate @ID
*/

CREATE PROCEDURE [dbo].[spLabTest_ValidateKeys]
	@RootId BIGINT = NULL	--##PARAM @RootId - LabTest ID
AS
	EXEC spValidateKeys 'tlbTesting', @RootId, 'Test'

